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


@end

@implementation TTJFRefreshStateHeader

#pragma mark - 重写父类的方法
- (void)prepare {

    [super prepare];
    // 初始化间距
    //设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; ++i) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%ld",i]];
        [idleImages addObject:image];
    }
    
    //    // 隐藏更新时间
    self.lastUpdatedTimeLabel.hidden = YES;
    //    // 隐藏刷新状态
    self.stateLabel.hidden = YES;
    //设置正在刷新状态的动画图片（发送网络请求等待response的过程）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSInteger i = 3; i<=21; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%ld",i]];
        [refreshingImages addObject:image];
    }
    //设置下拉过程中的动画图片
    NSMutableArray *pullingImages =[NSMutableArray array];
    for (NSInteger i = 3; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%ld",i]];
        [pullingImages addObject:image];
    }
    // 普通状态
    [self setImages:idleImages duration:5 forState:MJRefreshStateIdle];
    // 即将刷新状态
    [self setImages:pullingImages duration:4 forState:MJRefreshStatePulling];
    // 正在刷新状态
    [self setImages:refreshingImages duration:0.5 forState:MJRefreshStateRefreshing];
    
    

}
//6P下刷新图片尺寸1125*203
-(void)placeSubviews
{
    [super placeSubviews];
    if (IS_IPhone6plus) {
        CGFloat plusHeight = 203.f*(screen_width/1125.f);
        CGRect gifViewFrame = self.gifView.frame;
        gifViewFrame.size.width = screen_width;
        gifViewFrame.origin.y-=plusHeight - gifViewFrame.size.height;
        gifViewFrame.size.height = plusHeight;
        self.gifView.frame = gifViewFrame;
        self.gifView.contentMode = UIViewContentModeScaleAspectFill;//适配iphone6P、7P、8P尺寸下的刷新图片显示不全的问题
        
    }
}

@end
