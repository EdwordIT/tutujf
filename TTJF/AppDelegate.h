//
//  AppDelegate.h
//  DingXinDai
//
//  Created by 占碧光 on 16/6/17.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemConfigModel.h"
#define theAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) UITabBarController *rootTabbarCtr;
//系统配置model
Strong SystemConfigModel *systemConfigModel;
//允许访问的域名
Strong NSArray *urlJumpList;

-(UINavigationController *)currentNav;
@end

