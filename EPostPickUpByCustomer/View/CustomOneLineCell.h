//
//  CustomOneLineCell.h
//  EPostPickUpByCustomer
//
//  Created by user on 15/12/2.
//  Copyright © 2015年 gotop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomOneLineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *onecellimageview;


+ (instancetype)customOneLineCell;
@end
