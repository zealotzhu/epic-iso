//
//  NSObject+JSONCategories.m
//  test
//
//  Created by user on 15-11-5.
//  Copyright (c) 2015年 gotop. All rights reserved.
//

#import "NSObject+JSONCategories.h"

@implementation NSObject (JSONCategories)
-(id)JSONString
{
    NSError* error = nil;
    id result = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
    if (error) return nil;
    return result;
}

-(id)JSONData
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error) return nil;
    return result;
}
@end
