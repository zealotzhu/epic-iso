//
//  GTdelegeRecv.h
//  GTpostpackage
//
//  Created by zsm on 13-12-19.
//  Copyright (c) 2013年 zsm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GTcomm.h"
//#import "GTsocketViewController.h"
@protocol pubrecvdelegate;
@interface GTdelegeRecv : NSObject //<sockrecvdelegate>
{
    GTcomm *commData;
    GTPubdata *outpub;
    //GTsocketViewController *send;
    id<pubrecvdelegate> _delegate;
}
@property(strong,nonatomic) GTPubdata *outData;
@property(strong,nonatomic) id<pubrecvdelegate> delegate;
-(NSString *)parseInData:(NSString *)scode :(GTPubdata *)data;
-(void)parseOutData:(NSString *)scode :(NSString *)msg;
-(void)LoadData:(UIView *)view;;
//-(void)parseRecvData;
//-(void) parseRecvData :(NSString*) Translatecode;
-(NSMutableArray *) parseRecvData :(NSString*) Translatecode :(NSString *) Parsedata;
@end

@protocol pubrecvdelegate

-(void) pubrecvdone;
-(void) pubrecverr;
@end
