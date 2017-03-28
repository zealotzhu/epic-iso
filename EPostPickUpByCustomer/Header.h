//
//  Header.h
//  EPostPickUpByCustomer
//
//  Created by user on 15-11-24.
//  Copyright (c) 2015年 gotop. All rights reserved.
//

#ifndef EPostPickUpByCustomer_Header_h
#define EPostPickUpByCustomer_Header_h
#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "ZBarSDK.h"
#import <QuartzCore/QuartzCore.h>
NSString *sfdm;
NSString *jgbh;
NSString *gKey;
NSString *gIP;
NSString *gPort;
NSString *czygh; //操作员工号

int gNetState;
CGFloat constant;
CGFloat fonsize;

NSXMLParser *xmlParser1;
NSMutableString * soapResults1;

ZBarReaderView *_readerView;  //摄像机扫描界面
NSTimer *_timer;   //时间定时器


NSInteger *tjjjbz; //退件交接标志  全局使用
#endif
