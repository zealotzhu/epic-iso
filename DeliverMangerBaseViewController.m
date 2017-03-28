//
//  ViewController+DeliverMangerBaseViewController.m
//  EPostPickUpByCustomer
//
//  Created by zsm on 17/1/15.
//  Copyright © 2017年 gotop. All rights reserved.
//

#import "DeliverMangerBaseViewController.h"

@implementation DeliverMangerBaseViewController:UIViewController
@synthesize _GTSocketUtils;

-(void) onConnectionDone:(NSError *)error
{
    
}
-(void) onWriteDataDone:(NSData *) data withTag:(long)tag
{
    
}
-(void) onSocketWriteTimeout:(NSTimeInterval)elapsed
{
    [HUD hide:YES];
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"错误" message:@"发送服务请求超时" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
}

-(void) onSocketReadTimeout:(NSTimeInterval)elapsed
{
    [HUD hide:YES];
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"错误" message:@"接收数据超时" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
    
}
-(void)requestData
{
        if(_sendMsg==nil)
        {
            [HUD hide:YES];
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"错误" message:@"发送数据生成失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
        }
        if ([Utility netState])
        {
            [HUD show:[HUD isHidden]];
            NSError *aerror = nil;
            [_GTSocketUtils connect:@"211.156.198.98" port:8994 error:aerror];   //最先进行端口绑定
            //[self.ssxxfklsocket connectToHost:@"10.214.40.233" onPort:9990 error:&error];   //最先进行端口绑定
            
            if (aerror)
            {
                //self.textview.text = error.description;  //注意这里是没有提示的   就算错误了  也不会有报错
            }
            else
            {
                //self.textview.text = @"服务器连接成功!";
                [_GTSocketUtils sendMsg:[_sendMsg dataUsingEncoding:NSUTF8StringEncoding ]  withTimeout:30 tag:104];
            }
            
            
        }
        else
        {
            [HUD hide:YES];
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:@"网络异常，请稍后再试" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
        }
}

-(void)viewWillAppear:(BOOL)animated{
    
    _GTSocketUtils = [[GTSocketUtils alloc] initObjectWithDelegate:self];
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"查询中";
    HUD.square = YES;
    [HUD show:YES];
    [self requestData];  //在这里开始调用
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
@end
