//
//  MenuViewController.m
//  EPostPickUpByCustomer
//
//  Created by user on 15/12/10.
//  Copyright © 2015年 gotop. All rights reserved.
//

#import "MenuViewController.h"
#import "Utility.h"

#import "YWLTJAlertSelectView.h"
#import "YWLTJViewController.h"

#import "CSTTLViewController.h"
#import "CSTTLAlertSelectView.h"

#import "NCJSTDLViewController.h"
#import "NCJSTDLAlertSelectView.h"

#import "SSXXFKLViewController.h"
#import "SSXXFKLAlertSelectView.h"

#import "YWLYJYGViewController.h"

#import "ZDCSTTLViewController.h"

#import "TDTXLViewController.h"

#define angle2radian(x) ((x) / 180.0 * M_PI)


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenheighth [UIScreen mainScreen].bounds.size.height


@interface MenuViewController ()//<pubrecvdelegate>
@property (weak, nonatomic) IBOutlet UILabel *yhqjLabel;
@property (weak, nonatomic) IBOutlet UILabel *tjdjLabel;
@property (weak, nonatomic) IBOutlet UILabel *hztjLabel;
@property (weak, nonatomic) IBOutlet UILabel *lsyjcxLabel;
@property (weak, nonatomic) IBOutlet UILabel *dxcfLabel;
@property (weak, nonatomic) IBOutlet UILabel *ljdjLabel;
@property (weak, nonatomic) IBOutlet UILabel *dtyjLabel;
@property (weak, nonatomic) IBOutlet UILabel *tdtxllabel;

@property (weak, nonatomic) IBOutlet UIButton *ywltj;
@property (weak, nonatomic) IBOutlet UIButton *ywlyjyg;
@property (weak, nonatomic) IBOutlet UIButton *csttl;
@property (weak, nonatomic) IBOutlet UIButton *ncjstdl;

@property (weak, nonatomic) IBOutlet UIButton *ssxxfkl;
@property (weak, nonatomic) IBOutlet UIButton *zdcsttl;
@property (weak, nonatomic) IBOutlet UIButton *tdwq;

@property (weak, nonatomic) IBOutlet UIButton *tdtxl;


//创建按键对应的字典


//ywltj
@property (nonatomic, strong) NSDictionary *ywltjcxlxDic;  //业务量统计查询类型

//csttl
@property (nonatomic, strong) NSDictionary *csttlcxlxDic;  //城市妥投率查询类型

//ncjstdl
@property (nonatomic, strong) NSDictionary *ncjstdlcxlxDic;  //城市妥投率查询类型

//ssxxfkl
@property (nonatomic, strong) NSDictionary *ssxxfklcxlxDic;  //城市妥投率查询类型


@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投递管家";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:148/255.0 green:165/255.0 blue:199/255.0 alpha:1.0]];//更改全局的导航栏颜色
    self.navigationController.navigationBar.translucent= NO; //将按钮设置为 半透明  即可实现 显示栏不被改变
    self.view.backgroundColor=[UIColor colorWithRed:107/255.0 green:121/255.0 blue:181/255.0 alpha:1.0];
    
    [self Dicsetkeyvalue];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.view.frame.size.height > 480.0f) {
       // [self adjustLayout];
    }
}

- (void)adjustLayout {
    _ljdjLabel.font = [UIFont systemFontOfSize:fonsize];
    _yhqjLabel.font = [UIFont systemFontOfSize:fonsize];
    _tjdjLabel.font = [UIFont systemFontOfSize:fonsize];
    _hztjLabel.font = [UIFont systemFontOfSize:fonsize];
    _lsyjcxLabel.font = [UIFont systemFontOfSize:fonsize];
    _dxcfLabel.font = [UIFont systemFontOfSize:fonsize];
    _dtyjLabel.font = [UIFont systemFontOfSize:fonsize];
}

-(void)Dicsetkeyvalue{

    //创建字典属性
    self.ywltjcxlxDic = @{@"1.快递包裹（邮政）":@"1", @"2.快递包裹（速递）":@"2", @"3.标准快递":@"3",@"4.约投挂号":@"4",@"5.快递包裹（邮政＋速递）":@"5"};

    self.csttlcxlxDic = @{@"1.快递包裹（邮政）":@"1", @"2.快递包裹（速递）":@"2", @"3.标准快递":@"3",@"4.约投挂号":@"4",@"5.快递包裹（邮政＋速递）":@"5"};
    
     self.ncjstdlcxlxDic = @{@"1.快递包裹（邮政）":@"1", @"2.快递包裹（速递）":@"2", @"3.标准快递":@"3",@"4.约投挂号":@"4",@"5.快递包裹（邮政＋速递）":@"5"};
    
    self.ssxxfklcxlxDic = @{@"1.快递包裹（邮政）":@"1", @"2.快递包裹（速递）":@"2", @"3.标准快递":@"3",@"4.约投挂号":@"4",@"5.快递包裹（邮政＋速递）":@"5"};
    

}

//touchdown 按钮抖动
- (IBAction)ywltjtouchdown:(id)sender {
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@(angle2radian(-8)), @(angle2radian(8)), @(angle2radian(-8))];
    anim.duration = 0.1;
    // 动画次数设置为最大
    anim.repeatCount = 10;
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = YES;
    anim.fillMode = kCAFillModeForwards;
    
    [self.ywltj.layer addAnimation:anim forKey:@"shake"];

    
}
- (IBAction)ywlyjygtouchdown:(id)sender {
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@(angle2radian(-8)), @(angle2radian(8)), @(angle2radian(-8))];
    anim.duration = 0.1;
    // 动画次数设置为最大
    anim.repeatCount = 10;
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = YES;
    anim.fillMode = kCAFillModeForwards;
    
    [self.ywlyjyg.layer addAnimation:anim forKey:@"shake"];

}
- (IBAction)csttltouchdown:(id)sender {
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@(angle2radian(-8)), @(angle2radian(8)), @(angle2radian(-8))];
    anim.duration = 0.1;
    // 动画次数设置为最大
    anim.repeatCount = 10;
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = YES;
    anim.fillMode = kCAFillModeForwards;
    
    [self.csttl.layer addAnimation:anim forKey:@"shake"];

}
- (IBAction)ncjsttltouchdown:(id)sender {
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@(angle2radian(-8)), @(angle2radian(8)), @(angle2radian(-8))];
    anim.duration = 0.1;
    // 动画次数设置为最大
    anim.repeatCount = 10;
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = YES;
    anim.fillMode = kCAFillModeForwards;
    
    [self.ncjstdl.layer addAnimation:anim forKey:@"shake"];

}
- (IBAction)ssxxfkltouchdown:(id)sender {
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@(angle2radian(-8)), @(angle2radian(8)), @(angle2radian(-8))];
    anim.duration = 0.1;
    // 动画次数设置为最大
    anim.repeatCount = 10;
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = YES;
    anim.fillMode = kCAFillModeForwards;
    
    [self.ssxxfkl.layer addAnimation:anim forKey:@"shake"];

}
- (IBAction)zdcsttltouchdown:(id)sender {
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@(angle2radian(-8)), @(angle2radian(8)), @(angle2radian(-8))];
    anim.duration = 0.1;
    // 动画次数设置为最大
    anim.repeatCount = 10;
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = YES;
    anim.fillMode = kCAFillModeForwards;
    
    [self.zdcsttl.layer addAnimation:anim forKey:@"shake"];

}
- (IBAction)tdwqtouchdown:(id)sender {
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@(angle2radian(-8)), @(angle2radian(8)), @(angle2radian(-8))];
    anim.duration = 0.1;
    // 动画次数设置为最大
    anim.repeatCount = 10;
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = YES;
    anim.fillMode = kCAFillModeForwards;
    
    [self.tdwq.layer addAnimation:anim forKey:@"shake"];

}

- (IBAction)tdtxltouchdown:(id)sender {
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@(angle2radian(-8)), @(angle2radian(8)), @(angle2radian(-8))];
    anim.duration = 0.1;
    // 动画次数设置为最大
    anim.repeatCount = 10;
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = YES;
    anim.fillMode = kCAFillModeForwards;
    
    [self.tdtxl.layer addAnimation:anim forKey:@"shake"];

}

-(void)backanimation{
sleep(1.8);

//  /  / ///////////////////////////   对于动画的叠加特效  ////////////////////////////////////////////
//首先进行 父界面 抽走的效果
CATransition *animation1 = [CATransition animation];
animation1.delegate = self;
animation1.duration = 2.0f; //动画时长
animation1.timingFunction = UIViewAnimationCurveEaseInOut;
animation1.fillMode = kCAFillModeForwards;
animation1.type = @"suckEffect"; //过度效果
// animation1.subtype = @"formBottom"; //过渡方向
animation1.startProgress = 0.0; //动画开始起点(在整体动画的百分比)
animation1.endProgress = 1.0;  //动画停止终点(在整体动画的百分比)
animation1.removedOnCompletion = NO;

[self.view.layer addAnimation:animation1 forKey:@"animation1"];  //滴水效果 第三方库


//  /  / ///////////////////////////   对于动画的叠加特效 结束 ////////////////////////////////////////////
}



//touchdown 按钮抖动结束


//真正按钮的触发事件如下
- (IBAction)ljdj:(id)sender {
    
    [self backanimation];
    
    
    YWLTJAlertSelectView *popview =[[YWLTJAlertSelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheighth) withTitle:@" 业务量统计:"];
    //popview.zxjDic = self.zxjDic;   //这个先后顺序很重要
    [popview show];
    
//    YWLTJViewController *svc = [[YWLTJViewController alloc]init];
//    [svc parseRecvData];
    
    [popview click:^(ButtonClickType type)
     {
         if (type == ButtonClickCancel)  //按取消按钮
         {
             [popview hide];
         }
         if (type == ButtonClickConfirm)   //按确定按钮
         {
             
             
             
             /*
             if(([popview.sjjBtn.titleLabel.text isEqualToString:@"未选择"])&&([popview.jdjBtn.titleLabel.text isEqualToString:@"未选择"])){
                 
                 
                 tipsView * tips = [[tipsView alloc]init];
                 tips.tipsLable.text = @"收寄局和寄达局不能同时为空";
                 [tips show];
                 tips.center = CGPointMake(SCREEN_W*0.5, 330);
                 
                 
             }
             
             else{
                 
                */
             
                 [popview hide];//先关闭视图 然后再推送到另一个界面
                 
                 
                 
           
             
             
             
             YWLTJViewController *svc = [[YWLTJViewController alloc]initWithNibName:@"YWLTJViewController" bundle:nil];

             
             
             svc.ywltjV_JGBH = self.V_JGBH;
             svc.ywltjV_JB =self.V_JB;
             svc.ywltjV_LX =self.ywltjcxlxDic[popview.yjzlBtn.titleLabel.text];
             
             svc.ywltjV_DATEBEGIN =popview.timeTF.text;
             svc.ywltjV_DATEEND =popview.nexttimeTF.text;
             
             //   NSString *sjj=popview.sjjBtn.titleLabel.text;
//                 NSString *jdj=popview.jdjBtn.titleLabel.text;    //传进来的都是名称
//                 NSString *insertyjzl=popview.yjzlBtn.titleLabel.text;
//                 NSString *insertcxlx=popview.cxlxBtn.titleLabel.text;    //传进来的都是名称
//                 svc.getsjzxj=_zxjDic[sjj];   //这里是获取对应的编号
//                 svc.getjdzxj=_zxjDic[jdj];
//                 svc.getyjzl=_yjzlDic[insertyjzl];
//                 svc.getcxlx=_cxlxDic[insertcxlx];
//                 svc.getdate=popview.timeTF.text;
//                 svc.getssjgbh=self.getSSJGBH[0];
//                 svc.getssjb=self.getjGJB[0];
                // */
                 
             NSLog(@"业务量统计各个值的传入为[%@][%@][%@][%@][%@]",svc.ywltjV_JGBH,svc.ywltjV_JB,svc.ywltjV_LX,svc.ywltjV_DATEBEGIN,svc.ywltjV_DATEEND);
             
                //由管理着当前 ViewController 的上面的导航控制器负责推出 下一个 ViewController 界面
                 [self.navigationController pushViewController:svc animated:YES];
                 
                 
             }
         }
     //}
     
     ];

    
    
//    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ljdj"];
//    
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)yhqj:(id)sender {
    [self backanimation];
    
    
     YWLYJYGViewController *VC = [[YWLYJYGViewController alloc]initWithNibName:@"YWLYJYGViewController" bundle:nil];
    
    
    VC.ywlyjygV_YGXM = self.V_YGXM;
    VC.ywlyjygV_JGBH =self.V_JGBH;
    VC.ywlyjygV_JGMC =self.V_JGMC;
    VC.ywlyjygV_JB  =self.V_JB;
    
     [self.navigationController pushViewController:VC animated:YES];
    
//    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"yhqj"];
//    
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)tjdj:(id)sender {
    
    [self backanimation];
    
    
    CSTTLAlertSelectView *popview =[[CSTTLAlertSelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheighth) withTitle:@" 城市妥投率:"];
    //popview.zxjDic = self.zxjDic;   //这个先后顺序很重要
    [popview show];
    
    
    [popview CSTTLclick:^(CSTTLButtonClickType type)
     {
         if (type == CSTTLButtonClickCancel)  //按取消按钮
         {
             [popview hide];
         }
         if (type == CSTTLButtonClickConfirm)   //按确定按钮
         {
             
             
             
             /*
              if(([popview.sjjBtn.titleLabel.text isEqualToString:@"未选择"])&&([popview.jdjBtn.titleLabel.text isEqualToString:@"未选择"])){
              
              
              tipsView * tips = [[tipsView alloc]init];
              tips.tipsLable.text = @"收寄局和寄达局不能同时为空";
              [tips show];
              tips.center = CGPointMake(SCREEN_W*0.5, 330);
              
              
              }
              
              else{
              
              */
             
             [popview hide];//先关闭视图 然后再推送到另一个界面
             
             
             
             // /*
             CSTTLViewController *svc = [[CSTTLViewController alloc]initWithNibName:@"CSTTLViewController" bundle:nil];
             
             
             
             svc.csttlV_JGBH = self.V_JGBH;
             svc.csttlV_JB =self.V_JB;
             svc.csttlV_LX =self.csttlcxlxDic[popview.yjzlBtn.titleLabel.text];
             
             svc.csttlV_DATEBEGIN =popview.timeTF.text;
             svc.csttlV_DATEEND =popview.nexttimeTF.text;
             
             //   NSString *sjj=popview.sjjBtn.titleLabel.text;
             //                 NSString *jdj=popview.jdjBtn.titleLabel.text;    //传进来的都是名称
             //                 NSString *insertyjzl=popview.yjzlBtn.titleLabel.text;
             //                 NSString *insertcxlx=popview.cxlxBtn.titleLabel.text;    //传进来的都是名称
             //                 svc.getsjzxj=_zxjDic[sjj];   //这里是获取对应的编号
             //                 svc.getjdzxj=_zxjDic[jdj];
             //                 svc.getyjzl=_yjzlDic[insertyjzl];
             //                 svc.getcxlx=_cxlxDic[insertcxlx];
             //                 svc.getdate=popview.timeTF.text;
             //                 svc.getssjgbh=self.getSSJGBH[0];
             //                 svc.getssjb=self.getjGJB[0];
             // */
             
             NSLog(@"业务量统计各个值的传入为[%@][%@][%@][%@][%@]",svc.csttlV_JGBH,svc.csttlV_JB,svc.csttlV_LX,svc.csttlV_DATEBEGIN,svc.csttlV_DATEEND);
             
             //由管理着当前 ViewController 的上面的导航控制器负责推出 下一个 ViewController 界面
             [self.navigationController pushViewController:svc animated:YES];
             
         }
     }
     //}
     
     ];

    
    
    
//    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"tjdj"];
//    
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)hztj:(id)sender {
    
    [self backanimation];
    
    
    

    
    
    NCJSTDLAlertSelectView *popview =[[NCJSTDLAlertSelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheighth) withTitle:@" 农村及时投递率:"];
    //popview.zxjDic = self.zxjDic;   //这个先后顺序很重要
    [popview show];
    
    
    [popview NCJSTDLclick:^(NCJSTDLButtonClickType type)
     {
         if (type == NCJSTDLButtonClickCancel)  //按取消按钮
         {
             [popview hide];
         }
         if (type == NCJSTDLButtonClickConfirm)   //按确定按钮
         {
             
             
             
             /*
              if(([popview.sjjBtn.titleLabel.text isEqualToString:@"未选择"])&&([popview.jdjBtn.titleLabel.text isEqualToString:@"未选择"])){
              
              
              tipsView * tips = [[tipsView alloc]init];
              tips.tipsLable.text = @"收寄局和寄达局不能同时为空";
              [tips show];
              tips.center = CGPointMake(SCREEN_W*0.5, 330);
              
              
              }
              
              else{
              
              */
             
             [popview hide];//先关闭视图 然后再推送到另一个界面
             
             
             
             // /*
             NCJSTDLViewController *svc = [[NCJSTDLViewController alloc]initWithNibName:@"NCJSTDLViewController" bundle:nil];
             
             
             svc.ncjstdlV_JGBH = self.V_JGBH;
             svc.ncjstdlV_JB =self.V_JB;
             svc.ncjstdlV_LX =self.ncjstdlcxlxDic[popview.yjzlBtn.titleLabel.text];
             
             svc.ncjstdlV_DATEBEGIN =popview.timeTF.text;
             svc.ncjstdlV_DATEEND =popview.nexttimeTF.text;
             
             //   NSString *sjj=popview.sjjBtn.titleLabel.text;
             //                 NSString *jdj=popview.jdjBtn.titleLabel.text;    //传进来的都是名称
             //                 NSString *insertyjzl=popview.yjzlBtn.titleLabel.text;
             //                 NSString *insertcxlx=popview.cxlxBtn.titleLabel.text;    //传进来的都是名称
             //                 svc.getsjzxj=_zxjDic[sjj];   //这里是获取对应的编号
             //                 svc.getjdzxj=_zxjDic[jdj];
             //                 svc.getyjzl=_yjzlDic[insertyjzl];
             //                 svc.getcxlx=_cxlxDic[insertcxlx];
             //                 svc.getdate=popview.timeTF.text;
             //                 svc.getssjgbh=self.getSSJGBH[0];
             //                 svc.getssjb=self.getjGJB[0];
             // */
             
             NSLog(@"业务量统计各个值的传入为[%@][%@][%@][%@][%@]",svc.ncjstdlV_JGBH,svc.ncjstdlV_JB,svc.ncjstdlV_LX,svc.ncjstdlV_DATEBEGIN,svc.ncjstdlV_DATEEND);
             
             //由管理着当前 ViewController 的上面的导航控制器负责推出 下一个 ViewController 界面
             [self.navigationController pushViewController:svc animated:YES];

             
             
         }
     }
     //}
     
     ];

    
    
//    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    
//    
//    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ywlchangeview"];
//    
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)lsyjcx:(id)sender {
    
    [self backanimation];
    
    
    SSXXFKLAlertSelectView *popview =[[SSXXFKLAlertSelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheighth) withTitle:@" 实时信息反馈率:"];
    //popview.zxjDic = self.zxjDic;   //这个先后顺序很重要
    [popview show];
    
    

    
    [popview SSXXFKLclick:^(SSXXFKLButtonClickType type)
     {
         if (type == SSXXFKLButtonClickCancel)  //按取消按钮
         {
             [popview hide];
         }
         if (type == SSXXFKLButtonClickConfirm)   //按确定按钮
         {
             
             
             
             /*
              if(([popview.sjjBtn.titleLabel.text isEqualToString:@"未选择"])&&([popview.jdjBtn.titleLabel.text isEqualToString:@"未选择"])){
              
              
              tipsView * tips = [[tipsView alloc]init];
              tips.tipsLable.text = @"收寄局和寄达局不能同时为空";
              [tips show];
              tips.center = CGPointMake(SCREEN_W*0.5, 330);
              
              
              }
              
              else{
              
              */
             
             [popview hide];//先关闭视图 然后再推送到另一个界面
             
             
             
             // /*
             SSXXFKLViewController *svc = [[SSXXFKLViewController alloc]initWithNibName:@"SSXXFKLViewController" bundle:nil];
             
             svc.ssxxfklV_JGBH = self.V_JGBH;
             svc.ssxxfklV_JB =self.V_JB;
             svc.ssxxfklV_LX =self.ssxxfklcxlxDic[popview.yjzlBtn.titleLabel.text];
             
             svc.ssxxfklV_DATEBEGIN =popview.timeTF.text;
             svc.ssxxfklV_DATEEND =popview.nexttimeTF.text;
             
             //   NSString *sjj=popview.sjjBtn.titleLabel.text;
             //                 NSString *jdj=popview.jdjBtn.titleLabel.text;    //传进来的都是名称
             //                 NSString *insertyjzl=popview.yjzlBtn.titleLabel.text;
             //                 NSString *insertcxlx=popview.cxlxBtn.titleLabel.text;    //传进来的都是名称
             //                 svc.getsjzxj=_zxjDic[sjj];   //这里是获取对应的编号
             //                 svc.getjdzxj=_zxjDic[jdj];
             //                 svc.getyjzl=_yjzlDic[insertyjzl];
             //                 svc.getcxlx=_cxlxDic[insertcxlx];
             //                 svc.getdate=popview.timeTF.text;
             //                 svc.getssjgbh=self.getSSJGBH[0];
             //                 svc.getssjb=self.getjGJB[0];
             // */
             
             NSLog(@"业务量统计各个值的传入为[%@][%@][%@][%@][%@]",svc.ssxxfklV_JGBH,svc.ssxxfklV_JB,svc.ssxxfklV_LX,svc.ssxxfklV_DATEBEGIN,svc.ssxxfklV_DATEEND);
             
             //由管理着当前 ViewController 的上面的导航控制器负责推出 下一个 ViewController 界面
             [self.navigationController pushViewController:svc animated:YES];

             
         }
     }
     //}
     
     ];

    
    
    
//    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"lsyjcx"];
//    
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)dxcf:(id)sender {
    
    [self backanimation];
    
    ZDCSTTLViewController *svc = [[ZDCSTTLViewController alloc]initWithNibName:@"ZDCSTTLViewController" bundle:nil];
    [self.navigationController pushViewController:svc animated:YES];
    
    
//    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"dxcf"];
//    
//    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)dtyj:(id)sender {
    
    [self backanimation];
    
//    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"dtyj"];
//    
//    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (IBAction)tdtxl:(id)sender {
    
    [self backanimation];
    
    TDTXLViewController *svc = [[TDTXLViewController alloc]initWithNibName:@"TDTXLViewController" bundle:nil];
    [self.navigationController pushViewController:svc animated:YES];
    
}


@end
