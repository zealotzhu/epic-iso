//
//  NCJSTDLViewController.h
//  EPostPickUpByCustomer
//
//  Created by lzb on 17/1/8.
//  Copyright © 2017年 gotop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCJSTDLViewController : UIViewController


//获得menu 传下来的员工姓名
@property (nonatomic,strong) NSString *ncjstdlV_JGBH;       //机构编号
@property (nonatomic,strong) NSString *ncjstdlV_JB;     //级别
@property (nonatomic,strong) NSString *ncjstdlV_LX;

@property (nonatomic,strong) NSString *ncjstdlV_DATEBEGIN;     //date
@property (nonatomic,strong) NSString *ncjstdlV_DATEEND;


@end
