//
//  CustomTwoLineCell.m
//  EPostPickUpByCustomer
//
//  Created by user on 15/12/2.
//  Copyright © 2015年 gotop. All rights reserved.
//

#import "CustomTwoLineCell.h"

@implementation CustomTwoLineCell

+(instancetype)customTwoLineCell {
    CustomTwoLineCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"CustomTwoLineCell" owner:nil options:nil]lastObject];
    
    return cell;
}
@end
