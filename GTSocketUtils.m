//
//  GTSocketUtils.m
//  EPostPickUpByCustomer
//
//  Created by zsm on 17/1/12.
//  Copyright © 2017年 gotop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTSocketUtils.h"

@implementation GTSocketUtils:NSObject
@synthesize delegate;
-(BOOL)connect:(NSString *)ahost port:(uint16_t )aport error:(NSError *)aerror
{
    
    return [socket connectToHost:ahost onPort:aport error:&aerror];
}
-(void)sendMsg:(NSData *)data withTimeout:(NSTimeInterval)withTimeout tag:(long)tag
{
    [socket writeData:data withTimeout:withTimeout tag:tag];
    
}


-(id)initObjectWithDelegate:(id<GTSocketUtilsDelegate>)adelegate
{
    self=[super init];
    if(self!=nil)
    {
      _recvData=nil;
      _bytesReaded = 0;
      _totoalBytes = 0;
      delegate = adelegate;
      socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
      [socket setAutoDisconnectOnClosedReadStream:YES];
      [self.delegate onSocketInit];
    }
    return self;

}
//连接失败
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err   // 4
{
    NSString *errstr = err.description;
    NSLog(@"连接失败错误原因: %@", errstr);

    _bytesReaded = 0;
    _totoalBytes = 0;
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"接收到的报文＝＝%@",data);

    long recvlen = [data length];
    if(_recvData==NULL)
       _recvData = [[ NSMutableData alloc] initWithData:data];
     else
     {
        if(_bytesReaded==0)
        {
          _recvData=nil;
          _recvData=[[ NSMutableData alloc] initWithData:data];
        }
        else
         [_recvData appendData:data];
     }
    _bytesReaded+=recvlen;
    NSStringEncoding iso88591Encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);
    NSString *dataStr = [[NSString alloc] initWithData:_recvData encoding:iso88591Encode];
    NSArray  * array= [dataStr componentsSeparatedByString:@"#|"];
    if( _totoalBytes==0 )
    {
    //获取总长度
       if([array count ]>=4)
       {
           _totoalBytes = [[array objectAtIndex:3] integerValue];
           if( _bytesReaded==_totoalBytes )
           {
             [self.delegate onSocketReadDataDone:_recvData withTag:tag];
               [sock disconnectAfterReading];
           }
           else
           {
               [sock readDataWithTimeout:2 tag:tag];
           }
       }
    }
    else
    {
      if(_bytesReaded == _totoalBytes)
      {
        [ self.delegate onSocketReadDataDone:_recvData withTag:tag ];
          [sock disconnectAfterReading];
      }
      else
      {
         [sock readDataWithTimeout:2 tag:tag];
      }
    }
    
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port  //1
{
       //需判断代理类有没有实现 onConnectionDone 协议方法
    //self.delegate onConnectionDone:(NSData *) withTag:<#(long)#>
    NSLog(@"connto server %@:%d",host,port);
}

/**
 * Called when a socket has completed writing the requested data. Not called if there is an error.
 **/
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //需判断代理类有没有实现 onReadDataDone 协议方法
    //self.delegate onReadDataDone:(NSData *) withTag:<#(long)#>
    NSLog(@"数据已经发送%ld",tag);
    dataSent = YES;
    [socket readDataWithTimeout:2 tag:tag];
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    [self.delegate onSocketReadTimeout:elapsed];
    return 0;
}
/**
 * Called if a write operation has reached its timeout without completing.
 * This method allows you to optionally extend the timeout.
 * If you return a positive time interval (> 0) the write's timeout will be extended by the given amount.
 * If you don't implement this method, or return a non-positive time interval (<= 0) the write will timeout as usual.
 *
 * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
 * The length parameter is the number of bytes that have been written so far for the write operation.
 *
 * Note that this method may be called multiple times for a single write if you return positive numbers.
 **/
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    [self.delegate onSocketWriteTimeout:elapsed];
    return 0;
}
@end
