//
//  GTcomm.h
//  GTChinaPostPak
//
//  Created by zsm on 13-12-6.
//  Copyright (c) 2013年 zsm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTPubdata.h"
@class GTPubdata;
@interface GTcomm : NSObject
{
    NSString *in;
    NSString *out;
    GTPubdata *pub;
    NSMutableDictionary *conf;
    NSString *resultc;
    NSString *errinfo;
}
-(void) inits;
-(GTPubdata *) parseOut:(NSString *)code :(NSString *)msg;   //out
-(NSString *)parseIn:(NSString *)code :(GTPubdata *)pubin;   //out 
-(GTPubdata *) parseDetail:(NSMutableDictionary *)head :(NSArray *)data :(int) index :(int) num;
-(NSString *)resultCode;
-(NSString *)getErrorInfo;
@end
