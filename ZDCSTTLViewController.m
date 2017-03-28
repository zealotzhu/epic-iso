//
//  ZDCSTTLViewController.m
//  EPostPickUpByCustomer
//
//  Created by lzb on 17/1/8.
//  Copyright © 2017年 gotop. All rights reserved.
//

#import "ZDCSTTLViewController.h"



#import "ZWZLockableTableView.h"
#define kScreenWidth [[UIScreen mainScreen]bounds].size.width
#define kScreenHeight [[UIScreen mainScreen]bounds].size.height


#import "parseZDCSTTLViewController.h"


#import "Utility.h"
#import "GCDAsyncSocket.h"
#import "MBProgressHUD.h"


@interface ZDCSTTLViewController ()<GCDAsyncSocketDelegate,MBProgressHUDDelegate>{
    
    MBProgressHUD *HUD;
    parseZDCSTTLViewController *parserecv;
    NSMutableArray *Outarray;
}

//客户端
@property (nonatomic, strong) GCDAsyncSocket *  zdcsttlsocket;//创建套接字



@end

@implementation ZDCSTTLViewController



-(void)viewWillAppear:(BOOL)animated{
    
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"查询中";
    HUD.square = YES;
    //[HUD show:YES];
    
    //[self zdcsttlRequestData];  //在这里开始调用
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"重点城市妥投率";
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

    
    
    parserecv = [[parseZDCSTTLViewController alloc]init];
    parserecv.delegate =self;
    [parserecv LoadData:self.view];
        
    // Do any additional setup after loading the view from its nib.
}



//
//
////socket 相关定义
//-(GCDAsyncSocket *)ywltjsocket  //进行懒加载
//{
//    
//    if(!_ywltjsocket)
//        
//    {
//        _ywltjsocket=[[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//        
//    }
//    return _ywltjsocket;
//}
////成功连接到服务器  //绑定ip 端口号
//- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port  //1
//{
//    // NSLog(@"连接成功的ip 和 端口 是: %@ port: %hu", host, port);
//    [self.ywltjsocket readDataWithTimeout:30 tag:101];
//}
////发送成功以后回调函数  可用来进行判断tag 是哪个button
//- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag   // 2
//{
//    NSLog(@"didWriteDataWithTag: %ld", tag);  //这个是发送成功的 tag
//}
////返回消息时回调
//- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag  //3
//{
//    
//    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);  //自定义编码类型
//    NSString *dataStr = [[NSString alloc] initWithData:data encoding:gbkEncoding];  //使用其编码 返回nsstring
//    NSLog(@"接收返回信息：%@",dataStr);
//    NSLog(@"\n\n接收返回tag：%ld",tag);   //这个是返回的 tag  因为被socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port  //1  改了
//    
//    //self.textview.text = dataStr;
//    
//    
//    
//    NSArray  * array= [dataStr componentsSeparatedByString:@"#|"];
//    NSLog(@"[%@]",array);
//    
//    if([array.firstObject isEqualToString:@"0000"]){
//        
//        [HUD hide:YES];
//        
//        
//        Outarray = [parserecv parseRecvData:@"600151" :dataStr];
//        
//        
//        NSLog(@"传出数组是[%@]",Outarray);
//        
//        
//        
//        ZWZLockableTableView *ZWZView = [[ZWZLockableTableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 35*9.5) dataArray:Outarray];
//        [ZWZView showFromSuperView:self.view];
//        
//        [ZWZView returnSelectItem:^(id returnValue)
//         {
//             NSString *str = returnValue;
//             NSLog(@"点击了：%@",str);
//         }];
//        
//        
//        
//        
//    }
//    
//    else{
//        
//        [HUD hide:YES];
//        
//        
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:array[2] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alter show];
//        
//    }
//    
//    [self.ywltjsocket readDataWithTimeout:30 tag:101];
//    [self.ywltjsocket disconnectAfterReading];  //读取完之后关闭整个 socket
//}
//
////连接失败
//- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err   // 4
//{
//    NSLog(@"连接失败错误原因: %@", err);
//}
//
//
//
//
//
//-(void)ywltjRequestData {
//    
//    
//    if((![self.ywltjV_JGBH isEqualToString:@""]) && (![self.ywltjV_JB isEqualToString:@""]) && (![self.ywltjV_LX isEqualToString:@""]) )  //(!self.ywltjV_JGBH) && (!self.ywltjV_JB) &&
//        
//    {
//        
//        
//        //获得要拼接的字段
//        NSString *sendywltjV_JGBH=[@"#|" stringByAppendingString:self.ywltjV_JGBH ];
//        NSString *sendywltjV_JB=[@"#|" stringByAppendingString: self.ywltjV_JB ];
//        
//        NSString *sendv_ckjb =@"#|1";
//        NSString *sendksrq=[@"#|" stringByAppendingString:self.ywltjV_DATEBEGIN ];
//        NSString *sendjsrq=[@"#|" stringByAppendingString:self.ywltjV_DATEEND ];
//        NSString *sendlx=[@"#|" stringByAppendingString:self.ywltjV_LX ];
//        
//        NSString *sendrow=@"#|32";
//        NSString *sendpage=@"#|1";
//        
//        //获得系统时间
//        NSString * localtime =[Utility getdatetime];
//        NSLog(@"Utility getdatetime[%@]",localtime);
//        
//        
//        //获得报文头字符串写死
//        NSString * ywltjHeadstring=@"600151#|0022#|1.0.0.3#|";
//        
//        //待发送的报文 为了统计长度
//        NSString *ForywltjString =[ywltjHeadstring stringByAppendingFormat:@"%@%@%@%@%@%@%@%@%@",localtime,sendywltjV_JGBH,sendywltjV_JB,sendv_ckjb,sendksrq,sendjsrq,sendlx,sendrow,sendpage];
//        NSLog(@"准备发送的报文是[%@]长度是[%06d]",ForywltjString,[Utility convertToInt:ForywltjString]);
//        
//        //便利构造
//        NSString *ywltjString = [NSString stringWithFormat:@"%@%@%06d%@%@%@%@%@%@%@%@", ywltjHeadstring, localtime,[Utility convertToInt:ForywltjString],sendywltjV_JGBH,sendywltjV_JB,sendv_ckjb,sendksrq,sendjsrq,sendlx,sendrow,sendpage];
//        NSLog(@"发送的报文是[%@]",ywltjString);
//        
//        
//        //测试字符串的长度
//        /*
//         NSString *aaa=@"0000#|99#|#|000271#|#*5#|2#|10000100#|北京市邮政公司#|0#|0#|0#|0#|0#|0#|0#|2#|31000100#|浙江省邮政公司#|0#|0#|0#|0#|0#|0#|0#|2#|35000100#|福建省邮政局#|0#|0#|0#|0#|0#|0#|0#|2#|45000100#|河南省邮政公司#|0#|0#|0#|0#|0#|0#|0#|2#|83000100#|新疆省邮政局#|0#|0#|0#|0#|0#|0#|0#*";
//         NSLog(@"[%06lu]",(unsigned long)aaa.length);
//         NSLog(@"[%06lu]",sizeof([[aaa dataUsingEncoding:NSUTF8StringEncoding] bytes]));
//         NSLog(@"[%06lu]",strlen([[aaa dataUsingEncoding:NSUTF8StringEncoding] bytes]));
//         NSLog(@"[%06d]",[Utility convertToInt:aaa]);
//         */
//        
//        if ([Utility netState])
//        {
//            //HUD.labelText = @"登录中";
//            //[HUD show:YES];
//            
//            
//            
//            //需要查看服务器的ip地址    192.168.190.66
//            if ([self.ywltjsocket isDisconnected])
//            {
//                NSError *error = nil;
//                [self.ywltjsocket connectToHost:@"211.156.198.98" onPort:8994 error:&error];   //最先进行端口绑定
//                //[self.ywltjsocket connectToHost:@"10.214.40.233" onPort:9990 error:&error];   //最先进行端口绑定
//                
//                if (error)
//                {
//                    //self.textview.text = error.description;  //注意这里是没有提示的   就算错误了  也不会有报错
//                }
//                else
//                {
//                    //self.textview.text = @"服务器连接成功!";
//                    [self.ywltjsocket writeData:[ywltjString dataUsingEncoding:NSUTF8StringEncoding] withTimeout:30 tag:101];
//                }
//            }
//            
//            
//            
//            
//            
//            
//        }
//        
//        else{
//            
//            
//            [HUD hide:YES];
//            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:@"网络异常，请稍后再试" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alter show];
//        }
//        
//    }
//    
//    //输入警告 的语句 不用管 将警告的页面弹框出来
//    else {
//        
//        NSLog(@"self.ywltjV_JGBH,_ywltjV_JB[%@][%@]",self.ywltjV_JGBH,_ywltjV_JB);
//        
//        [HUD hide:YES];
//        
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:@"网络异常，请稍后再试" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alter show];
//    }
//    
//    
//    
//}
//
//
//
//

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
