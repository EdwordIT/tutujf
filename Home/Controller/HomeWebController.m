//
//  HomeWebController.m
//  TTJF
//
//  Created by 占碧光 on 2017/4/21.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "HomeWebController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import "UIImageView+WebCache.h"
//#import "XGPush.h"
//#import "XGSetting.h"f
#import "MBProgressHUD+MP.h"
#import <MOBFoundation/MOBFoundation.h>
#import "AppDelegate.h"
#import "Utils.h"
#import "Base64.h"
#import "DESFunc.h"

#import "NetworkManager.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import "WinChageType.h"
#import "HttpSignCreate.h"

@interface HomeWebController ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    UIButton *backBtn;
    Boolean isLoad;
      Boolean isHonBao;
    NSString *  loadUrlStr;
    NSString * eventStr;
    UIView *  top;
    Boolean  isvistor;
    Boolean  iseditpswd;
    UIView *backBg;
    UIView *backTopBg;
    Boolean isTeshu;
    UIView *topline;
    NSString *  returnWebUrl;
    //  UIImageView *gifImageView ;
        Boolean isOpen;
}

@end
//static HttpDnsService *httpdns;
@implementation HomeWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    //[self loadPage1:@"http://www.xipuw.com/test.aspx"];
    if(_urlStr==nil||[_urlStr isEqual:@""])
    {
        _urlStr=[oyUrlAddress stringByAppendingString:@"/wap/member/index"];
        isTeshu=TRUE;
        
    }
    else
        isTeshu=FALSE;
    isLoad=FALSE;
    iseditpswd=FALSE;
    isvistor=FALSE;
    isHonBao=FALSE;
    //
    isOpen=FALSE;
    if(_isreturn==nil)
        _isreturn=@"0";
    if(_returnmain==nil)
        _returnmain=@"0";
    _urlStr=[_urlStr stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
    loadUrlStr=_urlStr;
    eventStr=@"";
    theAppDelegate.httplink=_urlStr;
    [self loadPage1:_urlStr];
    if([_returnmain isEqual:@"5"]&&[_urlStr isEqual:[oyUrlAddress stringByAppendingString:@"/wap/page/getPage?action=reportlist"]])
    {
        if(backBtn==nil)
        {
            backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            if(kDevice_Is_iPhoneX)
                backBtn.frame = CGRectMake(0, 20, 85, 64);
            else
                backBtn.frame = CGRectMake(0, 20, 65, 44);
            backBtn.backgroundColor=[UIColor clearColor];
            [backBtn addTarget:self action:@selector(OnBackBtn2) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:backBtn];
            
        }
        [backBtn setHidden:FALSE];
    }
    //自定义超时时间，默认15秒
    //httpdns.timeoutInterval = 15;
    
    // Do any additional setup after loading the view from its nib.
}
//可以在方法中，添加释放资源代码
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.context) {
        self.context[@"native"] = nil;
    }
}

//加载网页
- (void)loadPage1: (NSString *) urlstr {
    if(kDevice_Is_iPhoneX)
    {
        iWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 34, screen_width,screen_height-34)];
        iWebView.scrollView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }
    else
        iWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, screen_width,screen_height-20)];
    if(kDevice_Is_iPhoneX)
        backTopBg=[[UIView alloc] initWithFrame:CGRectMake(0, -34, screen_width, 34)];
    else
        backTopBg=[[UIView alloc] initWithFrame:CGRectMake(0, -20, screen_width, 20)];
    backTopBg.backgroundColor=RGB(14, 161, 245);
    [iWebView addSubview:backTopBg];
    
    
    iWebView.delegate=self;
    //伸缩内容适应屏幕尺寸
    iWebView.scalesPageToFit=YES;
    [iWebView setUserInteractionEnabled:YES];
    if(kDevice_Is_iPhoneX)
        topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 34)];
    else
        topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 20)];
    topline.backgroundColor =RGB(14,118,235);
    [topline setHidden:TRUE];
    //  line.contentMode = UIViewContentModeScaleAspectFill;
    //  line.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topline];
    
    NSString *oldAgent = [iWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"old agent :%@", oldAgent);
    
    //add my info to the new agent
    NSString *newAgent = [oldAgent stringByAppendingString:@"TutuBrowser"];
    NSLog(@"new agent :%@", newAgent);
    
    //regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];

    NSMutableString *cookies = [NSMutableString string];
    NSArray *tmp = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie * cookie in tmp) {
        [cookies appendFormat:@"%@=%@;",cookie.name,cookie.value];
    }
     NSMutableURLRequest *request ;
    NSURL *url = [[NSURL alloc] initWithString:urlstr];
    if([_returnmain isEqual:@"4"])
    {
        //加载请求的时候忽略缓存
        request =[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
    }
    else
    {
        request = [NSMutableURLRequest requestWithURL:url];
    }
    [request setHTTPShouldHandleCookies:YES];
    // 注入Cookie
    [request setValue:cookies forHTTPHeaderField:@"Cookie"];
 
    
  //  if(iOS11)
    {
        
        [request setValue:@"Mozilla/5.0 (iPhone; CPU iPhone like Mac OS X; zh-CN;) AppleWebKit/537.51.1 (KHTML, like Gecko) Mobile/14C92 TutuBrowser/1.1.1 Mobile AliApp(TUnionSDK/0.1.12) AliApp(TUnionSDK/0.1.12)" forHTTPHeaderField:@"User-Agent"];
        
    }
    
    
    [iWebView loadRequest:request];
    iWebView.scrollView.bounces = NO;
    [self.view addSubview:iWebView];
    
}



#pragma mark-UIWebViewDelegate
/**
 *WebView开始加载资源的时候调用（开始发送请求）
 */
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSString *  currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    currentURL=[currentURL stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
    if([_returnmain isEqual:@"3"])
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    if((!isLoad||[loadUrlStr isEqual:@""]))
    {
        loadUrlStr=currentURL;
        isLoad=TRUE;
        [MBProgressHUD showIconMessage:@"" ToView:self.view RemainTime:0.3];
    }
    
    
    NSLog(@"webViewDidStartLoad---");
    // [MBProgressHUD showMessage:@"正在加载···"];
    //   NSLog(@"%@", @"111111");
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 打印异常
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        //     NSLog(@"%@", exceptionValue);
    };
    // 以 JSExport 协议关联 native 的方法
    self.context[@"native"] = self;
}


-(void) OnBackBtn
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    });
    // [self dismissModalViewControllerAnimated:YES];
}
-(void) OnBackBtn2
{
    // [super.navigationController setNavigationBarHidden:NO animated:TRUE];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        if([_returnmain isEqual:@"3"])
            [self.tabBarController.tabBar setHidden:FALSE];
        if([_returnmain isEqual:@"4"])
            [self dismissViewControllerAnimated:YES completion:NULL];
        else
            [self.navigationController popViewControllerAnimated:YES];
    });
    // [self dismissModalViewControllerAnimated:YES];
}


-(void) OnBackBtn1
{
    [backBtn setHidden:TRUE];
    NSString * jumpUrl=[NSString stringWithFormat:@"window.location.href='%@';",[oyUrlAddress stringByAppendingString:@"/wap/member/account"]];
    [iWebView stringByEvaluatingJavaScriptFromString:jumpUrl];
    return;
    // [self dismissModalViewControllerAnimated:YES];
}

-(void)hideAdtCode
{
    
    NSString * jumpUrl=@"  var iframe = document.getElementById('iframea') ;   iframe.style = \"display:none\";  var iclose = document.getElementById('close') ;   iclose.style = \"display:none\"; ";
    [iWebView stringByEvaluatingJavaScriptFromString:jumpUrl];
}

-(void) loadDoURL:(UIWebView *)webView{
//    NSString* secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    _currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    _currentURL=[_currentURL stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
    if([_currentURL isEqual:@"about:blank"])
        _currentURL=self.urlStr;
    if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/member/bounty"]].location != NSNotFound)
    {
        isHonBao=TRUE;
    }
    //
    
    if ([_currentURL rangeOfString:@"tutujf.com/random/draw/wap2018jqygwdfd.html?ut="].location != NSNotFound&&[_urlStr rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/shopinteractive/shopLogin?action="]].location != NSNotFound&&isHonBao)
    {
       NSString * jumpUrl=[NSString stringWithFormat:@"window.location.href='%@';",_urlStr];
        [webView stringByEvaluatingJavaScriptFromString:jumpUrl];
        isHonBao=FALSE;
        return;
        
    }
    
    if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/member/myaccountdata"]].location != NSNotFound)
    {
        NSString * str=[_currentURL stringByReplacingOccurrencesOfString:@"https://" withString:@""];
        str=[str stringByReplacingOccurrencesOfString:@"http://" withString:@""];
        if([str isEqual:[urlCheckAddress stringByAppendingString:@"/wap/member/myaccountdata"]])
        {
            theAppDelegate.user_name=@"";
            theAppDelegate.user_token=@"";
            theAppDelegate.IsLogin=FALSE;
            [TTJFUserDefault removeStrForKey:kToken];
            [TTJFUserDefault removeArrForKey:kUsername];
            [self OnBackBtn2];
            return ;
        }
    }
       if([_currentURL isEqual:[oyUrlAddress stringByAppendingString:@"/wap"]]||[_currentURL isEqualToString:[oyUrlAddress stringByAppendingString:@"/wap"]])
    {
        theAppDelegate.xbindex=0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        return;
    }
    
    //www.tutujf.com/wap/back/backRecharge
    else if( [_currentURL rangeOfString:[oyUrlAddress stringByAppendingString:@"/wap/loan/loantender"]].location != NSNotFound)
    {
        /*
        if(theAppDelegate.tabindex==2)
        {
            theAppDelegate.tabindex=0;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            return ;
        }
        else{
         */
          theAppDelegate.xbindex=1;
    WinChageType * wtype=[[WinChageType alloc] init];
    wtype.lgointype=@"1"; //
    wtype.logindeep=@"0"; //初始化
        
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:wtype];
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
        return;
       // }
    }
    else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/system/login"]].location != NSNotFound||[_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/system/reglogin"]].location != NSNotFound)
    {
        
       // [self dismissViewControllerAnimated:YES completion:NULL];
        if([self.returnmain isEqual:@"4"])
        {
        //theAppDelegate.jumpLogin=@"1";
         [self dismissViewControllerAnimated:YES completion:NULL];
        }
        else
        {
            theAppDelegate.jumpLogin=@"1";
            theAppDelegate.IsLogin=FALSE;
            [TTJFUserDefault removeStrForKey:kToken];
            [TTJFUserDefault removeArrForKey:kUsername];
            theAppDelegate.user_name=@"";
            theAppDelegate.user_token=@"";
            [self cleanCaches];
        [self.navigationController popToRootViewControllerAnimated:YES];
        }
        return;
    }
    else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/member/index"]].location != NSNotFound&&![CommonUtils isLogin])
    {
        theAppDelegate.jumpLogin=@"1";
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    //http://
    else if([_urlStr rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/page/getPage?action=bribe"]].location != NSNotFound&&[_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/system/register2"]].location != NSNotFound&&[CommonUtils isLogin])
    {
        theAppDelegate.xbindex=3;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    else if([_urlStr rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/page/getPage?action=noviceguide"]].location != NSNotFound&&[_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/system/register2"]].location != NSNotFound&&[CommonUtils isLogin])
    {
        theAppDelegate.xbindex=3;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    //http://cs.www.tutujf.com/User/Token/Login?user_token=lxqsqezjepaokdawcgacjkqkdmgfmy&expiration_date=2019-01-06+13%3A04%3A15&sign=cfafe6c5c54737cf
      if([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/User/Token/Login?user_token="]].location!= NSNotFound)//web注册App同步登陆
   {
      //theAppDelegate.xbindex=3;
        NSMutableDictionary * dirlist= [HttpSignCreate getURLParameters:_currentURL];
       if([dirlist count]>0)//同步登陆
       {
             [MBProgressHUD showIconMessage:@"" ToView:self.view RemainTime:0.3];
         NSString * user_token=[dirlist objectForKey:kToken];
           NSString * expiration_date=[HttpSignCreate  decodeString:[dirlist objectForKey:@"expiration_date"]] ;
           expiration_date=[expiration_date stringByReplacingOccurrencesOfString:@"+" withString:@" "];
         NSString * sign=[dirlist objectForKey:@"sign"];
         NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[user_token,expiration_date] forKeys:@[kToken,@"expiration_date"] ];
               NSString *sign1=[HttpSignCreate GetSignStr:dict_data];
              if([sign1 isEqual:sign])
               {
                 theAppDelegate.IsLogin=TRUE;
                   [TTJFUserDefault setStr:user_token key:kToken];
                 theAppDelegate.IsWebRegdit=TRUE;
                 theAppDelegate.user_token=user_token;
                   dispatch_async(dispatch_get_main_queue(), ^{
                       WinChageType * wtype=[[WinChageType alloc] init];
                       wtype.lgointype=@"1"; //
                       wtype.logindeep=@"0"; //初始化
                       [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:wtype];
                   });
                   return;
               }
       }
   }

    if(isTeshu)
    {
        if([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/member/index"]].location == NSNotFound)
            isvistor=TRUE;
        else
            isvistor=FALSE;
        
        if(isvistor)
            self.view.frame=   CGRectMake(0, 0, screen_width,screen_height-48);
        else
            self.view.frame=   CGRectMake(0, 0, screen_width,screen_height);
    
    }
    if ([_currentURL rangeOfString:@".chinapnr.com"].location != NSNotFound)
    {
        topline.backgroundColor=RGB(255, 255, 255);
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [backTopBg setHidden:TRUE];
        [topline setHidden:FALSE];
        if ([_currentURL rangeOfString:@".chinapnr.com/muser/publicRequests"].location != NSNotFound)
        {
            backBtn=[[UIButton alloc] init];
            if(kDevice_Is_iPhoneX)
                backBtn.frame = CGRectMake(0, 20, 85, 64);
            else
                backBtn.frame = CGRectMake(0, 20, 65, 44);
            backBtn.backgroundColor=[UIColor clearColor];
            [backBtn addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
            UIImageView * imageview1=[[UIImageView alloc] init];
            imageview1.frame=CGRectMake(25, 15, 8, 16);
        //    http://cs.www.tutujf.com/wap/member/recharge
           //     if ([self.urlStr rangeOfString:@".tutujf.com/wap/member/recharge"].location == NSNotFound)
           // [imageview1 setImage:[UIImage imageNamed:@"Signup_iceo_return"] ] ;
            [backBtn addSubview:imageview1];
            [self.view addSubview:backBtn];
        }
    }
    else
    {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [backTopBg setHidden:FALSE];
       
    }
    
    if ([_currentURL isEqualToString:@"https://lab.chinapnr.com"])
    {
        [backTopBg setHidden:TRUE];
        [topline setHidden:FALSE];
        iWebView.frame = CGRectMake(0, 20, screen_width,screen_height-20);
        topline.backgroundColor=RGB(255,255,255);
        self.tabBarController.tabBar.hidden=YES;
        if([_urlStr rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/member/index"]].location == NSNotFound )
            [self setReturnBack];
        
    }
    else if ([_currentURL rangeOfString:@".tutujf.com/wap/member/backRecharge"].location != NSNotFound)
    {
        topline.backgroundColor=RGB(14, 161, 245);
        backBtn=[[UIButton alloc] init];
        if(kDevice_Is_iPhoneX)
            backBtn.frame = CGRectMake(0, 20, 85, 64);
        else
            backBtn.frame = CGRectMake(0, 20, 65, 44);
        backBtn.backgroundColor=[UIColor clearColor];
        [backBtn addTarget:self action:@selector(returnBack1) forControlEvents:UIControlEventTouchUpInside];
    }

    else  if([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/member/index"]].location != NSNotFound)
    {
        if([_returnmain isEqual:@"4"])//注册跳转
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:NULL];
            });
        }
        else
        {
            theAppDelegate.xbindex=3;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    }
    else  if ([_currentURL isEqualToString:[oyUrlAddress stringByAppendingString:@"/wap"]]||[_currentURL rangeOfString:@".tutujf.com/wap/member/exit"].location != NSNotFound)//
    {
        if([_currentURL rangeOfString:@".tutujf.com/wap/member/exit"].location != NSNotFound)
        {
            theAppDelegate.IsLogin=FALSE;
            [TTJFUserDefault removeStrForKey:kToken];
            [TTJFUserDefault removeStrForKey:kUsername];
            theAppDelegate.user_name=@"";
            theAppDelegate.user_token=@"";
        }
        WinChageType * wtype=[[WinChageType alloc] init];
        wtype.lgointype=@"1"; //
        wtype.logindeep=@"0"; //初始化
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:wtype];
        return ;
    }

    
    else{
        [topline setHidden:FALSE];
        self.tabBarController.tabBar.hidden=YES;
        if(kDevice_Is_iPhoneX)
            iWebView.frame = CGRectMake(0, 34, screen_width,screen_height-34);
        else
            iWebView.frame = CGRectMake(0, 20, screen_width,screen_height-20);
        if([_urlStr rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/member/index"]].location == NSNotFound )
            [self setReturnBack];
        
        //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
        if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/transfer/transferList"]].location != NSNotFound||[_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/borrow/applyborrow"]].location != NSNotFound)
        {
            
            topline.backgroundColor=RGB(14, 161, 245);
        }
        //
        else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/system/reglogin"]].location != NSNotFound)
        {
            topline.backgroundColor=RGB(238,238,238);
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
        else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/system/login"]].location != NSNotFound)
        {
            topline.backgroundColor=RGB(14,142,235);
        }
        else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/member/account"]].location != NSNotFound)
        {
            topline.backgroundColor=RGB(14, 161, 245);
        }
        else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/member/updatephoneone"]].location != NSNotFound)
        {
            topline.backgroundColor=RGB(14,142,235);
        }
        else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/member/checkEmail"]].location != NSNotFound)
        {
            topline.backgroundColor=RGB(14,142,235);
        }
        else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/member/approveRealname"]].location != NSNotFound)
        {
            topline.backgroundColor=RGB(14,142,235);
        }
        else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/member/recharge"]].location != NSNotFound)
        {
            topline.backgroundColor=RGB(14, 161, 245);
        }
    
        
        else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/system/register2"]].location != NSNotFound)
        {
            topline.backgroundColor=RGB(14, 161, 245);
        }
        else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/member/index"]].location != NSNotFound)
        {
            topline.backgroundColor=RGB(14, 161, 245);
        }
        else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/account/accountLog"]].location != NSNotFound)
        {
            topline.backgroundColor=RGB(14, 161, 245);
        }
        else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/message/list"]].location != NSNotFound)
        {
            topline.backgroundColor=RGB(14, 161, 245);
        }
        
        else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/system/searchPwd"]].location != NSNotFound)
        {
            topline.backgroundColor=RGB(14, 161, 245);
        }
        //
        else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/loan/loaninfoview"]].location != NSNotFound)
        {
            topline.backgroundColor=RGB(14, 161, 245);
        }
        /*
        else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/member/editpwd"].location != NSNotFound)
        {
            topline.backgroundColor=RGB(14, 161, 245);
            theAppDelegate.IsLogin=FALSE;
            theAppDelegate.user_token=@"";
            theAppDelegate.user_name=@"";
        }
        */
        else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/bank/index"]].location != NSNotFound)
        {
            topline.backgroundColor=RGB(14, 161, 245);
        }
        else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/member/myaccountdata"]].location != NSNotFound)
        {
            topline.backgroundColor=RGB(14, 161, 245);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/spread/myqrcode"]].location != NSNotFound)
        {
            topline.backgroundColor=RGB(14, 161, 245);
        }
        else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/page/getPage"]].location != NSNotFound||[_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/system/reglogin"]].location != NSNotFound||[_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/articles/articlesDetail"]].location != NSNotFound||[_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/loan/tenderLoanview"]].location != NSNotFound)//
        {
            topline.backgroundColor=RGB(14, 161, 245);
        }
        else if([_currentURL isEqual:[oyUrlAddress stringByAppendingString:@"/#"]])
        {
            NSString * jumpUrl=[NSString stringWithFormat:@"window.location.href='%@';",[oyUrlAddress stringByAppendingString:@"/wap"]];
            [webView stringByEvaluatingJavaScriptFromString:jumpUrl];
            return;
        }
        else if ([_currentURL rangeOfString:@"https://ufunds.ips.com.cn/p2p-deposit/gateway.htm"].location != NSNotFound||[_currentURL rangeOfString:@"https://ufunds.ips.com.cn/p2p-deposit/login.html"].location != NSNotFound||[_currentURL rangeOfString:@"https://ufunds.ips.com.cn/p2p-deposit/user/accountviews.html"].location != NSNotFound||[_currentURL rangeOfString:@".chinapnr.com/muser/password/loginpwd/lpCheckLoginInfo"].location!= NSNotFound||[_currentURL rangeOfString:@".chinapnr.com/muser/QUERY/0100/"].location!= NSNotFound ||[self IsNeedBack:_currentURL])
        {
            if(backBtn==nil)
            {
               //
                backBtn=[[UIButton alloc] init];
                if(kDevice_Is_iPhoneX)
                    backBtn.frame = CGRectMake(0, 20, 85, 64);
                else
                    backBtn.frame = CGRectMake(0, 20, 65, 44);
                [backBtn addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
                // iWebView.frame =CGRectMake(0, 64, screen_width, screen_height-64);
                UIImageView * imageview1=[[UIImageView alloc] init];
                imageview1.frame=CGRectMake(25, 15, 8, 16);
                [imageview1 setImage:[UIImage imageNamed:@"Signup_iceo_return"] ] ;
                [backBtn addSubview:imageview1];
                
                [self.view addSubview:backBtn];
            }
            else
                [backBtn setHidden:FALSE];
            if ([_currentURL rangeOfString:@".chinapnr.com"].location != NSNotFound)
            {
                topline.backgroundColor=RGB(255, 255, 255);
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            }
            else
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }
        else{
            if(backBtn!=nil&&![_currentURL isEqual:_urlStr])
                [backBtn setHidden:TRUE];
        }
    }
    if ([_currentURL rangeOfString:@"?bak=close"].location != NSNotFound) {
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(kDevice_Is_iPhoneX)
            backBtn.frame = CGRectMake(0, 20, 85, 64);
        else
            backBtn.frame = CGRectMake(0, 20, 65, 44);
        backBtn.backgroundColor=[UIColor clearColor];
        [backBtn addTarget:self action:@selector(OnBackBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
        
    }
    
    //
    
}

-(BOOL) IsNeedBack:(NSString *) urlstr{
    if([theAppDelegate.needReturnList count]>0)
    {
        for(int k=0;k<[theAppDelegate.needReturnList count];k++)
        {
            if ( [ urlstr rangeOfString:[theAppDelegate.needReturnList objectAtIndex:k]].location != NSNotFound)
            {
                return TRUE;
            }
        }
        
    }
    
    return  FALSE;
}


-(void) setReturnBack
{
    
    if([_returnmain isEqual:@"5"]&&[_currentURL isEqual:_urlStr])
    {
        if(backBtn==nil)
        {
            backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            if(kDevice_Is_iPhoneX)
                backBtn.frame = CGRectMake(0, 20, 85, 64);
            else
                backBtn.frame = CGRectMake(0, 20, 65, 44);
            backBtn.backgroundColor=[UIColor clearColor];
            [backBtn addTarget:self action:@selector(OnBackBtn2) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:backBtn];
            
        }
        [backBtn setHidden:FALSE];
    }
    else if([_returnmain isEqual:@"3"]&&[_currentURL isEqual:_urlStr])
    {
        if(backBtn==nil)
        {
            backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            if(kDevice_Is_iPhoneX)
                backBtn.frame = CGRectMake(0, 20, 85, 64);
            else
                backBtn.frame = CGRectMake(0, 20, 65, 44);
            backBtn.backgroundColor=[UIColor clearColor];
            [backBtn addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:backBtn];
            
        }
        [backBtn setHidden:FALSE];
    }
    else if([_returnmain isEqual:@"4"]&&[_currentURL isEqual:_urlStr])
    {
        if(backBtn==nil)
        {
            backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            if(kDevice_Is_iPhoneX)
                backBtn.frame = CGRectMake(0, 20, 85, 64);
            else
                backBtn.frame = CGRectMake(0, 20, 65, 44);
            backBtn.backgroundColor=[UIColor clearColor];
            [backBtn addTarget:self action:@selector(OnBackBtn2) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:backBtn];
            
        }
        [backBtn setHidden:FALSE];
    }
    else{
        [backBtn setHidden:TRUE];
    }
}
-(void)returnBack1
{
        [[self navigationController] popToRootViewControllerAnimated:YES];
        return;
}
-(void)returnBack
{
   
        if(isTeshu)
        {
            [[self navigationController] popToRootViewControllerAnimated:YES];
            return;
        }
        if(!iWebView.canGoBack)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationController.navigationBarHidden = NO;
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        else
        {
            if ([self.urlStr rangeOfString:@"/wap/member/verifyTrustReg"].location != NSNotFound)
           {
                     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
               [self.navigationController popToRootViewControllerAnimated:YES];
           }
            else if( [_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/back/backRecharge"]].location != NSNotFound)
            {
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
         else   if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/back/backWithdraw"]].location != NSNotFound)
            {
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else if([_currentURL rangeOfString:@"tutujf.com/random/draw/wap2018jqygwdfd.html?ut="].location != NSNotFound)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.navigationController.navigationBarHidden = NO;
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
           
            else
            {
            NSString * jumpUrl=@"window.history.go(-1);";
            [iWebView stringByEvaluatingJavaScriptFromString:jumpUrl];
            }
        }
    
        
   
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    // 添加请求头信息
  //NSString * url =request.URL.absoluteString;
    if(!isOpen)
    {
        isOpen=TRUE;
        if([_returnmain isEqual:@"3"]&&backBg==nil)
        {
            backBg = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 65, 44)];
            if(kDevice_Is_iPhoneX)
                backBg.frame = CGRectMake(0, 20, 85, 64);
            backBg.backgroundColor =[UIColor clearColor];
            backBg.tag=2;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnBack)];
            [backBg addGestureRecognizer:tap];
            
            [self.view addSubview:backBg];
        }
       [self loadDoURL:webView];
    }
    
    return YES;
}
/**
 *WebView加载完毕的时候调用（请求完毕）
 */
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
     isOpen=FALSE;
     [self loadDoURL:webView];
    if(webView.isLoading)
    {
        return;
    }
    isLoad=FALSE;
    loadUrlStr=_currentURL;
    theAppDelegate.httplink=_currentURL;
    __weak typeof(self) weakSelf = self;
    
    self.context[@"HuanXunZHifu"] =
    ^(NSString *payinfo,NSString *sign)
    {
        //lWlkorKMYm2vb9pR9I8TbD9nUnv1jvRX
        NSData *data = [[NSData alloc] initWithBase64EncodedString:payinfo options:0];
        NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        // [self loadPage1:_urlStr];
        NSDictionary * dir= [weakSelf dictionaryWithJsonString:text];
        if(dir!=nil&&dir.count>0)
        {
            NSString * merBillNo=[dir objectForKey:@"merBillNo"];
            NSString * ipsAcctNo=[dir objectForKey:@"ipsAcctNo"];
            NSString * trdAmt=[dir objectForKey:@"trdAmt"];
            NSString * channelType=[dir objectForKey:@"channelType"];
            NSString * bankCode=[dir objectForKey:@"bankCode"];
//            NSString * depositType=[dir objectForKey:@"depositType"];
            
            NSString * ipsFeeType=[dir objectForKey:@"ipsFeeType"];
            NSString * userType=[dir objectForKey:@"userType"];
            NSString * merDate=[dir objectForKey:@"merDate"];
            NSString * merFee=[dir objectForKey:@"merFee"];
            NSString * merFeeType=[dir objectForKey:@"merFeeType"];
            NSString * taker=[dir objectForKey:@"taker"];
            NSString * weburl=[dir objectForKey:@"webUrl"];
            
            NSMutableDictionary * dir=[[NSMutableDictionary alloc] init];
            [dir setObject:merBillNo forKey:@"merBillNo"];
            [dir setObject:merDate forKey:@"merDate"];
            [dir setObject:trdAmt forKey:@"trdAmt"];
            [dir setObject:channelType forKey:@"channelType"];
            [dir setObject:bankCode forKey:@"bankCode"];
            [dir setObject:userType forKey:@"userType"];
            
            [dir setObject:ipsAcctNo forKey:@"ipsAcctNo"];
            [dir setObject:trdAmt forKey:@"trdAmt"];
            [dir setObject:ipsFeeType forKey:@"ipsFeeType"];
            [dir setObject:merFee forKey:@"merFee"];
            [dir setObject:merFeeType forKey:@"merFeeType"];
            [dir setObject:taker forKey:@"taker"];
            [dir setObject:weburl forKey:@"webUrl"];
            
//            NSArray *array = [NSArray arrayWithObjects:@"merBillNo",@"merDate",@"trdAmt",@"channelType",@"bankCode",@"userType",@"ipsAcctNo",@"trdAmt",@"ipsFeeType",@"merFee",@"merFeeType",@"taker",@"webUrl", nil];
            
//            NSString * signstr=[HttpSignCreate1 GetSignStr:dir array:array];
            
        }
        
        
    };
    
    
    self.context[@"StartShare"] =
    ^(NSString *title
      ,NSString *img_url
      ,NSString *link_url
      ,NSString *desc
      ,NSString *callback)
    {
        [weakSelf showShareActionSheet:title Img_url:img_url Link_url:link_url Desc:desc Callback:callback];
        
    };
    
    //获取设备信息
    self.context[@"GetTerminalId"] =
    ^(NSString *callback)
    {
        NSString * state=@"1";
        NSString * terminal_type=@"ios";
        UIDevice *device = [[UIDevice alloc] init];
        if(device==nil)
            state=@"0";
//        NSString *type = device.localizedModel; //获取本地化版本
        NSString *terminal_id = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *terminal_name = device.systemName;      //获取设备的类别
        NSString *terminal_model=device.systemVersion;
        NSString *msg=@"";
        
        // NSLog(@"%@", order);
        // [self getSubmitZFB:order price:price subject:subject paytype:paytype];
        NSString *func=callback;
        
        func= [func stringByAppendingString:@"('"];
        func= [func stringByAppendingString:state];
        func= [func stringByAppendingString:@"',"];
        func= [func stringByAppendingString:@"'"];
        func= [func stringByAppendingString:terminal_type];
        func= [func stringByAppendingString:@"',"];
        
        func= [func stringByAppendingString:@"'"];
        func= [func stringByAppendingString:terminal_id];
        func= [func stringByAppendingString:@"',"];
        func= [func stringByAppendingString:@"'"];
        func= [func stringByAppendingString:terminal_name];
        func= [func stringByAppendingString:@"',"];
        
        func= [func stringByAppendingString:@"'"];
        func= [func stringByAppendingString:terminal_model];
        func= [func stringByAppendingString:@"',"];
        func= [func stringByAppendingString:@"'"];
        func= [func stringByAppendingString:msg];
        func= [func stringByAppendingString:@"')"];
        [weakSelf.context evaluateScript:func];
        
        
        
    };
    //var browserVersion="web";
    /*
     (NSString *)platform
     Order_no:(NSString *)order_no
     Order_amount:(NSString *)order_amount
     Pay_subject:(NSString *)pay_subject
     Return_url:(UIImage *)return_url
     */
    
    
    // __block typeof(self) weakSelf = self; fenxiang
    
    self.context[@"JPushMsg"] =
    ^(NSString *msg)
    {
        NSString *func=msg;
        func= [func stringByAppendingString:@"('参数A')"];
        [weakSelf.context evaluateScript:func];
        //[weakSelf JiguangPush:msg];
    };
    
    if([_currentURL isEqual:[oyUrlAddress stringByAppendingString:@"/wap"]]&&![theAppDelegate.webJump isEqual:@""])
    {
        NSString * jumpUrl=[NSString stringWithFormat:@"window.location.href='%@';",theAppDelegate.webJump];
        theAppDelegate.webJump=@"";
        [webView stringByEvaluatingJavaScriptFromString:jumpUrl];
        return;
    }
    //
    
    
}

- (void)showShareActionSheet:(NSString *) titlecontent Img_url:(NSString *) img_url Link_url:(NSString *) link_url Desc:(NSString *) desc Callback:(NSString *) callback{
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.backgroundColor = [UIColor grayColor];
    
    _callbackShare=callback;
    //每个平台的分享参数、分享类型不同，具体可根据需求调整。
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL * url = [NSURL URLWithString:img_url];
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc]initWithData:data];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // img.image = image;
                
                NSArray *imageArray = @[image];
                if (imageArray) {
                    [shareParams SSDKSetupShareParamsByText:desc
                                                     images:imageArray
                                                        url:[NSURL URLWithString:link_url]
                                                      title:titlecontent
                                                       type:SSDKContentTypeAuto];
                }
                [self shareDoOperate:shareParams shareButton:shareButton];
            });
        }
    });
    
    
    
}

-(void) shareDoOperate:(NSMutableDictionary * )shareParams shareButton:(UIButton *)shareButton
{
    
    //系统自带的分享菜单存在顺序错乱BUG（未解决），此处采用自定义方式
    NSMutableArray *activePlatforms = [[NSMutableArray alloc]init];
    for (int i=0; i<4; i++) {
        NSString *imageName = @"";
        NSString *labText = @"";
        SSDKPlatformType type = SSDKPlatformTypeUnknown;
        if (i==0) {
            imageName = @"sns_icon_22_s.png";
            labText = @"微信好友";
            type = SSDKPlatformSubTypeWechatSession;
        } else if (i==1) {
            imageName = @"sns_icon_23_s.png";
            labText = @"微信朋友圈";
            type = SSDKPlatformSubTypeWechatTimeline;
        } else if (i==2) {
            imageName = @"sns_icon_24_s.png";
            labText = @"QQ好友";
            type = SSDKPlatformSubTypeQQFriend;
        } else if (i==3) {
            imageName = @"sns_icon_6_s.png";
            labText = @"QQ空间";
            type = SSDKPlatformSubTypeQZone;
        }
        /*
         else if (i==4) {
         imageName = @"sns_icon_19_s.png";
         labText = @"短信";
         type = SSDKPlatformTypeSMS;
         } else if (i==5) {
         imageName = @"sns_icon_21_s.png";
         labText = @"复制链接";
         type = SSDKPlatformTypeCopy;
         }
         */
        SSUIShareActionSheetCustomItem *item = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:imageName]
                                                                                      label:labText
                                                                                    onClick:^{
                                                                                        [self shareInfoWithType:type andParameters:shareParams];
                                                                                    }];
        [activePlatforms addObject:item];
    }
    
    //显示分享菜单
    [ShareSDK showShareActionSheet:shareButton items:activePlatforms shareParams:shareParams onShareStateChanged:nil];
}

- (void)shareInfoWithType:(SSDKPlatformType)type andParameters:(NSMutableDictionary *)shareParams {
    [ShareSDK share:type
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         NSString *messageTitle;
         switch (state) {
             case SSDKResponseStateSuccess: {
                 if (type == SSDKPlatformTypeCopy) {
                     messageTitle = @"复制成功";
                 }
                 else {
                     messageTitle = @"分享成功";
                     
                 }
                 NSString *func=_callbackShare;
                 func= [func stringByAppendingString:@"("];
                 func= [func stringByAppendingString:@"1"];
                 func= [func stringByAppendingString:@","];
                 func= [func stringByAppendingString:@"'"];
                 func= [func stringByAppendingString:messageTitle];
                 func= [func stringByAppendingString:@"')"];
                 [self.context evaluateScript:func];
                 NSLog(@"shareSDK:成功");
                 break;
             }
             case SSDKResponseStateFail: {
                 messageTitle = @"分享失败";
                 NSLog(@"shareSDK:失败:%@",error);
                 NSString *func=_callbackShare;
                 func= [func stringByAppendingString:@"("];
                 func= [func stringByAppendingString:@"0"];
                 func= [func stringByAppendingString:@","];
                 func= [func stringByAppendingString:@"'"];
                 func= [func stringByAppendingString:messageTitle];
                 func= [func stringByAppendingString:@"')"];
                 [self.context evaluateScript:func];
                 
                 
                 break;
             }
             case SSDKResponseStateCancel: {
                 NSLog(@"shareSDK:取消");
                 NSString *func=_callbackShare;
                 func= [func stringByAppendingString:@"("];
                 func= [func stringByAppendingString:@"2"];
                 func= [func stringByAppendingString:@","];
                 func= [func stringByAppendingString:@"'"];
                 func= [func stringByAppendingString:@"取消"];
                 func= [func stringByAppendingString:@"')"];
                 [self.context evaluateScript:func];
                 break;
             }
             default:
                 break;
         }
         if (messageTitle) {
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:messageTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
             [alertController addAction:cancelAction];
             [self presentViewController:alertController animated:YES completion:nil];
         }
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */




-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 *  清理缓存
 */
// 根据路径删除文件  删除cookies文件

- (void)cleanCaches{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}

@end

