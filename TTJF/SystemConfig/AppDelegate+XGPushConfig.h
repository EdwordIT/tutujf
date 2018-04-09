//
//  AppDelegate+XGPushConfig.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/4/8.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "AppDelegate.h"
#import <XGPush.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#endif
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate (XGPushConfig)<XGPushDelegate,UNUserNotificationCenterDelegate>
- (void)registerXGPush;
//消息处理
-(void)handleNotification:(NSDictionary *)userInfo isRemote:(BOOL)isRemote;
@end
