//
//  CustomTwoLineWithButtonCell.m
//  EPostPickUpByCustomer
//
//  Created by user on 15/12/15.
//  Copyright © 2015年 gotop. All rights reserved.
//

#import "CustomTwoLineWithButtonCell.h"

@implementation CustomTwoLineWithButtonCell

+ (instancetype)customTwoLineWithButtonCell {
    CustomTwoLineWithButtonCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"CustomTwoLineWithButtonCell" owner:nil options:nil]lastObject];
    return cell;
}


- (IBAction)edit:(id)sender {
    if ([self.actionDelegate respondsToSelector:@selector(buttonAction:)]) {
        
        [self.actionDelegate buttonAction:self.numLabel.text];
    }
}

@end
