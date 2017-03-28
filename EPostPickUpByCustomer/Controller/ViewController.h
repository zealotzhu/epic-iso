//
//  ViewController.h
//  EPostPickUpByCustomer
//
//  Created by user on 15-9-28.
//  Copyright (c) 2015年 gotop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
@interface ViewController : SuperViewController<NSXMLParserDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;


@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic,retain) NSMutableString * soapResults;


//@property NSString *actCheck;
//@property NSString *pwdCheck;


@end

