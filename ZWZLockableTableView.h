//
//  ZWZLockableTableView.h
//  测试表格视图
//
//  Created by 张文臻 on 17/1/7.
//  Copyright © 2017年 gotop. All rights reserved.
//

#import <UIKit/UIKit.h>


//定义block
typedef void (^ReturnBlock)(id returnValue);


@interface ZWZLockableTableView : UIView


@property (nonatomic, assign) CGFloat cellWidth;                //表格cell的宽度（ 默认100 ）
@property (nonatomic, assign) CGFloat cellHeight;               //表格cell的高度（ 默认35 ）


//初始化方法
//注意：传入数组的格式：@[  数组1（存上栏锁定栏的各个标题，如果标题有子标题，那么字典：@{父标题：@[子标题,子标题,子标题...]}） ，数组2（数组,数组...） ]

- (instancetype)initWithFrame:(CGRect)frame
                    dataArray:(NSMutableArray *)dataArray;

//显示方法
- (void)showFromSuperView:(UIView *)superView;

//回调方法
- (void)returnSelectItem:(ReturnBlock)item;


@end
