//
//  ViewController.m
//  EPostPickUpByCustomer
//
//  Created by user on 15-9-28.
//  Copyright (c) 2015年 gotop. All rights reserved.
//  Epost.list actCheck 0   pwdCheck 1  ip 2    port 3  account 4

#import "ViewController.h"
#import "SSKeychain.h"
#import "Utility.h"

#import "ViewController.h"
#import "CommonFunc.h"
#import "md5.h"
#import "SBJson.h"
//新增
#import "Masonry.h"
#import "MenuViewController.h"
#import "GCDAsyncSocket.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenheighth [UIScreen mainScreen].bounds.size.height


@interface ViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, MBProgressHUDDelegate,UIScrollViewDelegate,GCDAsyncSocketDelegate/*, InputToolBarDelegate*/> {
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UISwitch *actSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *pwdSwitch;
//plist  配置ip 端口 是否记住账号密码
@property (nonatomic) NSArray *paths;
@property (nonatomic) NSString *path;
@property (nonatomic) NSString *filename;
@property (nonatomic) NSMutableArray *array;
@property (nonatomic) NSString *service;
// 账号匹配所需变量
@property (nonatomic, strong) NSArray *actArray;
@property (nonatomic) NSInteger actCount;
@property (nonatomic) NSMutableArray *matchArray;   //存放匹配到的用户的账号
@property (nonatomic) NSString *actString;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationbr;

@property (strong, nonatomic) IBOutlet UIButton *languagebtn;
@property (strong, nonatomic) IBOutlet UIButton *setbtn;



@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

// 界面调整
@property (weak, nonatomic) IBOutlet UIImageView *loginimageview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gotopLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnHeight;
@property (weak, nonatomic) IBOutlet UILabel *gotopLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *actSwitchLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdSwitchLabel;
@property (weak, nonatomic) IBOutlet UILabel *actLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;
@property (weak, nonatomic) IBOutlet UILabel *portLabel;


//客户端
@property (nonatomic, strong) GCDAsyncSocket *loginsocket;//创建套接字


@end

@implementation ViewController



@synthesize xmlParser;               //存储解析后的数据
@synthesize soapResults;             //返回结果



#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSThread sleepForTimeInterval:4.0];   //设置进程停止3秒

    
    [Utility netWarm];      //网络监测
    [self initVar];
    
    
    //    [self.navigationController setTitle:@"登录"];
    //    [self checkUpdate];   //更新
    
    
   ///* //设置背景图片的方法二
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login"]]; //12 18 26通缉令 19  27彩色绚烂  28酷炫
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    bgView.autoresizesSubviews = YES;
    bgView.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    bgView.userInteractionEnabled=YES;
    bgView.frame = self.view.bounds;
    
    [self.view addSubview:bgView];  //这个方法不行  会露出来
    [self.view sendSubviewToBack:bgView];
    
    //self.view.backgroundColor=[UIColor grayColor];
   //*/
    
    
    self.navigationbr.hidden=YES;  //可以将这个导航栏暂时隐藏起来
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;//防止手势侧滑再跑回去
    
    
    self.scrollview.delegate=self;
    self.scrollview.backgroundColor = [UIColor clearColor];
    self.scrollview.contentSize = CGSizeMake(kScreenWidth, kScreenheighth*1.5);  //直接设定滑动的范围就是三倍的页面
    //self.scrollview.contentOffset = CGPointMake(0, 0);
    self.scrollview.pagingEnabled = NO;  //记住不要开启分页  否则会轻易点击导致滑动
    self.scrollview.bounces=NO;
    //设置取消触摸
    self.scrollview.canCancelContentTouches = NO;
    //是否自动裁切超出部分
    self.scrollview.clipsToBounds = YES;
    //设置是否可以滚动
    self.scrollview.scrollEnabled = YES;
    //设置在拖拽的时候是否锁定其在水平或者垂直的方向
    self.scrollview.directionalLockEnabled = YES;
    //隐藏滚动条设置（水平、跟垂直方向）
    self.scrollview.alwaysBounceHorizontal = NO;
    self.scrollview.alwaysBounceVertical = NO;
  
   
    
    //UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
    //imageView.image = [UIImage imageNamed:@"loginlogo"];
    //[self.scrollview addSubview:imageView];
    /*[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(150);
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
        //make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.height.mas_equalTo(50);
        //make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);  //底部距离父界面 5
    }];*/

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    [self.navigationController.navigationBar setHidden:YES];
    [_loginBtn.layer setMasksToBounds:YES];
    [_loginBtn.layer setCornerRadius:5.0f];
    //    NSLog(@"%f", self.view.frame.size.height);
    if (self.view.frame.size.height > 480.0f && self.view.frame.size.height < 570) {
        fonsize = 15.0f;  //fonsize = 12.0f;   fonsize = 15.0f;
        [self adjustLaytout];
    } else if (self.view.frame.size.height > 568) {
        fonsize = 18.0f;   //fonsize = 15.0f;    fonsize = 18.0f;
       // [self adjustLaytout];
    }
}

- (void)adjustLaytout {
    _gotopLabel.font = [UIFont systemFontOfSize:18.0f];
    _versionLabel.font = [UIFont systemFontOfSize:18.0f];
    _actSwitchLabel.font = [UIFont systemFontOfSize:fonsize];
    _pwdSwitchLabel.font = [UIFont systemFontOfSize:fonsize];
    _actLabel.font = [UIFont systemFontOfSize:fonsize];
    _accountTextField.font = [UIFont systemFontOfSize:fonsize];
    _pwdLabel.font = [UIFont systemFontOfSize:fonsize];
    _pwdTextField.font = [UIFont systemFontOfSize:fonsize];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:fonsize];
    _ipLabel.font = [UIFont systemFontOfSize:fonsize];
    _ipTextField.font = [UIFont systemFontOfSize:fonsize];
    _portLabel.font = [UIFont systemFontOfSize:fonsize];
    _portTextField.font = [UIFont systemFontOfSize:fonsize];
    _gotopLabelTop.constant = 40.0f;
    _loginBtnHeight.constant = _CONSTANT_;
    [self.view layoutIfNeeded];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    [self.navigationController.navigationBar setHidden:NO];
}
- (IBAction)netSetting:(id)sender {
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"netSetting"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)language:(id)sender {
    
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ywlchangeview"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)backLogin:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
}


- (void)checkUpdate {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
 //   NSLog(@"%@", currentVersion);
    
    NSString *URL = @"http://itunes.apple.com/lookup?id=你的应用程序的ID";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [results JSONValue];
    NSArray *infoArray = [dic objectForKey:@"results"];
    
    if ([infoArray count]) {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
        if (![lastVersion isEqualToString:currentVersion]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com"];
        [[UIApplication sharedApplication]openURL:url];
    }
}

- (void)initVar{
    
    
    self.languagebtn.showsTouchWhenHighlighted=YES;
    self.setbtn.showsTouchWhenHighlighted=YES;
    self.loginBtn.showsTouchWhenHighlighted=YES;

    
    self.ipTextField.delegate=self;
    self.portTextField.delegate=self;//将ip 和 端口号 的键盘设置可以关闭
    
//    self.accountTextField.delegate=self;
//    self.pwdTextField.delegate=self;//将ip 和 端口号 的键盘设置可以关闭
//    
//    self.tableView.delegate=self;
//    self.tableView.dataSource=self;
    
    gKey = @"A801C860DD05418F";
    self.service = @"com.gotop.epost";
    //显示几个匹配到到账号
    self.matchArray = [[NSMutableArray alloc]initWithObjects:@"", @"", @"", @"", @"",nil];
    self.actString = @"";
    [self.tableView setHidden:YES];
    [self plistInit];
    
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"登录中";
    HUD.square = YES;
  }



//socket 相关定义
-(GCDAsyncSocket *)loginsocket  //进行懒加载
{
    
    if(!_loginsocket)
        
    {
        _loginsocket=[[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
    }
    return _loginsocket;
}
//成功连接到服务器  //绑定ip 端口号
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port  //1
{
    // NSLog(@"连接成功的ip 和 端口 是: %@ port: %hu", host, port);
    [self.loginsocket readDataWithTimeout:-1 tag:100];
}
//发送成功以后回调函数  可用来进行判断tag 是哪个button
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag   // 2
{
    NSLog(@"didWriteDataWithTag: %ld", tag);  //这个是发送成功的 tag
}
//返回消息时回调
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag  //3
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
        if (self.actSwitch.on && self.pwdSwitch.on) {
            [SSKeychain setPassword:self.pwdTextField.text forService:self.service account:self.accountTextField.text];
        } else if(self.actSwitch.on){
            [SSKeychain setPassword:@"" forService:self.service account:self.accountTextField.text];
        }
        else if(!self.actSwitch.on){   // 不记住账号
            [SSKeychain deletePasswordForService:self.service account:self.accountTextField.text];
        }
        [_array replaceObjectAtIndex:4 withObject:self.accountTextField.text];
        [_array writeToFile:_filename  atomically:YES];
        
        
        
        UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        MenuViewController *vc = [sb instantiateViewControllerWithIdentifier:@"menu"];
        
        vc.V_YGXM = array[4];
        vc.V_JGBH = array[5];
        vc.V_JGMC = array[6];
        vc.V_JB = array[7];
        
        NSLog(@"员工姓名[%@],机构编号[%@],机构名称[%@],级别[%@]",vc.V_YGXM,vc.V_JGBH,vc.V_JGMC,vc.V_JB);
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    else{
    
        [HUD hide:YES];
        
        
        [self.accountTextField resignFirstResponder];
        [self.pwdTextField resignFirstResponder];
        CGRect rect = self.view.frame;
        if (rect.origin.y < 0) {
            self.view.frame = CGRectMake(rect.origin.x, rect.origin.y + 150, rect.size.width, rect.size.height);
        }

        [SSKeychain setPassword:@"" forService:self.service account:self.accountTextField.text];
        self.pwdTextField.text = @"";
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:array[2] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];

    }
    
    [self.loginsocket readDataWithTimeout:-1 tag:100];
}

//连接失败
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err   // 4
{
    NSLog(@"连接失败错误原因: %@", err);
}






- (IBAction)login:(id)sender {
    
    
    if((![_accountTextField.text isEqualToString:@""]) && (![_pwdTextField.text isEqualToString:@""])){
        
        
        //获得账号密码
        NSString *accounttext=[@"#|" stringByAppendingString:_accountTextField.text ];
        NSString *pwdtext=[@"#|" stringByAppendingString: _pwdTextField.text ];
        
        //获得系统时间
        NSString * localtime =[Utility getdatetime];
        NSLog(@"Utility getdatetime[%@]",localtime);
        
        
        //获得报文头字符串写死
        NSString * loginHeadstring=@"600140#|0022#|1.0.0.3#|";
        
        //待发送的报文 为了统计长度
        NSString *ForloginString =[loginHeadstring stringByAppendingFormat:@"%@%@%@",localtime,accounttext,pwdtext];
        NSLog(@"准备发送的报文是[%@]长度是[%06d]",ForloginString,[Utility convertToInt:ForloginString]);
        
        //便利构造
        NSString *loginString = [NSString stringWithFormat:@"%@%@%06d%@%@", loginHeadstring, localtime,[Utility convertToInt:ForloginString],accounttext,pwdtext];
        NSLog(@"发送的报文是[%@]",loginString);
        
        
        //测试字符串的长度
        /*
        NSString *aaa=@"0000#|99#|#|000271#|#*5#|2#|10000100#|北京市邮政公司#|0#|0#|0#|0#|0#|0#|0#|2#|31000100#|浙江省邮政公司#|0#|0#|0#|0#|0#|0#|0#|2#|35000100#|福建省邮政局#|0#|0#|0#|0#|0#|0#|0#|2#|45000100#|河南省邮政公司#|0#|0#|0#|0#|0#|0#|0#|2#|83000100#|新疆省邮政局#|0#|0#|0#|0#|0#|0#|0#*";
        NSLog(@"[%06lu]",(unsigned long)aaa.length);
        NSLog(@"[%06lu]",sizeof([[aaa dataUsingEncoding:NSUTF8StringEncoding] bytes]));
        NSLog(@"[%06lu]",strlen([[aaa dataUsingEncoding:NSUTF8StringEncoding] bytes]));
        NSLog(@"[%06d]",[Utility convertToInt:aaa]);
        */
        
        if ([Utility netState])
        {
            HUD.labelText = @"登录中";
            [HUD show:YES];
    
            
            
            //需要查看服务器的ip地址    192.168.190.66
            if ([self.loginsocket isDisconnected])
            {
                NSError *error = nil;
                [self.loginsocket connectToHost:@"211.156.198.98" onPort:8994 error:&error];   //最先进行端口绑定
                //[self.loginsocket connectToHost:@"10.214.40.233" onPort:9990 error:&error];   //最先进行端口绑定
                
                if (error)
                {
                    //self.textview.text = error.description;  //注意这里是没有提示的   就算错误了  也不会有报错
                }
                else
                {
                    //self.textview.text = @"服务器连接成功!";
                    [self.loginsocket writeData:[loginString dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:100];
                    
                    
                    
                    /*以下为测试专用*/
                    //[self.loginsocket writeData:[@"600151#|0022#|1.0.0.3#|20170106143126#|99#|000099#|10000000#|1#|1#|2016.12.30#|2017.01.05#|5#|32#|1" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:100];
                    //业务量统计接口 测试可以用
                    
                    
                    
                    
                }
            }

            
            
            
            
        
        }
        
        else{
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:@"无网络连接，请先设置好网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
        }

    }
    
    //输入警告 的语句 不用管 将警告的页面弹框出来
    else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请重新输入账号密码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
    }

    
    
}




//原来的报文解析 已经不需要
/*
-(void) connection:(NSURLConnection *) connection didReceiveData:(NSData *)responseData
{
    
  //  NSLog(@"url 是[%@]\n\n",connection);
    
    
    NSString * returnSoapXML = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"返回的soap信息是：[%@]\n",returnSoapXML); //设置编码 获得返回值
    
    
    
    
   
    //开始解析xml
    xmlParser = [[NSXMLParser alloc] initWithData: responseData];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities: YES];
    
    [xmlParser parse];//这里就是进行解析的函数调用
    
    
    
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
  //  NSLog(@"返回的soap内容中，return值是： [%@]\n\n",string);
    
    
    
    SBJsonParser *parser2 = [[SBJsonParser alloc] init];
    NSError *error1 = nil;
    
    
    NSMutableDictionary *jsonDic4 = [parser2 objectWithString:string error:&error1];//获取根节点 只需要获取一次
    
      NSDictionary *mm =[jsonDic4 objectForKey:@"V_RESULT" ];
    NSDictionary *mm1 =[jsonDic4 objectForKey:@"V_REMARK" ];
    NSDictionary *mm2 =[jsonDic4 objectForKey:@"V_JYLSH" ];
    // NSDictionary *mm3 =[jsonDic4 objectForKey:@"N_JGSJ" ];
    
    
    NSString *nn = [NSString stringWithFormat:@"%@",mm];
    NSString *nn1 = [NSString stringWithFormat:@"%@",mm1];
    NSString *nn2 = [NSString stringWithFormat:@"%@",mm2];
    //NSString *nn3 = [NSString stringWithFormat:@"%@",mm3];   //将字典类型转换为 string 类型
    
  //  NSLog(@"111[%@]\n",nn);  //先将节点打印出来
   // NSLog(@"222[%@]\n",nn1);
 //   NSLog(@"333[%@]\n",nn2);
    // NSLog(@"[%@]\n",nn3);
    
    
    
    
    NSString *codejiexi =[CommonFunc textFromBase64String:nn1];
 //   NSLog(@"最终解析出来的密文是:[%@]\n",codejiexi);
     if([nn isEqualToString:@"F0"])
        
    {
        [HUD hide:YES];
        //  if (iSuc == 1)
        //  {
        jgbh = self.accountTextField.text;
        if (self.actSwitch.on && self.pwdSwitch.on) {
            [SSKeychain setPassword:self.pwdTextField.text forService:self.service account:self.accountTextField.text];
        } else if(self.actSwitch.on){
            [SSKeychain setPassword:@"" forService:self.service account:self.accountTextField.text];
        }
        else if(!self.actSwitch.on){   // 不记住账号
            [SSKeychain deletePasswordForService:self.service account:self.accountTextField.text];
        }
        [_array replaceObjectAtIndex:4 withObject:self.accountTextField.text];
        [_array writeToFile:_filename  atomically:YES];
        UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"menu"];
        
        [self.navigationController pushViewController:vc animated:NO];
        
        
        //自定义解析报文  获取操作员工号
        SBJsonParser *loginparser2 = [[SBJsonParser alloc] init];
        NSError *loginerror2 = nil;
        NSMutableDictionary *loginjsonDic2 = [loginparser2 objectWithString:codejiexi error:&loginerror2];//获取根节点 只需要获取一次
        NSDictionary *loginmm23 =[loginjsonDic2 objectForKey:@"CZYID" ];
        czygh = [NSString stringWithFormat:@"%@",loginmm23];
   //     NSLog(@"czyid[%@]",czygh);  //这里是获取操作员工号
        
        NSDictionary *loginmm24 =[loginjsonDic2 objectForKey:@"SFDM" ];
        sfdm = [NSString stringWithFormat:@"%@",loginmm24];
   //     NSLog(@"sfdm[%@]",sfdm);  //这里是获取省份代码
        
        
        
        
    }
    //else if(!iSuc)
    else{
        [HUD hide:YES];
        [SSKeychain setPassword:@"" forService:self.service account:self.accountTextField.text];
        self.pwdTextField.text = @"";
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:codejiexi delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
    }
}


//}

*/










//////////////////////////////////////////////////////


- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
}

#pragma mark -  配置ip 端口 是否记住账号密码
// 配置文件
-(void)plistInit{
    
    _paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    _path=[_paths objectAtIndex:0];
    _filename=[_path stringByAppendingPathComponent:[[NSString alloc]initWithCString:_PLISTFILE_ encoding:NSUTF8StringEncoding]];    _array=[[NSMutableArray alloc] initWithContentsOfFile:_filename];
    
    if([_array count] == 5){
        if ([[self.array objectAtIndex:0] isEqual:@"True"]) {
            self.actSwitch.on = YES;
        } else {
            self.actSwitch.on = NO;
            [self.accountTextField setText:@""];
        }
        if ([[self.array objectAtIndex:1] isEqual:@"True"]) {
            self.actSwitch.on = YES;
            self.pwdSwitch.on = YES;
        } else {
            self.pwdSwitch.on = NO;
        }
        gIP = [_array objectAtIndex:2];
        gPort = [_array objectAtIndex:3];
        _ipTextField.text = gIP;
        _portTextField.text = gPort;
        if (![[self.array objectAtIndex:4] isEqualToString:@""] && self.actSwitch.on) {   //如果获取到了 就保存进去
            self.accountTextField.text = [self.array objectAtIndex:4];
            self.pwdTextField.text = [SSKeychain passwordForService:self.service account:self.accountTextField.text];
        }
    }
    else{
        _array=[[NSMutableArray alloc]init];
        [_array addObject:@"False"];
        [_array addObject:@"False"];
        
        //[_array addObject:@"211.156.198.83"];
        [_array addObject:@"211.156.200.95"];
        
        //[_array addObject:@"8019"];
        [_array addObject:@"8082"];
        
      
        
        [_array addObject:@""];
        
        //self.ipTextField.text = @"211.156.198.83";
        self.ipTextField.text = @"211.156.200.95";
        
        //self.portTextField.text = @"8019";
        self.portTextField.text = @"8082";
        
        [_array writeToFile:_filename  atomically:YES];
        
       
    }
    
    
    // NSLog(@"11111[%@]",_filename);
    
   }



//保存ip和端口号
- (IBAction)saveSetting:(id)sender {
    
    _paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    _path=[_paths    objectAtIndex:0];
    _filename=[_path stringByAppendingPathComponent:[[NSString alloc]initWithCString:_PLISTFILE_ encoding:NSUTF8StringEncoding]];    _array=[[NSMutableArray alloc] initWithContentsOfFile:_filename];
    
    
    if([_ipTextField.text isEqual:@""] || [_portTextField.text isEqual:@""]){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请将ip和端口号填完整" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
    }
    else if([self checkIp] == false){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:@"ip格式不正确" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
    }
    else{
        [_array replaceObjectAtIndex:2 withObject:_ipTextField.text];
        gIP = _ipTextField.text;
        [_array replaceObjectAtIndex:3 withObject:_portTextField.text];
        gPort = _portTextField.text;
        [_array writeToFile:_filename  atomically:YES];
        
               [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    }
}

//是否记住账户
- (IBAction)actCheck:(id)sender {
    if (self.actSwitch.on) {
        [self.array  replaceObjectAtIndex:0 withObject:@"True"];  //记住账户
    } else {
        [self.array  replaceObjectAtIndex:0 withObject:@"False"];  //不记住账户
        [self.array replaceObjectAtIndex:1 withObject:@"False"];   //不记住密码
        self.pwdSwitch.on = NO;                                    //密码控件  也随之关闭
    }
    [_array writeToFile:_filename  atomically:YES];               //实时写入
}

//是否记住密码
- (IBAction)pwdCheck:(id)sender {
    if (self.pwdSwitch.on) {
        [self.array  replaceObjectAtIndex:0 withObject:@"True"];   //账户也记住
        [self.array  replaceObjectAtIndex:1 withObject:@"True"];   //密码也记住
        self.actSwitch.on = YES;                                   //账户随之打开
    } else {
        [self.array  replaceObjectAtIndex:1 withObject:@"False"];  //密码标志位 关闭
    }
    [_array writeToFile:_filename  atomically:YES];
}


#pragma mark - textField Delegate
//有多少个用户
-(void)textFieldDidBeginEditing:(UITextField *)textField{
   
    
     if((textField != self.ipTextField)&&(textField != self.portTextField)){
    
    if (!textField.secureTextEntry) {
        self.actArray = [SSKeychain allAccounts];
        self.actCount = self.actArray.count;
    }
    CGRect rect = self.view.frame;
    if (rect.origin.y >= 0) {
        self.view.frame = CGRectMake(rect.origin.x, rect.origin.y - 150, rect.size.width, rect.size.height);
    }
    }
    
     else if ((textField == self.ipTextField)||(textField == self.portTextField)){
     
       //  NSLog(@"haha");
     }
    
}


//匹配用户
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (!textField.secureTextEntry) {
        _pwdTextField.text = @"";
        
        NSString *account = (NSMutableString *)textField.text;
        account = [account stringByAppendingString:string];
        self.actString = account;
        if ([string isEqual:@""]) {
            account = [account substringToIndex:account.length-1];
        }
        self.actString = account;
        
        [self.tableView reloadData];
    }
    return YES;
}

//收起键盘
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    
    if((textField != self.ipTextField)&&(textField != self.portTextField)){
    [textField resignFirstResponder];
    [self.tableView setHidden:YES];
    if (textField.secureTextEntry && textField != self.pwdTextField) {
        self.pwdTextField.text = [SSKeychain passwordForService:self.service account:self.accountTextField.text];
    }
    
    CGRect rect = self.view.frame;
    if (rect.origin.y <=0) {
        self.view.frame = CGRectMake(rect.origin.x, rect.origin.y + 150, rect.size.width, rect.size.height);
    }
    }
    
    else if((textField == self.ipTextField)||(textField == self.portTextField)){
    
    [textField resignFirstResponder];
    
    
    }
   
    return YES;
}

#pragma mark - UITableView Datasource

//返回一组多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    if(!self.actArray){
        return 0;
    }
    
       for (int i = 0, j = 0; i < self.actCount && count < self.matchArray.count; i++) {
        NSString *act = [self.actArray[i] valueForKey:@"acct"];
        if([act rangeOfString:self.actString].location == 0){
            count++;
            [self.matchArray replaceObjectAtIndex:j++ withObject:act];  //matchArray 存放账户
        }
    }
    if (count == 0) {
        [self.tableView setHidden:YES];
    } else {
        [self.tableView setHidden:NO];
    }
    return count;
}

//返回每行的cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    NSString *reuseId = @"act";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    
   
    
    cell.textLabel.text = self.matchArray[indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}



//ip格式检测  这个不用管
-(BOOL)checkIp{
    NSString *ip = _ipTextField.text;
    int i = 0;
    int j = -1;
    int dot = 0;
    char c;
    int length = (int)ip.length;
    for(;i<length;){
        c = [ip characterAtIndex:i];
        if(c == '.'){
            dot++;
            if(i == 0 || i-1 == j)
                return false;
            j = i;
        }
        
        i++;
    }
    if(dot == 3 && j != i-1)
        return true;
    return false;
}




#pragma mark - tableView 代理方法

//点击的时候  从tableview 出现的匹配  自动填上密码的值
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{  //点击的时候的流程
    self.accountTextField.text = self.matchArray[indexPath.row];
    self.pwdTextField.text = [SSKeychain passwordForService:self.service account:self.accountTextField.text];
    [self.tableView setHidden:YES];
    [self.accountTextField resignFirstResponder];
    
    CGRect rect = self.view.frame;
    if (rect.origin.y <=0) {
        self.view.frame = CGRectMake(rect.origin.x, rect.origin.y + 150, rect.size.width, rect.size.height);
    }
    
}





@end

