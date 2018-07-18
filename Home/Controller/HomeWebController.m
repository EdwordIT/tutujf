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
#import "MBProgressHUD+MP.h"
#import <MOBFoundation/MOBFoundation.h>
#import "AccountInfoController.h"//个人资料详情
#import "RegisterViewController.h"//注册
#import "ForgetPasswordViewController.h"//忘记密码
#import "ProgrameDetailController.h"//项目详情
#import "RushPurchaseController.h"//快速投资
#import "GetCashController.h"//提现页面
#import "GetCashRecordController.h"//提现记录页面
#import "RechargeController.h"//充值页面
#import "RechargeRecordController.h"//充值记录页面
#import "MyInvestController.h"//我的投资页面
#import "TransferListController.h"//我的债权转让页面
#import "MyRegAccountController.h"//我的托管账号页面
#import "MyBankCardController.h"//我的银行卡页面
#import "RealNameController.h"//实名认证
#import "MyPaybackController.h"//我的回款计划
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import "ChangePasswordViewController.h"
@interface HomeWebController ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate,WKNavigationDelegate,WKScriptMessageHandler>
Strong WKWebView *mainWebView;
//Strong UIProgressView *progressView;
Copy NSString *callBack;//分享之后回调方法，写入js的方法名
Copy NSString *  returnWebUrl;//如果有标记特殊返回页面
Strong UIButton *closeBtn;//关闭当前页面
Strong UIButton *refreshBtn;//刷新页面（清除页面缓存，保留cookie）
Assign NSInteger step;//外部链接跳转内部链接再跳转内部链接，此字段才会起作用

@end
@implementation HomeWebController
- (void)dealloc {
    [[_mainWebView configuration].userContentController removeScriptMessageHandlerForName:@"openShare"];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNav];

    
    if(_urlStr==nil||[_urlStr isEqual:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"链接错误"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.view addSubview:self.mainWebView];
    self.step = 10;
    [SVProgressHUD show];
//    _urlStr = @"https://cs.www.tutujf.com/wap/test/agenttest";//测试连接
    //添加ios客户端标识
    if ([_urlStr rangeOfString:@"equipment=ios"].location==NSNotFound) {
        [self refreshUrl:_urlStr];
    }else{
        [self loadRequest:_urlStr];
    }
}
-(void)loadNav
{
    self.titleString = @"土土金服";

    self.closeBtn = InitObject(UIButton);
    [self.titleView addSubview:self.closeBtn];
    [self.closeBtn setImage:IMAGEBYENAME(@"icons_close") forState:UIControlStateNormal];
    [self.closeBtn setHidden:YES];
    self.closeBtn.adjustsImageWhenHighlighted = NO;
    [self.closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.mas_equalTo(self.backBtn);
        make.left.mas_equalTo(self.backBtn.mas_right).offset(kSizeFrom750(10));
    }];
    //刷新按钮，清除缓存，保留cookie，并且刷新页面
    [self.rightBtn setHidden:NO];
    self.refreshBtn = self.rightBtn;
    [self.refreshBtn setImage:IMAGEBYENAME(@"icons_refresh") forState:UIControlStateNormal];
    [self.refreshBtn addTarget:self action:@selector(refreshBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(WKWebView *)mainWebView{
    if (!_mainWebView) {

        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        // WKWebView的配置
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        //js调用OC的内容名称注册
        [userContentController addScriptMessageHandler:self name:@"openShare"];//分享
        //对应前端js中调用时候要使用
       //  window.webkit.messageHandlers.openShare.postMessage({body: 'hello world!'});

        _mainWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, kNavHight, screen_width,kViewHeight) configuration:configuration];
        _mainWebView.navigationDelegate = self;
        [_mainWebView setUserInteractionEnabled:YES];
        _mainWebView.backgroundColor = separaterColor;
        // 获取默认User-Agent
        [_mainWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            NSString *oldAgent = result;
            NSString *typeString = [NSString stringWithFormat:@"TutuBrowser/%@",kVersion_Coding];
            if ([oldAgent rangeOfString:typeString].location!=NSNotFound) {
                return ;
            }
            // 给User-Agent添加额外的信息
            NSString *newAgent = [NSString stringWithFormat:@"%@;%@", oldAgent, typeString];
            // 设置global User-Agent
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newAgent, @"UserAgent", nil];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];

        }];
        
    }
    return _mainWebView;
}
#pragma mark --buttonClick
-(void)refreshBtnClick:(UIButton *)sender{
    [SVProgressHUD show];
    if ([UIDevice currentDevice].systemVersion.doubleValue<9.0) {//ios9以下清除缓存
        NSURLCache * cache = [NSURLCache sharedURLCache];
        
        [cache removeAllCachedResponses];
        
        [cache setDiskCapacity:0];
        
        [cache setMemoryCapacity:0];
    }else{
        //清除的缓存类型
        NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                
                                WKWebsiteDataTypeDiskCache,
                                
                                //WKWebsiteDataTypeOfflineWebApplicationCache,
                                
                                WKWebsiteDataTypeMemoryCache,
                                
                                //WKWebsiteDataTypeLocalStorage,
                                
                                //WKWebsiteDataTypeCookies,
                                
                                //WKWebsiteDataTypeSessionStorage,
                                
                                //WKWebsiteDataTypeIndexedDBDatabases,
                                
                                //WKWebsiteDataTypeWebSQLDatabases
                                
                                ]];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:[NSDate dateWithTimeIntervalSince1970:0] completionHandler:^{
            
        }];
    
    }
    
    [self loadRequest:self.mainWebView.URL.absoluteString];
}
//回退按钮点击（需要判断回退内容）
-(void)backPressed:(UIButton *)sender{
    /*
     点击返回按钮，可能三种状态：1、正常返回 2、越过上一页面，返回 3、跳转到某一链接(此链接不再走正常返回)
     appbakurl=https%3a%2f%2fcs.www.tutujf.com%2f    跳转指定的H5页面
     appbakurl=close_page    关闭H5返回原生
     appbakurl=index    跳转到最初页面
     */
    if ([self.mainWebView canGoBack]) {
        
        NSString *currentUrl = self.mainWebView.URL.absoluteString;
        if ([currentUrl rangeOfString:@"appbakurl="].location!=NSNotFound) {
            NSString *resaultUrl = [[currentUrl componentsSeparatedByString:@"appbakurl="] lastObject];
            NSLog(@"resaultUrl = %@",[resaultUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
            if ([resaultUrl isEqualToString:@"close_page"]) {
                [self.mainWebView stopLoading];
                if (self.isJumped) {//从实名认证跳转进来
                    NSArray *vcs = self.navigationController.viewControllers;
                    //跳过中间的实名认证页面返回上上层
                    [self.navigationController popToViewController:[vcs objectAtIndex:vcs.count-2] animated:YES];
                }else
                [self.navigationController popViewControllerAnimated:YES];//跳转原生
            }else if([resaultUrl isEqualToString:@"index"])
            {
                [self.mainWebView goToBackForwardListItem:[[self.mainWebView.backForwardList backList] firstObject]];//返回到最初的H5页面
            }else{
                [self loadRequest:[resaultUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//跳转到指定页面
            }
        }else{
            //A→B→C
            NSURL *back = [self.mainWebView.backForwardList backItem].URL;//后退的URL(上一个界面)
            if ([back.absoluteString rangeOfString:@"appatc=jump"].location!=NSNotFound) {
                NSArray *backList = [self.mainWebView.backForwardList backList];
                //跳过B界面直接返回A界面
                if (backList.count>1) {
                    [self.mainWebView goToBackForwardListItem:[backList objectAtIndex:backList.count-2]];
                }else{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }else{
                [self.mainWebView goBack];
            }
        }
    }else{
        [self.mainWebView stopLoading];
        if (self.isJumped) {//从实名认证跳转进来
            NSArray *vcs = self.navigationController.viewControllers;
            //跳过中间页面返回上上层
            [self.navigationController popToViewController:[vcs objectAtIndex:vcs.count-2] animated:YES];
        }else
            [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)closeBtnClick:(UIButton *)sender
{
     [self.mainWebView stopLoading];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --BackToOriginal
/**
 校验链接是否跳转到原生态页面
 */
-(void)checkIsGoOriginal:(NSURLRequest *)request
{
    NSString *urlPath =  request.URL.absoluteString;
    //跳转到系统原生页面
    if ([urlPath rangeOfString:@"tutujf:home"].location!=NSNotFound) {
        [self.mainWebView stopLoading];
        /**
         tutujf:home.index    跳转首页
         tutujf:home.loantender    跳转投资项目页
         tutujf:home.findactivity    跳转发现页
         tutujf:home.memberindex    跳转我的页面
         tutujf:home.myaccountdata    跳转我的帐号设置页面（我的》点击头像）
         tutujf:home.editpwd    跳转修改密码页面
         tutujf:home.login    跳转登录页面
         tutujf:home.register    跳转注册页面
         tutujf:home.seekpwd    跳转找回密码页面
         tutujf:home.loaninfoview?loan_id=636    跳转项目详情页，loan_id为项目ID
         tutujf:home.tenderloanview?loan_id=636    跳转项目购买页，loan_id为项目ID
         */
        
        UINavigationController *nav = self.navigationController;
        
        if ([urlPath rangeOfString:@"tutujf:home.index"].location!=NSNotFound) {
            //跳转首页
            self.tabBarController.selectedIndex = 0;
            
            [nav popToRootViewControllerAnimated:YES];
        }
       else if ([urlPath rangeOfString:@"tutujf:home.loantender"].location!=NSNotFound) {
            //跳转投资列表页
            self.tabBarController.selectedIndex = 1;
            
            [nav popToRootViewControllerAnimated:YES];
            
        }
       else if ([urlPath rangeOfString:@"tutujf:home.findactivity"].location!=NSNotFound) {
            //跳转发现页面
            self.tabBarController.selectedIndex = 2;
            
            [nav popToRootViewControllerAnimated:YES];
            
        }
       else if ([urlPath rangeOfString:@"tutujf:home.memberindex"].location!=NSNotFound) {
            // 跳转我的页面
            self.tabBarController.selectedIndex = 3;
            
            [nav popToRootViewControllerAnimated:YES];
            
            
        }
       else if ([urlPath rangeOfString:@"tutujf:home.myaccountdata"].location!=NSNotFound) {
            // 跳转我账号详情页面
            self.tabBarController.selectedIndex = 3;
            UINavigationController *selNav = [self.tabBarController.viewControllers objectAtIndex:3];
            AccountInfoController *account = InitObject(AccountInfoController);
            account.isBackToRootVC = YES;
            [selNav pushViewController:account animated:YES];
            //首页还是要返回到主页面，防止页面切换
            [nav popToRootViewControllerAnimated:NO];
            
        }
       else if ([urlPath rangeOfString:@"tutujf:home.editpwd"].location!=NSNotFound) {
            [nav popToRootViewControllerAnimated:NO];//退回到根视图，之后再决定跳转
            //跳转修改密码页面
            ChangePasswordViewController *forget = InitObject(ChangePasswordViewController);
            forget.isBackToRootVC = YES;
            [self.navigationController pushViewController:forget animated:YES];
            
        }
       else if ([urlPath rangeOfString:@"tutujf:home.login"].location!=NSNotFound) {
            //跳转登录页面
            [self goLoginVC];
            [nav popToRootViewControllerAnimated:NO];
        }
       else if ([urlPath rangeOfString:@"tutujf:home.register"].location!=NSNotFound) {
            [nav popToRootViewControllerAnimated:NO];//退回到根视图，之后再决定跳转
            //跳转注册页面
            RegisterViewController *regis = InitObject(RegisterViewController);
            regis.isBackToRootVC = YES;
            [nav pushViewController:regis animated:YES];
            
        }
       else if ([urlPath rangeOfString:@"tutujf:home.seekpwd"].location!=NSNotFound) {
            [nav popToRootViewControllerAnimated:NO];//退回到根视图，之后再决定跳转
            //跳转找回密码页面
            ForgetPasswordViewController *forget = InitObject(ForgetPasswordViewController);
            forget.isBackToRootVC = YES;
            [nav pushViewController:forget animated:YES];
        }
       else if ([urlPath rangeOfString:@"tutujf:home.loaninfoview?loan_id="].location!=NSNotFound) {
            
            //跳转项目详情页
            ProgrameDetailController *detail = InitObject(ProgrameDetailController);
            detail.isBackToRootVC = YES;
            NSRange range = [urlPath rangeOfString:@"tutujf:home.loaninfoview?loan_id="];
            NSString *loan_id = [urlPath substringFromIndex:range.location+range.length];
            detail.loan_id = loan_id;
            [nav pushViewController:detail animated:YES];
            
        }
       else if ([urlPath rangeOfString:@"tutujf:home.tenderloanview?loan_id="].location!=NSNotFound) {
            UINavigationController *nav = self.navigationController;
            //跳转项目快速购买页
            RushPurchaseController *purchase = InitObject(RushPurchaseController);
            purchase.isBackToRootVC = YES;
            NSRange range = [urlPath rangeOfString:@"tutujf:home.tenderloanview?loan_id="];
            NSString *loan_id = [urlPath substringFromIndex:range.location+range.length];
            purchase.loan_id = loan_id;
            [nav pushViewController:purchase animated:YES];
            
        }
       else if ([urlPath rangeOfString:@"tutujf:home.approverealname"].location!=NSNotFound) {
            // 跳转我实名认证
            UINavigationController *nav = self.navigationController;
            RealNameController *account = InitObject(RealNameController);
            account.isBackToRootVC = YES;
            [nav pushViewController:account animated:YES];
            //首页还是要返回到主页面，防止页面切换
            [nav popToRootViewControllerAnimated:NO];
            
        }
       else if ([urlPath rangeOfString:@"tutujf:home.recharge"].location!=NSNotFound) {
            // 跳转充值页面
            RechargeController *account = InitObject(RechargeController);
            account.isBackToRootVC = YES;
            [nav pushViewController:account animated:YES];
            //首页还是要返回到主页面，防止页面切换
            [nav popToRootViewControllerAnimated:NO];
            
        }
       else if ([urlPath rangeOfString:@"tutujf:home.rechargelog"].location!=NSNotFound) {
            // 跳转充值记录
            RechargeRecordController *account = InitObject(RechargeRecordController);
            account.isBackToRootVC = YES;
            [nav pushViewController:account animated:YES];
            //首页还是要返回到主页面，防止页面切换
            [nav popToRootViewControllerAnimated:NO];
            
        }
       else if ([urlPath rangeOfString:@"tutujf:home.cash"].location!=NSNotFound) {
            self.tabBarController.selectedIndex = 3;
            // 跳转我提现页面
            UINavigationController *selNav = [self.tabBarController.viewControllers objectAtIndex:3];
            GetCashController *account = InitObject(GetCashController);
            account.isBackToRootVC = YES;
            [selNav pushViewController:account animated:YES];
            //首页还是要返回到主页面，防止页面切换
            [nav popToRootViewControllerAnimated:NO];
            
        }
       else if ([urlPath rangeOfString:@"tutujf:home.cashlog"].location!=NSNotFound) {
            self.tabBarController.selectedIndex = 3;
            // 跳转提现列表
            UINavigationController *selNav = [self.tabBarController.viewControllers objectAtIndex:3];
            GetCashRecordController *account = InitObject(GetCashRecordController);
            account.isBackToRootVC = YES;
            [selNav pushViewController:account animated:YES];
            //首页还是要返回到主页面，防止页面切换
            [nav popToRootViewControllerAnimated:NO];
            
        }
       else if ([urlPath rangeOfString:@"tutujf:home.mytransfer"].location!=NSNotFound) {
            self.tabBarController.selectedIndex = 3;
            // 跳转我的债权转让
            UINavigationController *selNav = [self.tabBarController.viewControllers objectAtIndex:3];
            TransferListController *account = InitObject(TransferListController);
            account.isBackToRootVC = YES;
            [selNav pushViewController:account animated:YES];
            //首页还是要返回到主页面，防止页面切换
            [nav popToRootViewControllerAnimated:NO];
            
        }
       else if ([urlPath rangeOfString:@"tutujf:home.banklist"].location!=NSNotFound) {
            // 跳转我银行卡列表
            MyBankCardController *account = InitObject(MyBankCardController);
            account.isBackToRootVC = YES;
            [nav pushViewController:account animated:YES];
            //首页还是要返回到主页面，防止页面切换
            [nav popToRootViewControllerAnimated:NO];
            
        }
       else if ([urlPath rangeOfString:@"tutujf:home.mytrust"].location!=NSNotFound) {
            // 跳转托管账户
            MyRegAccountController *account = InitObject(MyRegAccountController);
            account.isBackToRootVC = YES;
            [nav pushViewController:account animated:YES];
            //首页还是要返回到主页面，防止页面切换
            [nav popToRootViewControllerAnimated:NO];
            
        }
       else if ([urlPath rangeOfString:@"tutujf:home.myinvest"].location!=NSNotFound) {
            // 跳转我的投资页面
            self.tabBarController.selectedIndex = 3;
            UINavigationController *selNav = [self.tabBarController.viewControllers objectAtIndex:3];
            MyInvestController *account = InitObject(MyInvestController);
            account.isBackToRootVC = YES;
            [selNav pushViewController:account animated:YES];
            //首页还是要返回到主页面，防止页面切换
            [nav popToRootViewControllerAnimated:NO];
            
        }
       else if ([urlPath rangeOfString:@"tutujf:home.myrecover"].location!=NSNotFound) {
           // 跳转我的投资页面
           self.tabBarController.selectedIndex = 3;
           UINavigationController *selNav = [self.tabBarController.viewControllers objectAtIndex:3];
           MyPaybackController *account = InitObject(MyPaybackController);
           account.isBackToRootVC = YES;
           [selNav pushViewController:account animated:YES];
           //首页还是要返回到主页面，防止页面切换
           [nav popToRootViewControllerAnimated:NO];
           
       }
        return;
    }
   //既不是自己内部的url，又不是调用内部功能如打电话等，表示是汇付支付的页面，隐藏刷新按钮，显示关闭按钮
    if (![urlPath hasPrefix:oyUrlAddress]&&[urlPath rangeOfString:@"tel:"].location==NSNotFound) {
        [self.closeBtn setHidden:NO];
        [self.refreshBtn setHidden:YES];
        
    }else{
        //对于 当Url参数中带有@“appfun=XXX”,表示对于顶部按钮有特殊处理
        //隐藏全部顶部功能按钮，仅保留标题
        if ([urlPath rangeOfString:@"appfun=notfun"].location!=NSNotFound) {
            [self.backBtn setHidden:YES];
            [self.closeBtn setHidden:YES];
            [self.refreshBtn setHidden:YES];
        }else{
            //如果是自己内部的url，保留刷新以及返回按钮
            [self.backBtn setHidden:NO];
            [self.refreshBtn setHidden:NO];
            [self.closeBtn setHidden:YES];
        }
    }
   

}
-(void)refreshUrl:(NSString *)urlString{
    NSString *resaultUrl = @"";
    //如果为自带下发的webView，则重新加载添加客户端标识的webView,并隐藏关闭按钮
    
    if ([urlString rangeOfString:urlCheckAddress].location!=NSNotFound) {
        [self.closeBtn setHidden:YES];
        [self.refreshBtn setHidden:NO];
        //如果链接已经加过标识符，则不重新添加
        if ([urlString rangeOfString:@"equipment"].location!=NSNotFound) {
            resaultUrl = urlString;
        }else{
            
            NSArray *array = [urlString componentsSeparatedByString:@"#"]; //从字符#中分隔成2个元素的数组,如果没有#，则数组里只有字符串本身一个元素
            NSString *header = array[0];
            if ([header rangeOfString:@"?"].location!=NSNotFound) {
                header = [header stringByAppendingString:@"&equipment=ios"];
            }else{
                header = [header stringByAppendingString:@"?equipment=ios"];
            }
            
            if (array.count>1) {
                resaultUrl = [NSString stringWithFormat:@"%@#%@",header,array[1]];
            }else{
                resaultUrl = header;
            }
            
            //http://cs.www.tutujf.com/wap/loan/loaninfoview?name=33#?id=774
            /**规则：1、链接中如果含有#，则在#之前加标识符?equipment=ios
             a，如果有#，并且前置标识符中已经有了？，则标识符变为&equipment=ios
             2、链接中如果没有#，则在链接结尾出直接添加标识符
             */
            
        }
        [self.mainWebView stopLoading];
        
        [self loadRequest:resaultUrl];//加载校验过的webView
    }else{
        //打开关闭按钮，加载外部链接
        [self.closeBtn setHidden:NO];
        [self.refreshBtn setHidden:YES];
        [self loadRequest:urlString];
    }
}


//加载网页
- (void)loadRequest: (NSString *) urlstr {
   
    if (IsEmptyStr(urlstr)) {
        [SVProgressHUD showInfoWithStatus:@"链接错误"];
        return;
    }
    NSURL *url = [[NSURL alloc] initWithString:urlstr];
    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];//超时时间12秒
    NSMutableString *cookies = [NSMutableString string];
    NSArray *tmp = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie * cookie in tmp) {
        [cookies appendFormat:@"%@=%@;",cookie.name,cookie.value];
    }
        // 注入Cookie，识别webView登录状态
    [request setValue:cookies forHTTPHeaderField:@"Cookie"];
    [request setHTTPShouldHandleCookies:YES];
    [self.mainWebView loadRequest:request];
    
}

#pragma mark --MessageHandler(WKWebView与JS方法交互:JS调用OC 方法)
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //调用app内部的方法
    //分享
    if ([message.name isEqualToString:@"openShare"]) {
        // 调用方法
        if ([self respondsToSelector:@selector(openShare:)]) {
            //传入要分享的内容
            if ([message.body isKindOfClass:[NSDictionary class]]) {
                [self openShare:message.body];
            }
        } else {
            NSLog(@"调用失败");
        }
    }
  
}
//弹出分享页面
-(void)openShare:(NSDictionary *)object
{
    NSLog(@"JS传入的分享内容%@",object);
    self.callBack = [object objectForKey:@"success_fun"];//获取回调方法名
    NSString *title = [object objectForKey:@"title"];
    NSString *img_url = [object objectForKey:@"img_url"];
    NSString *link_url = [object objectForKey:@"link_url"];
    NSString *desc = [object objectForKey:@"desc"];
     [self showShareActionSheet:title Img_url:img_url Link_url:link_url Desc:desc Callback:self.callBack];
}


#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    NSString *path= [webView.URL absoluteString];
    NSString * newPath = [path lowercaseString];
    
    if ([newPath hasPrefix:@"tel:"]) {
        
        UIApplication * app = [UIApplication sharedApplication];
        if ([app canOpenURL:[NSURL URLWithString:newPath]]) {
            [app openURL:[NSURL URLWithString:newPath]];
        }
        [webView stopLoading];
    }
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
  
    [SVProgressHUD dismiss];

        [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
          NSString*  str = (NSString *)title;
            //获取设置标题
            self.titleString = str;
        }];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
    [SVProgressHUD showInfoWithStatus:@"加载失败"];

}
//请求超时调用此方法
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if (error) {
        if (error.code==NSURLErrorCancelled) {//如果是手动取消加载，不算失败
            return;
        }
        NSString *errorKey = [error.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey];
        if ([errorKey hasPrefix:@"tel:"]) {//调用打电话造成加载失败，不算失败
            return;
        }
        if ([errorKey rangeOfString:@"tutujf:home"].location!=NSNotFound) {//跳转原生页面停止刷新，不算失败
            return;
        }
        if (error.code==NSURLErrorTimedOut) {
            [SVProgressHUD showInfoWithStatus:@"请求超时"];
            return;
        }
    }
    //所有的失败都会走此方法,包括页面刷新停止
     [SVProgressHUD showInfoWithStatus:@"加载失败"];
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);

}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //首先校验webView是否需要跳转到系统原生态页面
    [self checkIsGoOriginal:navigationAction.request];
    //外部链接，不做判断直接允许跳转
    if (![navigationAction.request.URL.absoluteString hasPrefix:oyUrlAddress]){
        self.step = 1;
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        //内部链接
        if (self.step==2) {//外部链接跳转内部链接，第二个页面再添加cookie值
            NSMutableString *cookies = [NSMutableString string];
            NSArray *tmp = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
            for (NSHTTPCookie * cookie in tmp) {
                [cookies appendFormat:@"%@=%@;",cookie.name,cookie.value];
            }
            NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:navigationAction.request.URL];
            [request setValue:cookies forHTTPHeaderField:@"Cookie"];
            [webView loadRequest:request];
            decisionHandler(WKNavigationActionPolicyCancel);

        }else{
            self.step++;
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }
}
#pragma mark --ShareSDK Delegate
- (void)showShareActionSheet:(NSString *) titlecontent Img_url:(NSString *) img_url Link_url:(NSString *) link_url Desc:(NSString *) desc Callback:(NSString *) callback{
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.backgroundColor = [UIColor grayColor];
    
    //每个平台的分享参数、分享类型不同，具体可根据需求调整。
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL * url = [NSURL URLWithString:img_url];
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc]initWithData:data];
        if (image != nil) {
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
                 NSString * jsStr = [NSString stringWithFormat:@"%@(%@)",self.callBack,@{@"status":@"success"}];
                 [self.mainWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                     //是否写入成功
                 }];
                 NSLog(@"shareSDK:成功");
                 break;
             }
             case SSDKResponseStateFail: {
                 messageTitle = @"分享失败";
                 NSLog(@"shareSDK:失败:%@",error);
                 NSString * jsStr = [NSString stringWithFormat:@"%@(%@)",self.callBack,@{@"status":@"fail"}];
                 [self.mainWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                     //
                 }];
                 
                 
                 break;
             }
             case SSDKResponseStateCancel: {
                 NSLog(@"shareSDK:取消");
                 NSDictionary *sendDic = @{@"status":@"cancel"};
                 NSString * jsStr = [NSString stringWithFormat:@"%@(%@)",self.callBack,[[HttpCommunication sharedInstance] dictionaryToJson:sendDic]];
                 [self.mainWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                 
                 
                 }];
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
@end

