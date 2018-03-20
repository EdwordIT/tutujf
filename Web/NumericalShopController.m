//
//  NumericalShopController.m
//  DingXinDai
//
//  Created by 占碧光 on 16/7/2.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import "NumericalShopController.h"
#import "AppDelegate.h"
//#import "SVProgressHUD.h"
#import "MBProgressHUD+NJ.h"
#import "UrlJumpHelp.h"

@interface NumericalShopController ()
{
    UIButton *backBtn;
    Boolean isLoad;
      NSString *  loadUrlStr;
    NSString * eventStr;
    UIView *  top;
    Boolean  isvistor;
    UrlJumpHelp * jumpHelp;
    UIView *backBg;
     Boolean isTeshu;
    UIView *topline;
    NSString * isWebLogin;
}
/**
 NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
 // 获取cookie,并设置到本地
 NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
 for (NSHTTPCookie *cookie in cookies) {
 [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
 }
 **/
@end

@implementation NumericalShopController

- (void)viewDidLoad {
    [super viewDidLoad];
   //   [super.navigationController setNavigationBarHidden:YES animated:TRUE];

    //[self loadPage1:@"http://www.xipuw.com/test.aspx"];
       [self.navigationController.navigationBar setHidden:YES];
   
    if(_urlStr==nil||[_urlStr isEqual:@""])
    {
       _urlStr=[oyUrlAddress stringByAppendingString:@"/wap"];
    }
    isLoad=FALSE;
    isvistor=FALSE;
    isTeshu=FALSE;
    jumpHelp=[[UrlJumpHelp alloc] init];
    [jumpHelp initLoad];
    jumpHelp.rootTempUrl=@"";
    jumpHelp.urlDeep=1;
   //    self.tabBarController.tabBar.hidden=YES;
    [self loadPage1:_urlStr];
    topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 20)];
    topline.backgroundColor =RGB(14,118,235);
    [topline setHidden:NO];
    [self.view addSubview:topline];
    if(_isreturn==nil)
        _isreturn=@"0";
    if(_returnmain==nil)
        _returnmain=@"0";
    isWebLogin=@"0";//0 未进入登录页面 1 已经登陆  2需要登录

 //   [self jsReturn:_returnmain];
    
    loadUrlStr=_urlStr;
    [self setHeadTop];
    eventStr=@"";
    theAppDelegate.httplink=_urlStr;
    theAppDelegate.tabindex=self.tabBarController.selectedIndex;
   
   // [theAppDelegate.httplink removeAllObjects];
  
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


/**
 *WebView加载完毕的时候调用（请求完毕）
 */
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([isWebLogin isEqual:@"0"]&&[_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/system/login2"]].location != NSNotFound)    {
        //theAppDelegate.webLogin=2;
        isWebLogin=@"2";//
        theAppDelegate.xbindex=2;
        dispatch_async(dispatch_get_main_queue(), ^{
            //   self.navigationController.navigationBarHidden = NO;
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        return ;
    }
    [self loadDoURL:webView];
    
    if(webView.isLoading)
    {
        return;
    }
     if(!isvistor&&[_currentURL rangeOfString:@"?type=back"].location != NSNotFound)
     {
         isvistor=TRUE;
     }
        else if([_currentURL rangeOfString:@"?type=back"].location != NSNotFound&&isvistor==TRUE)
        {
          //  self.navigationController.navigationBarHidden = NO;
            self.tabBarController.tabBar.hidden=NO;
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
    

        isLoad=FALSE;
        loadUrlStr=_currentURL;
        theAppDelegate.httplink=_currentURL;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD hideHUD];
            });
        });
  
  
//    NSLog(@"%@", @"00000");
    __block typeof(self) weakSelf = self;
    self.context[@"returnUrl"] =
    ^(NSString *maintype)
    {
       // [weakSelf jsReturn:maintype];
    };
  
}



-(void) loadDoURL:(UIWebView *)webView{
    
    _currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
     if ([_currentURL rangeOfString:@"?bak=close"].location != NSNotFound) {
         backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         backBtn.frame = CGRectMake(0, 20, 65, 44);
         backBtn.backgroundColor=[UIColor clearColor];
       if([_returnmain isEqual:@"2"])
         [backBtn addTarget:self action:@selector(OnBackBtn) forControlEvents:UIControlEventTouchUpInside];
         else
          [backBtn addTarget:self action:@selector(OnBackBtnHaveNavtion) forControlEvents:UIControlEventTouchUpInside];
         [self.view addSubview:backBtn];
         
    }
    else if([_returnmain isEqual:@"5"])
    {
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 20, 65, 44);
        backBtn.backgroundColor=[UIColor clearColor];
        [backBtn addTarget:self action:@selector(OnBackBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
    }
    
   
    if([jumpHelp isExist:_currentURL type:5] )
    {
       
        [self setNavtion:_currentURL];
        return ;
    }
    if([jumpHelp isExist:_currentURL type:0] )
    {
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 20, 65, 44);
        backBtn.backgroundColor=[UIColor clearColor];
        if([_returnmain isEqual:@"2"])
            [backBtn addTarget:self action:@selector(OnBackBtn) forControlEvents:UIControlEventTouchUpInside];
        else
            [backBtn addTarget:self action:@selector(OnBackBtnHaveNavtion) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
        jumpHelp.urlDeep=1;
        [backBtn setHidden:FALSE];
						  
    }
 
    else
    {
        if([jumpHelp isExist:_currentURL type:1] )
        {
          
               [backBg setHidden:FALSE];
            
        }
        else
        {
         [backBg setHidden:TRUE];
            jumpHelp.urlDeep++;
        }
    }
   //http://mshop.dingxindai.com/purchase/accounttender/20151100001.html
}



-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
     NSString *  currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    if((!isLoad||[loadUrlStr isEqual:@""])&&![currentURL isEqual:loadUrlStr])
    {
        loadUrlStr=currentURL;
        isLoad=TRUE;
        [MBProgressHUD showMessage:@""];
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
    //SVProgressHUDMaskType 设置显示的样式
}


//加载网页
- (void)loadPage1: (NSString *) urlstr {
   
    //  UIWebView *webview1;
    if(IS_IPhone6)
        iWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 375,667)];
    else  if(IS_IPhone6plus)
        iWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, 414,736)];
    else if(IS_IPHONE5)
        iWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320,568)];
    else if(isPhone)
        iWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320,480)];
    
    else
        iWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 640,1136)];
    
    iWebView.delegate=self;
    //伸缩内容适应屏幕尺寸
    iWebView.scalesPageToFit=YES;
    [iWebView setUserInteractionEnabled:YES];
    
      UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    line.backgroundColor =navigationBarColor;
    //  line.contentMode = UIViewContentModeScaleAspectFill;
    //  line.backgroundColor = [UIColor clearColor];
       [self.view addSubview:line];
 
    
    NSURL *url = [[NSURL alloc] initWithString:urlstr];
  //  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    //cachePolicy:网络缓存策略：玫举常量
    //timeoutInterval:请求超时时间:默认情况：最大1分钟，一般15秒
   // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:40];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"Mozilla/5.0 (iPhone; CPU iPhone like Mac OS X; zh-CN;) AppleWebKit/537.51.1 (KHTML, like Gecko) Mobile/14C92 XiPuWBrowser/1.1.1 Mobile AliApp(TUnionSDK/0.1.12) AliApp(TUnionSDK/0.1.12)" forHTTPHeaderField:@"User-Agent"];
    
    NSMutableString *cookies = [NSMutableString string];
    // 一般都只需要同步JSESSIONID,可视不同需求自己做更改
    // 获取本地所有的Cookie
    NSArray *tmp = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie * cookie in tmp) {
        
        [cookies appendFormat:@"%@=%@;",cookie.name,cookie.value];
    }
    [request setHTTPShouldHandleCookies:YES];
    // 注入Cookie
    [request setValue:cookies forHTTPHeaderField:@"Cookie"];
    // 加载请求
    
    [iWebView loadRequest:request];
    iWebView.scrollView.bounces = NO;
    [self.view addSubview:iWebView];

}
/*
-(void) jsReturn:(NSString *) maintype
{
     if([maintype isEqual:@"1"]) //支持内部返回
     {
         if ([_currentURL rangeOfString:@"bak=close"].location != NSNotFound) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 //self.navigationController.navigationBarHidden = NO;
                 
                 [self.navigationController popViewControllerAnimated:YES];
             });
             return ;
         }
         
         else if(iWebView.canGoBack&&[_currentURL rangeOfString:_urlStr].location == NSNotFound&&[_urlStr rangeOfString:_currentURL].location == NSNotFound)
         {
             if(backBg!=nil)
             {
                 if([jumpHelp isExist:_currentURL type:1] )
                 {
                     [backBg setHidden:FALSE];
                 }
                 else
                 {
                     [backBg setHidden:TRUE];
                 }
             }
             [iWebView goBack];
         }
         
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.navigationController.navigationBarHidden = NO;
                 
                 [self.navigationController popViewControllerAnimated:YES];
             });
             
         }
         
     }
     else if([maintype isEqual:@"2"])
     {
         dispatch_async(dispatch_get_main_queue(), ^{
        //     self.navigationController.navigationBarHidden = YES;
             
             [self.navigationController popViewControllerAnimated:YES];
         });
     }
     else if([maintype isEqual:@"3"])
     {
         if(!iWebView.canGoBack)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationController.navigationBarHidden = NO;
                 
                 [self.navigationController popViewControllerAnimated:YES];
             });
         }
         else
             [iWebView stringByEvaluatingJavaScriptFromString:@"window.history.go(-1); "];
         
     }
     else if([maintype isEqual:@"4"])
     {
         dispatch_async(dispatch_get_main_queue(), ^{
               self.navigationController.navigationBarHidden = NO;
             
             [self.navigationController popViewControllerAnimated:YES];
         });
     }
}
*/
-(void) setHeadTop{
    
    if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/loan/loantender"]].location != NSNotFound||[_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/transfer/transferList"]].location != NSNotFound||[_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/borrow/applyborrow"]].location != NSNotFound||[_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/page/getPage?action=noviceguide"]].location != NSNotFound||[_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/page/getPage?action=report"]].location != NSNotFound)
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
    //
    else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/member/approverealname#?action=open&id=1"]].location != NSNotFound)
    {
        topline.backgroundColor=RGB(14,142,235);
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
    else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/member/editpwd"]].location != NSNotFound)
    {
        topline.backgroundColor=RGB(14, 161, 245);
    }
    else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/bank/index"]].location != NSNotFound)
    {
        topline.backgroundColor=RGB(14, 161, 245);
    }
    else if ([_currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/member/myaccountdata"]].location != NSNotFound)
    {
        topline.backgroundColor=RGB(14, 161, 245);
    }
}


-(void) OnBackBtn1
{
    iWebView.frame =CGRectMake(0, 20, screen_width, screen_height-20);
    [top setHidden:TRUE];
}

-(void) OnBackBtn
{
    // [super.navigationController setNavigationBarHidden:NO animated:TRUE];
    dispatch_async(dispatch_get_main_queue(), ^{
     //   self.navigationController.navigationBarHidden = NO;
        
        [self.navigationController popViewControllerAnimated:YES];
    });
   // [self dismissModalViewControllerAnimated:YES];
}

-(void) OnBackBtnHaveNavtion
{
    // [super.navigationController setNavigationBarHidden:NO animated:TRUE];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationController.navigationBarHidden = NO;
        
        [self.navigationController popViewControllerAnimated:YES];
    });
    // [self dismissModalViewControllerAnimated:YES];
}


-(void) setNavtion:(NSString *) urlstr
{
    dispatch_async(dispatch_get_main_queue(), ^{
      //  self.navigationController.navigationBarHidden = NO;
        self.tabBarController.tabBar.hidden=NO;
       
         [self.navigationController popViewControllerAnimated:YES];
   
        
        });
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
