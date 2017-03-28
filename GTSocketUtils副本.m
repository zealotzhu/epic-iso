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

-(BOOL)connect:(NSString *)ahost port:(uint16_t )aport error:(NSError *)aerror
{
    return [socket connectToHost:ahost onPort:aport error:&aerror];
}
-(void)sendMsg:(NSData *)data withTimeout:(NSTimeInterval)withTimeout tag:(long)tag
{
    [socket writeData:data withTimeout:withTimeout tag:tag];
}


-(id)initObject
{
    id obj = [[NSObject alloc] init ];
    if(obj)
    {
      _recvData=NULL;
      _bytesReaded = 0;
      _totoalBytes = 0;
      socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
      [socket setAutoDisconnectOnClosedReadStream:YES];
      [self.delegate onInit];
      return obj;
    }
    return NULL;
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    long recvlen = [data length];
    if(_recvData==NULL)
       _recvData = [[ NSMutableData alloc] initWithData:data];
     else
       [_recvData appendData:data];
    _bytesReaded+=recvlen;
    NSStringEncoding iso88591Encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);
    NSString *dataStr = [[NSString alloc] initWithData:_recvData encoding:iso88591Encode];
    NSArray  * array= [dataStr componentsSeparatedByString:@"#|"];
    if( _totoalBytes==0 )
    {
    //获取总长度
       if([array count ]>=5)
       {
           _totoalBytes = [[array objectAtIndex:4] integerValue];
           if( _bytesReaded==_totoalBytes )
           {
             [self.delegate onReadDataDone:_recvData withTag:tag];
               
           }
       }
    }
    else
    {
      if(_bytesReaded == _totoalBytes)
        [ self.delegate onReadDataDone:_recvData withTag:tag ];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    //需判断代理类有没有实现 onConnectionDone 协议方法
    //self.delegate onConnectionDone:(NSData *) withTag:<#(long)#>
}

/**
 * Called when a socket has completed writing the requested data. Not called if there is an error.
 **/
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //需判断代理类有没有实现 onReadDataDone 协议方法
    //self.delegate onReadDataDone:(NSData *) withTag:<#(long)#>
    dataSent = YES;
}

@end
