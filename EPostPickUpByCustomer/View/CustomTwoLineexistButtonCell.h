//
//  CustomTwoLineWithButtonCell.h
//  EPostPickUpByCustomer
//
//  Created by user on 15/12/15.
//  Copyright © 2015年 gotop. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CellButtonActionDelegate <NSObject>

@optional
- (void)buttonAction : (NSString *)index;

@end
@interface CustomTwoLineexistButtonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (nonatomic, assign) id <CellButtonActionDelegate> actionDelegate;

+ (instancetype)customTwoLineexistButtonCell;
@end
