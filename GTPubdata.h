//
//  GTPubdata.h
//  GTChinaPostPak
//
//  Created by zsm on 13-12-3.
//  Copyright (c) 2013年 zsm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTPubdata : NSObject
{
    NSMutableArray *head;
    NSMutableArray *body;
    int row_num;
    int col_num;
    NSMutableArray *child;
}
-(void)inits;
-(void)setValue:(NSString *)name :(NSString *) val :(int) col;
-(void)setpValue:(NSString *)name :(GTPubdata *) val :(int)col;
-(NSString *)getValue:(NSString *)name :(int) col;
-(NSMutableArray *)getCollValue:(NSString *) name;
-(NSMutableArray *)getRow:(int) row;
-(void)addata;
-(void)addhead:(NSString *)val;
-(void)addata:(NSString *)val;
-(int) count;
-(GTPubdata *) getChild:(int) i;
-(void) showMsg;

-(void)getrownum;

@end
