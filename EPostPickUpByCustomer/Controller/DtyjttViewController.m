//
//  DtyjttViewController.m
//  EPostPickUpByCustomer
//
//  Created by lzb on 16/7/28.
//  Copyright © 2016年 gotop. All rights reserved.
//

#import "DtyjttViewController.h"

#import "Utility.h"


#import "CustomThreeLineCell.h"




#import "CommonFunc.h"
#import "md5.h"
#import "SBJson.h"
#import "webconn.h"


@interface DtyjttViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,  MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *postNumTextField;
@property (weak, nonatomic) IBOutlet UITableView *yhqjTableView;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumSearchBtn;
@property (weak, nonatomic) IBOutlet UIButton *postNumSearchBtn;

// 界面调整
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *postNumlabel;
@property (weak, nonatomic) IBOutlet UIButton *pwdGetPostBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pwdGetPostBtnHeight;
@property (weak, nonatomic) IBOutlet UIButton *certGetPostBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *certGetPostBtnHeight;


@property (nonatomic, assign) int cellNum;
@property (nonatomic, strong) NSMutableArray *tempPostNum;
@property (nonatomic, strong) NSMutableArray *tempUserName;
@property (nonatomic, strong) NSMutableArray *tempPhoneNum;

@property (strong, nonatomic) NSMutableArray *tempYJLSH;

@property (nonatomic, assign) NSInteger selectCellNum;
@property (nonatomic, assign) int getPostStyle;     //取件方式
@property (nonatomic, assign) int isSelfGetPost;   //本人取件?

@property (strong, nonatomic) NSMutableArray *clickedSelect;   //表示是否被选中
@property (strong, nonatomic)NSString *together;

@property (nonatomic) NSMutableArray *zjlxchaxuncarray;//页面刚开始加载时候  进行调用 获取证件类型

@property(strong,nonatomic)UIAlertView *yjttalert;


@end
#define PWD_GET_POST   1
#define CERT_GET_POST  2
#define SELF_GET_POST  1
#define OTHER_GET_POST 2
@implementation DtyjttViewController



//@synthesize xmlParser;               //存储解析后的数据
//@synthesize soapResults;             //返回结果




- (void)viewDidLoad {
    [super viewDidLoad];
    [self ini];
    //[self zhengjianchaxun];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_pwdGetPostBtn.layer setMasksToBounds:YES];
    [_pwdGetPostBtn.layer setCornerRadius:5.0f];
    [_certGetPostBtn.layer setMasksToBounds:YES];
    [_certGetPostBtn.layer setCornerRadius:5.0f];
    
    if(self.view.frame.size.height > 480.0f) {
        [self adjustLayout];
    }
}

- (void)adjustLayout {
    _postNumlabel.font = [UIFont systemFontOfSize:fonsize];
    _postNumTextField.font = [UIFont systemFontOfSize:fonsize];
    _phoneNumLabel.font = [UIFont systemFontOfSize:fonsize];
    _phoneNumTextField.font = [UIFont systemFontOfSize:fonsize];
    _pwdGetPostBtn.titleLabel.font = [UIFont systemFontOfSize:fonsize];
    _certGetPostBtn.titleLabel.font = [UIFont systemFontOfSize:fonsize];
    _pwdGetPostBtnHeight.constant = _CONSTANT_;
    _certGetPostBtnHeight.constant = _CONSTANT_;
    [self.view layoutIfNeeded];
}

- (void)ini{
    self.cellNum = 0;
    self.phoneNumTextField.delegate = self;
    self.postNumTextField.delegate = self;
    self.yhqjTableView.dataSource = self;
    self.yhqjTableView.delegate = self;
    
    
    self.selectCellNum = 0;  //在这里不对它进行初始化 以后如果想要有登入即可默认  只要把它放出来即可
    
    self.tempPostNum  = [[NSMutableArray alloc]init];
    self.tempUserName = [[NSMutableArray alloc]init];
    self.tempPhoneNum = [[NSMutableArray alloc]init];
    self.clickedSelect  = [[NSMutableArray alloc] init];
    self.tempYJLSH = [[NSMutableArray alloc]init]; //这里很重要  数组一定要分配内存
    
    
    //设置背景提示
    self.phoneNumTextField.placeholder=@"支持手机号后四位取件";
    self.postNumTextField.placeholder=@"支持邮件号后四位取件";
    
    self.title = @"邮件妥投";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.square = YES;
}






- (IBAction)phoneNumSearch:(id)sender {
    NSString *phoneNum = self.phoneNumTextField.text;
    NSString *postNum = self.postNumTextField.text;
    if (!postNum) {
        postNum = @"";                              //如果邮件号码没有内容  则为空
    }
    [self.phoneNumTextField endEditing:YES];
    if ((phoneNum.length != 11)&&(phoneNum.length != 4)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号格式不正确，请重新输入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];    //显示长度校验
        
        
    } else {
        [self.phoneNumTextField endEditing:YES];
        [self search:postNum andPhoneNum:phoneNum];    //这里调用的是用户取件 的接口
    }
    
   // NSLog(@"444hahahahha返回的soap信息是：[%@]\n",soapResults);
}

- (IBAction)postNumSearch:(id)sender {               //这里是邮件号码 校验
    
    //sleep(3);
    
    NSString *phoneNum = self.phoneNumTextField.text;
    NSString *postNum = self.postNumTextField.text;
    if (phoneNum == nil) {
        phoneNum = @"";                              //如果手机号码为空  就对手机号码 填空值
    }
    [self.postNumTextField endEditing:YES];
    if (postNum.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入邮件号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    } else {
        [self.postNumTextField endEditing:YES];
        [self search:postNum andPhoneNum:phoneNum];
    }
    
    
    
    
}

- (void)search:(NSString *)postNum andPhoneNum:(NSString *)phoneNum{
    
    if (self.cellNum != 0) {
        self.cellNum = 0;
        [self.tempPhoneNum removeAllObjects];
        [self.tempPostNum removeAllObjects];
        [self.tempUserName removeAllObjects];
        [self.tempYJLSH removeAllObjects];
        [self.clickedSelect removeAllObjects];
        [self.yhqjTableView reloadData];
    }
    
    
    if ([Utility netState]) {
        HUD.labelText = @"查询中";
        [HUD show:YES];
        
        
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:jgbh, @"V_JGBH", czygh,@"V_CZYGH", postNum, @"V_YJHM", phoneNum, @"V_SJRDH", @"1",@"C_YJZT",nil];
        
        //调用的是一样的查询邮件 接口
        
        
        
    //    NSLog(@"444[111%@]\n",dic);
    //    NSLog(@"555[111%@]\n",dic.JSONString);
        NSString *getxmldata=[Webconn Xmlappend:dic.JSONString params:@"getDTPostInfo" params1:@"http://service.search.gnzq.com" params2:@"PostService"];    //调用自定义方法  传入 方法名 命名空间   url
        
        //@"http://192.168.201.110:7602/gnzqService/service/PostService"
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:getxmldata returningResponse:nil error:&error];
        if (data == nil) {
            NSLog(@"send request failed: %@", error);
            // return nil;
        }
        
        NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     //   NSLog(@"response: %@", response);
        
        
        NSString *getdata=[Webconn decodexml:response];
        
        NSString *backremark=[Webconn jsondecoderemark:getdata];
     //   NSLog(@"lala返回的soap信息是：[%@]\n",backremark);
        
        NSString *backresult=[Webconn jsondecoderesult:getdata];
    //    NSLog(@"lala1返回的soap信息是：[%@]\n",backresult);
        
        
        
        
        if([backresult isEqualToString:@"F0"])
            
        {
            [HUD hide:YES];
            
            SBJsonParser *parser8 = [[SBJsonParser alloc] init];
            NSError *error8 = nil;
            NSMutableDictionary *jsonDic8 = [parser8 objectWithString:backremark error:&error8];//获取根节点 只需要获取一次
            NSMutableDictionary *dicUserInfo = [jsonDic8 objectForKey:@"rows"];    //找到对应的根节点
            
            
            NSString *nn9;
            NSString *nn10 ;
            NSString *nn11 ;
            NSString *nn12 ;
            NSString *nn13 ;
            
            for(NSMutableDictionary * member  in dicUserInfo)
            {
                nn9 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"N_YJLY"] description]];                  nn10 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_SJRDH"] description]];
                nn11 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_SJRXM"] description]];
                nn12 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_YJHM"] description]];
                nn13 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_YJLSH"] description]];
                
                
                
                
                NSString *yjly = nn9;
                NSString *yjhm = nn12;
                NSString *sjrxm = nn11;
                NSString *sjrdh = nn10;
                NSString *yjlsh = nn13;
                
                
                int exist = 0;
                if (exist == 0) {
                    [self.tempPostNum addObject:yjhm];
                    [self.tempUserName addObject:sjrxm];
                    [self.tempPhoneNum addObject:sjrdh];
                    [self.tempYJLSH addObject:yjlsh];
                    
                    [self.clickedSelect addObject:@"NO"];
                    
                    self.cellNum++;
                    
                    
                    
                    
                }
                
                [self.yhqjTableView reloadData];
                
            }
            
        }
        //else if(!iSuc)
        else{
            
            
            [HUD hide:YES];
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:backremark delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
            
            
        }
        
        
    }
    
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"网络错误，请设置好网络" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
    }
    
    
    
}




//以下是陈铭的代码逻辑
// // ////////////////////////////////////////////////////////////////////////////////////////////////
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [HUD removeFromSuperview];
}

- (IBAction)pwdGetPost:(id)sender {   //点击按键  密码取件  的显示
    if ((self.cellNum != 0)&&(self.selectCellNum != 0)) {     //重新载入数据以后  才能够进行  显示  才能判断成立
        self.getPostStyle = PWD_GET_POST;
        self.isSelfGetPost = SELF_GET_POST;
        
        /*
        
        CustomIOSAlertView* cusAlert = [[CustomIOSAlertView alloc] init];
        [cusAlert setContainerView:[self createDemoView]];                                   //此时 加载  这个代理函数 进行取件 createDemoView
        [cusAlert setButtonTitles:[NSMutableArray arrayWithObjects:@"取消？", @"确定？", nil]];   //然后调用 按键事件
        
        cusAlert.delegate = self;
        [cusAlert show];
        */
        
        _yjttalert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定进行邮件妥投？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [_yjttalert show];
        
        
        
        
        
    }
    
    else if(self.cellNum == 0){UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先进行邮件查询" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];}
    else if(self.selectCellNum == 0){UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先进行邮件选择" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];}
    
    
    
}

#pragma mark - 弹出框响应函数
//是否进行取件，是则弹出对话框要求输入密码等内容
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{       //注意  模式显示  和 按键 触发 都是这个函数调用 的
    
    
    //  NSLog(@"1111122222\n\n");
    
    
    
    if(alertView == _yjttalert){
    
        if (buttonIndex != 0){
        
            if (buttonIndex == 1) {
            
            
                
                if ([Utility netState]) {
                    HUD.labelText = @"上传信息中";
                    [HUD show:YES];
                    
                    
                    
                    //在这里进行算法的处理
                    self.together= [[NSString alloc]initWithFormat:@""];  //局部的初始化
                    for (int i = 0; i < self.cellNum; i++) {
                        
                   //     NSLog(@"111[%d][%d]",self.cellNum,i);   //33333333日志打印
                        
                        
                        if ([self.clickedSelect[i] isEqualToString:@"YES"] ) {
                            
                            self.together=[self.together stringByAppendingFormat:@",%@",self.tempYJLSH[i]];
                //            NSLog(@"[%@]",self.tempYJLSH[i]);
               //             NSLog(@"[%@]",self.together);
                        }
                    }
                    
                    
                    if([self.together isEqualToString:@""])
                        
                    {
                        UIAlertView *getyjalert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先点击选择邮件" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [getyjalert show];
                        
                    }
                    else{
                        
                        
                        
                        NSString *subtogether = [self.together substringFromIndex:1];
               //         NSLog(@"string2:%@",subtogether);  //获取所有的邮件流水号 并且截取第一个逗号
                        
                        //在这里进行算法的处理结束
                        
                        
                        NSDictionary *dic11 = [[NSDictionary alloc]initWithObjectsAndKeys:jgbh, @"V_JGBH", subtogether,@"V_YJLSH", czygh, @"V_CZYGH", nil];
                        
                        
                //        NSLog(@"444[111%@]\n",dic11);
                //        NSLog(@"555[111%@]\n",dic11.JSONString);  //这里是将json 串变成简单的字符串 555[111{"V_JGBH":"210005614","V_PASSWORD":"005614"}]
                        //这里是将页面的输入拼凑成json 串的形势 进行发送 这里无需修改
                        
                        
                        NSString *getxmldata1=[Webconn Xmlappend:dic11.JSONString params:@"getDTPost" params1:@"http://service.search.gnzq.com" params2:@"PostService"];    //调用自定义方法  传入 方法名 命名空间   url
                        
                        
                        
                        //@"http://192.168.201.110:7602/gnzqService/service/PostService"
                        NSError *error = nil;
                        NSData *data1 = [NSURLConnection sendSynchronousRequest:getxmldata1 returningResponse:nil error:&error];
                        if (data1 == nil) {
                            NSLog(@"send request failed: %@", error);
                            // return nil;
                        }
                        
                        NSString *response1 = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                 //       NSLog(@"response: %@", response1);
                        
                        
                        NSString *getdata1=[Webconn decodexml:response1];
                        
                        NSString *backremark1=[Webconn jsondecoderemark:getdata1];
           //             NSLog(@"lala返回的soap信息是：[%@]\n",backremark1);
           
                        NSString *backresult1=[Webconn jsondecoderesult:getdata1];
        //                NSLog(@"lala1返回的soap信息是：[%@]\n",backresult1);
                        
                        
                        if([backresult1 isEqualToString:@"F0"])
                            
                        {
                            
                            [HUD hide:YES];
                            
                            
                            
                            for (int i = 0; i < self.cellNum; i++) {
                                
                                
                      //          NSLog(@"更新之前删除原来的数据[%d][%d][%@]",self.cellNum,i,self.clickedSelect[i]);
                                
                                
                                if ([self.clickedSelect[i] isEqualToString:@"YES"] ) {
                    
                   //                 NSLog(@"更新成功删除原来的数据[%d][%d][%@]",self.cellNum,i,self.clickedSelect[i]);
                                    
                                    [self.tempPostNum removeObjectAtIndex:i];
                                    [self.tempUserName removeObjectAtIndex:i];
                                    [self.tempPhoneNum removeObjectAtIndex:i];
                                    [self.tempYJLSH removeObjectAtIndex:i];
                                    [self.clickedSelect removeObjectAtIndex:i];
                                    
                                    self.cellNum--;
                                    
                                    i=-1;//为了重置
                                }
                                
                            }
                            
                            
                            
                            [self.yhqjTableView reloadData];
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"妥投成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                            [alert show];
                            
                            self.selectCellNum=0;  //这里是为了取件成功删除以后 页面不会自动选择
                            
                            
                        }
                        //else if(!iSuc)
                        else{
                            
                            
                            [HUD hide:YES];
                            
                            // [self.yhqjTableView reloadData];
                            
                            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:backremark1 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alter show];
                            
                            
                        }
                        
                        
                        
                    }
                    
                }
                
                
                else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"网络错误，请设置好网络" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                    [alert show];
                }

                
                
                
                
                
            }
        
        }
    
    
    
    }
     
    //   NSLog(@"44446666\n\n");
    
}


#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellNum;
}


//自动选定行数  并且同时进行显示 用来进行查询用户区间 邮件的显示

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"threeLineCell";
    
    CustomThreeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell) {
        cell = [CustomThreeLineCell customThreeLineCell];
    }
    cell.numLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
    cell.postNumLabel.text = [NSString stringWithFormat:@"邮件 %@", self.tempPostNum[indexPath.row]];
    cell.nameLabel.text = [NSString stringWithFormat:@"收件人姓名：%@", self.tempUserName[indexPath.row]];
    cell.phoneNumLabel.text = [NSString stringWithFormat:@"收件人电话：%@", self.tempPhoneNum[indexPath.row]];
    
    
    //如何解决 cell 被重用以及重新加载时 样式也被重用  实现正常的多选返回
    //由于每一个cell在加载的时候都会调用这个函数  因此 每一次加载的时候都去进行一个调用 获取对应数组的 位置的属性 如果是符合 就将样式改成所要的 这是最正确的做法
    //关键在于  每一次都要调用 以及 indexPath.row 就代表每一次的 cell 位置  和数组关联  当然数组要事先维护好对应的值 只需要在点击的时候对数组进行添加即可
    BOOL isLiked = [[self.clickedSelect objectAtIndex:indexPath.row] boolValue];
    if (isLiked) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    
    
    
    
    return cell;
}

#pragma mark - UITableView Delegate methods


//设置自动选定
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *tempCell = [self.yhqjTableView cellForRowAtIndexPath:indexPath];
    if(tempCell.accessoryType == UITableViewCellAccessoryNone) {
        tempCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.clickedSelect replaceObjectAtIndex:indexPath.row withObject:@"YES"];     //如何 进行是否被选择的判断  如果点击下去 样式没有则进行选中 并且改变成为yes
        self.selectCellNum++;                                                           //这里是进行多选的判断
    } else {
        tempCell.accessoryType = UITableViewCellAccessoryNone;
        [self.clickedSelect replaceObjectAtIndex:indexPath.row withObject:@"NO"];
        self.selectCellNum--;
    }
    
    
    
    
    
}


//收起键盘
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    
    //    [textField resignFirstResponder];
    [textField endEditing:YES];
    return YES;
}

@end
