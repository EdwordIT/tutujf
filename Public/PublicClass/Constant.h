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

#define kVersion @"bundleVersion"
//友盟Appkey
#define UMAPPKEY @"59d656c4a40fa356ff00016a"


//友盟统计 https://itunes.apple.com/app/id1241881881
#define kUmeng_Event_Request_Notification @"Request_Notification"
#define kUmeng_Event_Request_RootList @"Request_RootList"
#define kUmeng_Event_Request_Get @"Request_Get"
#define kUmeng_Event_Request_ActionOfServer @"Request_ActionOfServer"
#define kUmeng_Event_Request_ActionOfLocal @"Request_ActionOfLocal"

//Social Data
#define kSocial_WX_ID @""
#define kSocial_WX_Secret @""
#define kSocial_QQ_ID  @""
#define kSocial_QQ_Secret @""
#define kSocial_EN_Key @""
#define kSocial_EN_Secret @""
#define kSocial_Sina_RedirectURL @""
#define kSocial_Sina_OfficailAccount @""

//信鸽推送
//#define kXGPush_Id 123456
//#define kXGPush_Key @""

//百度定位
//#define kBaiduGeotableId @""
//#define kBaiduAK @""
//#define kBaiduSK @""

//测试地址
//#define kBaseUrlStr_Test @"https://coding.net/"

//手机版地址
//#define kBaseUrlStr_Phone @"https://m.coding.net/"

//appStore地址
#define kAppUrl  @"http://itunes.apple.com/app/id923676989"
#define kAppReviewURL   @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=923676989"


//版本号
#define kVersion_Coding [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define kVersionBuild_Coding [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

#define Update_Coding @"6"  //当前版本号



#define kKeyWindow [UIApplication sharedApplication].keyWindow
#define DebugLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]

#define kKeyWindow [UIApplication sharedApplication].keyWindow

/*
#define kHigher_iOS_6_1 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
#define kHigher_iOS_6_1_DIS(_X_) ([[NSNumber numberWithBool:kHigher_iOS_6_1] intValue] * _X_)
#define kNotHigher_iOS_6_1_DIS(_X_) (-([[NSNumber numberWithBool:kHigher_iOS_6_1] intValue]-1) * _X_)

#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
 */

//#define  kBadgeTipStr @"badgeTip"

#define NAVBAR_COLOR                [UIColor hexFloatColor:@"f68e49"]

#endif
