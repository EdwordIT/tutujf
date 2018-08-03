//
//  TTJFRefreshStateHeader.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/6.
//  Copyright © 2018年 占碧光. All rights reserved.
//

#import "TTJFRefreshStateHeader.h"
#define BALLOON_GIF_DURATION 0.15

@interface TTJFRefreshStateHeader()
@property (weak, nonatomic) UILabel *textLabel;
Weak UIView *leftCycleView;//后轮
Weak UIView *rightCycleView;//前轮
@end

@implementation TTJFRefreshStateHeader

#pragma mark - 重写父类的方法
- (void)prepare {

    [super prepare];
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RGB_102;
    label.font = SYSTEMSIZE(26);
    [self addSubview:label];
    self.textLabel = label;

    //设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSInteger i = 1; i<=4; i++) {
        UIImage *image = nil;
        image =  [UIImage imageNamed:[NSString stringWithFormat:@"refresh_%ld",i]];
         [idleImages addObject:image];
    }
    // 隐藏更新时间
    self.lastUpdatedTimeLabel.hidden = YES;
     // 隐藏刷新状态
    self.stateLabel.hidden = YES;
    //拖动渐隐效果
    self.automaticallyChangeAlpha = YES;
    // 普通状态
    [self setImages:idleImages duration:4 forState:MJRefreshStateIdle];
    // 即将刷新状态(超过下拉区间，准备开始刷新显示的动画)
    [self setImages:idleImages duration:4  forState:MJRefreshStatePulling];
    // 正在刷新状态
    [self setImages:idleImages duration:4 forState:MJRefreshStateRefreshing];
    
     [self setImages:idleImages duration:4 forState:MJRefreshStateWillRefresh];

}
//刷新图片尺寸1242*400

//自定义动画
-(void)loadCycleView:(CGFloat)progress view:(UIView *)cycleView{
    
    if (progress<=0) {
        return;
    }
    //移除图层
    NSArray<CALayer *> *subLayers = cycleView.layer.sublayers;
    NSArray<CALayer *> *removedLayers = [subLayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject isKindOfClass:[CAShapeLayer class]];
    }]];
    [removedLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.lineWidth = kLineHeight*2;
    //圆环的颜色
    layer.strokeColor = RGB_153.CGColor;
    //背景填充色
    layer.fillColor = [UIColor clearColor].CGColor;
    //设置半径
    CGFloat radius = cycleView.height/2;
    //初始化一个路径
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:(1.5*M_PI) endAngle:(1.5*M_PI+progress*(2*M_PI)) clockwise:YES];
    layer.path = [path1 CGPath];
    [cycleView.layer addSublayer:layer];
    
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.mj_h = kSizeFrom750(80);
    self.gifView.frame = RECT(screen_width/2 - kSizeFrom750(100), (self.mj_h - kSizeFrom750(36))/2, kSizeFrom750(36), kSizeFrom750(36));
    self.textLabel.frame = RECT(self.gifView.right+kSizeFrom750(15), self.gifView.top, 300, self.gifView.height);
    
//    center.y +=3;
//    self.gifView.center = center;
//    //540*72
//    self.textLabel.frame = RECT(0, 0, 300, 15);
//    self.textLabel.center = CGPointMake(self.gifView.centerX, self.gifView.centerY+5);
//    self.leftCycleView.center = CGPointMake(self.gifView.centerX - 38, self.gifView.centerY +16);
//    self.rightCycleView.center = CGPointMake(self.gifView.centerX+42, self.leftCycleView.centerY);
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{

    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
        {
            self.textLabel.text = @"下拉刷新";
        }
            break;
        case MJRefreshStatePulling:
        {
            self.textLabel.text = @"释放开始刷新";
        }
            break;
        case MJRefreshStateRefreshing:
        {
            self.textLabel.text = @"数据加载中...";
        }
            break;
        default:
            break;
    }
}
#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
//    CGFloat progress = MIN((-self.scrollView.contentOffset.y)/self.mj_h, 1);
//    [self loadCycleView:progress view:self.leftCycleView];
//    [self loadCycleView:progress view:self.rightCycleView];
//

}
@end
