//
//  TjjjViewController.m
//  EPostPickUpByCustomer
//
//  Created by user on 15-11-9.
//  Copyright (c) 2015年 gotop. All rights reserved.
//

#import "Utility.h"
#import "FMDB.h"
#import "TjjjViewController.h"
#import "CustomIOSAlertView.h"
#import "CustomThreeLineCell.h"
#import "MBProgressHUD.h"

#import "TJDJViewController.h"

#import "CommonFunc.h"
#import "md5.h"
#import "SBJson.h"
#import "webconn.h"



@interface TjjjViewController () <UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate, CustomIOSAlertViewDelegate, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}




@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL isSelectAll;
@property (weak, nonatomic) IBOutlet UISwitch *selectAllSwitch;

// 界面调整
@property (weak, nonatomic) IBOutlet UILabel *selectAllLabel;
@property (weak, nonatomic) IBOutlet UIButton *handOverBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handOverBtnHeight;

@property (nonatomic, assign) int selectCount;
@property (strong, nonatomic) NSMutableArray *isSelect;
@property (strong, nonatomic) NSMutableArray *tempReturnReason;
@property (strong, nonatomic) NSMutableArray *tempOtherReason;
@property (nonatomic, strong) NSMutableArray *tempPostNum;
@property (nonatomic, strong) NSMutableArray *tempUserName;
@property (nonatomic, strong) NSMutableArray *tempPhoneNum;


@property (nonatomic, strong) NSMutableArray *tempTJJJYJLSH;//新增作为获取邮件流水号的标志

@property (nonatomic, assign) int cellNum;

@property (strong, nonatomic) NSString *tableName;
@property (strong, nonatomic) NSString *tjjjyjlsh; //退件交接邮件流水号
@property (nonatomic, assign) int switchcount;  //判断全选按键是否被按下的标志

@property (strong, nonatomic) FMDatabase *db;
@end

@implementation TjjjViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ini];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_handOverBtn.layer setMasksToBounds:YES];
    [_handOverBtn.layer setCornerRadius:5.0f];
    if (self.view.frame.size.height > 480.0f) {
        [self adjustLayout];
    }
}

- (void)adjustLayout {
    _selectAllLabel.font = [UIFont systemFontOfSize:fonsize];
    _handOverBtn.titleLabel.font = [UIFont systemFontOfSize:fonsize];
    _handOverBtnHeight.constant = _CONSTANT_;
    [self.view layoutIfNeeded];
}

- (void) ini{                           //只要一进入这个页面 立刻调用查询接口 获取未被交接的数量
    self.title = @"退件交接";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.isSelectAll = NO;
    self.selectCount = 0;
    self.isSelect  = [[NSMutableArray alloc] init];
    self.tempReturnReason = [[NSMutableArray alloc] init];
    self.tempOtherReason = [[NSMutableArray alloc] init];
    self.tempPostNum  = [[NSMutableArray alloc] init];
    self.tempUserName = [[NSMutableArray alloc] init];
    self.tempPhoneNum = [[NSMutableArray alloc] init];
    self.tempTJJJYJLSH = [[NSMutableArray alloc] init];
    self.cellNum = 0;
    
    
    _switchcount=0;  //初始化按键为0
       //退件交接 页面 一加载 就要调用这个接口
    
    if ([Utility netState]) {
             NSDictionary *dic;
        
        
        
        dic = [[NSDictionary alloc]initWithObjectsAndKeys:jgbh, @"V_JGBH",@"4",@"C_YJZT",nil];  //站点退回的状态
        
    //    NSLog(@"444[111%@]\n",dic);
    //    NSLog(@"555[111%@]\n",dic.JSONString);
        NSString *getxmldata51=[Webconn Xmlappend:dic.JSONString params:@"getPostInfo" params1:@"http://service.search.gnzq.com" params2:@"PostService"];    //调用自定义方法  传入 方法名 命名空间   url
        
        
        
        //@"http://192.168.201.110:7602/gnzqService/service/PostService"
        NSError *error51 = nil;
        NSData *data51 = [NSURLConnection sendSynchronousRequest:getxmldata51 returningResponse:nil error:&error51];
        if (data51 == nil) {
            NSLog(@"send request failed: %@", error51);
            // return nil;
        }
        
        NSString *response51 = [[NSString alloc] initWithData:data51 encoding:NSUTF8StringEncoding];
      //  NSLog(@"response: %@", response51);
        
        
        NSString *getdata51=[Webconn decodexml:response51];
        
        NSString *backremark51=[Webconn jsondecoderemark:getdata51];
   //     NSLog(@"lala返回的soap信息是：[%@]\n",backremark51);
        
        NSString *backresult51=[Webconn jsondecoderesult:getdata51];
   //     NSLog(@"lala1返回的soap信息是：[%@]\n",backresult51);
        
        
        
        
        if([backresult51 isEqualToString:@"F0"])
            
        {
            [HUD hide:YES];
            
            
            SBJsonParser *parser8 = [[SBJsonParser alloc] init];
            NSError *error8 = nil;
            NSMutableDictionary *jsonDic8 = [parser8 objectWithString:backremark51 error:&error8];
            NSMutableDictionary *dicUserInfo = [jsonDic8 objectForKey:@"rows"];
            
            
            NSString *nn9;
            NSString *nn10 ;
            NSString *nn11 ;
            NSString *nn12 ;
            NSString *nn13 ;
            
            for(NSMutableDictionary * member  in dicUserInfo)
            {
                nn9 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_JGBH"] description]];
                nn10 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_SJRDH"] description]];
                nn11 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_SJRXM"] description]];
                nn12 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_YJHM"] description]];
                nn13 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"V_YJLSH"] description]];
                
                
                
                NSString *yjhm = nn12;
                NSString *sjrxm = nn11;
                NSString *sjrdh = nn10;
                NSString *yjlsh = nn13;
               
                
                int exist = 0;
                
                if (exist == 0) {
                    self.cellNum++;
                    
                    [self.tempUserName addObject:sjrxm];
                    [self.tempPostNum addObject:yjhm];
                    [self.tempPhoneNum addObject:sjrdh];
                    [self.tempTJJJYJLSH addObject:yjlsh];
                    [self.isSelect addObject:@"NO"];
                    
                    
                    
                    
                }
                
                
                
                
            }
            
            [self.tableView reloadData];
        }
        
        //else if(!iSuc)
        else{
            
            
            [HUD hide:YES];
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该机构不存在未交接邮件" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
            
            
            
            
            
        }
        
      
    }
    
    
    
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.square = YES;
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex  //自定义代理类
{
    if (buttonIndex == 1) {
        NSString *lsrgh = ((UITextField *)alertView.containerView.subviews[2]).text;
        NSString *lsrmm = ((UITextField *)alertView.containerView.subviews[4]).text;
        
        if((lsrgh != nil)&& (lsrmm!= nil)){
            
            if ([Utility netState]) {
                HUD.labelText = @"上传信息中";
                [HUD show:YES];
                
                
                for (int i = 0; i < self.cellNum; i++) {
                    
               //     NSLog(@"111[%d][%d]",self.cellNum,i);
                    
                    
                    if ([self.isSelect[i] isEqualToString:@"YES"] || self.isSelectAll) {
                        
                        
                        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:jgbh, @"V_JGBH", sfdm, @"V_SFDM", self.tempTJJJYJLSH[i], @"V_YJLSH",lsrgh, @"V_LSYDH", lsrmm, @"V_LSYXM", nil];
                        
                        
                        
                        NSString *getxmldata41=[Webconn Xmlappend:dic.JSONString params:@"jjthPost" params1:@"http://service.search.gnzq.com" params2:@"PostService"];    //调用自定义方法  传入 方法名 命名空间   url
                        
                        
                        
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
           //             NSLog(@"lala返回的soap信息是：[%@]\n",backremark41);
                        
                        NSString *backresult41=[Webconn jsondecoderesult:getdata41];
           //             NSLog(@"lala1返回的soap信息是：[%@]\n",backresult41);
                        
                        
                        if([backresult41 isEqualToString:@"F0"])
                            
                        {
                            [HUD hide:YES];
                            
                            [self.tempPostNum removeObjectAtIndex:i];
                            [self.tempUserName removeObjectAtIndex:i];
                            [self.tempTJJJYJLSH removeObjectAtIndex:i];
                            [self.isSelect removeObjectAtIndex:i];
                            
                            self.cellNum--;
                            
                           
                            i=-1;
               //             NSLog(@"2222[%d][%d]",self.cellNum,i);   //33333333日志打印
                            
                            
                                          
                            
                        }
                        //else if(!iSuc)
                        else{
                            
                            
                            [HUD hide:YES];
                            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:backremark41 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alter show];
                            
                            
                            
                            
                        }
                        
                        
                    }
                  }  //ee
                
                [self.tableView reloadData];
                [HUD hide:YES];
            }
            
        }
        else{
            
            UIAlertView *lsyjjalert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"揽收员工姓名或者电话不可为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [lsyjjalert show];
            
        }
        
    }
    
    [alertView close];
}

- (IBAction)handOver:(id)sender {       //点击退件交接时候的 提示
    if ((_selectCount < 1)&&(_switchcount==0)) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择要退件交接的邮件" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    } else {
        CustomIOSAlertView* cusAlert = [[CustomIOSAlertView alloc] init];
        [cusAlert setContainerView:[self createDemoView]];
        [cusAlert setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
        
        cusAlert.delegate = self;
        [cusAlert show];
    }
    
}

#pragma mark -
//弹出窗口界面设计
- (UIView *)createDemoView      //弹出界面的提示输入框
{
    UIView *demoView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
    UILabel *titleLabel =    [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 270, 21)];
    titleLabel.textColor = [UIColor orangeColor];
    titleLabel.text = @"交接信息";
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 36, 270, 21)];
    lable1.text = @"揽收员工姓名";
    
    UITextField *userNameTextField  = [[UITextField alloc] initWithFrame:CGRectMake(10, 61, 270, 23)];
    userNameTextField.placeholder = @"请输入姓名";
    userNameTextField.delegate=self;
    [userNameTextField  setBorderStyle:UITextBorderStyleRoundedRect];
    
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 87, 270, 21)];
    lable2.text = @"揽收员工电话";
    
    UITextField *pwdTextField  = [[UITextField alloc] initWithFrame:CGRectMake(10, 113, 270, 23)];
    pwdTextField.placeholder = @"请输员工电话";
    pwdTextField.delegate=self;
    [pwdTextField  setBorderStyle:UITextBorderStyleRoundedRect];
    
    UIColor *color = [[UIColor alloc] initWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
    demoView.backgroundColor = color;
    titleLabel.backgroundColor = color;
    lable1.backgroundColor = color;
    userNameTextField.backgroundColor = color;
    lable2.backgroundColor = color;
    pwdTextField.backgroundColor = color;
    
    [demoView addSubview:titleLabel];
    [demoView addSubview:lable1];
    [demoView addSubview:userNameTextField];
    [demoView addSubview:lable2];
    [demoView addSubview:pwdTextField];
    return demoView;
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"threeLineCell";
    
    CustomThreeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    //如何解决 cell 被重用以及重新加载时 样式也被重用  实现正常的多选返回
    //由于每一个cell在加载的时候都会调用这个函数  因此 每一次加载的时候都去进行一个调用 获取对应数组的 位置的属性 如果是符合 就将样式改成所要的 这是最正确的做法
    //关键在于  每一次都要调用 以及 indexPath.row 就代表每一次的 cell 位置  和数组关联  当然数组要事先维护好对应的值 只需要在点击的时候对数组进行添加即可
    BOOL isLiked = [[self.isSelect objectAtIndex:indexPath.row] boolValue];
    if (isLiked) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    
    
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
    UITableViewCell *tempCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if(tempCell.accessoryType == UITableViewCellAccessoryNone) {
        tempCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.isSelect replaceObjectAtIndex:indexPath.row withObject:@"YES"];     //如何 进行是否被选择的判断  如果点击下去 样式没有则进行选中 并且改变成为yes
        _selectCount++;                                                           //这里是进行多选的判断
    } else {
        tempCell.accessoryType = UITableViewCellAccessoryNone;
        [self.isSelect replaceObjectAtIndex:indexPath.row withObject:@"NO"];
        _selectCount--;
    }
}

- (IBAction)tableViewCellSelectAll:(id)sender {          //这个是全选的按钮
    if (self.selectAllSwitch.isOn) {
        
        _switchcount=1;
        NSArray *cellArray = [self.tableView visibleCells];
        for (UITableViewCell *cell in cellArray) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            // for(int first=0;first <[])
            
            
        }
        self.isSelectAll = YES;
        
     //   NSLog(@"[%d]\n",_switchcount);
        
    } else {
        
        _switchcount=0; 
        NSArray *cellArray = [self.tableView visibleCells];
        for (UITableViewCell *cell in cellArray) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        self.isSelectAll = NO;
    }
    
}

//收起键盘
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
