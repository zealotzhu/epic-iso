//
//  CustomTwoLineWithButtonCell.m
//  EPostPickUpByCustomer
//
//  Created by user on 15/12/15.
//  Copyright © 2015年 gotop. All rights reserved.
//

#import "CustomTwoLineexistButtonCell.h"

@implementation CustomTwoLineexistButtonCell

+ (instancetype)customTwoLineexistButtonCell {
    CustomTwoLineexistButtonCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"CustomTwoLineexistButtonCell" owner:nil options:nil]lastObject];
    return cell;
}


- (IBAction)edit:(id)sender {
    if ([self.actionDelegate respondsToSelector:@selector(buttonAction:)]) {
        
        [self.actionDelegate buttonAction:self.numLabel.text];
    }
}

@end
