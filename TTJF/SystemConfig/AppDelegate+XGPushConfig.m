//
//  AppDelegate+XGPushConfig.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/4/8.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "AppDelegate+XGPushConfig.h"
#import "HomeWebController.h"
@implementation AppDelegate (XGPushConfig)
- (void)registerXGPush
{
    if (DEBUG) {
        [[XGPush defaultManager] setEnableDebug:YES];//打开信鸽推送日志
    }
    [[XGPush defaultManager] startXGWithAppID:kXGPush_AppId appKey:kXGPush_AppKey delegate:self];
    [[XGPush defaultManager] setXgApplicationBadgeNumber:0];//设置角标数字为0
    [self registerRemoteNotification];
}

- (void)registerRemoteNotification {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else{
        
    }
}

// 本地通知展示
- (void)showLocalNotification:(NSDictionary *)alert {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.userInfo = alert;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    NSString * title = [alert objectForKey:@"title"];
    NSString * body = [alert objectForKey:@"body"];
    NSString * alertBody = [NSString stringWithFormat:@"%@\n%@",title,body?:@""];
    
    localNotification.alertBody = alertBody;
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

#pragma mark --XGPush Delegate
//处理通知消息
-(void)handleNotification:(NSDictionary *)userInfo isRemote:(BOOL)isRemote{
    
    if (!isRemote) {
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0) {
            // iOS10 以下弹出提示框
            NSDictionary *aps = [userInfo objectForKey:@"aps"];
            NSString *message = [[aps objectForKey:@"alert"] objectForKey:@"title"];
          
            UIAlertController *alertview = [UIAlertController alertControllerWithTitle:@"接收到新消息，是否前往?" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *defult = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self handleNotification:userInfo isRemote:YES];
            }];
            [alertview addAction:cancel];
            [alertview addAction:defult];
            [self.window.rootViewController presentViewController:alertview animated:YES completion:nil];
//        } else {
//            // ios10 转换成本地通知 (点击本地消息后跳转)
//
//            NSDictionary *aps = [userInfo objectForKey:@"aps"];
//            [self showLocalNotification:[aps objectForKey:@"alert"]];
//        }
    }else{
        //点击推送进入应用响应事件
        /**
         {
         a = 1;
         url = @"www.baidu.com";
         aps =     {
         alert =         {
         body = 3;
         subtitle = 2;
         title = 1;
         };
         sound = default;
         category = "www.baidu.com";
         };
         xg =     {
         bid = 0;
         ts = 1523178521;
         };
         }
         */
        //category 推送自带默认字段名
        //url 自定义扩展字段名
        NSString *category = [[userInfo objectForKey:@"aps"] objectForKey:@"category"];
        if(!IsEmptyStr(category)){
            HomeWebController *web = InitObject(HomeWebController);
            web.urlStr = category;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[BaseViewController appRootViewController].navigationController pushViewController:web animated:YES];
            });
            
        }
    }
   
    
}

/**
 @brief 监控信鸽推送服务地启动情况
 
 @param isSuccess 信鸽推送是否启动成功
 @param error 信鸽推送启动错误的信息
 */
- (void)xgPushDidFinishStart:(BOOL)isSuccess error:(nullable NSError *)error{
    NSLog(@"信鸽推送是否启动成功%@",isSuccess?@"YES":@"NO");
}

/**
 @brief 监控信鸽服务上报推送消息的情况
 
 @param isSuccess 上报是否成功
 @param error 上报失败的信息
 */
- (void)xgPushDidReportNotification:(BOOL)isSuccess error:(nullable NSError *)error{
    NSLog(@"错误信息error%@",error);
}
@end
