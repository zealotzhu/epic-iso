//
//  YWLTJViewController.h
//  EPostPickUpByCustomer
//
//  Created by lzb on 17/1/8.
//  Copyright © 2017年 gotop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTSocketUtils.h"
#import "DeliverMangerBaseViewController.h"
#import "parseYWLViewController.h"    //引入被封装的解析类

@interface YWLTJViewController : DeliverMangerBaseViewController
{
    parseYWLViewController *parserecv;
}


//获得menu 传下来的员工姓名
@property (nonatomic,strong) NSString *ywltjV_JGBH;       //机构编号
@property (nonatomic,strong) NSString *ywltjV_JB;     //级别
@property (nonatomic,strong) NSString *ywltjV_LX;

//@property (nonatomic,strong) NSString *ywltjV_CKJB;   //查看级别 根据传下来的加一

@property (nonatomic,strong) NSString *ywltjV_DATEBEGIN;     //date
@property (nonatomic,strong) NSString *ywltjV_DATEEND;

//获得传下来的下级字典
@property (nonatomic,strong) NSDictionary *ywltjgetjb;     //date
@property (nonatomic,strong) NSString *ywltjgetjgbh;
@property (nonatomic,strong) NSString *ywltjgetdickey;     //date

-(void)generateRequestData :(NSString *)jgbh :(NSString *)jgjb :(NSString *)ckjb : (NSString *)begindate :(NSString *)enddate :(NSString *)lx;
@end


