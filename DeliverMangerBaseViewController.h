//
//  ViewController+DeliverMangerBaseViewController.h
//  EPostPickUpByCustomer
//
//  Created by zsm on 17/1/15.
//  Copyright © 2017年 gotop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "GTSocketUtils.h"
#import "MBProgressHUD.h"
@interface DeliverMangerBaseViewController:UIViewController<GTSocketUtilsDelegate,MBProgressHUDDelegate>
{
  MBProgressHUD *HUD;
  NSMutableArray *Outarray;
  GTSocketUtils   *_GTSocketUtils;
  //20170113 add by zsm
  NSString * _sendMsg;
}
@property(strong,nonatomic) GTSocketUtils *_GTSocketUtils;
-(void)requestData;
@end
