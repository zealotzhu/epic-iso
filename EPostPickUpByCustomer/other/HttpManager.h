//
//  HttpManager.h
//  EPostPickUpByCustomer
//
//  Created by user on 15/12/24.
//  Copyright © 2015年 gotop. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface HttpManager : AFHTTPRequestOperationManager

+ (instancetype)shareHttpMangager;
@end
