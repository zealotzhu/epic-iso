//
//  YWLTJViewController.m
//  EPostPickUpByCustomer
//
//  Created by lzb on 17/1/8.
//  Copyright © 2017年 gotop. All rights reserved.
//

#import "YWLTJViewController.h"
#import "parseYWLViewController.h"    //引入被封装的解析类
#import "ZWZLockableTableView.h"

#define kScreenWidth [[UIScreen mainScreen]bounds].size.width
#define kScreenHeight [[UIScreen mainScreen]bounds].size.height

@implementation YWLTJViewController

-(void)onSocketInit
{
    [self generateRequestData:self.ywltjV_JGBH :self.ywltjV_JB :self.ywltjV_JB :self.ywltjV_DATEBEGIN :self.ywltjV_DATEEND :self.ywltjV_LX];  //在这里开始调用
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"业务量统计";
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
    
    parserecv = [[parseYWLViewController alloc]init];
    [parserecv LoadData:self.view];
    
}
//返回消息时回调
- (void)onSocketReadDataDone:(NSData *)data withTag:(long)tag  //3
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
        
        
        Outarray = [parserecv parseRecvData:@"600151" :dataStr];
        
        
        //获取传出数组的首个元素 拼接机构编号和 级别
        NSMutableArray *getdicdata=Outarray.firstObject;
        NSDictionary *ywltjjgjbDic = [NSDictionary dictionaryWithObjects:getdicdata[0] forKeys:getdicdata[2]];
        NSDictionary *ywltjjgbhDic = [NSDictionary dictionaryWithObjects:getdicdata[1] forKeys:getdicdata[2]];
        //NSLog(@"解析传出数组获取到 级别 和 机构编号 是[%@][%@]",ywltjjgbhDic,ywltjjgjbDic);
        
        
        
        [Outarray removeObjectAtIndex:0]; //将多余的数组元素移除达到想要的格式
        NSLog(@"2222传出数组是[%@]",Outarray);
        
        
        
        ZWZLockableTableView *ZWZView = [[ZWZLockableTableView alloc] initWithFrame:CGRectMake(5, 64, kScreenWidth-10, kScreenHeight-150/*35*9.5*/) dataArray:Outarray];
        [ZWZView showFromSuperView:self.view];
        
        [ZWZView returnSelectItem:^(id returnValue)
         {
             NSString *str = returnValue;
             
             NSLog(@"点击了：[%@] [%@] [%@]",str,ywltjjgbhDic[str],ywltjjgjbDic[str]);
             int ckjb=[ywltjjgjbDic[str] intValue]+1;
             
             if(ckjb >= 6){  //到了6 不进行调用
             
                 NSLog(@"调用到尽头 无法再次调用");
                 UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已到达最后一级！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alter show];

                 
             }
             else{
             
                 [self generateRequestData:ywltjjgbhDic[str] :ywltjjgjbDic[str] :[ NSString stringWithFormat:@"%d",ckjb]:self.ywltjV_DATEBEGIN :self.ywltjV_DATEEND :self.ywltjV_LX];  //在这里开始调用
                 [self requestData];
             }
             
         }];
        
        
        
        
    }
    
    else{
        
        [HUD hide:YES];
        
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:array[2] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        
    }
}

-(void)generateRequestData :(NSString *)jgbh :(NSString *)jgjb :(NSString *)ckjb : (NSString *)begindate :(NSString *)enddate :(NSString *)lx {
    if((![self.ywltjV_JGBH isEqualToString:@""]) && (![self.ywltjV_JB isEqualToString:@""]) && (![self.ywltjV_LX isEqualToString:@""]) )  //(!self.ywltjV_JGBH) && (!self.ywltjV_JB) &&
        
    {
        //获得要拼接的字段
        NSString *sendywltjV_JGBH=[@"#|" stringByAppendingString:jgbh ];
        NSString *sendywltjV_JB=[@"#|" stringByAppendingString: jgjb ];
        
        NSString *sendv_ckjb =[@"#|" stringByAppendingString: ckjb ];
        NSString *sendksrq=[@"#|" stringByAppendingString:begindate ];
        NSString *sendjsrq=[@"#|" stringByAppendingString:enddate ];
        NSString *sendlx=[@"#|" stringByAppendingString:lx ];
        
        NSString *sendrow=@"#|32";
        NSString *sendpage=@"#|1";
        
        //获得系统时间
        NSString * localtime =[Utility getdatetime];
        NSLog(@"Utility getdatetime[%@]",localtime);
        
        
        //获得报文头字符串写死
        NSString * ywltjHeadstring=@"600151#|0022#|1.0.0.3#|";
        
        //待发送的报文 为了统计长度
        NSString *ForywltjString =[ywltjHeadstring stringByAppendingFormat:@"%@%@%@%@%@%@%@%@%@",localtime,sendywltjV_JGBH,sendywltjV_JB,sendv_ckjb,sendksrq,sendjsrq,sendlx,sendrow,sendpage];
        NSLog(@"准备发送的报文是[%@]长度是[%06d]",ForywltjString,[Utility convertToInt:ForywltjString]);
        
        //便利构造
        _sendMsg = [NSString stringWithFormat:@"%@%@%06d%@%@%@%@%@%@%@%@", ywltjHeadstring, localtime,[Utility convertToInt:ForywltjString],sendywltjV_JGBH,sendywltjV_JB,sendv_ckjb,sendksrq,sendjsrq,sendlx,sendrow,sendpage];
        NSLog(@"发送的报文是[%@]",_sendMsg);
        
    }
    //输入警告 的语句 不用管 将警告的页面弹框出来
    else {
        
        NSLog(@"self.ywltjV_JGBH,_ywltjV_JB[%@][%@]",self.ywltjV_JGBH,_ywltjV_JB);
        
        [HUD hide:YES];
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:@"网络异常，请稍后再试" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
