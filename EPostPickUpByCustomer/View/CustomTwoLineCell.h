//
//  CustomTwoLineCell.h
//  EPostPickUpByCustomer
//
//  Created by user on 15/12/2.
//  Copyright © 2015年 gotop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTwoLineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

+(instancetype)customTwoLineCell;
@end
