//
//  DtyjViewController.m
//  EPostPickUpByCustomer
//
//  Created by lzb on 16/7/27.
//  Copyright © 2016年 gotop. All rights reserved.
//

#import "DtyjViewController.h"


#import "Utility.h"
@interface DtyjViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dtljdjLabel;
@property (weak, nonatomic) IBOutlet UILabel *dttjdjLabel;
@property (weak, nonatomic) IBOutlet UILabel *dtyjttLabel;

@end

@implementation DtyjViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"代投邮件处理";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.view.frame.size.height > 480.0f) {
        [self adjustLayout];
    }
}


- (void)adjustLayout {
    _dtljdjLabel.font = [UIFont systemFontOfSize:fonsize];
    _dttjdjLabel.font = [UIFont systemFontOfSize:fonsize];
    _dtyjttLabel.font = [UIFont systemFontOfSize:fonsize];
   
}

- (IBAction)dtljdj:(id)sender {
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"dtljdj"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)dttjdj:(id)sender {
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"dttjdj"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)dtyjtt:(id)sender {
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"dtyjtt"];
    
    [self.navigationController pushViewController:vc animated:YES];
}



@end

