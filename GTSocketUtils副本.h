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
@protocol GTSocketUtilsDelegate
-(void) onInit;
-(void) onReadDataDone:(NSData *) data withTag:(long)tag;
@optional
-(void) onConnectionDone:(NSError *)error;
-(void) onWriteDataDone:(NSData *) data withTag:(long)tag;

@end

@interface GTSocketUtils<GCDAsyncSocketDelegate> : NSObject
{
    long _bytesReaded;
    long _totoalBytes;
    GCDAsyncSocket* socket;
    //Byte * _bytes;
    NSError * error;
    BOOL dataSent;
}
@property(strong,nonatomic) NSMutableData * recvData;
@property(strong,nonatomic) id<GTSocketUtilsDelegate> delegate;
@property(strong,nonatomic) NSString* sendMsg;//将要发送的数据在回调函数onInit中组装
-(BOOL)connect:(NSString *)ahost port:(uint16_t )aport error:(NSError *)error;
-(void)sendMsg:(NSData *)data withTimeout:(NSTimeInterval)withTimeout tag:(long)tag;
-(id)initObject;
@end

#endif /* GTSocketUtils_h */
