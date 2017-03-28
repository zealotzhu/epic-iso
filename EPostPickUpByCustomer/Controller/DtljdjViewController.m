//
//  DtljdjViewController.m
//  EPostPickUpByCustomer
//
//  Created by lzb on 16/7/27.
//  Copyright © 2016年 gotop. All rights reserved.
//

#import "DtljdjViewController.h"

#import "CustomIOSAlertView.h"
#import "Utility.h"
#import "CustomTwoLineWithButtonCell.h"
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




//tableView111 是由text点击的时候所产生的一个 列表框 用来显示物流公司的数据

@interface DtljdjViewController () <UITextFieldDelegate, CustomIOSAlertViewDelegate,UITableViewDataSource, UITableViewDelegate, /*PassQRCodeDelegate,*/ ZBarReaderDelegate, CellButtonActionDelegate, MBProgressHUDDelegate,ZBarReaderViewDelegate> {
    MBProgressHUD *HUD;
    
    
    UIView *_QrCodeline;
    
    
    //设置扫描画面
    UIView *_scanView;
    
    
    
    
}
/*
 //各个标志位说明
 qscglshbz  用来进行到站撤销的标志  如果签收成功 或者拒签成功 都是1 ； 然后如果是 手工录入的话 为2 标志不同时获取到的邮件流水号不同 才能做到站撤销
 到站撤销 到站拒签 到站签收 邮件信息补全都是 先要获取流水号
 
 dzqsbz 用来判断是签收 还是拒收  其实就是 那一个分段的滑块  为1签收 为2拒收
 
 self.type  在原版当中 修改的时候 会改变为 1 已经删掉
 一开始的时候为0 如果dzqsbz 为1 表示查不到而type 为0 则进行手工补录 现在只有type为0 主要是进行界面的调用
 主要的使用就是为了和 修改界面进行区分 现在没用了
 
 _alert123 这个是进行到站撤销的判断弹框
 _alert1   这个是进行手工录入的判断弹框 _sgblcusAlert 这个才是手工录入的大模块界面整体
 _xxbqalert 进行手机号 或者 姓名为空 查询以后补全的判断弹框 _xxbqcusAlert这个是补全弹框的界面整体 xxbqcreateDemoView是主界面设计
 
 
 */

@property (weak, nonatomic) IBOutlet UITextField *postNumTextField;
@property (weak, nonatomic) IBOutlet UITableView *ljdjTableView;
@property (nonatomic, strong) NSString *postNum;
// 界面调整
@property (weak, nonatomic) IBOutlet UILabel *postNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanBtnHeight;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;

@property (nonatomic, strong) NSMutableArray *tempPostNum;
@property (nonatomic, strong) NSMutableArray *tempUserName;
@property (nonatomic, strong) NSMutableArray *tempAddress;
@property (nonatomic, strong) NSMutableArray *tempPhoneNum;
@property (nonatomic) NSInteger cellNum;
@property (nonatomic) NSInteger type;   //补录还是修改
@property (nonatomic) NSInteger editRow;

//自定义显示界面  放在这里是为了进行全局的显示
//@property(strong,nonatomic) NSArray *listData;
@property(strong,nonatomic) NSMutableArray *listData;

//@property(strong,nonatomic)UITableView *tableView111;
@property(strong,nonatomic)UITableViewCell *tableViewCell;
@property(strong,nonatomic)UIView *demoview;
@property(strong,nonatomic)UIView *dzjqyydemoview;  //拒签原因界面
//@property(strong,nonatomic)UIView *xxbqdemoview;

@property(strong,nonatomic)UIAlertView* alert1;
//@property(strong,nonatomic)UIAlertView* alert2;
@property(strong,nonatomic)UITextField *userPhoneNumTextField3;
@property(strong,nonatomic)NSString *rowvalue;

@property(strong,nonatomic)UIAlertView *alert123;
@property(strong,nonatomic)UIAlertView *dzjqalerView1;
@property(strong,nonatomic)UITextField *userPhoneNumTextField;
@property(strong,nonatomic)UITextField *userAddressTextField;
@property(strong,nonatomic)UITextField *userNameTextField;

//@property(strong,nonatomic)UITextField *xxbquserNameTextField;//信息补全

//@property(strong,nonatomic)UIAlertView *xxbqalert;
@property (nonatomic, strong) NSString *ljdjyjlsh;
@property (nonatomic) NSInteger *dzqsbz;  //到站签收标志  记住如果是数字的话  不能使用strong

@property(strong,nonatomic)CustomIOSAlertView *dzjqcusAlert; //全局显示专用的自定义判断提示框
//@property(strong,nonatomic)CustomIOSAlertView *xxbqcusAlert;//全局专用的弹框
@property(strong,nonatomic)CustomIOSAlertView* sgblcusAlert; //手工补录界面全局弹框


@property (nonatomic, strong) NSString *dzqsyjlsh;  //到站签收邮件流水号
@property (nonatomic) NSInteger *qscglshbz;  //签收成功返回的标志 到站撤销使用 判断是哪一模块标志 1代表签收成功 2代表补录成功


@property(strong,nonatomic)UIAlertView *alert1237689798;//屏蔽测试专用
@property (nonatomic) NSMutableArray *wlgsmcgetArray;//物流公司名称数组 获取的时候使用
@property (nonatomic) NSMutableArray *wlgsmcarray;


@property (nonatomic, strong) NSString *sjh;  //手机号
@property (nonatomic, strong) NSString *sjrxm ;//收件人姓名


//定义用来传值  单选按钮
@property (retain, nonatomic) IBOutlet UIButton *getclick;
@property (retain, nonatomic) IBOutlet UIButton *getsecondclick;
@property (retain, nonatomic) IBOutlet UIImage *image1;
@property (retain, nonatomic) IBOutlet UIImage *image2;

@property (weak, nonatomic) IBOutlet UIButton *dzjqbutton2;   //到站拒签 按钮
@property (weak, nonatomic) IBOutlet UIButton *dzqsbutton1;   //到站签收按钮


@end

@implementation DtljdjViewController

//自定义显示界面
@synthesize listData=_listData;
//@synthesize tableView111 = _tableView111;
@synthesize tableViewCell =_tableViewCell;
@synthesize demoview = _demoview;


//@synthesize xmlParser;               //存储解析后的数据
//@synthesize soapResults;             //返回结果


- (void)viewDidLoad {
    [super viewDidLoad];
    [self ini];
    [self getitemdanxuan];
    
}


-(void)getitemdanxuan{
    
    
    _dzqsbz =1;
    self.cellNum=0;//进行初始化
    [self.ljdjTableView reloadData];
//    NSLog(@"11111[hello111][%d]\n",_dzqsbz);
    
    
    
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_scanBtn.layer setMasksToBounds:YES];
    [_scanBtn.layer setCornerRadius:5.0f];
    if (self.view.frame.size.height > 480.0) {
        [self adjustLayout];
    }
}

- (void)ini {
    self.postNumTextField.delegate = self;
    self.ljdjTableView.dataSource = self;
    self.tempPostNum  = [[NSMutableArray alloc] init];
    self.tempUserName = [[NSMutableArray alloc] init];
    self.tempAddress =  [[NSMutableArray alloc] init];
    self.tempPhoneNum = [[NSMutableArray alloc] init];
    self.cellNum = 0;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    self.title = @"代投来件登记";
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.square = YES;
    
    
}

- (void)adjustLayout {
    _postNumLabel.font = [UIFont systemFontOfSize:fonsize];
    _postNumTextField.font = [UIFont systemFontOfSize:fonsize];
    _scanBtn.titleLabel.font = [UIFont systemFontOfSize:fonsize];
    _scanBtnHeight.constant = _CONSTANT_;
    [self.view layoutIfNeeded];
    
}

#pragma mark - TableView 数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   /* if (tableView == _tableView111){NSLog(@"11这是第一个数据源代理");
        return [self.listData count];
    }
    else{NSLog(@"11这是第二个数据源代理");
 */
    
        return self.cellNum;


   //}
}


//选中单元格所产生事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
   /* if (tableView == _tableView111){
        NSLog(@"22这是第一个数据源代理");
        
        NSInteger row = [indexPath row];
        
        _rowvalue = [self.listData objectAtIndex:row];
        
        NSString *message = [[NSString alloc]initWithFormat:@"是否选择[%@]？",_rowvalue];
        
        _alert2 = [[UIAlertView alloc]initWithTitle:@"提示"
                                            message:message
                                           delegate:self
                                  cancelButtonTitle:@"取消"
                                  otherButtonTitles:@"确定",nil];
        [_alert2 show];}
    */
    
     if (tableView == _ljdjTableView){
        
        _alert123 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否进行到站撤销？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [_alert123 show];
        
        
    }
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
   /* if (tableView == _tableView111){
        
        
        static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
        }
        
        else {
            while ([cell.contentView.subviews lastObject ]!=nil) {
                [(UIView*)[cell.contentView.subviews lastObject]removeFromSuperview];
            }
        }
        
        NSUInteger row = [indexPath row];
        
        cell.detailTextLabel.text = @"物流名称";
        cell.detailTextLabel.alpha=0.4f;
        
        cell.textLabel.text=[self.listData objectAtIndex:row];
        
        
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        
        cell.backgroundColor=[[UIColor alloc] initWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
        
        
        return cell;
    }
    */
    
   // else{
        
        
        static NSString *cellIdentifier = @"twoLineWithButtonCell";
        
        CustomTwoLineWithButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(!cell) {
            cell = [CustomTwoLineWithButtonCell customTwoLineWithButtonCell];
            cell.actionDelegate = self;
        }
        
        cell.numLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
        cell.titleLabel.text =[NSString stringWithFormat:@"邮件:%@", self.tempPostNum[indexPath.row]];
        cell.detailLabel.text = [NSString stringWithFormat:@"%@, [%@]", self.tempUserName[indexPath.row], self.tempPhoneNum[indexPath.row]];
        return cell;
        
    //}
    
    
    
}



//调用邮件查询接口
#pragma mark - 按键响应
- (IBAction)search:(id)sender {
    self.type = 0;
    [self.postNumTextField resignFirstResponder];
    
    if ([self.postNumTextField.text isEqualToString:@""] || !self.postNumTextField.text) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入邮件号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if(_dzqsbz==1){
        if ([Utility netState]) {
            HUD.labelText = @"查询中";
            [HUD show:YES];
            
            
            if (self.cellNum != 0) {
                self.cellNum = 0;
                [self.tempPhoneNum removeAllObjects];
                [self.tempPostNum removeAllObjects];
                [self.tempUserName removeAllObjects];
                [self.ljdjTableView reloadData];
            }
            
            
            
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:jgbh, @"V_JGBH",czygh,@"V_CZYGH", self.postNumTextField.text, @"V_YJHM", @"", @"V_SJRDH",@"0",@"C_YJZT",nil];  //状态为0 表示未到站
            
            
          //  NSLog(@"444[111%@]\n",dic);
          //  NSLog(@"555[111%@]\n",dic.JSONString);
            NSString *getxmldata4=[Webconn Xmlappend:dic.JSONString params:@"getDTPostInfo" params1:@"http://service.search.gnzq.com" params2:@"PostService"];    //调用自定义方法  传入 方法名 命名空间   url
            //@"http://192.168.201.110:7602/gnzqService/service/PostService"
            
            NSError *error = nil;
            NSData *data4 = [NSURLConnection sendSynchronousRequest:getxmldata4 returningResponse:nil error:&error];
            if (data4 == nil) {
                NSLog(@"send request failed: %@", error);
                // return nil;
            }
            
            NSString *response4 = [[NSString alloc] initWithData:data4 encoding:NSUTF8StringEncoding];
          //  NSLog(@"response: %@", response4);
            
            
            NSString *getdata4=[Webconn decodexml:response4];
            
            NSString *backremark4=[Webconn jsondecoderemark:getdata4];
         //   NSLog(@"lala返回的soap信息是：[%@]\n",backremark4);
            
            NSString *backresult4=[Webconn jsondecoderesult:getdata4];
         //   NSLog(@"lala1返回的soap信息是：[%@]\n",backresult4);
            
            
            
            
            if([backresult4 isEqualToString:@"F0"])
                
            {
                [HUD hide:YES];
                
                _qscglshbz=1;
                
                //自定义获取解析出来的邮件流水号
                SBJsonParser *parser8 = [[SBJsonParser alloc] init];
                NSError *error8 = nil;
                NSMutableDictionary *jsonDic8 = [parser8 objectWithString:backremark4 error:&error8];
                NSMutableDictionary *dicUserInfo = [jsonDic8 objectForKey:@"rows"];
                
                NSString *yjhm ;
                
                
                for(NSMutableDictionary * member  in dicUserInfo)
                {
                    
                    _sjh = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_SJRDH"] description]];
                    _sjrxm = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_SJRXM"] description]];
                    yjhm = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_YJHM"] description]];
                    _dzqsyjlsh = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_YJLSH"] description]];
                }
           //     NSLog(@"[%@] [%@] [%@] [%@]", _sjh, _sjrxm, yjhm,_dzqsyjlsh);
                self.cellNum++;
                [self.tempUserName addObject:_sjrxm];
                [self.tempPostNum addObject:yjhm];
                [self.tempPhoneNum addObject:_sjh];
                [self.ljdjTableView reloadData];
                
                
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"到站签收成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alter show];
                
            
         
                                      
                    // // /////////////////////////到站签收接口 调用 成功///////////////////////////////////////////
                    
                    
                
                
            }
            
            else if([backresult4 isEqualToString:@"F2"]){
                
                [HUD hide:YES];
                
                
                _alert1 = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"未找到该邮件信息，是否进行登记"
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
                
                [_alert1 show];
                
                
                
                
                self.postNum = self.postNumTextField.text;
                
                
                
                
            }
            
            
            else {
                
                [HUD hide:YES];
                UIAlertView *alertmn = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                  message:backremark4
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                        otherButtonTitles:@"确定", nil];
                
                [alertmn show];
                
                
                
            }
            
            
        }
        
        
        
        else {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:@"无网络连接，请先设置好网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
        }
    }
    
    
}













// // //  //  //  //  //////////////////////////////////////////////////////////


- (void)hudWasHidden:(MBProgressHUD *)hud {
    [HUD removeFromSuperview];
}


/*
 //扫描 接口  暂时不用管
 - (IBAction)scan:(id)sender {
 //    QRCodeScanController * qrcodeScanVC = [[QRCodeScanController alloc]initWithNibName:@"QRCodeScanController" bundle:nil];
 //    qrcodeScanVC.qrCodeDelegate = self;
 //    [self.navigationController pushViewController:qrcodeScanVC animated:YES];
 
 ZBarReaderViewController *reader = [ZBarReaderViewController new];
 reader.readerDelegate = self;
 reader.showsZBarControls = NO;
 [reader.scanner setSymbology: ZBAR_UPCA config: ZBAR_CFG_ENABLE to: 0];
 reader.readerView.zoom = 1.0;
 [self.navigationController pushViewController:reader animated:NO];
 //    [self presentModalViewController: reader animated: YES];
 }
 
 
 //扫描控制
 
 - (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
 {
 id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
 ZBarSymbol *symbol = nil;
 for(symbol in results){
 _postNumTextField.text = symbol.data;
 [reader.navigationController popViewControllerAnimated:NO];
 //        [reader dismissModalViewControllerAnimated: YES];
 [self search:nil];
 }
 }
 
 //- (void)passQRCode:(NSString *)qrCode {
 //    self.postNumTextField.text = qrCode;
 //}
 */
///*

- (IBAction)scan:(id)sender {  //首先在扫描的按键上面设置事件
    
    
    
    _readerView = [[ ZBarReaderView alloc ] init ];  //边框分配大小
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
    
    
    //关闭闪光灯
    _readerView.torchMode = 0 ;
    // [self.view addSubview : _readerView ]; //将所有的界面统一添加到主界面
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
    
    
    
    
    
    [_readerView stop];
    [ _readerView start ];
    [ self createTimer ];
    
    
    
}
//*/



-( void )readerView:( ZBarReaderView *)readerView didReadSymbols:( ZBarSymbolSet *)symbols fromImage:( UIImage *)image
{
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol (symbols. zbarSymbolSet );
    NSString *symbolStr = [ NSString stringWithUTF8String : zbar_symbol_get_data (symbol)];
    
    
    _postNumTextField.text = symbolStr;
    
    [self.navigationController popViewControllerAnimated:NO]; //如果有扫描到邮件则进行返回
    
    [self search:nil];
    
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

#pragma mark -



//
// alertView 代理方法
//进行补录接口的调用 进行上传
//这里调用的是手工录入  接口  if (self.type == 0) 如果是0 调用邮件手工录入 否则调用邮件补录

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    
   // NSLog(@"11111[进来调用到手工录入]");
    if ([Utility netState]) {
        
       if((_dzqsbz== 1)&&(alertView==_sgblcusAlert)){                 //只有到站签收标志为  1 才表示签收 并且弹框是 登记界面才可以进行 手工补录
            
            //else if((_dzqsbz== 1)&&(alertView==_sgblcusAlert)){   //不管是签收还是拒签 都可以进行手工补录的提交  先提交再进行补录
            
            if (buttonIndex == 1) {
                HUD.labelText = @"登记信息中";
                [HUD show:YES];
                if (self.type == 0) {
                    //    保存邮件信息并显示
                    UITextField *t1 = alertView.containerView.subviews[5];
                    // UITextField *t2 = alertView.containerView.subviews[7];  //拿掉收件人地址
                    UITextField *t3 = alertView.containerView.subviews[6];   //[8];
                    UITextField *t4 = alertView.containerView.subviews[8];  //[10]
                    
                //    NSLog(@"[%@][%@][%@]",t1.text,t3.text,t4.text);
                    
                    //保存信息
                    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:jgbh, @"V_JGBH", self.postNum, @"V_YJHM", t3.text, @"V_SJRDH", t1.text, @"V_SJRXM",t4.text, @"V_WLGS",nil];
                    
                    //此处是进行手工补录的界面设计
                    
          //          NSLog(@"444[111%@]\n",dic);
          //          NSLog(@"555[111%@]\n",dic.JSONString);  //这里是将json 串变成简单的字符串
                    
                    
                    NSString *getxmldata45=[Webconn Xmlappend:dic.JSONString params:@"enterDTPost" params1:@"http://service.search.gnzq.com" params2:@"PostService"];    //调用自定义方法  传入 方法名 命名空间   url
                    
                    //@"http://192.168.201.110:7602/gnzqService/service/PostService"
                    NSError *error45 = nil;
                    NSData *data45 = [NSURLConnection sendSynchronousRequest:getxmldata45 returningResponse:nil error:&error45];                      if (data45 == nil) {
                        NSLog(@"send request failed: %@", error45);
                        // return nil;
                    }
                    
                    NSString *response45 = [[NSString alloc] initWithData:data45 encoding:NSUTF8StringEncoding];
                    
                    //NSLog(@"response: %@", response45);
                    
                    
                    NSString *getdata45=[Webconn decodexml:response45];
                    
                    NSString *backremark45=[Webconn jsondecoderemark:getdata45];
         //           NSLog(@"lala返回的soap信息是：[%@]\n",backremark45);
                    
                    NSString *backresult45=[Webconn jsondecoderesult:getdata45];
        //            NSLog(@"lala1返回的soap信息是：[%@]\n",backresult45);
                    
                    
                    
                    
                    if([backresult45 isEqualToString:@"F0"])
                        
                    {
                        [HUD hide:YES];
                        
                        
                        
                        
                        //自定义获取解析出来的邮件流水号
                        SBJsonParser *parser24 = [[SBJsonParser alloc] init];
                        NSError *error24 = nil;
                        NSMutableDictionary *jsonDic2 = [parser24 objectWithString:backremark45 error:&error24];//获取根节点 只需要获取一次
                        NSString *nn10 = [NSString stringWithFormat:@"%@",[[jsonDic2 objectForKey:@"V_YJLSH"] description]];
                  //      NSLog(@"[%@]",nn10);
                        _ljdjyjlsh=nn10;
                        
                        _qscglshbz=2;//手工录入成功  可以做到站撤销了
                        
                        UIAlertView *altermm = [[UIAlertView alloc] initWithTitle:@"提示" message:@"来件登记成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [altermm show];
                        
                        
                        self.cellNum++;
                        [self.tempPostNum addObject:self.postNum];
                        [self.tempUserName addObject:t1.text];
                        //      [self.tempAddress  addObject:t2.text];
                        [self.tempPhoneNum addObject:t3.text];
                        //  [self.tempPhoneNum addObject:t4.text];
                        
                        [self.ljdjTableView reloadData];
                        
                        
                    }
                    //else if(!iSuc)
                    else{
                        
                        [HUD hide:YES];
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:backremark45 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                        [alert show];
                        
                    }
                    
                    
                    
                }
                
                
            }
            //以上就是对于 按键为1 的设置
            
            
            
            [alertView close];
            [self.ljdjTableView reloadData];
        }
        
  
        
        
        
    }
    else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:@"无网络连接，请先设置好网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
    }
}



#pragma mark -
//弹出窗口界面设计      //这里 是对于弹出界面  的窗口的设计  进行补录  页面 的设计
- (UIView *)createDemoView
{
    _demoview =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 250)];
    
    UILabel *titleLabel =    [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 270, 21)];
    titleLabel.textColor = [UIColor orangeColor];
    titleLabel.text = @"修改信息";
    
    UILabel *mailNumLabel =  [[UILabel alloc] initWithFrame:CGRectMake(5, 22, 270, 21)];
    mailNumLabel.text = @"邮件号码";
    UILabel *numLabel =      [[UILabel alloc] initWithFrame:CGRectMake(5, 44, 270, 21)];
    //numLabel.text = self.postNum;
    numLabel.text = self.postNumTextField.text;
    
    UILabel *nameLabel =     [[UILabel alloc] initWithFrame:CGRectMake(5, 66, 270, 21)];
    nameLabel.text = @"收件人姓名";
    _userNameTextField  = [[UITextField alloc] initWithFrame:CGRectMake(5, 88, 270, 21)];
    _userNameTextField.placeholder = @"请输入用户名";
    [_userNameTextField  setBorderStyle:UITextBorderStyleRoundedRect];
    _userNameTextField.delegate=self; //此处设置代理为自身 否则无法关闭键盘
    
    
    UIColor *color = [[UIColor alloc] initWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
    // UIColor *color = [[UIColor alloc] initWithRed:100.0/255.0 green:180.0/255.0 blue:100.0/255.0 alpha:0.5];
    
    _demoview.backgroundColor = color;
    titleLabel.backgroundColor = color;
    mailNumLabel.backgroundColor = color;
    numLabel.backgroundColor = color;
    nameLabel.backgroundColor = color;
    _userNameTextField.backgroundColor = color;
    
    [_demoview addSubview:titleLabel];
    [_demoview addSubview:mailNumLabel];
    [_demoview addSubview:numLabel];
    [_demoview addSubview:nameLabel];
    
    // 补录
    if (self.type == 0) {
        
        
        UILabel *phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 110, 270, 21)];//(5, 154, 270, 21)
        phoneNumLabel.text = @"电话号码";
        _userPhoneNumTextField  = [[UITextField alloc] initWithFrame:CGRectMake(5, 132, 270, 21)];//(5, 176, 270, 21)
        _userPhoneNumTextField.placeholder = @"请输入用户电话";
        [_userPhoneNumTextField  setBorderStyle:UITextBorderStyleRoundedRect];
        _userPhoneNumTextField.delegate=self;//此处设置代理为自身 否则无法关闭键盘
        
        
        
        //    addressLabel.backgroundColor = color;
        phoneNumLabel.backgroundColor = color;
        _userNameTextField.backgroundColor = color;
        _userAddressTextField.backgroundColor = color;
        _userPhoneNumTextField.backgroundColor = color;
        
        //     [_demoview addSubview:addressLabel];
        [_demoview addSubview:phoneNumLabel];
        
        [_demoview addSubview:_userNameTextField];
        //     [_demoview addSubview:_userAddressTextField];
        [_demoview addSubview:_userPhoneNumTextField];
        
        
        
        //自定义新增界面测试
        UILabel *phoneNumLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 154, 270, 21)];//(5, 208, 270, 21)
        phoneNumLabel1.text = @"物流公司";
        
        
         _userPhoneNumTextField3  = [[UITextField alloc] initWithFrame:CGRectMake(5, 176, 270, 21)];
        _userPhoneNumTextField3.text=@"中国邮政";
        _userPhoneNumTextField3.userInteractionEnabled=NO;
        [_userPhoneNumTextField3  setBorderStyle:UITextBorderStyleRoundedRect];  //此处将文本框文字写死
        //设置代理数据源 才可以保证点击文本框的时候调用到代理函数  只有设置了代理才能对函数进行重载
        
        
        
        //自定义新增界面测试
        phoneNumLabel1.backgroundColor = color;
        //  userPhoneNumTextField1.backgroundColor = color;
        _userPhoneNumTextField3.backgroundColor = color;
        [_demoview addSubview:phoneNumLabel1];
        //  [_demoview addSubview:userPhoneNumTextField1];
        [_demoview addSubview:_userPhoneNumTextField3];
        
        
        
    }
    
    return _demoview;
}





-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
 //   NSLog(@"1111[%@]被按下\n",tableView);
    self.editRow = indexPath.row;
    self.type = 1;
    CustomIOSAlertView* cusAlert = [[CustomIOSAlertView alloc] init];
    [cusAlert setContainerView:[self createDemoView]];
    [cusAlert setButtonTitles:[NSMutableArray arrayWithObjects:@"取消1111", @"确定", nil]];
    cusAlert.delegate = self;
    [cusAlert show];
}






//只有返回失败以后  才会调用这个 界面
//是否补录信息  点击确定才会出现 补录的界面
//这里是针对 弹框提示的提示框进行的 函数重载


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{//这里是对于第一次弹框 的功能扩展  因此 如果是 到站撤销的话  只需要在这里进行即可
    
    
    if(alertView ==_alert1){   //这里是进行 是否进行来件登记手工补录的  弹框按键 的判断
     //   NSLog(@"111[%@]按键数字是[%ld]被按下\n",alertView,(long)buttonIndex);
        
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            _sgblcusAlert = [[CustomIOSAlertView alloc] init];
            [_sgblcusAlert setContainerView:[self createDemoView]];
            self.type = 0;
            [_sgblcusAlert setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]]; //如果这里被按下 就会触发下列函数进行接口的发送
            
            _sgblcusAlert.delegate = self;
            [_sgblcusAlert show];
        }}
    
    /*
    else if(alertView ==_alert2){NSLog(@"其他弹框按键,按键数字是[%ld]",(long)buttonIndex);  //这里是进行物流公司 的弹框判断
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            _userPhoneNumTextField3.text=_rowvalue;
            // [alertView close];
        }
    }*/
    
    
    
    //如果弹框的名称是  进行信息补全的话
    
 
    
    
    
    
    
    //如果是属于撤销的按键被按下 就触发撤销接口   到站撤销功能
    else if(alertView ==_alert123){
      //  NSLog(@"到站撤销的按键被按下按键数字是[%ld]",(long)buttonIndex);
        
        
        if ([Utility netState]) {
            if (buttonIndex == 1) {
                HUD.labelText = @"撤销信息中";
                [HUD show:YES];
                //   if (self.type == 1) {  //这个完全没有用 不用管了
                
                NSDictionary *dzcxdic;
                
                if(_qscglshbz==1){
                    
                    dzcxdic = [[NSDictionary alloc]initWithObjectsAndKeys:jgbh, @"V_JGBH",_dzqsyjlsh,@"V_YJLSH",nil];
                    
            //        NSLog(@"此时是签收成功流水号[%@][%@]标志[%d]\n",jgbh,_dzqsyjlsh,_qscglshbz);
                    
                    
                }
                
                else if (_qscglshbz==2){
                    dzcxdic = [[NSDictionary alloc]initWithObjectsAndKeys:jgbh, @"V_JGBH",_ljdjyjlsh,@"V_YJLSH",nil];
                    
            //        NSLog(@"此时是手工补录成功流水号[%@][%@]标志[%d]\n",jgbh,_ljdjyjlsh,_qscglshbz);
                    
                }
                
            //    NSLog(@"444[111%@]\n",dzcxdic);
            //    NSLog(@"555[111%@]\n",dzcxdic.JSONString);  //这里是将json 串变成简单的字符串 555[111{"V_JGBH":"210005614","V_PASSWORD":"005614"}]
                //这里是将页面的输入拼凑成json 串的形势 进行发送 这里无需修改
                
                
                
                
                
                
                
                //请求  //这里已经进行发送了
                
                NSString *getxmldata48=[Webconn Xmlappend:dzcxdic.JSONString params:@"repealDTPost" params1:@"http://service.search.gnzq.com" params2:@"PostService"];    //调用自定义方法  传入 方法名 命名空间   url
                
                //@"http://192.168.201.110:7602/gnzqService/service/PostService"
                NSError *error48 = nil;
                NSData *data48 = [NSURLConnection sendSynchronousRequest:getxmldata48 returningResponse:nil error:&error48];  //进行同步发送
                if (data48 == nil) {
                    NSLog(@"send request failed: %@", error48);
                    // return nil;
                }
                
                NSString *response48 = [[NSString alloc] initWithData:data48 encoding:NSUTF8StringEncoding];      //获得 返回的 xml 格式的字符串
          //      NSLog(@"response: %@", response48);
                
                
                
                NSString *getdata48=[Webconn decodexml:response48];//解析后获得最终传出的字符串  得到一大串返回json串
                
                NSString *backremark48=[Webconn jsondecoderemark:getdata48];  //一一获取对应的 值
          //      NSLog(@"lala返回的soap信息是：[%@]\n",backremark48);
                
                NSString *backresult48=[Webconn jsondecoderesult:getdata48];   //一一获取对应的 值 用来进行逻辑判断
        //        NSLog(@"lala1返回的soap信息是：[%@]\n",backresult48);
                
                
                
                
                if([backresult48 isEqualToString:@"F0"])
                    
                {
                    [HUD hide:YES];
                    
                    
                    for (int i = 0; i < self.cellNum; i++) {
                        [self.tempPostNum removeObjectAtIndex:i];
                        
                        [self.tempUserName removeObjectAtIndex:i];
                        [self.tempPhoneNum removeObjectAtIndex:i];
                        self.cellNum--;
                        [self.ljdjTableView reloadData]; //最后一定要重新加载
                        
                    }
                    
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"到站撤销成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alter show];
                    
                    
                }
                //else if(!iSuc)
                else{
                    
                    
                    [HUD hide:YES];  //注意 这里只是一个控件的显示  不管  是否查询成功  都要对他进行隐藏
                    
                    // [self.yhqjTableView reloadData];
                    
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:@"无法到站撤销，请确认邮件信息状态完整" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alter show];
                    
                    
                    
                    
                    
                }
                
                //以上是 调用自己封装的通讯方式  进行通讯  采用同步调用的方式
                
                
                
                
                
                
                //}
            }
            
            
            
        }
        
    }
    
    
    
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Do any additional setup after loading the view, typically from a nib.






//收起键盘
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return YES;
}


@end