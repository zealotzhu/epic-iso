//
//  ZWZLockableTableView.m
//  测试表格视图
//
//  Created by 张文臻 on 17/1/7.
//  Copyright © 2017年 gotop. All rights reserved.
//

#import "ZWZLockableTableView.h"




//颜色RGB
#define RGBColor(r, g, b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//随机色
#define RandomColor  RGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))





@interface LeftTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *serialNumberLabel;     //序号
@property (strong, nonatomic) UILabel *lockLabel;             //左侧锁定栏

@end


@implementation LeftTableViewCell

//重写cell的初始化方法
- (instancetype)initFrame:(CGRect)frame
                    style:(UITableViewCellStyle)style
          reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellEditingStyleNone; //设置列表点击没有灰亮
        
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        self.serialNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, height)];
        self.serialNumberLabel.textColor = [UIColor blackColor];
        self.serialNumberLabel.textAlignment = NSTextAlignmentCenter;
        self.serialNumberLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.serialNumberLabel];
        
        
        self.lockLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, width-50, height)];
        self.lockLabel.backgroundColor = RGBColor(246, 246, 246);
        self.lockLabel.textColor = [UIColor blackColor];
        self.lockLabel.textAlignment = NSTextAlignmentCenter;
        self.lockLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.lockLabel];
    }
    return self;
}



- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end


//********************************************************************************************************************

@interface RightTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;


@end


@implementation RightTableViewCell

//重写cell的初始化方法
- (instancetype)initFrame:(CGRect)frame
                    style:(UITableViewCellStyle)style
          reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellEditingStyleNone; //设置列表点击没有灰亮
        self.width = frame.size.width;
        self.height = frame.size.height;
    }
    return self;
}



//重写属性array的setter方法
- (void)setArray:(NSMutableArray *)array
{
    _array = array;
    
    NSUInteger count = array.count-1;
    CGFloat cellWidth = self.width/count;

    for (int i = 0; i < self.contentView.subviews.count; i++)
    {
        UIView *view = self.contentView.subviews[i];
        [view removeFromSuperview];
    }
    
    for (int i = 1; i < array.count; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( cellWidth*(i-1), 0, cellWidth, self.height )];
        NSString *str = array[i];
        label.text = str;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:label];
    }
    
}


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end


//********************************************************************************************************************










@interface ZWZLockableTableView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, copy) ReturnBlock returnBlock;                      //定义block属性
@property (nonatomic, strong) NSMutableArray *titlesArray;                //标题数组
@property (nonatomic, strong) NSMutableArray *detailTitlesArray;          //标题数组
@property (nonatomic, strong) NSMutableArray *dataArray;                  //数据数组
@property (nonatomic, strong) UITableView *leftTableView;                 //左侧列表视图
@property (nonatomic, strong) UITableView *rightTableView;                //右侧列表视图
@property (nonatomic, strong) UIScrollView *rightScrollView;              //右侧滚动视图
@property (nonatomic, strong) UIButton *gotoTopButton;                    //回到顶部按钮

@end


@implementation ZWZLockableTableView


//懒加载数组
- (NSMutableArray *)titlesArray
{
    if (!_titlesArray)
    {
        _titlesArray = [NSMutableArray array];
    }
    return _titlesArray;
}
//懒加载数组
- (NSMutableArray *)detailTitlesArray
{
    if (!_detailTitlesArray)
    {
        _detailTitlesArray = [NSMutableArray array];
    }
    return _detailTitlesArray;
}
//懒加载数组
- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


//懒加载左侧列表视图
- (UITableView *)leftTableView
{
    if (!_leftTableView)
    {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.separatorColor = [UIColor blackColor];
        [_leftTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _leftTableView.bounces = NO;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
    }
    return _leftTableView;
}

//懒加载右侧列表视图
- (UITableView *)rightTableView
{
    if (!_rightTableView)
    {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTableView.showsVerticalScrollIndicator = NO;
        _rightTableView.separatorColor = [UIColor blackColor];
        [_rightTableView setSeparatorInset:UIEdgeInsetsMake(0,-15,0,-15)];
        _rightTableView.bounces = NO;
        _rightTableView.tableFooterView = [UIView new];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
    }
    return _rightTableView;
}
//懒加载右侧滚动视图
- (UIScrollView *)rightScrollView
{
    if (!_rightScrollView)
    {
        _rightScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _rightScrollView.showsHorizontalScrollIndicator = NO;
        _rightScrollView.bounces = NO;
        _rightScrollView.delegate = self;
    }
    return _rightScrollView;
}

//初始化方法
- (instancetype)initWithFrame:(CGRect)frame
                    dataArray:(NSMutableArray *)dataArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titlesArray = [dataArray.firstObject mutableCopy];
        self.dataArray = [dataArray.lastObject mutableCopy];
        
        [self.titlesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                NSArray *valuesArray = [obj allValues];
                NSArray *array = valuesArray.firstObject;
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                 {
                     [self.detailTitlesArray addObject:obj];
                }];
            }
            
            else
            {
                [self.detailTitlesArray addObject:obj];
            }
        }];
    }
    return self;
}



//显示方法
- (void)showFromSuperView:(UIView *)superView
{
    _cellWidth = _cellWidth ? _cellWidth : 100;
    _cellHeight = _cellHeight ? _cellHeight : 35;
    
    self.leftTableView.frame = CGRectMake(0, 0, 50+_cellWidth, self.frame.size.height);
    [self addSubview:self.leftTableView];
    
    UIView *verticalSeparateLine1 = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 0.5, self.frame.size.height)];
    verticalSeparateLine1.backgroundColor = [UIColor blackColor];
    [self addSubview:verticalSeparateLine1];
    
    UIView *verticalSeparateLine2 = [[UIView alloc] initWithFrame:CGRectMake(50+_cellWidth-0.5, 0, 0.5, self.frame.size.height)];
    verticalSeparateLine2.backgroundColor = [UIColor blackColor];
    [self addSubview:verticalSeparateLine2];
    
    
    self.rightScrollView.frame = CGRectMake(50+_cellWidth, 0, self.frame.size.width-50-_cellWidth, self.frame.size.height);
    self.rightScrollView.contentSize = CGSizeMake((_detailTitlesArray.count-1)*_cellWidth, self.frame.size.height);
    [self addSubview:self.rightScrollView];
    
    self.rightTableView.frame = CGRectMake(0, 0, (_detailTitlesArray.count-1)*_cellWidth, self.frame.size.height);
    [self.rightScrollView addSubview:self.rightTableView];
    
    for (int i = 1; i<_detailTitlesArray.count; i++)
    {
        UIView *verticalSeparateLine = [[UIView alloc] initWithFrame:CGRectMake(_cellWidth*i, _cellHeight*1.5, 0.5, self.frame.size.height-_cellHeight*1.5)];
        verticalSeparateLine.backgroundColor = [UIColor blackColor];
        [self.rightScrollView addSubview:verticalSeparateLine];
    }
    
    self.gotoTopButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-50, self.frame.size.height-50, 35, 35)];
    [self.gotoTopButton setBackgroundImage:[UIImage imageNamed:@"toTopButton"] forState:UIControlStateNormal];
    [self.gotoTopButton addTarget:self action:@selector(gotoTop:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.gotoTopButton];
    self.gotoTopButton.hidden = YES;
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    
    UIView *horizontalSeparateLine = [[UIView alloc] initWithFrame:CGRectMake(0, _cellHeight*1.5, self.frame.size.width, 0.5)];
    horizontalSeparateLine.backgroundColor = [UIColor blackColor];
    [self addSubview:horizontalSeparateLine];
    
    [self removeFromSuperview];
    [superView addSubview:self];
}


//回调方法
- (void)returnSelectItem:(ReturnBlock)item
{
    self.returnBlock = item;
}

//回到顶部按钮
- (void)gotoTop:(UIButton *)sender
{
    [self.leftTableView setContentOffset:CGPointMake(0, 0)];
    [self.rightTableView setContentOffset:CGPointMake(0, 0)];
}


#pragma mark ----------------------- <UITableViewDelegate, UITableViewDataSource> -----------------------

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _cellHeight*1.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_leftTableView == tableView)
    {
        CGFloat width = _leftTableView.frame.size.width;
        CGFloat height = _cellHeight*1.5;
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        headView.backgroundColor = RGBColor(226, 226, 226);
        
        UILabel *serialNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, height)];
        serialNumberLabel.text = @"序号";
        serialNumberLabel.font = [UIFont systemFontOfSize:15];
        serialNumberLabel.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:serialNumberLabel];
        
        UILabel *lockLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, _cellWidth, height)];
        NSString *str = self.titlesArray[0];
        lockLabel.text = str;
        lockLabel.font = [UIFont systemFontOfSize:15];
        lockLabel.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:lockLabel];
        
        
        return headView;
    }
    
    else
    {
        CGFloat width = _rightTableView.frame.size.width;
        CGFloat height = _cellHeight*1.5;
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        headView.backgroundColor = RGBColor(226, 226, 226);
        
        CGFloat x = 0;
        for (int i=1; i<self.titlesArray.count; i++)
        {
            if ([self.titlesArray[i] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = self.titlesArray[i];
                
                NSArray *keysArray = [dict allKeys];
                NSString *keyTitle = keysArray.firstObject;
                
                NSArray *valuesArray = [dict allValues];
                NSArray *array = valuesArray.firstObject;
                
                NSUInteger titlesCount = array.count;
                
                
                UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, _cellWidth*titlesCount, height)];
                [headView addSubview:bgView];
                
                UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _cellWidth*titlesCount, height*0.5)];
                keyLabel.text = keyTitle;
                keyLabel.font = [UIFont systemFontOfSize:15];
                keyLabel.textAlignment = NSTextAlignmentCenter;
                [bgView addSubview:keyLabel];
                
                UIView *verticalSeparateLine = [[UIView alloc] initWithFrame:CGRectMake(_cellWidth*titlesCount-0.5, 0, 0.5, height*0.5)];
                verticalSeparateLine.backgroundColor = [UIColor blackColor];
                [keyLabel addSubview:verticalSeparateLine];
                
                UIView *horizontalSeparateLine = [[UIView alloc] initWithFrame:CGRectMake(0, height*0.5-0.5, _cellWidth*titlesCount, 0.5)];
                horizontalSeparateLine.backgroundColor = [UIColor blackColor];
                [keyLabel addSubview:horizontalSeparateLine];
                
                
                for (int j = 0; j < titlesCount; j++)
                {
                    NSString *str = array[j];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_cellWidth*j, height*0.5, _cellWidth, height*0.5)];
                    label.text = str;
                    label.font = [UIFont systemFontOfSize:15];
                    label.textAlignment = NSTextAlignmentCenter;
                    [bgView addSubview:label];
                 
                    UIView *verticalSeparateLine = [[UIView alloc] initWithFrame:CGRectMake(_cellWidth-0.5, 0, 0.5, height*0.5)];
                    verticalSeparateLine.backgroundColor = [UIColor blackColor];
                    [label addSubview:verticalSeparateLine];
                }
                
                x += _cellWidth*titlesCount;
            }
            else
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, _cellWidth, height)];
                NSString *str = self.titlesArray[i];
                label.text = str;
                label.font = [UIFont systemFontOfSize:15];
                label.textAlignment = NSTextAlignmentCenter;
                [headView addSubview:label];
                
                UIView *verticalSeparateLine = [[UIView alloc] initWithFrame:CGRectMake(_cellWidth-0.5, 0, 0.5, height)];
                verticalSeparateLine.backgroundColor = [UIColor blackColor];
                [label addSubview:verticalSeparateLine];
                
                x += _cellWidth;
            }
            
            
        }
        
        return headView;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    NSString *str = [NSString stringWithFormat:@"LeftView%li",(long)indexPath.row];
    
    
    if (_leftTableView == tableView)
    {
        //LeftTableViewCell *cell = (LeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ID];
        LeftTableViewCell *cell = (LeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:str];

        if (cell == nil)
        {
            cell = [[LeftTableViewCell alloc] initFrame:CGRectMake(0, 0, 50+self.cellWidth, self.cellHeight)
                                                  style:UITableViewCellStyleDefault
                                        reuseIdentifier:ID];
        }
        
        cell.serialNumberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        NSMutableArray *array = self.dataArray[indexPath.row];
        NSString *str = array.firstObject;
        cell.lockLabel.text = str;
        
        return cell;
        
    }
    
    else
    {
       // RightTableViewCell *cell = (RightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ID];
        RightTableViewCell *cell = (RightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:str];

        if (cell == nil)
        {
            cell = [[RightTableViewCell alloc] initFrame:CGRectMake(0, 0, self.cellWidth*(self.detailTitlesArray.count-1), self.cellHeight)
                                                   style:UITableViewCellStyleDefault
                                         reuseIdentifier:ID];
        }
        
        NSMutableArray *cellArray = self.dataArray[indexPath.row];
        cell.array = cellArray;
        
        return cell;
    }
    


}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *array = self.dataArray[indexPath.row];
    
    int a=indexPath.row;
    
    if(a==0)
    
    {
        NSLog(@"nonono");
    }
    
    else{
    NSString *str=[NSString stringWithFormat:@"%d", indexPath.row-1];  //因为第一行是合计  所以要-1
    //NSString *str = array.firstObject;
    //self.returnBlock(str);  //点击了以后就将这个值传出去
    self.returnBlock(str);  //点击了以后就将这个值传出去
    
    }
}






//为tableview设置旋转动画

//
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
     //tableview  在滑动的时候会进行破碎拼接
     NSArray *array =  tableView.indexPathsForVisibleRows;
     NSIndexPath *firstIndexPath = array[0];
     
     //设置anchorPoint
     cell.layer.anchorPoint = CGPointMake(0, 0.5);
     //为了防止cell视图移动，重新把cell放回原来的位置
     cell.layer.position = CGPointMake(0, cell.layer.position.y);
     
     
     //设置cell 按照z轴旋转90度，注意是弧度
     if (firstIndexPath.row < indexPath.row) {
     cell.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1.0);
     }else{
     cell.layer.transform = CATransform3DMakeRotation(- M_PI_2, 0, 0, 1.0);
     }
     
     
     cell.alpha = 0.0;
     
     
     [UIView animateWithDuration:1 animations:^{
     cell.layer.transform = CATransform3DIdentity;
     cell.alpha = 1.0;
     }];
     
     */
    
    
     /*  //tableview  滑动的时候会变大变小
    cell.contentView.alpha = 0.1;
    
    CGAffineTransform transformScale = CGAffineTransformMakeScale(2,2);
    CGAffineTransform transformTranslate = CGAffineTransformMakeTranslation(0, 0);
    
    cell.contentView.transform = CGAffineTransformConcat(transformScale, transformTranslate);
    
    [tableView bringSubviewToFront:cell.contentView];
    [UIView animateWithDuration:0.5 animations:^{
        cell.contentView.alpha = 1;
        cell.contentView.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    */
    
    ///*
     //tableview滑动的时候 会从旁边滑动出来
     CGFloat rotationAngleDegrees = 0;
     CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
     CGPoint offsetPositioning = CGPointMake(-200, -20);
     CATransform3D transform = CATransform3DIdentity;
     transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
     transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
     
     
     UIView *card = [cell contentView];
     card.layer.transform = transform;
     card.layer.opacity = 0.1;
     
     
     
     [UIView animateWithDuration:0.5f animations:^{
     card.layer.transform = CATransform3DIdentity;
     card.layer.opacity = 1;
     }];
     //*/
    
    
    
}






#pragma mark ----------------------- <UIScrollViewDelegate> -----------------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.rightScrollView == scrollView)
    {
        
    }
    else
    {
        CGFloat currentOffsetY = scrollView.contentOffset.y;
        
        [self.leftTableView setContentOffset:CGPointMake(0, currentOffsetY)];
        [self.rightTableView setContentOffset:CGPointMake(0, currentOffsetY)];
    }
    
    
    CGFloat tableViewOffsetY = self.leftTableView.contentOffset.y;
    self.gotoTopButton.hidden = tableViewOffsetY >= self.cellHeight ? NO : YES;
    
    
}


@end
