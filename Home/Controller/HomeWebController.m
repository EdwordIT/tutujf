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
#import "MBProgressHUD+MP.h"
#import <MOBFoundation/MOBFoundation.h>
#import "AppDelegate.h"
#import "Utils.h"
#import "Base64.h"
#import "DESFunc.h"
#import "AccountInfoController.h"//个人资料详情
#import "RegisterViewController.h"//注册
#import "ForgetPasswordViewController.h"//忘记密码
#import "ProgrameNewDetailController.h"//项目详情
#import "RushPurchaseController.h"//快速投资
#import "NetworkManager.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import "HttpSignCreate.h"
#import "ChangePasswordViewController.h"
@interface HomeWebController ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate,WKNavigationDelegate,WKScriptMessageHandler>
Strong WKWebView *mainWebView;
//Strong UIProgressView *progressView;
Copy NSString *callBack;//分享之后回调方法，写入js的方法名
Copy NSString *  returnWebUrl;//如果有标记特殊返回页面

@end
//static HttpDnsService *httpdns;
@implementation HomeWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"土土金服";
    [self.rightBtn setHidden:YES];
    [self.rightBtn setImage:IMAGEBYENAME(@"close_white") forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = separaterColor;

    if(_urlStr==nil||[_urlStr isEqual:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"链接错误"];
        return;
    }
    [self.view addSubview:self.mainWebView];
    
    //添加ios客户端标识
    if ([_urlStr rangeOfString:@"equipment=ios"].location==NSNotFound) {
        [self refreshUrl:_urlStr];
    }else{
        [self loadRequest:_urlStr];
    }
}
-(void)refreshUrl:(NSString *)urlString{
    NSString *resaultUrl = @"";
    //如果为自带下发的webView，则重新加载添加客户端标识的webView,并隐藏关闭按钮
    if ([urlString rangeOfString:oyUrlAddress].location!=NSNotFound) {
        [self.rightBtn setHidden:YES];
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
        //打开关闭按钮
        [self.rightBtn setHidden:NO];
    }

}
-(WKWebView *)mainWebView{
    if (!_mainWebView) {
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        // WKWebView的配置
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        //js调用OC的内容名称注册
        [userContentController addScriptMessageHandler:self name:@"openShare"];//分享
        [userContentController addScriptMessageHandler:self name:@"return_link"];//返回链接跳转
        //对应前端js中调用时候要使用
       //  window.webkit.messageHandlers.openShare.postMessage({body: 'hello world!'});

        if(kDevice_Is_iPhoneX)
        {
            if (@available(iOS 11.0, *)) {
                _mainWebView.scrollView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
            } else {
                // Fallback on earlier versions
            }
        }
        
        _mainWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, kNavHight, screen_width,kViewHeight) configuration:configuration];
        _mainWebView.navigationDelegate = self;
        [_mainWebView setUserInteractionEnabled:YES];
        _mainWebView.backgroundColor = separaterColor;
//        [_mainWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//            //response为获取js相关内容
//        }];
        _mainWebView.scrollView.bounces = NO;

        
    }
    return _mainWebView;
}
#pragma mark --buttonClick
//回退按钮点击（需要判断回退内容）
-(void)backPressed:(UIButton *)sender{
    if ([self.mainWebView canGoBack]) {
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
    }else{
        [self.mainWebView stopLoading];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)rightBtnClick:(UIButton *)sender
{
    [self.mainWebView stopLoading];
    [self.navigationController popViewControllerAnimated:YES];
}
//加载网页
- (void)loadRequest: (NSString *) urlstr {
    [SVProgressHUD show];

    NSMutableString *cookies = [NSMutableString string];
    NSArray *tmp = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie * cookie in tmp) {
        [cookies appendFormat:@"%@=%@;",cookie.name,cookie.value];
    }
     NSMutableURLRequest *request ;
    NSURL *url = [[NSURL alloc] initWithString:urlstr];
   
    request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPShouldHandleCookies:YES];
    // 注入Cookie
    [request setValue:cookies forHTTPHeaderField:@"Cookie"];
    [request setValue:@"Mozilla/5.0 (iPhone; CPU iPhone like Mac OS X; zh-CN;) AppleWebKit/537.51.1 (KHTML, like Gecko) Mobile/14C92 TutuBrowser/1.1.1 Mobile AliApp(TUnionSDK/0.1.12) AliApp(TUnionSDK/0.1.12)" forHTTPHeaderField:@"User-Agent"];
    [self.mainWebView loadRequest:request];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}
- (void)dealloc {
    [[_mainWebView configuration].userContentController removeScriptMessageHandlerForName:@"openShare"];
    [[_mainWebView configuration].userContentController removeScriptMessageHandlerForName:@"return_link"];

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
    //点击返回按钮，如果返回按钮有要求跳转的链接，则不走返回，而是跳转到新的链接
    if ([message.name isEqualToString:@"return_link"]) {
        self.returnWebUrl = [message.body objectForKey:@"link_url"];
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

#pragma mark --BackToOriginal
/**
 校验链接是否跳转到原生态页面
 */
-(void)checkIsGoOriginal:(NSURL *)url
{
    NSString *urlPath = url.absoluteString;
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
        if ([urlPath rangeOfString:@"tutujf:home.loantender"].location!=NSNotFound) {
            //跳转投资列表页
            self.tabBarController.selectedIndex = 1;
            
            [nav popToRootViewControllerAnimated:YES];
            
        }
        if ([urlPath rangeOfString:@"tutujf:home.findactivity"].location!=NSNotFound) {
            //跳转发现页面
            self.tabBarController.selectedIndex = 2;
            
            [nav popToRootViewControllerAnimated:YES];
            
        }
        if ([urlPath rangeOfString:@"tutujf:home.memberindex"].location!=NSNotFound) {
            // 跳转我的页面
            self.tabBarController.selectedIndex = 3;
            
            [nav popToRootViewControllerAnimated:YES];
            
            
        }
        if ([urlPath rangeOfString:@"tutujf:home.myaccountdata"].location!=NSNotFound) {
            // 跳转我账号详情页面
            self.tabBarController.selectedIndex = 3;
            UINavigationController *selNav = [self.tabBarController.viewControllers objectAtIndex:3];
            AccountInfoController *account = InitObject(AccountInfoController);
            account.isBackToRootVC = YES;
            [selNav pushViewController:account animated:YES];
            //首页还是要返回到主页面，防止页面切换
            [nav popToRootViewControllerAnimated:NO];
            
        }
        if ([urlPath rangeOfString:@"tutujf:home.editpwd"].location!=NSNotFound) {
            [nav popToRootViewControllerAnimated:NO];//退回到根视图，之后再决定跳转
            //跳转修改密码页面
            ChangePasswordViewController *forget = InitObject(ChangePasswordViewController);
            forget.isBackToRootVC = YES;
            [self.navigationController pushViewController:forget animated:YES];
            
        }
        if ([urlPath rangeOfString:@"tutujf:home.login"].location!=NSNotFound) {
            //跳转登录页面
            [self goLoginVC];
            [nav popToRootViewControllerAnimated:NO];
        }
        if ([urlPath rangeOfString:@"tutujf:home.register"].location!=NSNotFound) {
            [nav popToRootViewControllerAnimated:NO];//退回到根视图，之后再决定跳转
            //跳转注册页面
            RegisterViewController *regis = InitObject(RegisterViewController);
            regis.isBackToRootVC = YES;
            [nav pushViewController:regis animated:YES];
            
        }
        if ([urlPath rangeOfString:@"tutujf:home.seekpwd"].location!=NSNotFound) {
            [nav popToRootViewControllerAnimated:NO];//退回到根视图，之后再决定跳转
            //跳转找回密码页面
            ForgetPasswordViewController *forget = InitObject(ForgetPasswordViewController);
            forget.isBackToRootVC = YES;
            [nav pushViewController:forget animated:YES];
        }
        if ([urlPath rangeOfString:@"tutujf:home.loaninfoview?loan_id="].location!=NSNotFound) {
            
            //跳转项目详情页
            ProgrameNewDetailController *detail = InitObject(ProgrameNewDetailController);
            detail.isBackToRootVC = YES;
            detail.user_token = [CommonUtils getToken];
            NSRange range = [urlPath rangeOfString:@"tutujf:home.loaninfoview?loan_id="];
            NSString *loan_id = [urlPath substringFromIndex:range.location+range.length];
            detail.loan_id = loan_id;
            [nav pushViewController:detail animated:YES];
            
        }
        if ([urlPath rangeOfString:@"tutujf:home.tenderloanview?loan_id="].location!=NSNotFound) {
            UINavigationController *nav = self.navigationController;
            //跳转项目快速购买页
            RushPurchaseController *purchase = InitObject(RushPurchaseController);
            purchase.isBackToRootVC = YES;
            NSRange range = [urlPath rangeOfString:@"tutujf:home.tenderloanview?loan_id="];
            NSString *loan_id = [urlPath substringFromIndex:range.location+range.length];
            purchase.loan_id = loan_id;
            [nav pushViewController:purchase animated:YES];
            
        }
        
        
        return;
    }
    
    
    
}
#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //首先校验webView是否需要跳转到系统原生态页面
    [self checkIsGoOriginal:webView.URL];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    [SVProgressHUD dismiss];
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
    
    [SVProgressHUD dismiss];

}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
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

