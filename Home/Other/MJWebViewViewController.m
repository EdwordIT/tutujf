//
//  MJWebViewViewController.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/12.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJWebViewViewController.h"
#import "UIViewController+Example.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MP.h"
#import  "AppDelegate.h"

@interface MJWebViewViewController () <UIWebViewDelegate>
{
    UIButton *backBtn;
    Boolean isLoad;
    NSString *  loadUrlStr;
    UIView *backTopBg;
    Boolean isTeshu;
    UIView *topline;
      UIView *backBg;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation MJWebViewViewController
#pragma mark - 示例
- (void)example31
{
    __weak UIWebView *webView = self.webView;
    webView.delegate = self;
    
    __weak UIScrollView *scrollView = self.webView.scrollView;
    
    // 添加下拉刷新控件
    scrollView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [webView reload];
    }];
    
    // 如果是上拉刷新，就以此类推
}

#pragma mark - webViewDelegate
- (void)webViewDidFinishLoad:(nonnull UIWebView *)webView
{
    if(backBtn==nil)
    {
        backBtn=[[UIButton alloc] init];
        if(kDevice_Is_iPhoneX)
            backBtn.frame = CGRectMake(0, 20, 85, 64);
        else
            backBtn.frame = CGRectMake(0, 20, 65, 44);
        [backBtn addTarget:self action:@selector(OnTapBack:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView * imageview1=[[UIImageView alloc] init];
        imageview1.frame=CGRectMake(25, 15, 8, 16);
        [imageview1 setImage:[UIImage imageNamed:@"Signup_iceo_return"] ] ;
        [backBtn addSubview:imageview1];
        [self.view addSubview:backBtn];
    }
    else
        [backBtn setHidden:FALSE];
    if(webView.isLoading)
    {
        return;
    }
    isLoad=FALSE;
    [self.webView.scrollView.mj_header endRefreshing];
}

#pragma mark - 其他
- (void)viewDidLoad {
    [super viewDidLoad];
    isTeshu=FALSE;
    isLoad=FALSE;
    if(kDevice_Is_iPhoneX)
        topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 34)];
    else
        topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 20)];
    topline.backgroundColor =RGB(14,118,235);
    [topline setHidden:TRUE];
    //  line.contentMode = UIViewContentModeScaleAspectFill;
    //  line.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topline];
    [self example31];
    
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
    
    // 加载页面
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  //  [self performSelector:NSSelectorFromString(self.method) withObject:nil];
#pragma clang diagnostic pop
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


-(void)webViewDidStartLoad:(UIWebView *)webView
{
    self.currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    self.currentURL=[self.currentURL stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
    if([_returnmain isEqual:@"3"])
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    if((!isLoad||[loadUrlStr isEqual:@""]))
    {
        loadUrlStr=self.currentURL;
        isLoad=TRUE;
        [MBProgressHUD showIconMessage:@"" ToView:self.view RemainTime:0.3];
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
        
        else if(self.webView.canGoBack&&[_currentURL rangeOfString:_urlStr].location == NSNotFound&&[_urlStr rangeOfString:_currentURL].location == NSNotFound)
        {
            if(backBg!=nil)
            {
               
            }
            [self.webView goBack];
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
    
            return;
        }
        if(!self.webView.canGoBack)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationController.navigationBarHidden = NO;
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        else
        {
            NSString * jumpUrl=[NSString stringWithFormat:@"window.location.href='%@';",self.currentURL];
          [self.webView stringByEvaluatingJavaScriptFromString:jumpUrl];
        }
        
    }
    
}

@end
