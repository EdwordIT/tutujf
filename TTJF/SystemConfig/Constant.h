//
//  Constant.h
//  meituan
//
//  Created by jinzelu on 15/7/13.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#ifndef meituan_Constant_h
#define meituan_Constant_h

/*************************************关键字***********************************************************************/
#define kToken @"user_token"
#define kUsername @"user_name"
#define kNikename @"nike_name"
#define kPassword @"password"
#define kExpirationTime @"expiration_date"//token过期时间
#define kVersion @"bundleVersion"//系统版本号1.4.7
#define kDeviceToken @"device_token"
#define isBindUser @"isBindUser"//是否绑定用户deviceToken
#define isCertificationed @"isCertificationed"//是否实名认证过
#define Sign_IOS @"?equipment=ios"//webView里的ios标记
//登录状态发生变化全局通知
#define Noti_LoginChanged @"LoginStatusChanged"//改变首页数据显示

#define Noti_CountDownFinished @"CountDownFinished"//项目持续倒计时结束，发送通知使按钮无法点击
//token失效重新登录通知
#define Noti_AutoLogin @"autoLogin"
//获取系统配置成功通知
#define Noti_GetSystemConfig @"Noti_GetSystemConfig"
//缓存系统配置页面信息
#define Cache_SystemConfig @"Cache_SystemConfig"
//友盟Appkey
#define UMAPPKEY @"59d656c4a40fa356ff00016a"

//友盟统计 https://itunes.apple.com/app/id1241881881
#define kUmeng_Event_Request_Notification @"Request_Notification"
#define kUmeng_Event_Request_RootList @"Request_RootList"
#define kUmeng_Event_Request_Get @"Request_Get"
#define kUmeng_Event_Request_ActionOfServer @"Request_ActionOfServer"
#define kUmeng_Event_Request_ActionOfLocal @"Request_ActionOfLocal"

#define Bugly_AppId @"7674c51751"
//Social Data
#define kSocial_WX_ID @"wx581b4dfd960c0630"
#define kSocial_WX_Secret @"47021c19b0073598db49d21351903710"
#define kSocial_QQ_ID  @"1106229820"
#define kSocial_QQ_Secret @"rUrqDzQCUHdXyAoj"
#define kSocial_EN_Key @""
#define kSocial_EN_Secret @""
#define kSocial_Sina_RedirectURL @""
#define kSocial_Sina_OfficailAccount @""
#define HomeTabBar_Tag 20170101
//信鸽推送
#define kXGPush_AppId 2200278986
#define kXGPush_AppKey @"I1GD7447ZIYH"


//appStore地址
#define kAppUrl  @"http://itunes.apple.com/app/id923676989"
#define kAppReviewURL   @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=923676989"

//版本号
#define kVersion_Coding [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define kVersionBuild_Coding [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

#define kKeyWindow [UIApplication sharedApplication].keyWindow
#define DebugLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]

#define kKeyWindow [UIApplication sharedApplication].keyWindow

#define NAVBAR_COLOR                [UIColor hexFloatColor:@"f68e49"]

#endif
