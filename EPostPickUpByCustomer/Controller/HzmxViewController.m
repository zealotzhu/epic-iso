//
//  HzmxViewController.m
//  EPostPickUpByCustomer
//
//  Created by user on 15-11-19.
//  Copyright (c) 2015年 gotop. All rights reserved.
//

#import "Utility.h"
#import "HzmxViewController.h"
#import "HzcxViewController.h"
#import "CustomTwoLineCell.h"



#import "CommonFunc.h"
#import "md5.h"
#import "SBJson.h"
#import "webconn.h"



@interface HzmxViewController () <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *userName;
@property (strong, nonatomic) NSMutableArray *phoneNum;
@property (strong, nonatomic) NSMutableArray *postNum;
@property (nonatomic, assign) int cellNum;
@end

@implementation HzmxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ini];
    [self updateCell:self.paramArray];
}

- (IBAction)back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
}


- (void)ini {
    self.title = @"汇总明细";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.userName = [[NSMutableArray alloc]init];
    self.postNum = [[NSMutableArray alloc]init];
    self.phoneNum = [[NSMutableArray alloc]init];
    
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.square = YES;
}

- (void)updateCell:(NSArray *)array {
    if ([Utility netState]) {
        self.cellNum = 0;
        NSString *yjtjbz = (NSString *)array[0];
        NSString *jkrq_b = (NSString *)array[1];
        NSString *jkrq_e = (NSString *)array[2];
        NSDictionary *sDic = [[NSDictionary alloc] initWithObjectsAndKeys:jgbh, @"JGBH", jkrq_b, @"JKRQ_B", jkrq_e, @"JKRQ_E", nil];
        
               
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
    return self.cellNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"twoLineCell";
    
    CustomTwoLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell) {
        cell = [CustomTwoLineCell customTwoLineCell];
    }
    cell.numLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
    cell.titleLabel.text = [NSString stringWithFormat:@"邮件号码：%@", self.postNum[indexPath.row]];
    cell.detailLabel.text = [NSString stringWithFormat:@"%@, %@", self.userName[indexPath.row], self.phoneNum[indexPath.row]];
    return cell;
}


#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
