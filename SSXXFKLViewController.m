//
//  SSXXFKLViewController.m
//  EPostPickUpByCustomer
//
//  Created by lzb on 17/1/8.
//  Copyright © 2017年 gotop. All rights reserved.
//

#import "SSXXFKLViewController.h"


#import "ZWZLockableTableView.h"
#define kScreenWidth [[UIScreen mainScreen]bounds].size.width
#define kScreenHeight [[UIScreen mainScreen]bounds].size.height

@implementation SSXXFKLViewController:DeliverMangerBaseViewController
-(void) onSocketInit
{
    if((![self.ssxxfklV_JGBH isEqualToString:@""]) && (![self.ssxxfklV_JB isEqualToString:@""]) && (![self.ssxxfklV_LX isEqualToString:@""]) )  //(!self.ssxxfklV_JGBH) && (!self.ssxxfklV_JB) &&
        
    {
        //获得要拼接的字段
        NSString *sendssxxfklV_JGBH=[@"#|" stringByAppendingString:self.ssxxfklV_JGBH ];
        NSString *sendssxxfklV_JB=[@"#|" stringByAppendingString: self.ssxxfklV_JB ];
        
        NSString *sendv_ckjb =[@"#|" stringByAppendingString: self.ssxxfklV_JB ];
        NSString *sendksrq=[@"#|" stringByAppendingString:self.ssxxfklV_DATEBEGIN ];
        NSString *sendjsrq=[@"#|" stringByAppendingString:self.ssxxfklV_DATEEND ];
        NSString *sendlx=[@"#|" stringByAppendingString:self.ssxxfklV_LX ];
        
        NSString *sendrow=@"#|32";
        NSString *sendpage=@"#|1";
        
        //获得系统时间
        NSString * localtime =[Utility getdatetime];
        NSLog(@"Utility getdatetime[%@]",localtime);
        
        
        //获得报文头字符串写死
        NSString * ssxxfklHeadstring=@"600142#|0022#|1.0.0.3#|";
        
        //待发送的报文 为了统计长度
        NSString *ForssxxfklString =[ssxxfklHeadstring stringByAppendingFormat:@"%@%@%@%@%@%@%@%@%@",localtime,sendssxxfklV_JGBH,sendssxxfklV_JB,sendv_ckjb,sendksrq,sendjsrq,sendlx,sendrow,sendpage];
        NSLog(@"准备发送的报文是[%@]长度是[%06d]",ForssxxfklString,[Utility convertToInt:ForssxxfklString]);
        
        //便利构造
         _sendMsg = [NSString stringWithFormat:@"%@%@%06d%@%@%@%@%@%@%@%@", ssxxfklHeadstring, localtime,[Utility convertToInt:ForssxxfklString],sendssxxfklV_JGBH,sendssxxfklV_JB,sendv_ckjb,sendksrq,sendjsrq,sendlx,sendrow,sendpage];
        NSLog(@"发送的报文是[%@]",_sendMsg);
        
    }
}
-(void) onSocketReadDataDone:(NSData *) data withTag:(long)tag
{

    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);  //自定义编码类型
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:gbkEncoding];  //使用其编码 返回nsstring
    NSLog(@"接收返回信息：%@",dataStr);
    NSLog(@"\n\n接收返回tag：%ld",tag);   //这个是返回的 tag  因为被socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port  //1  改了
    
    //self.textview.text = dataStr;
    
    
    
    NSArray  * array= [dataStr componentsSeparatedByString:@"#|"];
    NSLog(@"[%@]",array);
    
    if([array.firstObject isEqualToString:@"0000"]){
        
        [HUD hide:YES];
        
        
        Outarray = [parserecv parseRecvData:@"600142" :dataStr];
        
        
        NSLog(@"传出数组是[%@]",Outarray);
        
        
        
        ZWZLockableTableView *ZWZView = [[ZWZLockableTableView alloc] initWithFrame:CGRectMake(5, 64, kScreenWidth-10, kScreenHeight-150/*35*9.5*/) dataArray:Outarray];
        [ZWZView showFromSuperView:self.view];
        
        [ZWZView returnSelectItem:^(id returnValue)
         {
             NSString *str = returnValue;
             NSLog(@"点击了：%@",str);
         }];
        
        
        
        
    }
    
    else{
        
        [HUD hide:YES];
        
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:array[2] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实时信息反馈率";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    //旧版的图片旋转方式
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(12, 20, 30, 30)];
    imageview.layer.masksToBounds = YES;
    [imageview setImage:[UIImage imageNamed:@"excel"]];
    imageview.contentMode = UIViewContentModeScaleToFill;
    imageview.autoresizesSubviews = YES;
    [self.view addSubview:imageview];
    
    UILabel *tiplabel =[[UILabel alloc] initWithFrame:CGRectMake(45, 22, 200, 30)];
    tiplabel.text=@"单击可查看下级机构明细";
    tiplabel.textColor=[UIColor redColor];
    tiplabel.textAlignment=NSTextAlignmentLeft;
    tiplabel.font=[UIFont systemFontOfSize:14.0f];
    [self.view addSubview:tiplabel];
    
    parserecv = [[parseSSXXFKLViewController alloc]init];
    [parserecv LoadData:self.view];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
