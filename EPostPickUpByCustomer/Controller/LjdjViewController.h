//
//  MenuViewController.h
//  EPostPickUpByCustomer
//
//  Created by user on 15-10-9.
//  Copyright (c) 2015年 gotop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"

@interface LjdjViewController : UIViewController<NSXMLParserDelegate>
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;


@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic,retain) NSMutableString * soapResults;

@end
