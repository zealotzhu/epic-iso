//
//  SmjmViewController.m
//  EPostPickUpByCustomer
//
//  Created by lzb on 16/7/15.
//  Copyright © 2016年 gotop. All rights reserved.
//

#import "SmjmViewController.h"


#import "Utility.h"

#import "CommonFunc.h"
#import "md5.h"
#import "SBJson.h"
#import "webconn.h"


@interface SmjmViewController ()<UITableViewDelegate, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}



@end

@implementation SmjmViewController


- (void)ini {
    
        self.title = @"自动扫描";
    self.view.backgroundColor=[UIColor blackColor];// 这里设置的是搭载相机扫描的 背景界面
    
    UILabel *labIntroudction= [[ UILabel alloc ] init ];
    labIntroudction. backgroundColor = [ UIColor clearColor ];
   // labIntroudction. frame = CGRectMake ( 10 , 45 , 300 , 20 );
    labIntroudction. numberOfLines = 1 ;
    labIntroudction. font =[ UIFont systemFontOfSize : 15.0 ];
    labIntroudction. textAlignment = NSTextAlignmentCenter ;
    labIntroudction. textColor =[ UIColor whiteColor ];
    labIntroudction. text = @"将条形码对准方框，即可自动扫描" ;
    [self.view addSubview :labIntroudction];     //这里添加 一行提示语
    
    
    
    
     //nameLabel高度为20
     //使用代码设置约束
     labIntroudction.contentMode=UIViewContentModeScaleAspectFit;
     labIntroudction.translatesAutoresizingMaskIntoConstraints=NO;//设置自动转换为不
    
     
     NSLayoutConstraint* Constraint1=[NSLayoutConstraint constraintWithItem:labIntroudction attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:20];//1前端距离邮件号码前段20
     NSLayoutConstraint* Constraint2=[NSLayoutConstraint constraintWithItem:labIntroudction attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20];//2后端距离尾部-20
    
   // NSLayoutConstraint* Constraint3=[NSLayoutConstraint constraintWithItem:labIntroudction attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:50];//距离顶部50
    
     NSLayoutConstraint* Constraint3=[NSLayoutConstraint constraintWithItem:labIntroudction attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:0.3 constant:0];//位置是中线的三分之一
    
    NSLayoutConstraint* Constraint4=[NSLayoutConstraint constraintWithItem:labIntroudction attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30];//1自身高度是30
    
    
     //使用代码设置约束的方法
     //往左边和往上面是小于0的负数  右边和下面是大于0
     //或者引入一个概念   a 相对于 b 的坐标是大于还是小于 大于的话 就是正 小于的就是负
    
    [self.view addConstraints:@[Constraint1, Constraint2,Constraint3]];
    [labIntroudction addConstraints:@[Constraint4]];
    
}

/*
 - (IBAction)back:(id)sender {
 [self.navigationController popToRootViewControllerAnimated:NO];
 }
 */


- ( void )viewWillDisappear:( BOOL )animated
{
    
    [_readerView flushCache];
    [_readerView stop];
    [_readerView removeFromSuperview];
   
    
       // NSLog(@"hahahahah11111");           //为了防止内存泄漏调用的
    
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer  =nil;
        
    }

    
    if (_timer !=nil) {
        [_timer invalidate];
        _timer  =nil;
        
    }
    
    
    
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [HUD removeFromSuperview];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self ini];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self.view];
  }


@end
