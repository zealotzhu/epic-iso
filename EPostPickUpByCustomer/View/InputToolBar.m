//
//  InputToolBar.m
//  DatePickerViewInput
//
//  Created by user on 15/12/17.
//  Copyright © 2015年 gotop. All rights reserved.
//

#import "InputToolBar.h"

@interface InputToolBar ()
@property (nonatomic, assign) int iTag;

@end

@implementation InputToolBar

+ (instancetype)inputToolBarWithTag:(int)iTag {
    InputToolBar *toolBar = [[[NSBundle mainBundle]loadNibNamed:@"InputToolBar" owner:nil options:nil]lastObject];
    toolBar.iTag = iTag;
    return toolBar;
}

- (IBAction)cancel:(id)sender {
    if ([self.toolBarDelegate respondsToSelector:@selector(toolBarItemAction:iTag:)]) {
        [self.toolBarDelegate toolBarItemAction:NO iTag:_iTag];
    }
}

- (IBAction)done:(id)sender {
    if ([self.toolBarDelegate respondsToSelector:@selector(toolBarItemAction:iTag:)]) {
        [self.toolBarDelegate toolBarItemAction:YES iTag:_iTag];
    }
}

@end
