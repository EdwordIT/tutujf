//
//  AppDelegate.m
//  TTJF
//
//  Created by 占碧光 on 2017/2/24.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
//#import "UMSocial.h"
//#import "UMSocialWechatHandler.h"
#import "MobClick.h"
#import "XGPush.h"

#import "SYSafeCategory.h"
#import "introductoryPagesHelper.h"
//#import "AutoLogin.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"

#import "MainViewController.h"
#import "ProgrameViewController.h"
#import "MineViewController.h"
//#import "PPNetworkCache.h"
#import "EMNavigationController.h"
#import "WinChageType.h"
#import "HomeWebController.h"


#import "RSA.h"
#import <CommonCrypto/CommonDigest.h>

#import "NetworkManager.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import "CustomURLProtocol.h"
#import "XHLaunchAd.h"
#import "UIImage+GIF.h"
#import "ProgrameListController.h"
//#import "MobClick.h"
#import "PPNetworkHelper.h"
//#import "Reachability.h"
#import "NoNetController.h"
#import "WinChageType.h"
#import "SVProgressHUD.h"
#import "MineViewController.h"
#import "FoundController.h"
#import "HttpSignCreate.h"
#import "ggHttpFounction.h"
#import "HttpUrlAddress.h"
#import "YBLUserManageCenter.h"
#import "YBLNetWorkHudBar.h"
#import "ReactiveObjC.h"
#import "AFNetworkReachabilityManager.h"

#define Banner_Url @"/wapassets/trust/images/news/banner.jpg"//banner页面图片地址为固定地址
#define Banner_DetailUrl [oyUrlAddress stringByAppendingString:@"/wap/system/register2"]//banner页面详情地址
@interface AppDelegate ()<HttpDNSDegradationDelegate,XHLaunchAdDelegate>
{
    
    MainViewController *VC1 ;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //判断机型、是否登录等各类系统状态
    _IS_IPhoneX=FALSE;
    CGSize resultSize = [[UIScreen mainScreen] bounds].size;
    resultSize = CGSizeMake(resultSize.width * [UIScreen mainScreen].scale, resultSize.height * [UIScreen mainScreen].scale);
    if(resultSize.width==1125&&resultSize.height==2436)
        _IS_IPhoneX=TRUE;
    //删除所有缓存 http 请求  PPNetworkCache json数据请求可以缓存
   // [PPNetworkCache removeAllHttpCache];
    _IsLogin=FALSE;
    _IsValid=TRUE;
    _IsJump=FALSE;
    _IsUpdate=FALSE;
    _IsWebRegdit=FALSE;
    _user_token=[TTJFUserDefault strForKey:kToken];
    _device_token=@"";
    _password=@"";
    _MobileNum=@"";
    _xbindex=-1;
    _isrenzheng=@"0";
    _personalImage=@"";
    _nick_name=@"";
    _vistorjg=@"";
    _jumpLogin=@"";
    _lockLogin=@"";
    _user_name=@"";
    _webJump=@"";
    _webLogin=0;
    _accountQh=@"";
    _certificate_no=@"";
    _httplink=@"";
    _globed=[[GlobeData alloc] init];
    _globed.register_txt=@"快速注册";
      _globed.register_link=@"";
    _needReturnList= @[ @"https://www.ecailtd.com/M/Account/MyRecharge", @"https://ebspay.boc.cn/PGWPortal/RecvOrder.do",@"https://ibsbjstar.ccb.com.cn/CCBIS/ccbMain",@"https://gateway.95516.com/gateway/api/frontTransReq.do",@"https://cashier.95516.com/b2c/acronym.action?transNumber=",@"https://b2c.bank.ecitic.com/pec/e3rdplaceorder.do",@"https://b2c.bank.ecitic.com/pec/e3rdplaceorder.do",@"https://www.cebbank.com/per/preEpayLogin.do",@"https://netpay.cmbchina.com/mobile-card/BaseHttp.dll?MB_Pay_FromPC",@"https://ebanks.cgbchina.com.cn/payment/parseOrderInfo.do",@"https://ebank.cmbc.com.cn/weblogic/servlets/EService/CSM/NonSignPayPre",@"https://ebank.spdb.com.cn/payment/main",@"https://pbank.psbc.com/psbcpay/main",[oyUrlAddress stringByAppendingString:@"/wap/member/cash"],@"https://lab.chinapnr.com/muser/QUERY/0100/"];
    
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
            //[YBLLogLoadingView dismissInWindow];
        }];
    });

    [self getSystemConfigDara];//获取配置信息
    //注册protocol
    [NSURLProtocol registerClass:[CustomURLProtocol class]];
    //键盘统一收回处理
    [self configureBoardManager];
    
   // [self initAdvView];
    self.device_token=@"";
    //信鸽推送
    [XGPush startApp:2200260064 appKey:@"I192JMQK2N3G"];
    [XGPush handleLaunching:launchOptions];
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(sysVer < 8){
        [self registerPush];
    }
    else{
        [self registerPushForIOS8];
    }
    self.userLogin=[[LoginViewController alloc] init];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com/"]];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
  //  [self initRootVC];
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    
    //
//    [ShareSDK registerApp:@"1f858b512c6ba"
//
//          activePlatforms:@[
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
                 [appInfo SSDKSetupWeChatByAppId:@"wx0693ca25b9dda8b8"
                                       appSecret:@"dc83f73464cbe135b61e8fc16bfefa3d"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1106229820"
                                      appKey:@"rUrqDzQCUHdXyAoj"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    
   

 /*
    EMNavigationController *navigationController = nil;
    HomeWebController *    webv=[[HomeWebController alloc] init];
    
    navigationController = [[EMNavigationController alloc] initWithRootViewController:webv];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window setRootViewController:navigationController];
    [self.window makeKeyAndVisible];
    

    */
   /*
    WinChageType * wtype=[[WinChageType alloc] init];
    wtype.lgointype=@"1"; //
    wtype.logindeep=@"2"; //初始化
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:wtype];
 */
    //注册更目录切换监听  登录，主窗体，盟约 之间切换
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    WinChageType * wtype=[[WinChageType alloc] init];
    wtype.lgointype=@"1"; //
    wtype.logindeep=@"0"; //初始化
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:wtype];
  
 
    [self setupIntroductoryPage];
  //  if(iOS11)
    {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *newUserAgent = [userAgent stringByAppendingString:@" TutuBrowser/1.1.1 Mobile AliApp(TUnionSDK/0.1.12) AliApp(TUnionSDK/0.1.12)"];//自定义需要拼接的字符串
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    }
    
    //通知监测
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    /*
    //block监测
    reach.reachableBlock = ^(Reachability * reachability)
    {
        NSString * netWorkName = [NSString stringWithFormat:@"Baidu Block Says Reachable:%@", reachability.currentReachabilityString];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"(%@)网络可用!",netWorkName);
            if (reachability.isReachableViaWiFi) {
                NSLog(@"(%@)当前通过wifi连接",netWorkName);
            } else {
                NSLog(@"(%@)wifi未开启，不能用",netWorkName);
            }
            if (reachability.isReachableViaWWAN) {
                NSLog(@"(%@)当前通过2g or 3g or 4g连接",netWorkName);
            } else {
                NSLog(@"(%@)2g or 3g or 4g网络未使用",netWorkName);
            }
  
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        NSString * netWorkName = [NSString stringWithFormat:@"GOOGLE Block Says Reachable(%@)", reachability.currentReachabilityString];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"(%@)网络不可用!",netWorkName);
   
            
        });
    };
    
    [reach startNotifier];
  */
    
    /**
     *  HUD 设置
     */
    [self setUpSvpProgress];
   // self.IsLogin=TRUE;
    return YES;
}

//初始化提示框
- (void)setUpSvpProgress {
    
    [[UIButton appearance] setExclusiveTouch:YES];
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"hud_error"]];
    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"hud_success"]];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setCornerRadius:8];
    [SVProgressHUD setBackgroundColor:RGBA(0, 0, 0, 0.6)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setFont:CHINESE_SYSTEM(16)];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    CGFloat wi = screen_width/3-space;
    [SVProgressHUD setMinimumSize:CGSizeMake(wi, wi)];
    
}
/*
- (void)reachabilityChanged:(NSNotification*)note {
    Reachability * reach = [note object];
    if(!reach.isReachable) {
        NSLog(@"网络不可用");

    }else{
        NSLog(@"网络可用");
    }
    if (reach.isReachableViaWiFi) {
        NSLog(@"当前通过wifi连接");
    } else {
        NSLog(@"wifi未开启，不能用");
    }
    if (reach.isReachableViaWWAN) {
        NSLog(@"当前通过2g or 3g连接");
    } else {
        NSLog(@"2g or 3g网络未使用");
    }
}
*/
//http://img.zcool.cn/community/01940257c291760000012e7e0e1470.jpg

#pragma mark 设置引导页相关内容
-(void)setupIntroductoryPage
{
    
    //如果版本号发生变化，则重新加载引导页
    if ([[CommonUtils getVersion] isEqualToString:currentVersion]){
        [self setLanouceAdt];
      
    }else{
        [TTJFUserDefault setStr:currentVersion key:kVersion];
        NSArray *images=@[@"introductoryPage1",@"introductoryPage2",@"introductoryPage3"];
        [introductoryPagesHelper showIntroductoryPageView:images];
    }
    
//    if (BBUserDefault.isNoFirstLaunch)
//    {
//
//        [self setLanouceAdt];
//        return;
//    }
//
//    BBUserDefault.isNoFirstLaunch=YES;
//    NSArray *images=@[@"introductoryPage1",@"introductoryPage2",@"introductoryPage3"];
//    [introductoryPagesHelper showIntroductoryPageView:images];
}

-(void) setLanouceAdt
{
    //2.自定义配置初始化
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
    //广告停留时间
    imageAdconfiguration.duration = 3;
    //广告frame
    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    imageAdconfiguration.imageNameOrURLString =[NSString stringWithFormat:@"%@%@",oyImageBigUrl,Banner_Url];
    //网络图片缓存机制(只对网络图片有效)
    imageAdconfiguration.imageOption = XHLaunchAdImageRefreshCached;
    //图片填充模式
    imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
    //广告点击打开链接
    imageAdconfiguration.openURLString = Banner_DetailUrl;
    //广告显示完成动画
    imageAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
    //跳过按钮类型
    imageAdconfiguration.skipButtonType = SkipTypeTimeText;
    //后台返回时,是否显示广告
    imageAdconfiguration.showEnterForeground = NO;
    
    //设置要添加的子视图(可选)
    //imageAdconfiguration.subViews = ...
    
    //显示图片开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
    
}

/**
 *  广告点击事件 回调
 */
- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenURLString:(NSString *)openURLString;
{
    //跳转到广告详情页面,详见demo
  //  WebViewController *VC = [[WebViewController alloc] init];
   // VC.URLString = openURLString;
//http://www.tutujf.com/wap/system/register2
    _webJump=Banner_DetailUrl;
    
}

-(void)xhLaunchShowFinish:(XHLaunchAd *)launchAd
{
    if(VC1!=nil)
    [VC1 setBanndrNum];
    
}

- (Boolean)compareOneDay:(NSDate *)fromDate withAnotherDay:(NSDate *)toDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dayComponents = [gregorian components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];
    // NSLog(@"date1 : %@, date2 : %@", fromDate, toDate);
    
    if ((-dayComponents.day)>0) {
        //NSLog(@"Date1  is in the future");
        return TRUE;
    }
    else if ((-dayComponents.day)<=0){
        //NSLog(@"Date1 is in the past");
        return FALSE;
    }
    //NSLog(@"Both dates are the same");
    return TRUE;
}


- (NSDate *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    
    //NSLog(@"---------- currentDate == %@",date);
    return date;
}

-(void)initRootVC{
    
    //    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.hidden = NO;
    //1.
    VC1 = [[MainViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:VC1];
    
    //    InfoViewController *VC2 = [[InfoViewController alloc] init];
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
    
    item1.selectedImage = [[UIImage imageNamed:@"xuanzhong"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"new"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"xuanzhong"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"nian"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    item2.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    item3.selectedImage = [[UIImage imageNamed:@"xuanzhong"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"kuai"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item4.selectedImage = [[UIImage imageNamed:@"xuanzhong"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image = [[UIImage imageNamed:@"le"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:RGB(0, 160,240)];
    
    
   NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];

    tabbar.tintColor =RGB(255, 45, 18);
    //友盟统计
    [MobClick startWithAppkey:UMAPPKEY reportPolicy:BATCH   channelId:@"GitHub"];
    //友盟初始化，对未安装QQ，微信的平台进行隐藏
   // [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
  //  [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline]];

    [self.window makeKeyAndVisible];
   // [self setupIntroductoryPage];
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
    
    /*
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        if([code isEqualToString:@"success"]) {
            
            NSDictionary *myDictionary = [NSDictionary dictionaryWithObject:@"success" forKey:@"IPSStatus"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"StatusNotification" object:nil userInfo:myDictionary];
        }
        else if([code isEqualToString:@"fail"]) {
            //交易失败
            
            NSDictionary *myDictionary = [NSDictionary dictionaryWithObject:@"fail" forKey:@"IPSStatus"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"StatusNotification" object:nil userInfo:myDictionary];
        }
        else if([code isEqualToString:@"cancel"]) {
            //交易取消
            
            NSDictionary *myDictionary = [NSDictionary dictionaryWithObject:@"cancel" forKey:@"IPSStatus"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"StatusNotification" object:nil userInfo:myDictionary];
        }
        
    }];
    */
    return YES;
}



 // NOTE: 9.0以后使用新API接口
 - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
 {
     /*
 [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
 
 if([code isEqualToString:@"success"]) {
 
 NSDictionary *myDictionary = [NSDictionary dictionaryWithObject:@"success" forKey:@"IPSStatus"];
 [[NSNotificationCenter defaultCenter] postNotificationName:@"StatusNotification" object:nil userInfo:myDictionary];
 }
 else if([code isEqualToString:@"fail"]) {
 //交易失败
 
 NSDictionary *myDictionary = [NSDictionary dictionaryWithObject:@"fail" forKey:@"IPSStatus"];
 [[NSNotificationCenter defaultCenter] postNotificationName:@"StatusNotification" object:nil userInfo:myDictionary];
 }
 else if([code isEqualToString:@"cancel"]) {
 //交易取消
 
 NSDictionary *myDictionary = [NSDictionary dictionaryWithObject:@"cancel" forKey:@"IPSStatus"];
 [[NSNotificationCenter defaultCenter] postNotificationName:@"StatusNotification" object:nil userInfo:myDictionary];
 }
 
 }];
 */
 return YES;
 }




#pragma mark 键盘收回管理
-(void)configureBoardManager
{
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    manager.enable = YES;
//    manager.shouldResignOnTouchOutside = YES;
//    manager.shouldToolbarUsesTextFieldTintColor = YES;
//    manager.keyboardDistanceFromTextField=60;
//    manager.enableAutoToolbar = NO;
}

#pragma mark - APP运行中接收到通知(推送)处理


//禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_



//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)(void))completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}

#endif
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //notification是发送推送时传入的字典信息
    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];
    
    //删除推送列表中的这一条
    [XGPush delLocalNotification:notification];
    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];
    
    //清空推送列表
    //[XGPush clearLocalNotifications];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //   UIUserNotificationType allowedTypes = [notificationSettings types];
    
}



#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]register errorBlock");
    };
    
    // 设置账号
    //	[XGPush setAccount:@"test"];
    //将device token转换为字符串
    //   NSString *deviceTokenStr1 = [NSString stringWithFormat:@"%@",deviceToken];
    //注册设备
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //如果不需要回调
    //[XGPush registerDevice:deviceToken];
    
    self.device_token=deviceTokenStr;
    
    //打印获取的deviceToken的字符串
    NSLog(@"[XGPush] deviceTokenStr is %@",deviceTokenStr);
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"[XGPush]%@",str);
    
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
    
    
    //回调版本示例
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleReceiveNotification successBlock");
        //  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleReceiveNotification errorBlock");
    };
    
    void (^completion)(void) = ^(void){
        //完成之后的处理
        NSLog(@"[xg push completion]userInfo is %@",userInfo);
        //   [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    };
    
    [XGPush handleReceiveNotification:userInfo successCallback:successBlock errorCallback:errorBlock completion:completion];
    
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

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

#pragma mark - login changed

- (void)loginStateChange:(NSNotification *)notification
{
    WinChageType * wtype =notification.object;
    
    EMNavigationController *navigationController = nil;
    if (wtype!=nil&&[wtype.lgointype isEqual:@"0"]) {//登陆成功加载主窗口控制器
       
    }
    else if (wtype!=nil&&[wtype.lgointype isEqual:@"1"]) {//
           [self initRootVC];
    }
  
    else if (wtype!=nil&&[wtype.lgointype isEqual:@"2"]) {//没有网络
        NoNetController *    webv=[[NoNetController alloc] init];
        
        navigationController = [[EMNavigationController alloc] initWithRootViewController:webv];
        self.window.backgroundColor = [UIColor clearColor];
        [self.window setRootViewController:navigationController];
        
        [self.window makeKeyAndVisible];
    }
     else if (wtype!=nil&&[wtype.lgointype isEqual:@"3"]) {//webview 页面
   HomeWebController *    webv=[[HomeWebController alloc] init];
   
    navigationController = [[EMNavigationController alloc] initWithRootViewController:webv];
    self.window.backgroundColor = [UIColor clearColor];
    [self.window setRootViewController:navigationController];
    [self.window makeKeyAndVisible];
    
     }
    //HomeWebController
    //设置7.0以下的导航栏
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0){
        navigationController.navigationBar.barStyle = UIBarStyleDefault;
        [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleBar"]
                                                 forBarMetrics:UIBarMetricsDefault];
        [navigationController.navigationBar.layer setMasksToBounds:YES];
        
    }
    
    
}


/**
 *  设置navigationBar样式
 */
- (void)setUpNavigationBarAppearance {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
        
        textAttributes = @{
                           NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                           NSForegroundColorAttributeName : [UIColor blackColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
        textAttributes = @{
                           UITextAttributeFont : [UIFont boldSystemFontOfSize:18],
                           UITextAttributeTextColor : [UIColor blackColor],
                           UITextAttributeTextShadowColor : [UIColor clearColor],
                           UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
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

-(void) getSystemConfigDara
{
    NSString *urlStr =  [NSString stringWithFormat:getSystemConfig,oyApiUrl,Update_Coding];
    
    NSData * data= [ggHttpFounction  synHttpGet:urlStr];
    if([ggHttpFounction getJsonIsOk:data])
    {
        NSDictionary * dir= [ggHttpFounction getJsonData1:data];
       
                 NSArray * allows=   [dir objectForKey:@"allow_domain"];
                  if([allows count]>0)
                  self.urlJumpList=[allows copy];
        _globed.register_txt= [dir objectForKey:@"register_txt"];
        _globed.register_link= [dir objectForKey:@"register_link"];
          NSArray * links=   [dir objectForKey:@"return_column_link"];
          if([links count]>0)
               self.needReturnList=[links copy];
        
        NSString * show_state=[NSString stringWithFormat:@"%@",[dir objectForKey:@"show_state"]];
        if([show_state isEqual:@"0"])
        {
            _IsUpdate=TRUE;
        }
    }
    else
    {
        
    }
}
/*
-(void) doGetSystemConfig{
    NSString *urlStr = @"";
    
    urlStr = @"http://appapi.tutujf.com/Api/Platform/GetSystemConfig";
  //  NSLog(@"urlStr:%@",urlStr);
    [PPNetworkHelper GET:urlStr parameters:nil success:^(id responseObject) {
        //请求成功
      //  NSDictionary *dic = [responseObject objectForKey:@"resultData"];
        NSString * resultStatus= [responseObject objectForKey:@"resultStatus"];
        
        if([resultStatus isEqual:@"0"])
        {
            NSArray * resultData= [responseObject objectForKey:@"resultData"];
            
         //   HttpDnsService *httpdns = [[HttpDnsService alloc] initWithAccountID:194445];//139450
            
            // 为HTTPDNS服务设置降级机制
        //    [httpdns setDelegateForDegradationFilter:self];
            // 允许返回过期的IP
         //   [httpdns setExpiredIPEnabled:YES];
            // 打开HTTPDNS Log，线上建议关闭
          //  [httpdns setLogEnabled:YES];
            
            
            if([resultData count]<1)
                self.urlJumpList = @[ @"www.tutujf.com", @"ufunds.ips.com.cn",@"lab.chinapnr.com",@"mertest.chinapnr.com"];
            else
                self.urlJumpList=[resultData copy];
            // NSArray* preResolveHosts = @[@"pic1cdn.igetget.com"];
            // 设置预解析域名列表
          //  [httpdns setPreResolveHosts: self.urlJumpList];
            
        }
       
        //[PPNetworkCache setHttpCache:responseObject URL:urlStr parameters:nil];
    } failure:^(NSError *error) {
        //请求失败
    }];
}
//
-(void) doGetReturnConfig{
    NSString *urlStr = @"";
    urlStr = @"http://appapi.tutujf.com/Api/Platform/GetConfig";
    //  NSLog(@"urlStr:%@",urlStr);
    [PPNetworkHelper GET:urlStr parameters:nil success:^(id responseObject) {
        //请求成功

        NSString * resultStatus= [responseObject objectForKey:@"resultStatus"];
        
        if([resultStatus isEqual:@"0"])
        {
            NSDictionary * resultData= [responseObject objectForKey:@"resultData"];
            NSArray * list=[resultData objectForKey:@"bak_url"];
            
            
            if([list count]>0)
                self.needReturnList=[list copy];
            // NSArray* preResolveHosts = @[@"pic1cdn.igetget.com"];
            
        }
        else{
            
            
        }
        //[PPNetworkCache setHttpCache:responseObject URL:urlStr parameters:nil];
    } failure:^(NSError *error) {
        //请求失败
        
    }];
}
*/
//
- (UINavigationController *)getNavigationCWithWindow:(UIWindow *)window;{
    UITabBarController *tabVC = (UITabBarController  *)window.rootViewController;
    UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
    return pushClassStance;
}


@end
