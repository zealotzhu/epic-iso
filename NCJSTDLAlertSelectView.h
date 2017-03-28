//
//  NCJSTDLAlertSelectView.h
//  EPostPickUpByCustomer2
//
//  Created by 张文臻 on 16/10/9.
//  Copyright © 2016年 gotop. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    NCJSTDLButtonClickCancel = 0,
    NCJSTDLButtonClickConfirm = 1,
    
}NCJSTDLButtonClickType;

typedef void  (^NCJSTDLbuttonClick)(NCJSTDLButtonClickType type);


@interface NCJSTDLAlertSelectView : UIView

@property (nonatomic, strong) UIButton *sjjBtn;     //收寄局按钮
@property (nonatomic, strong) UIButton *jdjBtn;     //寄达局按钮
@property (nonatomic, strong) UIButton *cxlxBtn;    //查询类型按钮
@property (nonatomic, strong) UIButton *yjzlBtn;    //邮件种类按钮
@property (nonatomic, strong) UITextField *timeTF;  //日期输入框
@property (nonatomic, strong) UITextField *nexttimeTF;  //日期输入框

@property (nonatomic, strong) NSMutableDictionary *yjzlDic;   //邮件种类数字字典
@property (nonatomic, strong) NSDictionary *cxlxDic;          //查询类型字典
@property (nonatomic, strong) NSDictionary *zxjDic;           //中心局字典(机构名称:机构编号)





@property (nonatomic, strong) NSMutableDictionary *sjjrememberarray;   //记忆回传的数组
@property (nonatomic, strong) NSMutableDictionary *jdjrememberarray;   //记忆回传的数组
@property (nonatomic, strong) NSMutableDictionary *cxlxrememberarray;   //记忆回传的数组
@property (nonatomic, strong) NSMutableDictionary *yjzlrememberarray;   //记忆回传的数组


- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title;
- (void)NCJSTDLclick:(NCJSTDLbuttonClick) block;
- (void)show;
- (void)hide;
@end
