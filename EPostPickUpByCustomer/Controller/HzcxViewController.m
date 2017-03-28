//
//  HzcxViewController.m
//  EPostPickUpByCustomer
//
//  Created by user on 15-11-9.
//  Copyright (c) 2015年 gotop. All rights reserved.
//

#import "Utility.h"
#import "HzcxViewController.h"
#import "HzmxViewController.h"
#import "InputToolBar.h"



#import "CommonFunc.h"
#import "md5.h"
#import "SBJson.h"
#import "webconn.h"



@interface HzcxViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MBProgressHUDDelegate, InputToolBarDelegate> {
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;
// 界面调整
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBtnHeight;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (nonatomic, assign) int btnNum;
@property (nonatomic, strong) NSArray *titleArray;
@property (strong, nonatomic) NSArray *numArray;
@end

@implementation HzcxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ini];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_searchBtn.layer setMasksToBounds:YES];
    [_searchBtn.layer setCornerRadius:5.0f];
    if (self.view.frame.size.height > 480.0f) {
        [self adjustLayout];
    }
}

- (void)adjustLayout {
    _dateLabel.font = [UIFont systemFontOfSize:fonsize];
    _startDate.font = [UIFont systemFontOfSize:fonsize];
    _endDate.font = [UIFont systemFontOfSize:fonsize];
    _searchBtn.titleLabel.font = [UIFont systemFontOfSize:fonsize];
    _searchBtnHeight.constant = _CONSTANT_;
    [self.view layoutIfNeeded];
}


- (void) ini{
    self.title = @"商户业务量查询";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    self.btnNum = 0;
    self.titleArray = [[NSArray alloc] initWithObjects:@"来件数量", @"用户已取", @"退回数量", @"留存数量", @"自行处理数",@"拒签数量",nil];
    //self.numArray = [[NSArray alloc] initWithObjects:@"0", @"0", @"0", @"0", nil];
    
    self.numArray = [[NSArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0",@"0",nil];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setHidden:YES];
    
    //如何获取当前日期的前一天的时间
    NSTimeInterval secondsPerDay1 = 24*60*60;
    NSDate *now = [NSDate date];
    NSDate *yesterDay = [now addTimeInterval:-secondsPerDay1];
    
    
    NSString *dateStr = [self stringFromDate:yesterDay];
    self.startDate.text = dateStr;
    self.endDate.text = dateStr;
    
    _datePicker = [[UIDatePicker alloc]init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh"];
    
    self.startDate.inputView = _datePicker;
    self.endDate.inputView = _datePicker;
    
    InputToolBar *toolBar1 = [InputToolBar inputToolBarWithTag:1];
    InputToolBar *toolBar2 = [InputToolBar inputToolBarWithTag:2];
    self.startDate.tag = 1;
    self.endDate.tag = 2;
    
    toolBar1.toolBarDelegate = self;
    toolBar2.toolBarDelegate = self;
    self.startDate.delegate = self;
    self.endDate.delegate = self;
    self.startDate.inputAccessoryView = toolBar1;
    self.endDate.inputAccessoryView = toolBar2;
    
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.square = YES;
}


- (IBAction)search:(id)sender {
    if ([Utility netState]) {
        NSDictionary *sDic = [[NSDictionary alloc] initWithObjectsAndKeys:jgbh, @"V_JGBH", self.startDate.text, @"V_STARTTIME", self.endDate.text, @"V_ENDTIME", nil];
        NSString *url = [Utility urlWithMethod:@"statistics" params:sDic.JSONString];
        HUD.labelText = @"查询信息中";
        [HUD show:YES];
        
        
        NSString *getxmldata2=[Webconn Xmlappend:sDic.JSONString params:@"ztdpd" params1:@"http://service.search.gnzq.com" params2:@"PostService"];    //调用自定义方法  传入 方法名 命名空间   url
        
        //@"http://192.168.201.110:7602/gnzqService/service/PostService"
        
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:getxmldata2 returningResponse:nil error:&error];
        if (data == nil) {
            NSLog(@"send request failed: %@", error);
            // return nil;
        }
        
        NSString *response2 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
      //  NSLog(@"response: %@", response2);
        
        NSString *getdata2=[Webconn decodexml:response2];
        
        NSString *backremark2=[Webconn jsondecoderemark:getdata2];
    //    NSLog(@"lala返回的soap信息是：[%@]\n",backremark2);
        
        NSString *backresult2=[Webconn jsondecoderesult:getdata2];
   //     NSLog(@"lala1返回的soap信息是：[%@]\n",backresult2);
        
        
        
        
        if([backresult2 isEqualToString:@"F0"])
            
        {
            [HUD hide:YES];
            
            
            
            SBJsonParser *parser2 = [[SBJsonParser alloc] init];
            NSError *error2 = nil;
            NSMutableDictionary *jsonDic2 = [parser2 objectWithString:backremark2 error:&error2];//获取根节点 只需要获取一次
            
            NSDictionary *dic11 = (NSDictionary*)jsonDic2;
            
            self.numArray = [[NSArray alloc] initWithObjects:[dic11 objectForKey:@"N_SQJCS"], [dic11 objectForKey:@"N_ZXCLS"], [dic11 objectForKey:@"N_JCS"], [dic11 objectForKey:@"N_LJS"],[dic11 objectForKey:@"N_QJS"],[dic11 objectForKey:@"N_THS"], nil];
            [self.tableView reloadData];
            [self.tableView setHidden:NO];
            
            
            
        }
        //else if(!iSuc)
        else{
            
            
            
            [HUD hide:YES];
            
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:backremark2 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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


- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return [dateStr copy];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        self.datePicker.maximumDate = [self dateFromString:_endDate.text];
        self.datePicker.minimumDate = [self dateFromString:@"1900-01-01"];
    } else {
        self.datePicker.minimumDate = [self dateFromString:_startDate.text];
        //        self.datePicker.maximumDate = [self dateFromString:@"2999-12-31"];
        self.datePicker.maximumDate = [NSDate date];
    }
}

//收起键盘
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)toolBarItemAction:(BOOL)isDone iTag:(int)iTag{
    [self.startDate endEditing:YES];
    [self.endDate endEditing:YES];
    if (isDone) {
        NSString *dateStr = [self stringFromDate:self.datePicker.date];
        if (iTag == 1) {
            self.startDate.text = dateStr;
        } else {
            self.endDate.text = dateStr;
        }
        
    }
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 4;
    
    
    return 6;  
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {   //自定义显示格式
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UIColor* color=[[UIColor alloc]initWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1];
    cell.backgroundColor=color;  // 设置cell背景颜色
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton; //不需要样式
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@", self.titleArray[indexPath.row], self.numArray[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /* if (((NSString *)self.numArray[indexPath.row]).intValue != 0) {
     NSArray *array = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%d",(int)indexPath.row+1], self.startDate.text, self.endDate.text, nil];
     UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
     HzmxViewController *hzmxVC = [sb instantiateViewControllerWithIdentifier:@"hzmx"];
     hzmxVC.paramArray = array;
     
     [self.navigationController pushViewController:hzmxVC animated:YES];
     }*/
    
}

@end
