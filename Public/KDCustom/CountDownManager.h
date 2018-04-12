//
//  CountDownManager.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/4/10.
//  Copyright © 2018年 TTJF. All rights reserved.
//倒计时管理类，保证在一个主线程中只有一个倒计时在进行

#import <Foundation/Foundation.h>
#define Noti_CountDown @"countDownNotification"
@interface CountDownManager : NSObject
Assign NSTimeInterval timeInterval;
+(instancetype)manager;
-(void)start;
-(void)reload;
-(void)cancel;
@end
