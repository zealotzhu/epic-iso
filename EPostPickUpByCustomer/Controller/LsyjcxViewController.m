//
//  LsyjcxViewController.m
//  EPostPickUpByCustomer
//
//  Created by user on 15-11-9.
//  Copyright (c) 2015年 gotop. All rights reserved.
//

#import "Utility.h"
#import "LsyjcxViewController.h"
#import "CustomOneLineCell.h"


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




@interface LsyjcxViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate,ZBarReaderViewDelegate> {
    MBProgressHUD *HUD;
    
    
    UIView *_QrCodeline;
    
    
    //设置扫描画面
    UIView *_scanView;
    
    
    
    
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *postNumTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 界面调整
//@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;  //自定义按钮

@property (weak, nonatomic) IBOutlet UILabel *postNumLabel;


@property (nonatomic, assign) int cellNum;
@property (strong, nonatomic) NSMutableArray *postInfo;
@end

@implementation LsyjcxViewController

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
    _phoneNumTextField.font = [UIFont systemFontOfSize:fonsize];
    //    _phoneNumLabel.font = [UIFont systemFontOfSize:fonsize];
    
    _scanBtn.titleLabel.font = [UIFont systemFontOfSize:fonsize];
    
    
    _postNumLabel.font = [UIFont systemFontOfSize:fonsize];
    _postNumTextField.font = [UIFont systemFontOfSize:fonsize];
}

- (void) ini {
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;

    
    self.title = @"历史邮件查询";
    
    //    self.phoneNumTextField.delegate = self;
    self.postNumTextField.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //    self.phoneNumTextField.text = @"18650717531";
    self.cellNum = 0;
    self.postInfo = [[NSMutableArray alloc]init];
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.square = YES;
    
    
    //自定义调整cell的高度
    self.tableView.rowHeight = 140;
    
    //self.tableView.
    
}

- (IBAction)searchByPostNum:(id)sender {
    NSString *postNum = self.postNumTextField.text;
    NSString *phoneNum = @"";
    if (postNum.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入邮件号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
    } else {
        [self searchWithPostNum:postNum phoneNum:phoneNum];
    }
}


- (void)searchWithPostNum:(NSString *)postNum phoneNum:(NSString *)phoneNum{
    [self.postNumTextField endEditing:YES];
    [self.phoneNumTextField endEditing:YES];
    if (self.cellNum != 0) {
        self.cellNum = 0;
        [self.postInfo removeAllObjects];
    }
    
    if ([Utility netState]) {
        HUD.labelText = @"查询信息中";
        [HUD show:YES];
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:jgbh, @"V_JGBH", self.postNumTextField.text, @"V_YJHM",nil];
        
        
      
        
        NSString *getxmldata7=[Webconn Xmlappend:dic.JSONString params:@"queryHistory" params1:@"http://service.search.gnzq.com" params2:@"PostService"];    //调用自定义方法  传入 方法名 命名空间   url
        
        //@"http://192.168.201.110:7602/gnzqService/service/PostService"
        NSError *error = nil;
        NSData *data7 = [NSURLConnection sendSynchronousRequest:getxmldata7 returningResponse:nil error:&error];  //进行同步发送
        if (data7 == nil) {
            NSLog(@"send request failed: %@", error);
            // return nil;
        }
        
        NSString *response7 = [[NSString alloc] initWithData:data7 encoding:NSUTF8StringEncoding];
   //     NSLog(@"response: %@", response7);
        
        NSString *getdata7=[Webconn decodexml:response7];
        
        NSString *backremark7=[Webconn jsondecoderemark:getdata7];
  //      NSLog(@"lala返回的soap信息是：[%@]\n",backremark7);
        
        NSString *backresult7=[Webconn jsondecoderesult:getdata7];
  //      NSLog(@"lala1返回的soap信息是：[%@]\n",backresult7);
        
        
        
        
        if([backresult7 isEqualToString:@"F0"])
            
        {
            
            [HUD hide:YES];
            
            SBJsonParser *parser8 = [[SBJsonParser alloc] init];
            NSError *error8 = nil;
            NSMutableDictionary *jsonDic8 = [parser8 objectWithString:backremark7 error:&error8];//获取根节点 只需要获取一次
            NSMutableDictionary *dicUserInfo = [jsonDic8 objectForKey:@"rows"];    //找到对应的根节点
            
            
            NSString *nn9;
            NSString *nn10 ;
            NSString *nn11 ;
            NSString *nn12 ;
            
            for(NSMutableDictionary * member  in dicUserInfo)
            {
                nn9 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"POSTINFO"] description]];  //如果有多个
            }
            
            
            
            nn9 =[nn9 stringByReplacingOccurrencesOfString:@"@@@@@@" withString:@"\n"]; //先将6个@替换掉
            nn9 =[nn9 stringByReplacingOccurrencesOfString:@"@@@" withString:@"\n"];  //再替换掉3个@
        //    NSLog(@"44444555555555555\n[%@]\n",nn9);
            
            // nn9=@"哈哈哈哈\n谁是大英雄\n我才是大英雄\n啦啦啦\n我我我\n性感的我\n嘻嘻嘻嘻\n滚滚滚\n来来来\n";
            
            [self.postInfo addObject:nn9];
            self.cellNum++;
            [self.tableView reloadData];
            
            
        }
        //else if(!iSuc)
        else{
            
            
            [HUD hide:YES];
            
            // [self.yhqjTableView reloadData];
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:backremark7 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
            
            
        }
                
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"网络错误，请设置好网络" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
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
    return _cellNum;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"oneLineCell";
    
    CustomOneLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell) {
        cell = [CustomOneLineCell customOneLineCell];
    }
    
    
    cell.numLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
    cell.titleLabel.text = self.postInfo[indexPath.row];
    
    return cell;
}



#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (IBAction)scan:(id)sender {
    
   // NSLog(@"cat hahahah ");
    
    
    //[self setScanView];   //先加载函数实现边框自定义 根笨不需要调用 因为暂时不实现 边框里面再进行嵌套
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
    
   // _readerView.showsFPS=YES;//显示扫描帧数
    //_readerView.zoom =1.0;
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
    
    
    [ _readerView stop ];
    [ _readerView start ];
    [ self createTimer ];
    
    
    
    
}


//*/



-( void )readerView:( ZBarReaderView *)readerView didReadSymbols:( ZBarSymbolSet *)symbols fromImage:( UIImage *)image
{
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol (symbols. zbarSymbolSet );
    NSString *symbolStr = [ NSString stringWithUTF8String : zbar_symbol_get_data (symbol)];
    
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

#pragma mark -





//收起键盘
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return YES;
}



@end
