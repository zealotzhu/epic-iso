//
//  InputToolBar.h
//  DatePickerViewInput
//
//  Created by user on 15/12/17.
//  Copyright © 2015年 gotop. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputToolBarDelegate <NSObject>

@optional
- (void)toolBarItemAction:(BOOL)isDone iTag:(int)iTag;

@end
@interface InputToolBar : UIToolbar

@property (nonatomic, weak) id <InputToolBarDelegate> toolBarDelegate;
+ (instancetype)inputToolBarWithTag:(int)tag;

@end
