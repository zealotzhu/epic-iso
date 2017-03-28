//
//  NSString+JSONCategories.m
//  test
//
//  Created by user on 15-11-5.
//  Copyright (c) 2015年 gotop. All rights reserved.
//

#import "NSString+JSONCategories.h"

@implementation NSString (JSONCategories)

-(id)JSONValue
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) return nil;
    return result;
}


@end
