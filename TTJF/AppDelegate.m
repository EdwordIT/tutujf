//
//  AppDelegate.m
//  TTJF
//
//  Created by 占碧光 on 2017/2/24.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <MobClick.h>
#import "AppDelegate+XGPushConfig.h"
#import "SYSafeCategory.h"
#import "introductoryPagesHelper.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
#import "MainViewController.h"
#import "MineViewController.h"
#import "HomeWebController.h"
#import "RSA.h"
#import <CommonCrypto/CommonDigest.h>
#import "NetworkManager.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import "CustomURLProtocol.h"
#import "XHLaunchAd.h"
#import "UIImage+GIF.h"
#import "ProgrameListController.h"
#import "PPNetworkHelper.h"
#import "MineViewController.h"
#import "FoundController.h"
#import "YBLUserManageCenter.h"
#import "YBLNetWorkHudBar.h"
#import "ReactiveObjC.h"
#import "AFNetworkReachabilityManager.h"

@interface AppDelegate ()<HttpDNSDegradationDelegate,XHLaunchAdDelegate,UIWebViewDelegate>
{
    
    MainViewController *VC1 ;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //初始化网络请求参数
    [self checkNetwork];
    //获取配置信息
    [self getSystemConfigData];
    //注册protocol
    [NSURLProtocol registerClass:[CustomURLProtocol class]];
    //键盘统一收回处理
    [self configureBoardManager];
    //定制SVProgressHUD
    [self setUpSvpProgress];
    
    //注册推送通知
    [self registerPushForIOS8];
    //信鸽推送
    [self registerXGPush];
    //友盟统计
    [MobClick startWithAppkey:UMAPPKEY reportPolicy:BATCH   channelId:@"GitHub"];
    
    //注册shareSDK
    [self registerShareSDK];
    //取消引导页
//    [self setupIntroductoryPage];
    //初始化
    [self initRootVC];
//信鸽推送信息上送到推送端
    [[XGPush defaultManager] reportXGNotificationInfo:launchOptions];
    return YES;
}

//初始化提示框
- (void)setUpSvpProgress {
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD setBackgroundColor:RGBA(255, 255, 255, 0.6)];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBorderColor:RGB_183];
    [SVProgressHUD setBorderWidth:kLineHeight];
    [SVProgressHUD setCornerRadius:kSizeFrom750(10)];
//    [[UIButton appearance] setExclusiveTouch:YES];
//    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"hud_error"]];
//    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"hud_success"]];
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//    [SVProgressHUD setCornerRadius:8];
//    [SVProgressHUD setBackgroundColor:RGBA(0, 0, 0, 0.6)];
//    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
//    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
//    [SVProgressHUD setFont:CHINESE_SYSTEM(16)];
//    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
//    CGFloat wi = screen_width/3-space;
//    [SVProgressHUD setMinimumSize:CGSizeMake(wi, wi)];
    
}
-(void)checkNetwork
{
    /**
     *  网络
     */
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                NSLog(@"未知网络");
                break;
            case 0:
                NSLog(@"网络不可达");
                break;
            case 1:
                NSLog(@"GPRS网络");
                break;
            case 2:
                NSLog(@"wifi网络");
                break;
            default:
                break;
        }
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            NSLog(@"有网");
            [YBLUserManageCenter shareInstance].isNoActiveNetStatus = NO;
        }else
        {
            NSLog(@"没有网");
            [YBLUserManageCenter shareInstance].isNoActiveNetStatus = YES;
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ///监听网络
        @weakify(self)
        [RACObserve([YBLUserManageCenter shareInstance], isNoActiveNetStatus) subscribeNext:^(NSNumber*  _Nullable x) {
            @strongify(self)
            if (x.boolValue) {
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                UINavigationController *navVc = [self getNavigationCWithWindow:window];
                [YBLNetWorkHudBar startMonitorWithVc:navVc.visibleViewController];
            } else {
                [YBLNetWorkHudBar dismissHudView];
            }
            [SVProgressHUD dismiss];
        }];
    });
}
-(void)registerShareSDK
{
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSMS),
                                        @(SSDKPlatformTypeCopy),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ)]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:kSocial_WX_ID
                                       appSecret:kSocial_WX_Secret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:kSocial_QQ_ID
                                      appKey:kSocial_QQ_Secret
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}
#pragma mark 设置引导页相关内容
//-(void)setupIntroductoryPage
//{
//
//    //如果版本号发生变化，则重新加载引导页，否则直接走倒计时页面
//    if ([[CommonUtils getVersion] isEqualToString:currentVersion]){
//        [self setLanouceAdt];
//
//    }else{
//        [TTJFUserDefault setStr:currentVersion key:kVersion];
//        NSArray *images=@[@"introductoryPage1",@"introductoryPage2",@"introductoryPage3"];
//        [introductoryPagesHelper showIntroductoryPageView:images];
//    }
//
//
//}
//倒计时页面
-(void) setLanouceAdt
{
    //2.自定义配置初始化
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
    //广告停留时间
    imageAdconfiguration.duration = 3;
    //广告frame
    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //广告图片
    imageAdconfiguration.imageNameOrURLString =self.systemConfigModel.start_adver_imgurl;
//    //显示图片开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
    //广告数据请求
}
//使用SDWeImage加载图片
-(void)xhLaunchAd:(XHLaunchAd *)launchAd launchAdImageView:(UIImageView *)launchAdImageView URL:(NSURL *)url{
    [launchAdImageView sd_setImageWithURL:url];
}
-(void)xhLaunchShowFinish:(XHLaunchAd *)launchAd
{
    if(VC1!=nil)
    [VC1 setBanndrNum];
    
}
- (NSDate *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    
    //NSLog(@"---------- currentDate == %@",date);
    return date;
}
//获取当前所在的视图控制器
- (UINavigationController *)currentNav {
    UIViewController *nav = self.window.rootViewController;
    if ([nav isKindOfClass:[UITabBarController class]]) {
        return ((UITabBarController *)nav).selectedViewController;
    }else{
        return (UINavigationController *)nav;
    }

}
-(void)initRootVC{
    
    //    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.hidden = NO;
    //1.
    VC1 = [[MainViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:VC1];
    
    ProgrameListController *VC2 = [[ProgrameListController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:VC2];
    FoundController *VC3 = [[FoundController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:VC3];
    MineViewController *VC4= [[MineViewController alloc] init];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:VC4];
    VC1.title = @"首页";
    VC2.title = @"项目";
    VC3.title = @"发现";
    VC4.title = @"我的";
    //2.
    NSArray *viewCtrs = @[nav1,nav2,nav3,nav4];
    //3.
    //    UITabBarController *tabbarCtr = [[UITabBarController alloc] init];rootTabbarCtr
    self.rootTabbarCtr  = [[UITabBarController alloc] init];
    //4.
    [self.rootTabbarCtr setViewControllers:viewCtrs animated:YES];
    //5.
    self.window.rootViewController = self.rootTabbarCtr;
    
    //6.
    UITabBar *tabbar = self.rootTabbarCtr.tabBar;
    UITabBarItem *item1 = [tabbar.items objectAtIndex:0];
    UITabBarItem *item2 = [tabbar.items objectAtIndex:1];
    UITabBarItem *item3 = [tabbar.items objectAtIndex:2];
    UITabBarItem *item4 = [tabbar.items objectAtIndex:3];
    
    item1.selectedImage = [[UIImage imageNamed:@"menu_home_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"menu_home_unsel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"menu_program_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"menu_program_unsel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [[UIImage imageNamed:@"menu_discover_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"menu_discover_unsel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.selectedImage = [[UIImage imageNamed:@"menu_my_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image = [[UIImage imageNamed:@"menu_my_unsel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:RGB(0, 160,240)];
    
    
   NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];

    tabbar.tintColor =HEXCOLOR(@"#53b3ed");
   
    [self.window makeKeyAndVisible];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return YES;
}


 // NOTE: 9.0以后使用新API接口
 - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
 {
 return YES;
 }




#pragma mark 键盘收回管理
-(void)configureBoardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    manager.enable = YES;
//    manager.shouldResignOnTouchOutside = YES;
//    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.keyboardDistanceFromTextField=kSizeFrom750(40);
//    manager.enableAutoToolbar = NO;
}
//禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - 远程通知(推送)回调
/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //注册用户信息上送给信鸽推送
    [[XGPushTokenManager defaultTokenManager] registerDeviceToken:deviceToken];
    NSString *device_token = [XGPushTokenManager defaultTokenManager].deviceTokenString;
    NSLog(@"deviceToken:%@",device_token);
    [TTJFUserDefault setStr:device_token key:kDeviceToken];
    //如果是第一次打开应用，则调用此接口上送deviceToken到服务器
    if ([[NSUserDefaults standardUserDefaults] boolForKey:isBindUser]) {
     /*   手机类型 1=android，2=IOS
       terminal_id IMEI,  UUID
       terminal_name (设备名称)：如 iPhone 6S
       terminal_model (设备型号)：iPhone 6S
        terminal_device_token  信鸽设备推送device_token*/
        
        NSString *phone_type = @"2";
        NSString * terminal_id = [CommonUtils getUUID];
        NSString * terminal_name = [UIDevice currentDevice].name;
        NSString *terminal_model = [CommonUtils getDeviceVersion];
        NSString * terminal_device_token = device_token;
  
        NSArray *keys = @[@"phone_type",@"terminal_id",@"terminal_name",@"terminal_model",@"terminal_device_token"];
        NSArray *values = @[phone_type,terminal_id,terminal_name,terminal_model,terminal_device_token];
        
        [[HttpCommunication sharedInstance] getSignRequestWithPath:sendDeviceTokenUrl keysArray:keys valuesArray:values refresh:nil success:^(NSDictionary *successDic){            //存储device_token
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isBindUser];
        } failure:^(NSDictionary *errorDic) {
            
        }];
       
    }else{
        
    }
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"[XGPush]token获取失败%@",str);
    
}
/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
#pragma mark - APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送
//应用在运行当中，（处于后台或者处于前台）收到通知调用此方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
   if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive)//当前程序在前台，跳出弹框
    [self handleNotification:userInfo isRemote:NO];
    else
    [self handleNotification:userInfo isRemote:YES];
    [[XGPush defaultManager] reportXGNotificationInfo:userInfo];
}
#pragma mark - iOS 10中收到推送消息
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//  信鸽推送ios10: App在前台获取到通知
-(void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
     [self handleNotification:notification.request.content.userInfo isRemote:NO];
    [[XGPush defaultManager] reportXGNotificationInfo:userInfo];
}
//  信鸽推送ios10: App在后台获取到通知，点击通知进入应用调用此方法
-(void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:response.notification.request.content.userInfo];
    [self handleNotification:userInfo isRemote:YES];
    completionHandler();
}


#endif
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)registerPushForIOS8{
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    //  [acceptAction release];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    // [inviteCategory release];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

/*
 * 降级过滤器，您可以自己定义HTTPDNS降级机制
 */
- (BOOL)shouldDegradeHTTPDNS:(NSString *)hostName {
    NSLog(@"Enters Degradation filter.");
    // 根据HTTPDNS使用说明，存在网络代理情况下需降级为Local DNS
    if ([NetworkManager configureProxies]) {
        NSLog(@"Proxy was set. Degrade!");
        return YES;
    }
    
    // 假设您禁止"www.taobao.com"域名通过HTTPDNS进行解析
    if ([hostName isEqualToString:@"www.taobao.com"]) {
        NSLog(@"The host is in blacklist. Degrade!");
        return YES;
    }
    
    return NO;
}
//获取系统配置相关数据
-(void) getSystemConfigData
{
    //设置数据获取等待时间
    [XHLaunchAd setWaitDataDuration:5];
    NSString *urlStr =  [NSString stringWithFormat:getSystemConfig,oyApiUrl];
    [[HttpCommunication sharedInstance] getSignRequestWithPath:urlStr keysArray:nil valuesArray:nil refresh:nil success:^(NSDictionary *successDic) {
        self.systemConfigModel = [SystemConfigModel yy_modelWithJSON:successDic];
        //系统配置数据加入缓存
        [CommonUtils cacheDataWithObject:successDic WithPathName:Cache_SystemConfig];
        [[NSNotificationCenter defaultCenter] postNotificationName:Noti_GetSystemConfig object:nil];
        [self setLanouceAdt];//添加广告页面
        //如果版本号相同，则不需要更新版本
        if ([self.systemConfigModel.ios_version isEqualToString:currentVersion]) {
            [TTJFUserDefault setStr:currentVersion key:kVersion];//更新本地版本号
        }else{
            
        }
        NSArray * allows=   [successDic objectForKey:@"allow_domain"];
        if([allows count]>0)
            self.urlJumpList=[allows copy];
    } failure:^(NSDictionary *errorDic) {
        //从缓存中读取广告内容
        NSDictionary *cache_system = [CommonUtils getCacheDataWithKey:Cache_SystemConfig];
        if (cache_system!=nil) {
            self.systemConfigModel = [SystemConfigModel yy_modelWithJSON:cache_system];
            [self setLanouceAdt];//添加广告页面
        }
       
    }];
    
}

//
- (UINavigationController *)getNavigationCWithWindow:(UIWindow *)window;{
    UITabBarController *tabVC = (UITabBarController  *)window.rootViewController;
    UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
    return pushClassStance;
}


@end
