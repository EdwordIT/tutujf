//
//  DZWKWebViewController.m
//  DingXinDai
//
//  Created by 占碧光 on 2017/8/11.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DZWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import "MBProgressHUD+NJ.h"
#import "UrlJumpHelp.h"
#import "DMLoginViewController.h"
#import "XXWebKitSupport.h"
#import "WinChageType.h"

@interface DZWKWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (nonatomic,strong)WKWebView *dzWebView;
@property (nonatomic,strong) CALayer *progressLayer;

@end

@implementation DZWKWebViewController{
    WKWebViewConfiguration *config;
    UIButton *backBtn;
    Boolean isLoad;
    NSString *  loadUrlStr;
    NSString * eventStr;
    UIView *  top;
    Boolean  isvistor;
    UrlJumpHelp * jumpHelp;
    UIView *backBg;
    Boolean isTeshu;
     Boolean isPointList;//鼎信币列表特殊处理
     //Boolean isFinishExe;//
   //  NSTimer * myTimer;
       UIView *backTopBg;
      UIView *topline;
}
- (void)viewDidLoad {
    [super viewDidLoad];
      self.navigationController.navigationBarHidden = YES;
    if(_urlStr==nil||[_urlStr isEqual:@""])
    {
        _urlStr=@"";
    }
    isLoad=FALSE;
    isTeshu=FALSE; //返回首页
  //  isFinishExe=FALSE;
    jumpHelp=theAppDelegate.jumpHelp;
    jumpHelp.rootTempUrl=@"";
    jumpHelp.urlDeep=1;
    //    self.tabBarController.tabBar.hidden=YES;
    
    if(_isreturn==nil)
        _isreturn=@"0";
    if(_returnmain==nil)
        _returnmain=@"0";
    loadUrlStr=_urlStr;
    eventStr=@"";
    theAppDelegate.httplink=_urlStr;
    theAppDelegate.tabindex=self.tabBarController.selectedIndex;
    // 添加KVO监听
    [self.dzWebView addObserver:self
                     forKeyPath:@"loading"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    [self.dzWebView addObserver:self
                     forKeyPath:@"title"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    [self.dzWebView addObserver:self
                     forKeyPath:@"estimatedProgress"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    // Do any additional setup after loading the view.
    [self showMessageToUI:@""];
    [self loadPage1:_urlStr];
}

//加载网页
- (void)loadPage1: (NSString *) urlstr {
    // self.dzWebView=theAppDelegate.dzWebView;
    // 根据生成的WKUserScript对象，初始化WKWebViewConfiguration
    config=[XXWebKitSupport createSharableWKWebView];
    [config.userContentController addScriptMessageHandler:self name:@"iosApp"];
    //self.dzWebView.frame=CGRectMake(0,20,self.view.frame.size.width,self.view.frame.size.height-20);
    self.dzWebView=[[WKWebView alloc]initWithFrame:CGRectMake(0,20,self.view.frame.size.width,self.view.frame.size.height-20) configuration:config];
    if(kDevice_Is_iPhoneX)
        self.dzWebView.frame =CGRectMake(0, 34, screen_width,screen_height-34);
    else
        self.dzWebView.frame  =CGRectMake(0, 20, screen_width,screen_height-20);
    self.dzWebView.navigationDelegate=self;
    self.dzWebView.UIDelegate=self;
    if(kDevice_Is_iPhoneX)
        backTopBg=[[UIView alloc] initWithFrame:CGRectMake(0, -34, screen_width, 34)];
    else
        backTopBg=[[UIView alloc] initWithFrame:CGRectMake(0, -20, screen_width, 20)];
    backTopBg.backgroundColor=RGB(14, 161, 245);
    [self.dzWebView addSubview:backTopBg];
    if(kDevice_Is_iPhoneX)
        topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 34)];
    else
        topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 20)];
    topline.backgroundColor =RGB(14,118,235);
    [topline setHidden:TRUE];
    [self.view addSubview:topline];
    //伸缩内容适应屏幕尺寸
    [self.dzWebView setUserInteractionEnabled:YES];
    
    //UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
  //  line.backgroundColor =navigationBarColor;
    //  line.contentMode = UIViewContentModeScaleAspectFill;
    //  line.backgroundColor = [UIColor clearColor];
 //   [self.view addSubview:line];
    
    
    NSURL *url = [[NSURL alloc] initWithString:urlstr];
    //  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    //cachePolicy:网络缓存策略：玫举常量
    //timeoutInterval:请求超时时间:默认情况：最大1分钟，一般15秒
    // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:40];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30] ;
    [request setValue:@"Mozilla/5.0 (iPhone; CPU iPhone like Mac OS X; zh-CN;) AppleWebKit/537.51.1 (KHTML, like Gecko) Mobile/14C92 TutuWBrowser/1.1.1 Mobile AliApp(TUnionSDK/0.1.12) AliApp(TUnionSDK/0.1.12)" forHTTPHeaderField:@"User-Agent"];
    

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
    [self.dzWebView loadRequest:request];
    

    self.dzWebView.scrollView.bounces = NO;
    [self.view addSubview:self.dzWebView];
    
    if([_returnmain isEqual:@"1"])
    {
        
        backBg = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 65, 44)];
        backBg.backgroundColor =[UIColor clearColor];
        backBg.tag=1;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBack:)];
        [backBg addGestureRecognizer:tap];
        
        [self.view addSubview:backBg];
        
    }
    else if([_returnmain isEqual:@"3"])
    {
        backBg = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 65, 44)];
        backBg.backgroundColor =[UIColor clearColor];
        backBg.tag=3;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBack:)];
        [backBg addGestureRecognizer:tap];
        
        [self.view addSubview:backBg];
    }
   else if([_returnmain isEqual:@"4"])
    {
        backBg = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 65, 44)];
        backBg.backgroundColor =[UIColor clearColor];
        backBg.tag=4;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnBackBtn)];
        [backBg addGestureRecognizer:tap];
        
        [self.view addSubview:backBg];
    }
    
    
}

-(void)OnTapBack:(UITapGestureRecognizer *)sender{
    if([_returnmain isEqual:@"1"]) //支持内部返回
    {
        //[self OnBackBtn];
        if ([_currentURL rangeOfString:@"bak=close"].location != NSNotFound) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationController.navigationBarHidden = NO;
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            return ;
        }
        
        else if(self.dzWebView.canGoBack&&[_currentURL rangeOfString:_urlStr].location == NSNotFound&&[_urlStr rangeOfString:_currentURL].location == NSNotFound)
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
            [self.dzWebView goBack];
        }
        
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationController.navigationBarHidden = NO;
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
    }
    else if([_returnmain isEqual:@"3"])
    {
        if(isTeshu)
        {
          [[self navigationController] popToRootViewControllerAnimated:YES];
            return;
        }
        if(!self.dzWebView.canGoBack)
        {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationController.navigationBarHidden = NO;
                
                [self.navigationController popViewControllerAnimated:YES];
            });
        
        }
        else
            [self.dzWebView evaluateJavaScript:@"window.history.go(-1); " completionHandler:^(id object, NSError * error) {
                NSLog(@"111111111");
            }];
        
    }

}

-(void) loadDoURL:(WKWebView *)webView{
    
  
    self.tabBarController.tabBar.hidden=YES;
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
            [backBtn addTarget:self action:@selector(OnBackBtn1) forControlEvents:UIControlEventTouchUpInside];
           
            [self.view addSubview:backBtn];
        }
    }
    else
    {
        //tt15000000666
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [backTopBg setHidden:FALSE];
         if ([_currentURL rangeOfString:@".tutujf.com/wap/back/backTender"].location != NSNotFound)
         {
             backBtn.backgroundColor=[UIColor clearColor];
             isTeshu=TRUE;
             
         }
         else
             isTeshu=FALSE;
        if ([_currentURL rangeOfString:@".www.tutujf.com/wap/member/mytender"].location != NSNotFound)
        {
            
        }

    }
    
    if ([_currentURL isEqualToString:@"https://lab.chinapnr.com"])
    {
        [backTopBg setHidden:TRUE];
        [topline setHidden:FALSE];
        self.dzWebView.frame = CGRectMake(0, 20, screen_width,screen_height-20);
        topline.backgroundColor=RGB(255,255,255);
        self.tabBarController.tabBar.hidden=YES;
        if([_urlStr rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/member/index"]].location == NSNotFound )
            [self setReturnBack];
        
    }
    
   
   //
    //http://mshop.dingxindai.com/purchase/accounttender/20151100001.html
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

-(void) setReturnBack
{
    
    if([_returnmain isEqual:@"5"]&&[_currentURL isEqual:_urlStr])
    {
        if(backBtn==nil)
        {
            backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            \
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
            [backBtn addTarget:self action:@selector(OnBackBtn2) forControlEvents:UIControlEventTouchUpInside];
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
-(void) loadDoURLBack
{
    if(backBg!=nil)
    {
    
    }
}

-(void) setNavtion:(NSString *) urlstr
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationController.navigationBarHidden = NO;
        self.tabBarController.tabBar.hidden=NO;
        
     
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    });
    
}



-(void) OnBackBtn1
{
    self.dzWebView.frame =CGRectMake(0, 20, screen_width, screen_height-20);
    [top setHidden:TRUE];
}
-(void) OnBackBtn
    {
        // [super.navigationController setNavigationBarHidden:NO animated:TRUE];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationController.navigationBarHidden = NO;
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        // [self dismissModalViewControllerAnimated:YES];
}



//导航返回刷新
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   // NSString * tmp=theAppDelegate.httplink ;
   // int log=theAppDelegate.webLogin;
  //  int cur=theAppDelegate.tabindex;
    if(theAppDelegate.tabindex!=self.tabBarController.selectedIndex)
    {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"loading"]) {
        NSLog(@"loading");
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.dzWebView.title;
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
       // self.progressView.progress = self.dzWebView.estimatedProgress;
    }
    // 加载完成
    if (!self.dzWebView.loading) {
        [UIView animateWithDuration:0.5 animations:^{
          //  self.progressView.alpha = 0;
        }];
    }
}
//获取js传给iOS的参数
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSDictionary *dict=message.body;
    NSLog(@">>%@",dict);
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",dict] message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

//关闭页面
- (void)off {
    [self.navigationController popViewControllerAnimated:YES];
}
// 后退
- (void)goBack {
    // 判断是否可以后退
    if (self.dzWebView.canGoBack) {
        [self.dzWebView goBack];
    }
}
// 前进
- (void)GoForward {
    // 判断是否可以前进
    if (self.dzWebView.canGoForward) {
        [self.dzWebView goForward];
    }
}
//刷新
- (void)Refresh{
    //这个是带缓存的验证
    //            [self.dzWebView reloadFromOrigin];
    // 是不带缓存的验证，刷新当前页面
    [self.dzWebView reload];
}
//停止载入
- (void)StopLoading {
    [self.dzWebView stopLoading];
}
//返回指定页面
- (void)GOTO {
    NSLog(@"%@",self.dzWebView.backForwardList.backList);
    if (self.dzWebView.backForwardList.backList.count >1) {
        [self.dzWebView goToBackForwardListItem:self.dzWebView.backForwardList.backList[1]];
    }
}
//调用js方法
- (void)CallJs:(UIButton *)sender {
    //js方法名＋参数
  //  NSString* jsCode = @"executeJS()";
   // [self.dzWebView evaluateJavaScript:jsCode completionHandler:^(id object, NSError * error) {
   //     NSLog(@"111111111");
  //  }];
}

#pragma mark WKNavigationDelegate
//类似UIWebView的-webViewDidStartLoad:页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
     NSString *  currentURL =webView.URL.absoluteString;
    
    if((!isLoad||[loadUrlStr isEqual:@""])&&![currentURL isEqual:loadUrlStr])
    {
        loadUrlStr=currentURL;
        isLoad=TRUE;
        [self showMessageToUI:@""];
    }
    [self loadDoURLBack];
         //_currentURL = webView.URL.absoluteString; //2
}
//类似UIWebView的-webViewDidFinishLoad:页面加载完成时调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
  //  isFinishExe=TRUE;
   
    [self setFinishWebLoad:webView];
 
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD hideHUD];
        });
    });
   
    
    
    //    NSLog(@"%@", @"00000");
   // __block typeof(self) weakSelf = self;
    //  [webView stringByEvaluatingJavaScriptFromString:@" if(typeof(browserVersion)!='undefined') {setBrowserVersionIOS('iphone');} "];
    // 以 block 形式关联 JavaScript function AppJsHelper.StartShare(platform,type,title,img_url,link_url,desc, callback(state,msg));
    
    /*
    NSArray *tmp = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    if(tmp.count>0)
    {
    NSString * cookies=@"";
    for (NSHTTPCookie * cookie in tmp) {
        cookies=[cookies stringByAppendingString:[NSString stringWithFormat:@"document.cookie='%@=%@';",cookie.name,cookie.value ]];
    }
    
    [webView evaluateJavaScript:cookies completionHandler:^(id result, NSError *error) {
        //...
        NSLog(@"111");
    }];
    }
    */
}

-(void) setFinishWebLoad:(WKWebView *)webView
{
    _currentURL = webView.URL.absoluteString;  //3
    [self loadDoURL:webView];
    
    if(!isvistor&&[_currentURL rangeOfString:@"?type=back"].location != NSNotFound)
    {
        isvistor=TRUE;
    }
    else if([_currentURL rangeOfString:@"?type=back"].location != NSNotFound&&isvistor==TRUE)
    {
        
        self.navigationController.navigationBarHidden = NO;
        self.tabBarController.tabBar.hidden=NO;
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    else if([_returnmain isEqual:@"3"])
    {
        backBg = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 65, 44)];
        backBg.backgroundColor =[UIColor clearColor];
        backBg.tag=2;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBack:)];
        [backBg addGestureRecognizer:tap];
        
        [self.view addSubview:backBg];
    }
    
    /* [self setFinishWebLoad:_dzWebView]**/
    isLoad=FALSE;
    loadUrlStr=_currentURL;
    theAppDelegate.httplink=_currentURL;
}
//类似UIWebView的-webView:didFailLoadWithError:页面加载失败时调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"%@",error);
}
// 当内容开始返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
   
}
//类似UIWebView的-webView:shouldStartLoadWithRequest:navigationType:在发送请求之前，决定是否跳转
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //    NSLog(@"%@",navigationAction.request);
        NSString *originHostString=[navigationAction.request.URL.absoluteString  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     decisionHandler(WKNavigationActionPolicyAllow);
    
      //  _currentURL=url;
    //    NSLog(@">>>>%@",url);
   // self.progressView.alpha = 1.0;
}

-(void) stopUnFeifaUrl:(NSString * )currUrl
{
 
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD hideHUD];
        });
    });
    if(_currentURL!=nil&&![_currentURL isEqual:@"(null)"])
    {
        currUrl=_currentURL;
    }
    NSString * localurl=[NSString stringWithFormat:@"window.location.href='%@';" ,currUrl];
    [self.dzWebView evaluateJavaScript:localurl completionHandler:^(id object, NSError * error) {
       // NSLog(@"111111111");
    }];
   // [self.dzWebView reload];
}
//接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
   // NSString *url=webView.URL.absoluteString;
   // WKWebView
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
   //  NSString *url=webView.URL.absoluteString;
   
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    // 获取cookie,并设置到本地
    NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
   
    decisionHandler(WKNavigationResponsePolicyAllow);
}
#pragma mark WKUIDelegate
/*以下三个代理方法全都是与界面弹出提示框相关的（H5自带的这三张弹出框早iOS中不能使用，需要通过以下三种方法来实现），针对于web界面的三种提示框（警告框、确认框、输入框）分别对应三种代理方法*/
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    //js里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    //  js 里面的alert实现，如果不实现，网页的alert函数无效  ,
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
    
}
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    //js里的输入框实现，如果不实现，网页的输入框无效
    completionHandler(@"Client Not handler");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showMessageToUI:(NSString*) message {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.labelText = message;
    [self performSelector:@selector(hideHUD:) withObject:progress afterDelay:10];
}


-(void) hideHUD:(MBProgressHUD*) progress {
    __block MBProgressHUD* progressC = progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        [progressC hide:YES];
        progressC = nil;
     
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
