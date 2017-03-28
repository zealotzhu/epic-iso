//
//  md5.h
//  connect
//
//  Created by lzb on 16/6/21.
//  Copyright © 2016年 heyiming. All rights reserved.
//

#ifndef md5_h
#define md5_h


#endif /* md5_h */

#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>      //这个头文件一定要引用进来  不然会导致各种引用报错


//此处自己声明一个 接口  在.m文件当中  去进行继承

@interface Md5 : NSObject
+ (NSString *)getMd5_32Bit:(NSString *)srcstring;

@end