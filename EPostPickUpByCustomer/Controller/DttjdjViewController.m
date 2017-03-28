//
//  DttjdjViewController.m
//  EPostPickUpByCustomer
//
//  Created by lzb on 16/7/27.
//  Copyright © 2016年 gotop. All rights reserved.
//

#import "DttjdjViewController.h"

#import "Utility.h"

//#import "QRCodeScanController.h"
#import "CustomIOSAlertView.h"
#import "FMDB.h"
#import "CustomThreeLineCell.h"
#import "ZBarSDK.h"



#import "CommonFunc.h"
#import "md5.h"
#import "SBJson.h"
#import "webconn.h"

#define SCANVIEW_EdgeTop 0.0  //40.0
#define SCANVIEW_EdgeLeft 0.0  //50.0

#define TINTCOLOR_ALPHA 0.2  //浅色透明度
#define DARKCOLOR_ALPHA 0.5  //深色透明度

#define VIEW_WIDTH 400   //400
#define VIEW_HEIGHT 700   //700



@interface DttjdjViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CustomIOSAlertViewDelegate, /*PassQRCodeDelegate,*/ ZBarReaderDelegate, MBProgressHUDDelegate,ZBarReaderViewDelegate> {
    MBProgressHUD *HUD;
    
    UIView *_QrCodeline;
    
    
    //设置扫描画面
    UIView *_scanView;
    
    
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *postNumTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

// 界面调整
@property (weak, nonatomic) IBOutlet UILabel *postNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanBtnHeight;
@property (weak, nonatomic) IBOutlet UIButton *handOverBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handOverBtnHeight;


@property (nonatomic, strong) NSMutableArray *tempPostNum;
@property (nonatomic, strong) NSMutableArray *tempUserName;
@property (nonatomic, strong) NSMutableArray *tempPhoneNum;
@property (nonatomic, assign) int cellNum;

@property (strong, nonatomic) NSString *tableName;
@property (strong, nonatomic) FMDatabase *db;

//@property (nonatomic, strong) IBOutlet UISegmentedControl *segone;

@property (nonatomic) NSMutableArray *tuihuiyycarray; //退回原因数组 保存接口传下来的名称
//@property (nonatomic) NSMutableArray *zxclyycarray; //自行处理原因数组 保存接口传下来的名称


@property (nonatomic, strong)UIAlertView *tjdjyyalerView;//退件登记原因 弹框
//@property (nonatomic, strong)UIAlertView *zxclyyalerView;//自行处理原因 弹框


@property (nonatomic, strong) NSString *tjyjlsh;  //获取退件登记 或者 自行处理 的邮件流水号
@end

@implementation DttjdjViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ini];
   
    
    [self tuihuiyychaxun];//调用查看退回原因
    
    
    
}







-(void)tuihuiyychaxun
{
    
    
    if ([Utility netState]) {
        NSDictionary *tuihuiyychaxundic;
        
        tuihuiyychaxundic = [[NSDictionary alloc]initWithObjectsAndKeys:jgbh, @"V_JGBH", czygh, @"V_CZYGH", nil];  //站点退回的状态
        
    //    NSLog(@"444[111%@]\n",tuihuiyychaxundic);
   //     NSLog(@"555[111%@]\n",tuihuiyychaxundic.JSONString);
        NSString *tuihuiyygetxmldata51=[Webconn Xmlappend:tuihuiyychaxundic.JSONString params:@"queryThyy" params1:@"http://service.search.gnzq.com" params2:@"PostService"];    //调用自定义方法  传入 方法名 命名空间   url
        
        //@"http://192.168.201.110:7602/gnzqService/service/PostService"
        NSError *tuihuiyyerror51 = nil;
        NSData *tuihuiyydata51 = [NSURLConnection sendSynchronousRequest:tuihuiyygetxmldata51 returningResponse:nil error:&tuihuiyyerror51];
        if (tuihuiyydata51 == nil) {
            NSLog(@"send request failed: %@", tuihuiyyerror51);
            // return nil;
        }
        
        NSString *tuihuiyyresponse51 = [[NSString alloc] initWithData:tuihuiyydata51 encoding:NSUTF8StringEncoding];
        
        //NSLog(@"response: %@", tuihuiyyresponse51);
        
        
        
        NSString *tuihuiyygetdata51=[Webconn decodexml:tuihuiyyresponse51];
        
        NSString *tuihuiyybackremark51=[Webconn jsondecoderemark:tuihuiyygetdata51];
    //    NSLog(@"lala返回的soap信息是：[%@]\n",tuihuiyybackremark51);
        
        NSString *tuihuiyybackresult51=[Webconn jsondecoderesult:tuihuiyygetdata51];
    //    NSLog(@"lala1返回的soap信息是：[%@]\n",tuihuiyybackresult51);
        
        
        
        
        if([tuihuiyybackresult51 isEqualToString:@"F0"])
            
        {
            [HUD hide:YES];
            
            
            //NSLog(@"/////////////////////////解析退回原因接口 /////////////////////////\n\n");
            SBJsonParser *tuihuiyyparser18 = [[SBJsonParser alloc] init];
            NSError *tuihuiyyerror18 = nil;
            
            
            NSMutableDictionary *tuihuiyyroot = [[NSMutableDictionary alloc]initWithDictionary:[tuihuiyyparser18 objectWithString:tuihuiyybackremark51 error:&tuihuiyyerror18]];
            
            
            //注意转换代码
            SBJsonWriter *tuihuiyyjsonWriter = [[SBJsonWriter alloc] init];
            
            NSString *tuihuiyyjsonStringhello = [tuihuiyyjsonWriter stringWithObject:tuihuiyyroot];
            
            NSMutableDictionary *tuihuiyydicUserInfo = [tuihuiyyroot objectForKey:@"rows"];
            
            
            _tuihuiyycarray=[[NSMutableArray alloc]initWithCapacity:100];
            
            
            int i=0;
            for(NSMutableDictionary * member  in tuihuiyydicUserInfo)
            {
                
              //  NSLog(@"%@[%d]",[[member objectForKey:@"SM"] description],i++);
                
                
                [_tuihuiyycarray addObject:[[member objectForKey:@"SM"] description]];
                
                
            }
            
            
            
        }
        
        
        else{
            
            
            [HUD hide:YES];
            
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法获取退件原因请检查网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
            
            
            
            
            
        }
        
        
    }
}








- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_scanBtn.layer setMasksToBounds:YES];
    [_scanBtn.layer setCornerRadius:5.0f];
    [_handOverBtn.layer setMasksToBounds:YES];
    [_handOverBtn.layer setCornerRadius:5.0f];
    if (self.view.frame.size.height > 480.0f) {
        [self adjustLayout];
    }
    
}

- (void)adjustLayout {
    _postNumLabel.font = [UIFont systemFontOfSize:fonsize];
    _postNumTextField.font = [UIFont systemFontOfSize:fonsize];
    _scanBtn.titleLabel.font = [UIFont systemFontOfSize:fonsize];
    _handOverBtn.titleLabel.font = [UIFont systemFontOfSize:fonsize];
    _scanBtnHeight.constant = _CONSTANT_;
    _handOverBtnHeight.constant = _CONSTANT_;
    [self.view layoutIfNeeded];
}
- (void) ini {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    self.title = @"代投退件登记";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.postNumTextField.delegate = self;
    //    self.postNumTextField.text = @"12356";
    self.tempPostNum  = [[NSMutableArray alloc] init];
    self.tempUserName = [[NSMutableArray alloc] init];
    self.tempPhoneNum = [[NSMutableArray alloc] init];
    self.cellNum = 0;
    NSString *dbName = @"postinfo.sqlite";
    //self.tableName = @"postinfo";
    
    self.tableName = @"postinfo1";
    //新建一张表
    
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:dbName];
    self.db = [FMDatabase databaseWithPath:dbpath];
    if([self.db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT primary key, '%@' TEXT, '%@' TEXT)",self.tableName,@"POSTNUM",@"USERNAME",@"PHONENUM"];
        [self.db executeUpdate:sqlCreateTable];
    }
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.square = YES;
    
    
    self.exist =0;
    tjjjbz =1;
    
}

- (IBAction)searchByPostNum:(id)sender {
    [self.postNumTextField endEditing:YES];
    if ([self.postNumTextField.text isEqual:@""] || !self.postNumTextField.text) {
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入邮件号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alerView show];
    } else {
        if ([Utility netState]) {
            if(self.cellNum != 0) {                           //如果点击了取消按钮
                [self.tempPhoneNum removeLastObject];
                [self.tempPostNum removeLastObject];
                [self.tempUserName removeLastObject];
                self.cellNum--;
                [self.tableView reloadData];
            }
            
            
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:jgbh, @"V_JGBH",czygh,@"V_CZYGH", self.postNumTextField.text, @"V_YJHM", @"", @"V_SJRDH", @"1", @"C_JSBZ", @"0", @"C_QSBZ",@"",@"C_JQBZ",@"1",@"C_YJZT",nil];   //状态为1 表示待取件
            
            
            
            
            NSString *getxmldata4=[Webconn Xmlappend:dic.JSONString params:@"getDTPostInfo" params1:@"http://service.search.gnzq.com" params2:@"PostService"];    //调用自定义方法  传入 方法名 命名空间   url
            
            
            //@"http://192.168.201.110:7602/gnzqService/service/PostService"
            NSError *error = nil;
            NSData *data4 = [NSURLConnection sendSynchronousRequest:getxmldata4 returningResponse:nil error:&error];
            if (data4 == nil) {
                NSLog(@"send request failed: %@", error);
                // return nil;
            }
            
            NSString *response4 = [[NSString alloc] initWithData:data4 encoding:NSUTF8StringEncoding];
     //       NSLog(@"response: %@", response4);
            
            
            
            NSString *getdata4=[Webconn decodexml:response4];
            
            NSString *backremark4=[Webconn jsondecoderemark:getdata4];
    //        NSLog(@"lala返回的soap信息是：[%@]\n",backremark4);
            
            NSString *backresult4=[Webconn jsondecoderesult:getdata4];
    //        NSLog(@"lala1返回的soap信息是：[%@]\n",backresult4);
            
            
            
            
            if([backresult4 isEqualToString:@"F0"])
                
            {
                [HUD hide:YES];
                
                
                
                SBJsonParser *parser8 = [[SBJsonParser alloc] init];
                NSError *error8 = nil;
                NSMutableDictionary *jsonDic8 = [parser8 objectWithString:backremark4 error:&error8];//获取根节点 只需要获取一次
                NSMutableDictionary *dicUserInfo = [jsonDic8 objectForKey:@"rows"];    //找到对应的根节点
                
                
                NSString *nn9;
                NSString *nn10 ;
                NSString *nn11 ;
                NSString *nn12 ;
                
                for(NSMutableDictionary * member  in dicUserInfo)
                {
                    nn9 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_JGBH"] description]];
                    nn10 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_SJRDH"] description]];
                    nn11 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_SJRXM"] description]];
                    nn12 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_YJHM"] description]];
                    _tjyjlsh = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_YJLSH"] description]];
                }
                
                NSString *yjhm = nn12;
                NSString *sjrxm = nn11;
                NSString *sjrdh = nn10;
                if (self.exist == 0) {
                    [self.tempUserName addObject:sjrxm];
                    [self.tempPostNum addObject:yjhm];
                    [self.tempPhoneNum addObject:sjrdh];
                    self.cellNum++;
                    
                    
                    
                    
                    _tjdjyyalerView = [[UIAlertView alloc]initWithTitle:@"退件登记原因" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
                    for(NSString *title in _tuihuiyycarray) {
                        
                        [_tjdjyyalerView addButtonWithTitle:title];
                    }
                    
                    [_tjdjyyalerView addButtonWithTitle:@"取消"];
                    _tjdjyyalerView.cancelButtonIndex=[_tuihuiyycarray count];
                    [_tjdjyyalerView show];
                    
                    
                    
                    
                    
                    [self.tableView reloadData];
                    
                }
                
                          }
            //else if(!iSuc)
            else{
                
                [HUD hide:YES];
                
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:backremark4 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alter show];
                
                
                
                
                
            }
            
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"网络错误，请设置好网络" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [HUD removeFromSuperview];
}



- (IBAction)tjjj:(id)sender {    //这个功能对应的是点击 退件交接的时候产生的  暂时不管  加载的是另外一个界面
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"dttjjj"];
    
    [self.navigationController pushViewController:vc animated:YES];
}




#pragma mark - 弹出框响应函数
//这个弹框专门是针对点击  退件 原因的时候产生的   重点修改的 是这个模块
//是否进行取件，是则弹出对话框要求输入密码等内容
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //    NSLog(@"indix %d", buttonIndex);
    
    if((self.exist == 0) &&(alertView==_tjdjyyalerView))   //如果是退件登记接口
    {
        
        if (buttonIndex != [_tuihuiyycarray count]) {
            if (buttonIndex == 3) {
                CustomIOSAlertView* cusAlert = [[CustomIOSAlertView alloc] init];
                [cusAlert setContainerView:[self createDemoView]];
                [cusAlert setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
                
                cusAlert.delegate = self;
                [cusAlert show];
                
                
                
                
            } else {
                
                [self putPost:(int)buttonIndex putandOtherReason:@""];
            }
        }
        
        else {
            
            //NSLog(@"111222");
            if(self.cellNum != 0) {
                [self.tempPhoneNum removeLastObject];
                [self.tempPostNum removeLastObject];
                [self.tempUserName removeLastObject];
                self.cellNum--;
                [self.tableView reloadData];
            }
            
        }
        
        
        
        
    }
   
}

- (void)returnPost:(int)returnReason andOtherReason:(NSString *)otherReason {      //这个是点击退件原因 的时候进行一个数据库插入操作
    if([self.db open]) {
        
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO %@ values ('%@', '%@', '%@', '%@', '%@')",
                               self.tableName, self.tempPostNum[self.cellNum-1], self.tempUserName[self.cellNum-1], self.tempPhoneNum[self.cellNum-1], [NSString stringWithFormat:@"%d", returnReason], otherReason];
        [self.db executeUpdate:insertSql1];
        [self.db close];
    }
}

- (UIView *)createDemoView    //设置退件原因显示   如果点击了 其他 这个按键的时候 的弹框显示

{
    UIView *demoView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 120)];
    UILabel *titleLabel =    [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 270, 21)];
    titleLabel.textColor = [UIColor orangeColor];
    titleLabel.text = @"退件原因";
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 36, 270, 21)];
    lable1.text = @"其他";
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 61, 270, 21)];
    lable2.text = @"其他退件原因";
    
    UITextField *userNameTextField  = [[UITextField alloc] initWithFrame:CGRectMake(10, 87, 270, 23)];
    userNameTextField.placeholder = @"请输退件原因";                                   //这里表示设置隐藏框 提示
    userNameTextField.delegate=self;
    [userNameTextField  setBorderStyle:UITextBorderStyleRoundedRect];
    
    UIColor *color = [[UIColor alloc] initWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];       demoView.backgroundColor = color;
    titleLabel.backgroundColor = color;
    lable1.backgroundColor = color;
    userNameTextField.backgroundColor = color;
    lable2.backgroundColor = color;
    
    
    [demoView addSubview:titleLabel];
    [demoView addSubview:lable1];
    [demoView addSubview:userNameTextField];
    [demoView addSubview:lable2];
    
    return demoView;
}







- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{   //这里是根据不同的接口  进行调用不同的 处理方式 一个是退件登记  一个是自行处理
    
    
    if(self.exist == 0){
        if (buttonIndex == 1) {
            
            [self putPost:3 putandOtherReason:((UITextField *)alertView.containerView.subviews[2]).text];
            
            
            
        } else {
            if(self.cellNum != 0) {
                [self.tempPhoneNum removeLastObject];
                [self.tempPostNum removeLastObject];
                [self.tempUserName removeLastObject];
                self.cellNum--;
                [self.tableView reloadData];
            }
        }
    }
    
  
    
    [alertView close];
}



/*
 - (IBAction)scan:(id)sender {     //扫描功能
 //    QRCodeScanController * qrcodeScanVC = [[QRCodeScanController alloc]initWithNibName:@"QRCodeScanController" bundle:nil];
 //    qrcodeScanVC.qrCodeDelegate = self;
 //    [self.navigationController pushViewController:qrcodeScanVC animated:YES];
 ZBarReaderViewController *reader = [ZBarReaderViewController new];
 reader.readerDelegate = self;
 reader.showsZBarControls = NO;
 [reader.scanner setSymbology: ZBAR_UPCA config: ZBAR_CFG_ENABLE to: 0];
 reader.readerView.zoom = 1.0;
 
 [self.navigationController pushViewController:reader animated:NO];
 }
 
 
 - (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
 {
 id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
 
 ZBarSymbol *symbol = nil;
 
 for(symbol in results){
 
 _postNumTextField.text = symbol.data;
 [reader.navigationController popViewControllerAnimated:NO];
 [self searchByPostNum:nil];
 }
 }
 
 //- (void)passQRCode:(NSString *)qrCode {
 //    self.postNumTextField.text = qrCode;
 //}
 
 */
///*

- (IBAction)scan:(id)sender {
    
    
    //[self setScanView];
    _readerView = [[ ZBarReaderView alloc ] init ];  //边框分配大小
    _readerView.frame =CGRectMake ( 15 , 30 , 300 , [UIScreen mainScreen].bounds.size.height-180 ) ;  //这里是设置总体的边框大小
    
    
    //设置边框的颜色和圆角
    _readerView.layer.cornerRadius=55;
    _readerView.layer.masksToBounds=YES;
    _readerView.layer.borderWidth=10;
    _readerView.layer.borderColor=[UIColor greenColor].CGColor;
    
    
    
    
    _readerView.tracksSymbols = NO ;
    _readerView.readerDelegate = self ;
    
    
    //[ _readerView addSubview : _scanView ];  //在扫描框上面增加界面 这里暂时不需要
    
    //_readerView.showsFPS=YES;//显示扫描帧数
    //_readerView.zoom =1.0;
    _readerView.allowsPinchZoom=YES;
    _readerView.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds)); //设置扫描框处于中心位置
    
    
    //直接在这里定义中心横线的位置
    _QrCodeline = [[ UIView alloc ] initWithFrame : CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft , 4 )];  //2
    _QrCodeline . backgroundColor = [ UIColor greenColor ];  //redcolor
    [ _readerView addSubview : _QrCodeline ];
    
    
    //关闭闪光灯
    _readerView.torchMode = 0 ;
    //[self.view addSubview : _readerView ]; //将所有的界面统一添加到主界面
    //扫描区域
    //readerView.scanCrop =
    
    
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];  //这个跳转到时候要重新拉一个页面来进行显示
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"smjm"];
    //[vc.view addSubview : _readerView ];
    [self.navigationController pushViewController:vc animated:YES];
    [vc.view addSubview : _readerView ];
    
    
    //nameLabel高度为20
    //使用代码设置约束
    _readerView.contentMode=UIViewContentModeScaleAspectFit;
    _readerView.translatesAutoresizingMaskIntoConstraints=NO;//设置自动转换为不
    
    
    NSLayoutConstraint* Constraint1=[NSLayoutConstraint constraintWithItem:_readerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:vc.view attribute:NSLayoutAttributeLeading multiplier:1 constant:20];//1前端距离邮件号码前段20
    NSLayoutConstraint* Constraint2=[NSLayoutConstraint constraintWithItem:_readerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:vc.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20];//2后端距离尾部-20
    
    
    
    NSLayoutConstraint* Constraint3=[NSLayoutConstraint constraintWithItem:_readerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:vc.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];//位于屏幕的中间线
    
    NSLayoutConstraint* Constraint4=[NSLayoutConstraint constraintWithItem:_readerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:vc.view attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0];//1自身高度是屏幕的一半
    
    [vc.view addConstraints:@[Constraint1, Constraint2,Constraint3,Constraint4]];
    
    
    
    
    
    [ _readerView stop ];
    [ _readerView start ];
    [ self createTimer ];
    
    
    
}
//*/



-( void )readerView:( ZBarReaderView *)readerView didReadSymbols:( ZBarSymbolSet *)symbols fromImage:( UIImage *)image
{
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol (symbols. zbarSymbolSet );
    NSString *symbolStr = [ NSString stringWithUTF8String : zbar_symbol_get_data (symbol)];
    
    /*UIAlertView *alertView=[[ UIAlertView alloc ] initWithTitle : @"扫描结果" message :symbolStr delegate : nil cancelButtonTitle : @"ok" otherButtonTitles : nil ];
     [alertView show ];
     */
    _postNumTextField.text = symbolStr;
    // [_readerView.navigationController popViewControllerAnimated:NO]; //自动跳转返回
    
    [self.navigationController popViewControllerAnimated:NO]; //如果有扫描到邮件则进行返回
    
    [self searchByPostNum:nil];
    
    [_readerView stop];
    [self stopTimer];//一次扫描完一定要结束 不然会多次提示
    
    
}


//二维码的横线移动
- ( void )moveUpAndDownLine
{
    CGFloat Y= _QrCodeline . frame . origin . y ;
    //CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH-2*SCANVIEW_EdgeLeft, 1)]
    if (VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations: @"asa" context: nil ];  //设置一个动画
        [UIView setAnimationDuration: 1.5 ];              //设置持续时间
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft, 1 );
        [UIView commitAnimations];
    } else if (SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations: @"asa" context: nil ];
        [UIView setAnimationDuration: 1.5 ];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop, VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft, 1 );
        [UIView commitAnimations];
    }
}

- ( void )createTimer
{
    //创建一个时间计数
    _timer=[NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector (moveUpAndDownLine) userInfo: nil repeats: YES ];
}
- ( void )stopTimer
{
    if ([_timer isValid] == YES ) {
        [_timer invalidate];
        _timer = nil ;
    }
    [_timer setFireDate:[NSDate distantFuture]];
    //关闭定时器
    //[myTimer setFireDate:[NSDate distantFuture]];
}




//  /  //  /////////////////扫描结束//////////////////////
#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    //报表显示  这个功能暂时不用管
    return self.cellNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"threeLineCell";
    
    CustomThreeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell) {
        cell = [CustomThreeLineCell customThreeLineCell];
    }
    cell.numLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
    cell.postNumLabel.text = [NSString stringWithFormat:@"邮件号码 %@", self.tempPostNum[indexPath.row]];
    cell.nameLabel.text = [NSString stringWithFormat:@"收件人姓名：%@", self.tempUserName[indexPath.row]];
    cell.phoneNumLabel.text = [NSString stringWithFormat:@"收件人电话：%@", self.tempPhoneNum[indexPath.row]];
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

//调用邮件退件原因上传接口
- (void)putPost:(int)returnReason putandOtherReason:(NSString *)otherReason {      //这个是点击退件原因 的时候进行一个数据库插入操作
    
//    NSLog(@"[调用退件登记接口]\n");
 //   NSLog(@"[%d]\n",self.exist);
    
    
    NSDictionary *dic;
    
    if ([Utility netState]) {
        
        if(returnReason != 3){
            NSString *string = [[NSString alloc] initWithFormat:@"%d",(returnReason+1)];  //使用自定义以后 要加1 本来是returnReason
            dic = [[NSDictionary alloc]initWithObjectsAndKeys:jgbh, @"V_JGBH",_tjyjlsh, @"V_YJLSH", string, @"C_THYY", @"", @"V_QTTHYY",nil];
        }
        else{
            
            NSString *string1 = [[NSString alloc] initWithFormat:@"%d",(returnReason+1)];
            dic = [[NSDictionary alloc]initWithObjectsAndKeys:jgbh, @"V_JGBH",_tjyjlsh, @"V_YJLSH", string1, @"C_THYY", otherReason, @"V_QTTHYY",nil];
        }
        
        
        NSString *getxmldata41=[Webconn Xmlappend:dic.JSONString params:@"backDTPost" params1:@"http://service.search.gnzq.com" params2:@"PostService"];    //调用自定义方法  传入 方法名 命名空间   url
        
        //@"http://192.168.201.110:7602/gnzqService/service/PostService"
        NSError *error41 = nil;
        NSData *data41 = [NSURLConnection sendSynchronousRequest:getxmldata41 returningResponse:nil error:&error41];
        if (data41 == nil) {
            NSLog(@"send request failed: %@", error41);
            // return nil;
        }
        
        NSString *response41 = [[NSString alloc] initWithData:data41 encoding:NSUTF8StringEncoding];
      
        //NSLog(@"response: %@", response41);
        
        
        
        NSString *getdata41=[Webconn decodexml:response41];
        
        NSString *backremark41=[Webconn jsondecoderemark:getdata41];
   //     NSLog(@"lala返回的soap信息是：[%@]\n",backremark41);
        
        NSString *backresult41=[Webconn jsondecoderesult:getdata41];
 //       NSLog(@"lala1返回的soap信息是：[%@]\n",backresult41);
        
        
        if([backresult41 isEqualToString:@"F0"])
            
        {
            [HUD hide:YES];
            
            
            
            
            [self.tempPhoneNum removeLastObject];
            [self.tempPostNum removeLastObject];
            [self.tempUserName removeLastObject];
            self.cellNum--;
            [self.tableView reloadData];
            
            
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退件登记成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
            
            
            
            UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"tjjj"];
            [self.navigationController pushViewController:vc animated:YES];
            //这一段代码是如何进行 页面的切换
            
            
            
            
            
        }
        //else if(!iSuc)
        else{
            
            
            [HUD hide:YES];  //注意 这里只是一个控件的显示  不管  是否查询成功  都要对他进行隐藏
            
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:backremark41 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
            
            
            
            
        }
        
        
        
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"网络错误，请设置好网络" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
    }
    
    
}





//收起键盘
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
