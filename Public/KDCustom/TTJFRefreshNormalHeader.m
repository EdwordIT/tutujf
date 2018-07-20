//
//  TTJFRefreshNormalHeader.m
//  TTJF
//
//  Created by wbzhan on 2018/4/26.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "TTJFRefreshNormalHeader.h"
@interface TTJFRefreshNormalHeader()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIImageView *logo;
@property (weak, nonatomic) UIActivityIndicatorView *loading;
@property (weak,nonatomic) UIView *bgView;

@end
#define mj_height kSizeFrom750(100)
@implementation TTJFRefreshNormalHeader
#pragma mark - 重写父类的方法
- (void)prepare {
    
    [super prepare];
    _canRefresh = YES;
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = navigationBarColor;
    [self addSubview:view];
    self.bgView = view;
    // 设置控件的高度
    self.mj_h = mj_height;
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = COLOR_White;
    label.font = SYSTEMSIZE(24);
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    
    
    // logo
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_mine"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:logo];
    self.logo = logo;

    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:loading];
    self.loading = loading;
    
}
-(void)setCanRefresh:(BOOL)canRefresh{
    _canRefresh = canRefresh;
        [self.logo setHidden:!canRefresh];
        [self.label setHidden:!canRefresh];
        [self.loading setHidden:!canRefresh];
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
 
    self.bgView.frame = RECT(0, mj_height-kViewHeight, screen_width, kViewHeight);
    
    self.logo.bounds = CGRectMake(0, 0, kSizeFrom750(46), kSizeFrom750(46));
    self.logo.center = CGPointMake(self.mj_w * 0.5, mj_height - kSizeFrom750(90) +kSizeFrom750(46)/2);
    
    self.label.frame = RECT(0, self.logo.bottom+kSizeFrom750(10), screen_width, kSizeFrom750(30));
    
    self.loading.center = self.logo.center;
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    if (!self.canRefresh) {
        return;
    }
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            [self.loading stopAnimating];
            self.label.text = @"下拉刷新";
            [self.logo setHidden:NO];
            self.logo.transform = CGAffineTransformMakeRotation(M_PI);
            break;
        case MJRefreshStatePulling:
            [self.loading stopAnimating];
            self.logo.transform = CGAffineTransformMakeRotation(M_PI*2);
            [self.logo setHidden:NO];
            self.label.text = @"松开即可加载";
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"数据加载中";
            self.logo.transform = CGAffineTransformMakeRotation(M_PI*2);
            [self.logo setHidden:YES];
            [self.loading startAnimating];
            break;
        default:
            break;
    }
}

//#pragma mark 监听拖拽比例（控件被拖出来的比例）
//- (void)setPullingPercent:(CGFloat)pullingPercent
//{
//    [super setPullingPercent:pullingPercent];
//}
//
//#pragma mark 监听scrollView的contentOffset改变
//- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
//{
//    [super scrollViewContentOffsetDidChange:change];
//
//}
//
//#pragma mark 监听scrollView的contentSize改变
//- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
//{
//    [super scrollViewContentSizeDidChange:change];
//
//}
//
//#pragma mark 监听scrollView的拖拽状态改变
//- (void)scrollViewPanStateDidChange:(NSDictionary *)change
//{
//    [super scrollViewPanStateDidChange:change];
//
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end
