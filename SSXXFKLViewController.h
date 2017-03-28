//
//  SSXXFKLViewController.h
//  EPostPickUpByCustomer
//
//  Created by lzb on 17/1/8.
//  Copyright © 2017年 gotop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTSocketUtils.h"
#import "parseSSXXFKLViewController.h"
#import "Utility.h"
#import "GCDAsyncSocket.h"
#import "MBProgressHUD.h"
#import "DeliverMangerBaseViewController.h"
@interface SSXXFKLViewController: DeliverMangerBaseViewController
{
    parseSSXXFKLViewController *parserecv;
}
//获得menu 传下来的员工姓名
@property (nonatomic,strong) NSString *ssxxfklV_JGBH;       //机构编号
@property (nonatomic,strong) NSString *ssxxfklV_JB;     //级别
@property (nonatomic,strong) NSString *ssxxfklV_LX;
@property (nonatomic,strong) NSString *ssxxfklV_DATEBEGIN;     //date
@property (nonatomic,strong) NSString *ssxxfklV_DATEEND;



@end
