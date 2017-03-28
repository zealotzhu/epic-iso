
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, CPAlignStyle)
{
    CPAlignStyleCenter,
    CPAlignStyleLeft,
    CPAlignStyleRight,
};


#define kTriangleHeight 8.0
#define kTriangleWidth 10.0
#define kPopOverLayerCornerRadius 5.0

@class CustomPopOverView;
@protocol CustomPopOverViewDelegate <NSObject>

@optional
- (void)popOverViewDidShow:(CustomPopOverView *)pView;
- (void)popOverViewDidDismiss:(CustomPopOverView *)pView;

- (void)popOverView:(CustomPopOverView *)pView didClickMenuIndex:(NSInteger)index;


@end


@interface CustomPopOverView : UIView


@property (nonatomic,   weak) id<CustomPopOverViewDelegate> delegate;


@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIViewController *contentViewController;

@property (nonatomic, assign) NSInteger getflag;   //标志符，用于判断是什么按钮跳出视图


@property (nonatomic, strong) UIColor *containerBackgroudColor;

+ (instancetype)popOverView;

//- (instancetype)initWithBounds:(CGRect)bounds titleMenus:(NSArray *)titles;
- (instancetype)initWithBounds:(CGRect)bounds ;

//- (void)showFrom:(UIView *)from alignStyle:(CPAlignStyle)style;
- (void)othershowFrom:(UIView *)from alignStyle:(CPAlignStyle)style;
- (void)showFrom:(UIView *)from alignStyle:(CPAlignStyle)style titleMenus:(NSArray *)titles;

- (void)dismiss;
@end
