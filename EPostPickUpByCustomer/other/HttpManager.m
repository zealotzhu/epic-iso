//
//  HttpManager.m
//  EPostPickUpByCustomer
//
//  Created by user on 15/12/24.
//  Copyright © 2015年 gotop. All rights reserved.
//

#import "HttpManager.h"
#import "Utility.h"
@implementation HttpManager

+ (instancetype)shareHttpMangager {
    static HttpManager *_sharedHttpManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        NSString *url = [NSString stringWithFormat:@"http://%@:%@/postreceive.do?", [Utility ip], [Utility port]];
//        _sharedHttpManager = [[HttpManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
        _sharedHttpManager = [HttpManager manager];
        _sharedHttpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sharedHttpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    });
    
    return _sharedHttpManager;
}
@end
