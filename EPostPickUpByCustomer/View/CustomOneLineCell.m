//
//  CustomOneLineCell.m
//  EPostPickUpByCustomer
//
//  Created by user on 15/12/2.
//  Copyright © 2015年 gotop. All rights reserved.
//

#import "CustomOneLineCell.h"

@implementation CustomOneLineCell


+(instancetype)customOneLineCell {
    CustomOneLineCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"CustomOneLineCell" owner:nil options:nil]lastObject];
    
    return cell;
}
@end
