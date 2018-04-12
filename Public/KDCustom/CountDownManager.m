//
//  CountDownManager.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/4/10.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "CountDownManager.h"
@interface CountDownManager()
Strong NSTimer *timer;
@end
@implementation CountDownManager
+(instancetype)manager{
    static CountDownManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CountDownManager alloc]init];
    });
    return manager;
}
-(void)start{
    //启动定时器
    if (!_timer) {
        [self timer];
    }else{
        self.timeInterval = 0;
    }
}
-(void)reload{
    if (self.timer==nil) {
        [self timer];
    }
}
-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        _timeInterval = 0;
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
-(void)timerAction
{
    self.timeInterval++;
    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_CountDown object:nil userInfo:@{@"timeInterval":@(self.timeInterval)}];//全局广播倒计时
}
-(void)cancel{
    [_timer invalidate];
    _timer = nil;
}
@end
