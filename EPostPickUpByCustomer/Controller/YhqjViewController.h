//
//  YhqjViewController.h
//  EPostPickUpByCustomer
//
//  Created by user on 15-11-5.
//  Copyright (c) 2015年 gotop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YhqjViewController : UIViewController<NSXMLParserDelegate>



@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic,retain) NSMutableString * soapResults;
@property(nonatomic,retain) NSData *receivedData;

@property(nonatomic,retain) NSString *receivedyjlsh;

@property(nonatomic,retain) NSString *getzjlx;


@end
