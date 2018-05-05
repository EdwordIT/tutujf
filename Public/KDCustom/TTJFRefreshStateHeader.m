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
    for (NSUInteger i = 1; i<=12; ++i) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_0%ld.jpg",i]];
        [idleImages addObject:image];
    }
    
    //    // 隐藏更新时间
    self.lastUpdatedTimeLabel.hidden = YES;
    //    // 隐藏刷新状态
    self.stateLabel.hidden = YES;
    //设置正在刷新状态的动画图片（发送网络请求等待response的过程）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSInteger i = 13; i<=34; i++) {
        UIImage *image;
//        if (i>34) {
//           image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_0%ld.jpg",i-34]];
//
//        }else
            image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_0%ld.jpg",i]];
        [refreshingImages addObject:image];
    }
    NSMutableArray *pullingImages =[NSMutableArray array];
    for (NSInteger i = 12; i<=12; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_0%ld.jpg",i]];
        [pullingImages addObject:image];
    }
    // 普通状态
    [self setImages:idleImages duration:5 forState:MJRefreshStateIdle];
    // 即将刷新状态(超过下拉区间，准备开始刷新显示的动画)
    [self setImages:pullingImages forState:MJRefreshStatePulling];
    // 正在刷新状态
    [self setImages:refreshingImages duration:0.8 forState:MJRefreshStateRefreshing];
    

    

}
//刷新图片尺寸1242*400
-(void)placeSubviews
{
    [super placeSubviews];
    CGFloat plusHeight = 280*(screen_width/1242);
    CGRect gifViewFrame = self.gifView.frame;
    gifViewFrame.size.width = screen_width;
    gifViewFrame.size.height = plusHeight;
    self.gifView.frame = gifViewFrame;
    self.gifView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.mj_w = screen_width;
    self.mj_h = plusHeight;
    self.gifView.mj_w = screen_width;

}

@end
