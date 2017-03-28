//
//  YwlchangeviewViewController.m
//  EPostPickUpByCustomer
//
//  Created by lzb on 16/7/20.
//  Copyright © 2016年 gotop. All rights reserved.
//

#import "YwlchangeviewViewController.h"
#import "Utility.h"

@interface YwlchangeviewViewController ()



@property (weak, nonatomic) IBOutlet UILabel *wlywl;
@property (weak, nonatomic) IBOutlet UILabel *dtywl;
@property (weak, nonatomic) IBOutlet UILabel *qdywl;

@property (weak, nonatomic) IBOutlet UILabel *shywl;

@end

@implementation YwlchangeviewViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"业务量查询";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.view.frame.size.height > 480.0f) {
        [self adjustLayout];
    }
}


-(void)adjustLayout{
    
    _qdywl.font = [UIFont systemFontOfSize:fonsize];
    _shywl.font = [UIFont systemFontOfSize:fonsize];
    _wlywl.font = [UIFont systemFontOfSize:fonsize];
    _dtywl.font = [UIFont systemFontOfSize:fonsize];
    
    
    
    
    
}

- (IBAction)dtywl:(id)sender {
    
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"dtywl"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

- (IBAction)wlgsywl:(id)sender {
    
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"wlgsywl"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}



- (IBAction)qdywl:(id)sender {
    
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"qdywl"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}



- (IBAction)shywl:(id)sender {
    
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"hzcx"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}













/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
