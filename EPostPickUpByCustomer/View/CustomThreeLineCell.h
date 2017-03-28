//
//  CustomThreeLineCell.h
//  EPostPickUpByCustomer
//
//  Created by user on 15/12/3.
//  Copyright © 2015年 gotop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomThreeLineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *postNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;


+(instancetype)customThreeLineCell;
@end
