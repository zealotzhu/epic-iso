//
//  CustomThreeLineCell.m
//  EPostPickUpByCustomer
//
//  Created by user on 15/12/3.
//  Copyright © 2015年 gotop. All rights reserved.
//

#import "CustomThreeLineCell.h"

@implementation CustomThreeLineCell

+(instancetype)customThreeLineCell {
    CustomThreeLineCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"CustomThreeLineCell" owner:nil options:nil]lastObject];
    return cell;
}
@end
