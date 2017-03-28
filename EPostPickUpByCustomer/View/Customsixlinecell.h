//
//  customsixlinecell.h
//  EPostPickUpByCustomer
//
//  Created by lzb on 16/7/20.
//  Copyright © 2016年 gotop. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface Customsixlinecell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *postLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *the4Label;


@property (weak, nonatomic) IBOutlet UILabel *the5Label;

@property (weak, nonatomic) IBOutlet UILabel *the6Label;


+ (instancetype)Customsixlinecell;
@end
