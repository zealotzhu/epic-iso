//
//  Utility.h
//  webUrlTest
//
//  Created by user on 15-11-11.
//  Copyright (c) 2015年 gotop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InputToolBar.h"
#import "NSString+JSONCategories.h"
#import "NSObject+JSONCategories.h"
#import "Header.h"
#import <AFNetworking.h>
#import "HttpManager.h"
#define _PLISTFILE_ "Eposttoudiguanjia.plist"
#define _CONSTANT_ 35.0f;
#define BGCOLOR @"#BA400F"
#define _BGCOLOR_ARRAY @[@"#368FBD",@"#369544",@"#BA400F",@"#718D98"]//四种界面的主题颜色
@interface Utility : NSObject


- (Byte *)hex2dec:(NSString *)hex;
+ (NSString *)dec2hex:(Byte *)dec andLen:(int)len;
+ (NSString *)ascii2Hex:(NSString *)asciiStr;
+ (NSString *)encrypt:(NSString *)inStr andKey:(NSString *)key;
+ (NSString *)decrypt:(NSString *)inStr andKey:(NSString *)key;
+ (NSString *)md5DoubleByteEncrypt:(NSString *)msb;
+ (NSMutableArray *)arrayOfSetting;
+ (NSString *)ip;
+ (NSString *)port;
+ (NSString *)urlWithMethod:(NSString *)method params:(NSString *)params;
+ (int)resolveHeadNoData:(NSString *)src;
+ (NSArray *)resolveHead:(NSString *)src;
+ (NSArray *)resolveBody:(NSArray *)array;
+ (BOOL)netState;
+ (void)netWarm;
+ (UIColor *) colorWithHexString: (NSString *)color;
+ (NSString *)urlappendwithmethod:(NSString *)method ;
+(NSString *)getdatetime;
+  (int)convertToInt:(NSString*)strtemp;
//+ (NSInteger *)tjjjbz;

@end
