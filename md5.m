//
//  md5.m
//  connect
//
//  Created by lzb on 16/6/21.
//  Copyright © 2016年 heyiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "md5.h"

@implementation Md5

+ (NSString *)getMd5_32Bit:(NSString *)srcstring {
    const char *cStr = [srcstring UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

@end



