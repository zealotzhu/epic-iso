//
//  GTSocketUtils.h
//  EPostPickUpByCustomer
//
//  Created by zsm on 17/1/12.
//  Copyright © 2017年 gotop. All rights reserved.
//

#ifndef GTSocketUtils_h
#define GTSocketUtils_h
#import "GCDAsyncSocket.h"
@protocol GTSocketUtilsDelegate;
@interface GTSocketUtils:NSObject<GCDAsyncSocketDelegate>
{
    long _bytesReaded;
    long _totoalBytes;
    GCDAsyncSocket* socket;
    //Byte * _bytes;
    NSError * error;
    BOOL dataSent;
}
@property(strong,nonatomic) NSMutableData * recvData;
@property(weak,nonatomic) id<GTSocketUtilsDelegate> delegate;
@property(strong,nonatomic) NSString* sendMsg;//将要发送的数据在回调函数onInit中组装
-(BOOL)connect:(NSString *)ahost port:(uint16_t )aport error:(NSError *)error;
-(void)sendMsg:(NSData *)data withTimeout:(NSTimeInterval)withTimeout tag:(long)tag;
-(id)initObjectWithDelegate:(id<GTSocketUtilsDelegate>)adelegate;
@end
@protocol GTSocketUtilsDelegate
-(void) onSocketInit;
-(void) onSocketReadDataDone:(NSData *) data withTag:(long)tag;
-(void) onSocketReadTimeout:(NSTimeInterval)elapsed;
-(void) onSocketWriteTimeout:(NSTimeInterval)elapsed;
@optional
-(void) onConnectionDone:(NSError *)error;
-(void) onWriteDataDone:(NSData *) data withTag:(long)tag;


@end

#endif /* GTSocketUtils_h */
