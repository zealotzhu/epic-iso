//
//  DxcfViewController.m
//  EPostPickUpByCustomer
//
//  Created by user on 15-11-9.
//  Copyright (c) 2015年 gotop. All rights reserved.
//

#import "Utility.h"
#import "DxcfViewController.h"
//#import "QRCodeScanController.h"
#import "ZBarSDK.h"
#import "CustomThreeLineCell.h"



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


@interface DxcfViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, /*PassQRCodeDelegate,*/ ZBarReaderDelegate, MBProgressHUDDelegate,ZBarReaderViewDelegate> {  //新增自定义界面
    MBProgressHUD *HUD;
    
    UIView *_QrCodeline;
    
    
    //设置扫描画面
    UIView *_scanView;
    
    
    
}
@property (weak, nonatomic) IBOutlet UITextField *postNumTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

// 界面调整
@property (weak, nonatomic) IBOutlet UILabel *postNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanBtnHeight;

@property (nonatomic, assign) int cellNum;
@property (nonatomic, copy) NSString *tempPostNum;
@property (nonatomic, copy) NSString *tempUserName;
@property (nonatomic, copy) NSString *tempPhoneNum;
@property (nonatomic, copy) NSString *tempYjlsh;

//自定义
@property (nonatomic, copy)NSString *dxcfyjlsh;
@property (nonatomic)UIView* line; // 二维码扫描线
@property (nonatomic)NSTimer* lineTimer;// 二维码扫描线计时器。


@end

@implementation DxcfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ini];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_scanBtn.layer setMasksToBounds:YES];
    [_scanBtn.layer setCornerRadius:5.0f];
    if (self.view.frame.size.height > 480.0f) {
        [self adjustLayout];
    }
    
}

- (void)adjustLayout {
    _postNumLabel.font = [UIFont systemFontOfSize:fonsize];
    _postNumTextField.font = [UIFont systemFontOfSize:fonsize];
    _scanBtn.titleLabel.font = [UIFont systemFontOfSize:fonsize];
    _scanBtnHeight.constant = _CONSTANT_;
    [self.view layoutIfNeeded];
}
- (void) ini {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    self.title = @"短信重发";
    
    self.postNumTextField.delegate = self;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.cellNum = 0;
    self.tempPostNum  = [NSString string];
    self.tempUserName = [NSString string];
    self.tempPhoneNum = [NSString string];
    self.tempYjlsh = [NSString string];
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.square = YES;
}

- (IBAction)searchByPostNum:(id)sender {
    [self.postNumTextField endEditing:YES];
    NSString *postNum = self.postNumTextField.text;
    if ([postNum isEqual:@""]||!self.postNumTextField.text) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入邮件号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    } else {
        if ([Utility netState]) {
            HUD.labelText = @"查询信息中";
            [HUD show:YES];
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:jgbh, @"V_JGBH", self.postNumTextField.text, @"V_YJHM", @"", @"V_SJRDH", @"1", @"C_JSBZ", @"0", @"C_QSBZ",@"",@"C_JQBZ",@"1",@"C_YJZT",nil];
            
            
            
            
            //请求  //这里已经进行发送了
            
            NSString *dxcfgetxmldata4=[Webconn Xmlappend:dic.JSONString params:@"getPostInfo" params1:@"http://service.search.gnzq.com" params2:@"PostService"];    //调用自定义方法  传入 方法名 命名空间   url
            
            //params2:@"http://192.168.201.110:7602/gnzqService/service/PostService"];
            
            NSError *dxcferror = nil;
            NSData *dxcfdata4 = [NSURLConnection sendSynchronousRequest:dxcfgetxmldata4 returningResponse:nil error:&dxcferror];  //进行同步发送
            if (dxcfdata4 == nil) {
                NSLog(@"send request failed: %@", dxcferror);
                // return nil;
            }
            
            NSString *dxcfresponse4 = [[NSString alloc] initWithData:dxcfdata4 encoding:NSUTF8StringEncoding];      //获得 返回的 xml 格式的字符串
          
            
            
            
            
            NSString *dxcfgetdata4=[Webconn decodexml:dxcfresponse4];
            
            NSString *dxcfbackremark4=[Webconn jsondecoderemark:dxcfgetdata4];
           
            
            NSString *dxcfbackresult4=[Webconn jsondecoderesult:dxcfgetdata4];
           
            
            
            
            
            if([dxcfbackresult4 isEqualToString:@"F0"])
                
            {
                [HUD hide:YES];
                
                SBJsonParser *dxcfparser8 = [[SBJsonParser alloc] init];
                NSError *dxcferror8 = nil;
                NSMutableDictionary *dxcfjsonDic8 = [dxcfparser8 objectWithString:dxcfbackremark4 error:&dxcferror8];//获取根节点 只需要获取一次
                NSMutableDictionary *dxcfdicUserInfo = [dxcfjsonDic8 objectForKey:@"rows"];    //找到对应的根节点
                
                
                NSString *nn9;
                NSString *nn10 ;
                NSString *nn11 ;
                NSString *nn12 ;
                
                for(NSMutableDictionary * member  in dxcfdicUserInfo)
                {
                    nn9 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_YJLSH"] description]];  //如果有多个相似的 json 要使用循环连续获取
                    nn10 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_SJRDH"] description]];
                    nn11 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_SJRXM"] description]];
                    nn12 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_YJHM"] description]];
                }
                
                
                
                NSString *yjhm = nn12;
                NSString *sjrxm = nn11;
                NSString *sjrdh = nn10;
                _dxcfyjlsh = nn9;
                
                
                
                
                
                
                
                self.tempPostNum = yjhm;
                self.tempUserName = sjrxm;
                self.tempPhoneNum = sjrdh;
                self.tempYjlsh = _dxcfyjlsh;
                self.cellNum = 1;
                [self.tableview reloadData];
                
            }
            //else if(!iSuc)
            else{
                
             
                
                [HUD hide:YES];
                
             
                
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:dxcfbackremark4 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomThreeLineCell *cell = [CustomThreeLineCell customThreeLineCell];
    
    cell.numLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
    cell.postNumLabel.text = [NSString stringWithFormat:@"邮件号码 %@", self.tempPostNum];
    cell.nameLabel.text = [NSString stringWithFormat:@"收件人姓名：%@", self.tempUserName];
    cell.phoneNumLabel.text = [NSString stringWithFormat:@"收件人电话：%@", self.tempPhoneNum];
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否重发短信" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        if ([Utility netState]) {
            HUD.labelText = @"发送请求中";
            [HUD show:YES];
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:jgbh,@"V_JGBH",_dxcfyjlsh, @"V_YJLSH", nil];
            
            NSString *getxmldata5=[Webconn Xmlappend:dic.JSONString params:@"reSendInMsg" params1:@"http://service.search.gnzq.com" params2:@"PostService"];    //调用自定义方法  传入 方法名 命名空间   url
            
            //@"http://192.168.201.110:7602/gnzqService/service/PostService"
            NSError *error = nil;
            NSData *data5 = [NSURLConnection sendSynchronousRequest:getxmldata5 returningResponse:nil error:&error];
            if (data5 == nil) {
                NSLog(@"send request failed: %@", error);
                // return nil;
            }
            
            NSString *response5 = [[NSString alloc] initWithData:data5 encoding:NSUTF8StringEncoding];
         //   NSLog(@"response: %@", response5);
            
            
            NSString *getdata5=[Webconn decodexml:response5];
            
            NSString *backremark5=[Webconn jsondecoderemark:getdata5];
  //          NSLog(@"lala返回的soap信息是：[%@]\n",backremark5);
            
            NSString *backresult5=[Webconn jsondecoderesult:getdata5];
  //          NSLog(@"lala1返回的soap信息是：[%@]\n",backresult5);
            
            
            
            
            if([backresult5 isEqualToString:@"F0"])
                
            {
                [HUD hide:YES];
                
                self.cellNum = 0;
                [self.tableview reloadData];
                
                
                UIAlertView *dxcfalert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"重发短信成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [dxcfalert show];
                
                
            }
            //else if(!iSuc)
            else{
                
                
                [HUD hide:YES];
                
                
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:backremark5 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alter show];
                
                
            }
            
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"网络错误，请设置好网络" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }
        
    }
}


///*

- (IBAction)scan:(id)sender {
    
    
    
    _readerView = [ZBarReaderView new ];  //边框分配大小
    _readerView.frame =CGRectMake ( 15 , 30 , 300 , [UIScreen mainScreen].bounds.size.height-180 ) ;  //这里是设置总体的边框大小
    
    
    //设置边框的颜色和圆角
    _readerView.layer.cornerRadius=55;
    _readerView.layer.masksToBounds=YES;
    _readerView.layer.borderWidth=10;
    _readerView.layer.borderColor=[UIColor greenColor].CGColor;
    
    
    
    _readerView.tracksSymbols = NO ;
    _readerView.readerDelegate = self ;
    
     _readerView.allowsPinchZoom=YES;
    _readerView.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds)); //设置扫描框处于中心位置
    
    
    //直接在这里定义中心横线的位置
    _QrCodeline = [[ UIView alloc ] initWithFrame : CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft , 4 )];  //2
    _QrCodeline . backgroundColor = [ UIColor greenColor ];  //redcolor
    [ _readerView addSubview : _QrCodeline ];
    
    

///*
    //关闭闪光灯
    _readerView.torchMode = 0 ;
    
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
    //[_readerView addConstraints:@[Constraint4]];
    

    [_readerView stop];
    [ _readerView start ];
    [ self createTimer ];
    
    
    
}
//*/


/*
 //设置条形码进行调用

- (IBAction)scan:(id)sender {
    //    QRCodeScanController * qrcodeScanVC = [[QRCodeScanController alloc]initWithNibName:@"QRCodeScanController" bundle:nil];
    //    qrcodeScanVC.qrCodeDelegate = self;
    //    [self.navigationController pushViewController:qrcodeScanVC animated:YES];
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.showsZBarControls = YES;
    [reader.scanner setSymbology: ZBAR_UPCA config: ZBAR_CFG_ENABLE to: 0];
    reader.readerView.zoom = 1.0;
    reader.readerView.showsFPS=YES;
    reader.readerView.allowsPinchZoom=YES;
    reader.readerView.torchMode=0;
    
    
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


 
*/





///*

-( void )readerView:( ZBarReaderView *)readerView didReadSymbols:( ZBarSymbolSet *)symbols fromImage:( UIImage *)image
{
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol (symbols. zbarSymbolSet );
    NSString *symbolStr = [ NSString stringWithUTF8String : zbar_symbol_get_data (symbol)];
    
       _postNumTextField.text = symbolStr;
    
    
    [self.navigationController popViewControllerAnimated:NO]; 
    
    [self searchByPostNum:nil];
    
    [_readerView stop];
    [self stopTimer];
    
}//*/



- ( void )viewWillDisappear:( BOOL )animated
{
    [ super viewWillDisappear :animated];
    
    
}

///*
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
    [_timer fire];
}
- ( void )stopTimer
{
    if (_timer !=nil) {
    [_timer invalidate];
    _timer  =nil;
        
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer  =nil;
            
        }
    
}
    
}

//*/


- ( void )didReceiveMemoryWarning
{
    [ super didReceiveMemoryWarning];
    // Dispose of any resources that can be
    
}




//收起键盘
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
