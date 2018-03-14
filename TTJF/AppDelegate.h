//
//  AppDelegate.h
//  DingXinDai
//
//  Created by 占碧光 on 16/6/17.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlJumpHelp.h"
#import "DMLoginViewController.h"
#import "GlobeData.h"

#define theAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) UIImageView *advImage;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property(nonatomic, strong) UITabBarController *rootTabbarCtr;

@property  NSString  * MobileNum;
@property BOOL IsLogin;
@property BOOL IsValid;
@property BOOL IsJump;
@property BOOL IS_IPhoneX;
@property BOOL IsUpdate;
@property BOOL IsWebRegdit;

@property  NSString  *  user_token;
@property  NSString  *  password;
@property  NSString  *  certificate_name;
@property  NSString  *  certificate_no;

@property  NSInteger  xbindex;
//@property  NSInteger  tmpindex;
@property  NSInteger  tabindex;

@property  NSString  *  personalImage;
@property  NSString  *  isrenzheng;
@property  NSString  *  nick_name;
@property  NSString  *  user_name;
@property  NSString  *  vistorjg;
@property  NSString  *  device_token;
@property  NSString  *  jumpLogin;
@property  NSString  *  lockLogin;
@property  int  webLogin;
@property  NSString  *  userdxb;
@property  NSString  *  userhb;
@property  NSString  *  webJump;
@property  NSString  *  accountQh;
@property(nonatomic, strong) UrlJumpHelp * jumpHelp;

@property(nonatomic, strong) DMLoginViewController * userLogin;
@property  NSString  *   httplink;
//@property  NSString  *   VersionNum;
@property  NSArray  *   urlJumpList;
@property  NSArray  *   needReturnList;

@property  NSString  *  expirationdate;

@property(nonatomic, strong)  GlobeData * globed;

@end

