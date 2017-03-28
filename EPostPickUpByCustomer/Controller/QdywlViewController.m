//
//  HzcxViewController.m
//  EPostPickUpByCustomer
//
//  Created by user on 15-11-9.
//  Copyright (c) 2015年 gotop. All rights reserved.
//

#import "Utility.h"
#import "QdywlViewController.h"
#import "InputToolBar.h"
#import "Customsixlinecell.h"

//#import "CustomThreeLineCell.h"


#import "CommonFunc.h"
#import "md5.h"
#import "SBJson.h"
#import "webconn.h"



@interface QdywlViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MBProgressHUDDelegate, InputToolBarDelegate> {
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


//@"渠道商",@"来件数", @"取件数", @"退回数", @"自行处理数",@"结存数
@property (nonatomic, strong) NSMutableArray *qds;
@property (nonatomic, strong) NSMutableArray *ljs;
@property (nonatomic, strong) NSMutableArray *qjs;
@property (nonatomic, strong) NSMutableArray *ths;
@property (nonatomic, strong) NSMutableArray *zxcls;
@property (nonatomic, strong) NSMutableArray *jcs;

@property (nonatomic, assign) int cellNum;


@end

@implementation QdywlViewController

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
    self.title = @"渠道业务量查询";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    
    self.cellNum = 0;
    self.qds  = [[NSMutableArray alloc] init];
    self.ljs = [[NSMutableArray alloc] init];
    self.qjs = [[NSMutableArray alloc] init];
    self.ths  = [[NSMutableArray alloc] init];
    self.zxcls = [[NSMutableArray alloc] init];
    self.jcs = [[NSMutableArray alloc] init];
    self.tableView.rowHeight = 125;
    //   [self.tableView setHidden:YES];
    
    
    
    
    self.btnNum = 0;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    NSString *dateStr = [self stringFromDate:[NSDate date]];
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
    
    
    
    if (self.cellNum != 0) {
        self.cellNum = 0;
        [self.qds removeAllObjects];
        [self.ljs removeAllObjects];
        [self.qjs removeAllObjects];
        [self.ths removeAllObjects];
        [self.zxcls removeAllObjects];
        [self.jcs removeAllObjects];
        [self.tableView reloadData];
    }

    
    
    if ([Utility netState]) {
        NSDictionary *sDic = [[NSDictionary alloc] initWithObjectsAndKeys:jgbh, @"V_JGBH", self.startDate.text, @"V_STARTTIME", self.endDate.text, @"V_ENDTIME", nil];
        NSString *url = [Utility urlWithMethod:@"statistics" params:sDic.JSONString];
        HUD.labelText = @"查询信息中";
        [HUD show:YES];
        
        
        
        NSString *getxmldata2=[Webconn Xmlappend:sDic.JSONString params:@"qdywltj" params1:@"http://service.search.gnzq.com" params2:@"PostService"];    //调用自定义方法  传入 方法名 命名空间   url
        
        //@"http://192.168.201.110:7602/gnzqService/service/PostService"
        
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:getxmldata2 returningResponse:nil error:&error];
        if (data == nil) {
            NSLog(@"send request failed: %@", error);
            // return nil;
        }
        
        NSString *response2 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    NSLog(@"response: %@", response2);
        
        
        NSString *getdata2=[Webconn decodexml:response2];
        
        NSString *backremark2=[Webconn jsondecoderemark:getdata2];
  //      NSLog(@"lala返回的soap信息是：[%@]\n",backremark2);
        
        NSString *backresult2=[Webconn jsondecoderesult:getdata2];
 //       NSLog(@"lala1返回的soap信息是：[%@]\n",backresult2);
        
        
        
        
        if([backresult2 isEqualToString:@"F0"])
            
        {
            [HUD hide:YES];
            
            
            SBJsonParser *parser8 = [[SBJsonParser alloc] init];
            NSError *error8 = nil;
            NSMutableDictionary *jsonDic8 = [parser8 objectWithString:backremark2 error:&error8];//获取根节点 只需要获取一次
            NSMutableDictionary *dicUserInfo = [jsonDic8 objectForKey:@"rows"];    //找到对应的根节点
            
            
            NSString *nn9;
            NSString *nn10 ;
            NSString *nn11 ;
            NSString *nn12 ;
            NSString *nn13 ;
            NSString *nn14 ;
            
            for(NSMutableDictionary * member  in dicUserInfo)
            {
                nn9 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"QDS"] description]];  //如果有多个相似的 json 要使用循环连续获取
                nn10 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"ZXCLS"] description]];
                nn11 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"LJS"] description]];
                nn12 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"JYS"] description]];
                nn13 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"TJS"] description]];
                nn14 = [NSString stringWithFormat:@"%@",[[member objectForKey:@"QJS"] description]];
                
                
       //         NSLog(@"111111111222233\n[%@]\n[%@]\n[%@]\n[%@]\n[%@]\n[%@]",nn9,nn10,nn11,nn12,nn13,nn14);
                
                
                
                
                [self.qds addObject:nn9];
                [self.ljs addObject:nn11];
                [self.qjs addObject:nn14];
                [self.ths addObject:nn13];
                [self.zxcls addObject:nn10];
                [self.jcs addObject:nn12];
                self.cellNum++;
                
            }
            
            [self.tableView reloadData];
            
            
            
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
    
    
    return self.cellNum;      
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {   //自定义显示格式
    
    
    static NSString *cellIdentifier = @"sixlinecell";
    
    Customsixlinecell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell) {
        cell = [Customsixlinecell Customsixlinecell];
    }
      
    //@"渠道商",@"来件数", @"取件数", @"退回数", @"自行处理数",@"结存数
    
    cell.numLabel.text= [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    cell.postLabel.text = [NSString stringWithFormat:@"渠道商：%@",  self.qds[indexPath.row]];
    cell.nameLabel.text = [NSString stringWithFormat:@"来件数：%@",self.ljs[indexPath.row]];
    cell.phoneLabel.text = [NSString stringWithFormat:@"取件数：%@", self.qjs[indexPath.row]];
    cell.the4Label.text= [NSString stringWithFormat:@"退回数：%@", self.ths[indexPath.row]];
    cell.the5Label.text = [NSString stringWithFormat:@"自行处理数：%@", self.zxcls[indexPath.row]];
    cell.the6Label.text = [NSString stringWithFormat:@"结存数：%@", self.jcs[indexPath.row]];
    
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
