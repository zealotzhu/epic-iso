//
//  SSXXFKLAlertSelectView.m
//  EPostPickUpByCustomer2
//
//  Created by 张文臻 on 16/10/9.
//  Copyright © 2016年 gotop. All rights reserved.
//

#import "SSXXFKLAlertSelectView.h"
#import "CustomPopOverView.h"
//#import "MyProgressHUD.h"
#import "UIView+RippleAnimation.h"

#define MaskColor [UIColor colorWithWhite:0.000 alpha:0.400]
#define ButtonMaskColor [UIColor colorWithRed:34.0/255.0 green:127.0/255.0 blue:244.0/255.0 alpha:0.3];  //23.0/255.0 green:132.0/255.0 blue:233.0/255.0 alpha:0.3];   //点击按钮时候的四散开来的颜色

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height

#define AlertView_Width    300   //弹出视图的宽度
#define Margin    20   // 内容视图各个控件上下之间的间距

#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface SSXXFKLAlertSelectView() <CustomPopOverViewDelegate,UITextFieldDelegate,CAAnimationDelegate>

@property(nonatomic ,strong) UIView *alertView;


@property (nonatomic, copy) SSXXFKLbuttonClick block;
@property (nonatomic, strong) NSArray *titles;   //跳出选择视图选项数组,如：_titles = @[@"1.全部类型", @"2.快递包裹", @"3.标准特快",];



//************  下面5个属性要声明为公开属性（在.h文件中声明），为了回调（点击确定按钮）可以获取这些属性的值*********************************

//@property (nonatomic,strong) UIButton *sjjBtn; //收寄局按钮
//@property (nonatomic, strong) UIButton *jdjBtn; //寄达局按钮
//@property (nonatomic, strong) UIButton *cxlxBtn; //查询类型按钮
//@property (nonatomic, strong) UIButton *yjzlBtn; //邮件种类按钮
//@property (nonatomic, strong) UITextField *timeTF;  //日期输入框

@property (nonatomic, strong) UIButton *changePlaceBtn; //收寄局寄达局交换按钮

@property (strong, nonatomic) CustomPopOverView *datePickerView; //时间选择器视图
@property (strong, nonatomic) UIDatePicker *datePicker;  //时间选择器
@property (strong, nonatomic) UIToolbar *datePickerToolBar;  //时间选择器上的确定取消选择条

@property (nonatomic, assign) NSInteger flag;   //标志符，用于判断是什么按钮跳出视图


@property (strong, nonatomic) CustomPopOverView *sjjview;
@property (strong, nonatomic) CustomPopOverView *jdjview;
@property (strong, nonatomic) CustomPopOverView *cxlxview;
@property (strong, nonatomic) CustomPopOverView *yjzlview;



@end


@implementation SSXXFKLAlertSelectView

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = frame;
        self.backgroundColor = MaskColor;
        
        [self addAlertWithTitle:title];
        
    }
    return self;
}

- (void)addAlertWithTitle:(NSString *)title
{
    UIView *alertView = [[UIView alloc]init];
    
    
    //UIColor *colorback = [[UIColor alloc] initWithRed:34.0/255.0 green:127.0/255.0 blue:244.0/255.0 alpha:1.0];
    //UIColor *colorback = [UIColor colorWithRed:9.0/255.0 green:140.0/255.0 blue:1.0/255.0 alpha:1.0];
    UIColor *colorback =[[UIColor alloc] initWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
    
    UIColor *colortitle=[[UIColor alloc] initWithRed:34.0/255.0 green:127.0/255.0 blue:244.0/255.0 alpha:1.0];
    
    //UIColor *colorbutton = [[UIColor alloc] initWithRed:208.0/255.0 green:208.0/255.0 blue:225.0/255.0 alpha:1.0];
    UIColor *colorbutton = [UIColor whiteColor];
    UIColor *colorinbutton = [[UIColor alloc] initWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
    
    
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, AlertView_Width, 40)];//(20, 5, AlertView_Width-2*20, 40)
    titleLabel.text = title;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.backgroundColor = colortitle;
    titleLabel.font=[UIFont boldSystemFontOfSize:22];
    titleLabel.layer.masksToBounds = YES;
    //titleLabel.layer.cornerRadius = 10.0;
    [alertView addSubview:titleLabel];
    
    /*
    //线1
    CGFloat lineOne_Y = 38;//5+40+5;
    UIView *lineOne = [[UIView alloc]initWithFrame:CGRectMake(0, lineOne_Y, AlertView_Width, 2.0f)];
    lineOne.backgroundColor = [UIColor whiteColor];
    [alertView addSubview:lineOne];
    */
    
    //******************************************************************************************************
    
    
    //内容视图
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, AlertView_Width, 250)];  //(15, 62, 270, 220)
    //    contentView.backgroundColor = RGBColor(242.0, 242.0, 242.0);
    contentView.backgroundColor = [UIColor whiteColor];
    
    
    
    UIImage *dateimage = [UIImage imageNamed:@"datapick.png"];
    // UIImage *dateimage = [UIImage imageNamed:@"icon_xiala.png"];
    UIImageView *dateimageview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 60, 60)];//使图片适应整个视图窗
    dateimageview.image = dateimage;
    [contentView addSubview:dateimageview];
    
    //日期输入框
    _timeTF = [[UITextField alloc]initWithFrame:CGRectMake(75, 20-3, 230-70, 40)];
    //(Margin, 40+Margin, 270-2*Margin, 40)
    
    
    //UIImageView *timeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"datapick.png"]];
    //timeImage.frame = CGRectMake(5, 5, 45, 30);
    //_timeTF.leftView = timeImage;
    _timeTF.backgroundColor=  [UIColor whiteColor];
    _timeTF.leftViewMode = UITextFieldViewModeAlways;
    _timeTF.layer.borderWidth = 2.0;
    _timeTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //_timeTF.layer.cornerRadius = 5.0;
    
    NSTimeInterval PerDay1 = 24*60*60*7;
    NSDate *getnow = [NSDate date];
    NSDate *yesterDay = [getnow addTimeInterval:-PerDay1];
    
    NSDate *today = yesterDay;  //获取系统时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *todayTime = [formatter stringFromDate:today];
    _timeTF.text = todayTime;
    _timeTF.textAlignment = NSTextAlignmentCenter;
    _timeTF.textColor=colortitle;
    _timeTF.delegate = self;
    
    [contentView addSubview:_timeTF];

    
    
    //如何获取当前日期的前一礼拜的时间
    
    UIImage *dateimage1 = [UIImage imageNamed:@"datapick.png"];
    // UIImage *dateimage = [UIImage imageNamed:@"icon_xiala.png"];
    UIImageView *dateimageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 60, 60, 60)];//使图片适应整个视图窗
    dateimageview1.image = dateimage1;
    [contentView addSubview:dateimageview1];
    
    //日期输入框
    _nexttimeTF = [[UITextField alloc]initWithFrame:CGRectMake(75, 20-3+60, 230-70, 40)];
    //(Margin, 40+Margin, 270-2*Margin, 40)
    
    
    //UIImageView *timeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"datapick.png"]];
    //timeImage.frame = CGRectMake(5, 5, 45, 30);
    //_timeTF.leftView = timeImage;
    _nexttimeTF.backgroundColor=  [UIColor whiteColor];
    _nexttimeTF.leftViewMode = UITextFieldViewModeAlways;
    _nexttimeTF.layer.borderWidth = 2.0;
    _nexttimeTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    NSTimeInterval secondsPerDay1 = 24*60*60*1;
    NSDate *now = [NSDate date];
    NSDate *getyesterDay = [now addTimeInterval:-secondsPerDay1];
    
    NSDate *beforetoday = getyesterDay;  //获取系统时间
    NSDateFormatter *beforeformatter = [[NSDateFormatter alloc]init];
    beforeformatter.dateFormat = @"yyyy-MM-dd";
    NSString *beforetodayTime = [beforeformatter stringFromDate:beforetoday];
    _nexttimeTF.text = beforetodayTime;
    _nexttimeTF.textAlignment = NSTextAlignmentCenter;
    _nexttimeTF.textColor=colortitle;
    _nexttimeTF.delegate = self;
    
    [contentView addSubview:_nexttimeTF];

    
    
    
    
    //收寄局标签
    UILabel *cxlxLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10+60+60, 270-2*Margin, 30)];//(20, 5, AlertView_Width-2*20, 40)
    cxlxLabel.text = @" 查询类型 :";
    cxlxLabel.textColor=colortitle;
    cxlxLabel.textAlignment = NSTextAlignmentLeft;
    cxlxLabel.backgroundColor = [UIColor clearColor];
    cxlxLabel.font=[UIFont boldSystemFontOfSize:20];
    cxlxLabel.layer.masksToBounds = YES;
    [contentView addSubview:cxlxLabel];

    
    //邮件种类按钮
    _yjzlBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 10+60+60+30+5, AlertView_Width-10, 40)];
    _yjzlBtn.backgroundColor = [[UIColor alloc] initWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
    [_yjzlBtn setImage:[UIImage imageNamed:@"ArrowDown"] forState:UIControlStateNormal];
    _yjzlBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 250, 6, 6);
    [_yjzlBtn setTitle:@"5.快递包裹（邮政＋速递）" forState:UIControlStateNormal];
    _yjzlBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _yjzlBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    [_yjzlBtn setTitleColor:colortitle forState:UIControlStateNormal];
    [_yjzlBtn addTarget:self action:@selector(showYJZLView:) forControlEvents:UIControlEventTouchUpInside];
    _yjzlBtn.layer.cornerRadius = 5.0;
    _yjzlBtn.layer.borderWidth = 1.0;
    _yjzlBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _yjzlBtn.rippleAnimationEnable = YES;  //添加遮盖动画
    _yjzlBtn.rippleLayerColor = ButtonMaskColor;
    _yjzlBtn.type = LQRippleAnimationTypeCenter;
//    UILabel *yjzlLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
//    yjzlLabel.text = @"邮件种类:";
//    yjzlLabel.textAlignment = NSTextAlignmentCenter;
//    yjzlLabel.font = [UIFont boldSystemFontOfSize:18];
//    yjzlLabel.backgroundColor = colorinbutton;
//    yjzlLabel.textColor  = colorback;
//    [_yjzlBtn addSubview:yjzlLabel];
    
    [contentView addSubview:_yjzlBtn];

    
    
    /*
    //收寄局按钮
    _sjjBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sjjBtn.frame = CGRectMake(5, 90, AlertView_Width-10, 40);  //(0, 0, 100, 40)
    
    _sjjBtn.backgroundColor = colorinbutton;
    [_sjjBtn setImage:[UIImage imageNamed:@"ArrowDown"] forState:UIControlStateNormal];
    [_sjjBtn setTitle:@"未选择" forState:UIControlStateNormal];
    _sjjBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 250, 6, 6);
    _sjjBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    _sjjBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [_sjjBtn setTitleColor:colorback forState:UIControlStateNormal];
    //_sjjBtn.layer.cornerRadius = 5.0;
    _sjjBtn.layer.borderWidth = 1.0;
    _sjjBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_sjjBtn addTarget:self action:@selector(showSJJView:) forControlEvents:UIControlEventTouchUpInside];
    
    _sjjBtn.rippleAnimationEnable = YES;  //添加遮盖动画
    _sjjBtn.rippleLayerColor = ButtonMaskColor;
    _sjjBtn.type = LQRippleAnimationTypeCenter;
    
    [contentView addSubview:_sjjBtn];
    */
    
    
    /*
    //两地交换按钮
    _changePlaceBtn = [[UIButton alloc]initWithFrame:CGRectMake(117, 2, 36, 36)];
    [_changePlaceBtn setImage:[UIImage imageNamed:@"two-way selection"] forState:UIControlStateNormal];
    [_changePlaceBtn addTarget:self action:@selector(changePlace:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_changePlaceBtn];
    */
    
    
    
    /*
    //寄达局标签
    UILabel *jdjLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,130+2, 270-2*Margin, 30)];//(20, 5, AlertView_Width-2*20, 40)
    jdjLabel.text = @" 寄达局 :";
    jdjLabel.textColor=[UIColor whiteColor];
    jdjLabel.textAlignment = NSTextAlignmentLeft;
    jdjLabel.backgroundColor = [UIColor clearColor];
    jdjLabel.font=[UIFont boldSystemFontOfSize:20];
    jdjLabel.layer.masksToBounds = YES;
    [contentView addSubview:jdjLabel];
    
    
    
    //寄达局按钮
    _jdjBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 160, AlertView_Width-10, 40)];//(170, 0, 100, 40)
    _jdjBtn.backgroundColor = colorinbutton;
    [_jdjBtn setImage:[UIImage imageNamed:@"ArrowDown"] forState:UIControlStateNormal];
    [_jdjBtn setTitle:@"未选择" forState:UIControlStateNormal];
    _jdjBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 250, 6, 6);
    _jdjBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    _jdjBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [_jdjBtn setTitleColor:colorback forState:UIControlStateNormal];
   // _jdjBtn.layer.cornerRadius = 5.0;
    _jdjBtn.layer.borderWidth = 1.0;
    _jdjBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_jdjBtn addTarget:self action:@selector(showJDJView:) forControlEvents:UIControlEventTouchUpInside];
    _jdjBtn.rippleAnimationEnable = YES;  //添加遮盖动画
    _jdjBtn.rippleLayerColor = ButtonMaskColor;
    _jdjBtn.type = LQRippleAnimationTypeCenter;
    [contentView addSubview:_jdjBtn];
    */
    
    
    
    /*
    //查询类型按钮
    _cxlxBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 200 + 20, AlertView_Width-10, 40)];//(20, 2*40+2*Margin, 230, 40)
    _cxlxBtn.backgroundColor = colorinbutton;
    [_cxlxBtn setImage:[UIImage imageNamed:@"ArrowDown"] forState:UIControlStateNormal];
    _cxlxBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 250, 6, 6);
    [_cxlxBtn setTitle:@"全网" forState:UIControlStateNormal];
    _cxlxBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _cxlxBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);  ///(0, -25, 0, 0);
    [_cxlxBtn setTitleColor:colorback forState:UIControlStateNormal];
    [_cxlxBtn addTarget:self action:@selector(showCXLXView:) forControlEvents:UIControlEventTouchUpInside];
   // _cxlxBtn.layer.cornerRadius = 5.0;
    _cxlxBtn.layer.borderWidth = 1.0;
    _cxlxBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _cxlxBtn.rippleAnimationEnable = YES;  //添加遮盖动画
    _cxlxBtn.rippleLayerColor = ButtonMaskColor;
    _cxlxBtn.type = LQRippleAnimationTypeCenter;
    UILabel *cxlxLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    cxlxLabel.text = @"查询类型:";
    cxlxLabel.textAlignment = NSTextAlignmentCenter;
    cxlxLabel.font = [UIFont boldSystemFontOfSize:18];
    cxlxLabel.textColor = colorback;
    cxlxLabel.backgroundColor = colorinbutton;
    [_cxlxBtn addSubview:cxlxLabel];
    
    [contentView addSubview:_cxlxBtn];
    
    
    //邮件种类按钮
    _yjzlBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 240+ 40, AlertView_Width-10, 40)];
    _yjzlBtn.backgroundColor = colorinbutton;
    [_yjzlBtn setImage:[UIImage imageNamed:@"ArrowDown"] forState:UIControlStateNormal];
    _yjzlBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 250, 6, 6);
    [_yjzlBtn setTitle:@"全部类型" forState:UIControlStateNormal];
    _yjzlBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _yjzlBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [_yjzlBtn setTitleColor:colorback forState:UIControlStateNormal];
    [_yjzlBtn addTarget:self action:@selector(showYJZLView:) forControlEvents:UIControlEventTouchUpInside];
    //_yjzlBtn.layer.cornerRadius = 5.0;
    _yjzlBtn.layer.borderWidth = 1.0;
    _yjzlBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _yjzlBtn.rippleAnimationEnable = YES;  //添加遮盖动画
    _yjzlBtn.rippleLayerColor = ButtonMaskColor;
    _yjzlBtn.type = LQRippleAnimationTypeCenter;
    UILabel *yjzlLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    yjzlLabel.text = @"邮件种类:";
    yjzlLabel.textAlignment = NSTextAlignmentCenter;
    yjzlLabel.font = [UIFont boldSystemFontOfSize:18];
    yjzlLabel.backgroundColor = colorinbutton;
    yjzlLabel.textColor  = colorback;
    [_yjzlBtn addSubview:yjzlLabel];
    
    [contentView addSubview:_yjzlBtn];
    */
    
    
    [alertView addSubview:contentView];
    
    
    
    
    
    contentView.backgroundColor=colorback;
    alertView.backgroundColor=colorback;
    //******************************************************************************************************
    
    ///*
    //线2
    CGFloat lineTwo_Y = 15+contentView.frame.size.height;
    UIView *lineTwo = [[UIView alloc]initWithFrame:CGRectMake(0, lineTwo_Y, AlertView_Width, 1.5f)];
    lineTwo.backgroundColor = colortitle;
    [alertView addSubview:lineTwo];
    //*/
    
    
    //左边的取消
    
    CGFloat cancelBtn_Y = 30+contentView.frame.size.height;
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, cancelBtn_Y, 120, 40)];
    cancelBtn.backgroundColor = colorbutton;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(ClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:colortitle forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    cancelBtn.tag = SSXXFKLButtonClickCancel;
    cancelBtn.layer.cornerRadius = 10.0;
    cancelBtn.layer.borderWidth = 1.0;
    cancelBtn.layer.borderColor = colortitle.CGColor;
    cancelBtn.rippleAnimationEnable = YES;  //添加遮盖动画
    cancelBtn.rippleLayerColor = ButtonMaskColor;
    cancelBtn.type = LQRippleAnimationTypeCenter;
    [alertView addSubview:cancelBtn];
    
    
    //确认按钮
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(160, cancelBtn_Y, 120, 40)];
    confirmBtn.backgroundColor = colorbutton;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(ClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitleColor:colortitle forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [confirmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    confirmBtn.tag = SSXXFKLButtonClickConfirm;
    confirmBtn.layer.cornerRadius = 10.0;
    confirmBtn.layer.borderWidth = 1.0;
    confirmBtn.layer.borderColor = colortitle.CGColor;
    confirmBtn.rippleAnimationEnable = YES;  //添加遮盖动画
    confirmBtn.rippleLayerColor = ButtonMaskColor;
    confirmBtn.type = LQRippleAnimationTypeCenter;
    [alertView addSubview:confirmBtn];
    
    
    
    //初始化 alertView
    
    CGFloat alertView_H = 5+40+contentView.frame.size.height+40;
    CGFloat alertView_X = (SCREEN_WIDTH - AlertView_Width) * 0.5;
    CGFloat alertView_Y = (SCREENH_HEIGHT - alertView_H) * 0.5;
    
    alertView.frame = CGRectMake(alertView_X, alertView_Y, AlertView_Width, alertView_H);
    
    [self addSubview:alertView];
    
    
    self.alertView = alertView;
    //alertView.backgroundColor = [UIColor whiteColor];
    alertView.backgroundColor = colorback;
    
    alertView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    [UIView animateWithDuration:0.2 animations:^{
        
        alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    }];
    //alertView.layer.cornerRadius = 10.0;
    alertView.layer.borderWidth = 1.0;
    alertView.layer.borderColor = colorbutton.CGColor;
}

- (void)ClickButton:(UIButton *)btn
{
    //    [self hide];   //若执行这行代码，点击取消和确定按钮都会退去视图
    if (self.block)
    {
        self.block((int)btn.tag);
    }
    
}
- (void)hide
{
    [UIView animateWithDuration:0.3 animations:^
     {
         self.alpha = 0;
     } completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}

- (void)SSXXFKLclick:(SSXXFKLbuttonClick) block
{
    self.block = block;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGPoint startPoint = CGPointMake(SCREEN_WIDTH/2, -SCREENH_HEIGHT);
    //damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
    //velocity:弹性复位的速度
    self.alertView.layer.position = startPoint;
    [UIView animateWithDuration:1.0
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^
     {
         self.alertView.layer.position = self.center;
     }                completion:^(BOOL finished)
     {
         
     }];
    
    
    
    
    //self.yjzlview = [[CustomPopOverView alloc]initWithBounds:CGRectMake(0, 0, 150, 40*3) titleMenus:@[@"全部类型", @"快递包裹", @"标准特快"]];;
    self.yjzlview = [[CustomPopOverView alloc]initWithBounds:CGRectMake(0, 0, 230, 40*4) ];
    //self.yjzlview.containerBackgroudColor = [UIColor colorWithRed:1.0/255.0 green:123.0/255.0 blue:4.0/255.0 alpha:1.0];
    self.yjzlview.containerBackgroudColor = [UIColor colorWithRed:34.0/255.0 green:127.0/255.0 blue:244.0/255.0 alpha:1.0];
    self.yjzlview.delegate = self;
    self.yjzlview.getflag=_flag;
    
    
}

//******************************************************************************************************

//显示收寄局视图
- (void)showSJJView:(id)sender
{
    
    
    /*
     @property (nonatomic, strong) NSMutableDictionary *sjjrememberarray;   //记忆回传的数组
     @property (nonatomic, strong) NSMutableDictionary *jdjrememberarray;   //记忆回传的数组
     @property (nonatomic, strong) NSMutableDictionary *cxlxrememberarray;   //记忆回传的数组
     @property (nonatomic, strong) NSMutableDictionary *yjzlrememberarray;   //记忆回传的数组
     */
    
    
    //NSLog(@"111传到的数组[%@]",self.sjjrememberarray);
    
    _flag = 0;
    
    [_sjjBtn setImage:[UIImage imageNamed:@"ArrowUp"] forState:UIControlStateNormal];
    _sjjBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 250, 6, 6);
    
    
    _titles = [self.zxjDic allKeys];
    /*
    _titles = [self.zxjDic allKeys];
    
  
    CustomPopOverView *view = [[CustomPopOverView alloc]initWithBounds:CGRectMake(0, 0, 150, 40*5) titleMenus:_titles];;
    view.containerBackgroudColor = [UIColor colorWithRed:1.0/255.0 green:123.0/255.0 blue:4.0/255.0 alpha:1.0];
    view.delegate = self;
    view.getflag=_flag;
    [view showFrom:_sjjBtn alignStyle:CPAlignStyleCenter];
   
   */
    [self.sjjview showFrom:_sjjBtn alignStyle:CPAlignStyleCenter titleMenus:[self.zxjDic allKeys]] ;
    
}

//显示寄达局视图
- (void)showJDJView:(id)sender
{
    
  //  NSLog(@"222传到的数组[%@]",self.sjjrememberarray);
    
    
    _flag = 1;
    
    [_jdjBtn setImage:[UIImage imageNamed:@"ArrowUp"] forState:UIControlStateNormal];
    
    
    _titles = [self.zxjDic allKeys];
    /*
    _titles = [self.zxjDic allKeys];
    CustomPopOverView *view = [[CustomPopOverView alloc]initWithBounds:CGRectMake(0, 0, 150, 40*5) titleMenus:_titles];;
    view.containerBackgroudColor = [UIColor colorWithRed:1.0/255.0 green:123.0/255.0 blue:4.0/255.0 alpha:1.0];
    view.delegate = self;
     view.getflag=_flag;
    
     */
    
    [self.jdjview showFrom:_jdjBtn alignStyle:CPAlignStyleCenter titleMenus:[self.zxjDic allKeys]];
}

//显示查询类型视图
- (void)showCXLXView:(id)sender
{
    
    
    
   //  NSLog(@"333传到的数组[%@]",self.cxlxrememberarray);
    
    _flag = 2;
    [_cxlxBtn setImage:[UIImage imageNamed:@"ArrowUp"] forState:UIControlStateNormal];
    
    
    _titles = @[@"全网", @"邮政", @"速递"];
    /*
    _titles = @[@"全网", @"邮政", @"速递"];
    CustomPopOverView *view = [[CustomPopOverView alloc]initWithBounds:CGRectMake(0, 0, 150, 40*3) titleMenus:_titles];;
    view.containerBackgroudColor = [UIColor colorWithRed:1.0/255.0 green:123.0/255.0 blue:4.0/255.0 alpha:1.0];
    view.delegate = self;
     view.getflag=_flag;
    */
    
    [self.cxlxview showFrom:_cxlxBtn alignStyle:CPAlignStyleCenter titleMenus:@[@"全网", @"邮政", @"速递"]];
}
//显示邮件种类视图
- (void)showYJZLView:(id)sender
{
    
   // NSLog(@"444传到的数组[%@]",self.yjzlrememberarray);
    
    
    _flag = 3;
    [_yjzlBtn setImage:[UIImage imageNamed:@"ArrowUp"] forState:UIControlStateNormal];
   
    
    _titles = @[@"1.快递包裹（邮政）", @"2.快递包裹（速递）", @"3.标准快递",@"4.约投挂号",@"5.快递包裹（邮政＋速递）"];  //此处保留着是为了下面更加方便获取到点击的位置
    
    [self.yjzlview showFrom:_yjzlBtn alignStyle:CPAlignStyleCenter titleMenus:@[@"1.快递包裹（邮政）", @"2.快递包裹（速递）", @"3.标准快递",@"4.约投挂号",@"5.快递包裹（邮政＋速递）"]];
}


//显示时间选择器视图
- (void)showDatePickerView
{
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.view.frame = CGRectMake(0, 0, 230, 160);
    
    _datePickerToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 230, 35)];
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 35)];
    [_datePickerToolBar addSubview:btn1];
    
    UIButton *dateCancel = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 50, 35)];
    [dateCancel setTitle:@"取消" forState:UIControlStateNormal];
    [dateCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dateCancel addTarget:self action:@selector(toolBarCancel:) forControlEvents:UIControlEventTouchUpInside];
    [_datePickerToolBar addSubview:dateCancel];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(80, 0, 70, 35)];
    [_datePickerToolBar addSubview:btn2];
    
    UIButton *dateOK = [[UIButton alloc]initWithFrame:CGRectMake(150, 0, 50, 35)];
    [dateOK setTitle:@"确定" forState:UIControlStateNormal];
    [dateOK setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dateOK addTarget:self action:@selector(toolBarDone:) forControlEvents:UIControlEventTouchUpInside];
    [_datePickerToolBar addSubview:dateOK];
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(200, 0, 30, 35)];
    [_datePickerToolBar addSubview:btn3];
    
    [vc.view addSubview:_datePickerToolBar];
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 35, 230, 125)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh"];
    _datePicker.maximumDate = [NSDate date];//最大时间
    NSString *string = @"2014-01-01"; //最小时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *minDate = [formatter dateFromString:string];
    _datePicker.minimumDate = minDate;  //最小时间
    
    [vc.view addSubview:_datePicker];
    
    
    _datePickerView = [CustomPopOverView popOverView];
    _datePickerView.contentViewController = vc;
    [_datePickerView othershowFrom:_timeTF alignStyle:CPAlignStyleCenter];
}
//按时间选择器上的确定按钮
- (void)toolBarDone:(id)sender
{
    NSDate *date = self.datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    _timeTF.text = dateString;
    [_datePickerView dismiss];
}
//按时间选择器上的取消按钮
- (void)toolBarCancel:(id)sender
{
    [_datePickerView dismiss];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self showDatePickerView];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}


/*
 //两地互换地址
 - (void)changePlace:(id)sender
 {
 NSString *sjjStr = _sjjBtn.titleLabel.text;
 NSString *jdjStr = _jdjBtn.titleLabel.text;
 if ([_sjjBtn.titleLabel.text isEqual:@"收寄局"] || [_jdjBtn.titleLabel.text isEqual:@"寄达局"])
 {
 //跳出提醒框
 //  [MyProgressHUD showMessage:@"地址有空，不能互换!" inView:self]; //2秒后自动关闭
 }
 else
 {
 [_sjjBtn setTitle:jdjStr forState:UIControlStateNormal];
 [_jdjBtn setTitle:sjjStr forState:UIControlStateNormal];
 }
 }
 */





#pragma mark- CustomPopOverViewDelegate


- (void)popOverViewDidShow:(CustomPopOverView *)pView
{
    
}
- (void)popOverViewDidDismiss:(CustomPopOverView *)pView
{
    switch (_flag)  //视图消失把箭头改成向下
    {
            
        default:
            [_yjzlBtn setImage:[UIImage imageNamed:@"ArrowDown"] forState:UIControlStateNormal];
            break;
    }
    
}

- (void)popOverView:(CustomPopOverView *)pView didClickMenuIndex:(NSInteger)index
{
    NSLog(@"点击了: %@", _titles[index]);
    NSString *returnStr = _titles[index];//对点击跳出列表视图后做相应的处理（这里要把点击列表某行的数据显示在按钮上）
    switch (_flag)
    {
                default:
            [_yjzlBtn setTitle:returnStr forState:UIControlStateNormal];
            break;
    }
}



@end
