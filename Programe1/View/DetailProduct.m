//
//  DetailProduct.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DetailProduct.h"
#import "MBProgressHUD.h"

@implementation DetailProduct

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
       iWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)];
    iWebView.delegate=self;
  //  [iWebView sizeToFit];
    //伸缩内容适应屏幕尺寸
    iWebView.scalesPageToFit=YES;
    [iWebView setUserInteractionEnabled:YES];
    iWebView.scrollView.scrollEnabled = NO;
    iWebView.backgroundColor = [UIColor whiteColor];
    iWebView.opaque = NO; //去掉下面黑线
    iWebView.scrollView.bounces = NO;
    iWebView.scrollView.backgroundColor = [UIColor clearColor];
}
-(void) setLoaUrl:(NSString *) url
{
       self.currentURL=url;
        [self loadPage1:url];
}


//加载网页
- (void)loadPage1: (NSString *) urlstr {
    
    NSString *oldAgent = [iWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"old agent :%@", oldAgent);
    
    //add my info to the new agent
    NSString *newAgent = [oldAgent stringByAppendingString:@"TutuBrowser"];
    NSLog(@"new agent :%@", newAgent);
    
    //regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
    NSURL *url = [[NSURL alloc] initWithString:urlstr];
    NSMutableURLRequest *request ;
    
    
   
    request = [NSMutableURLRequest requestWithURL:url];
    
  //  if(iOS11)
    {
        
        [request setValue:@"Mozilla/5.0 (iPhone; CPU iPhone like Mac OS X; zh-CN;) AppleWebKit/537.51.1 (KHTML, like Gecko) Mobile/14C92 TutuBrowser/1.1.1 Mobile AliApp(TUnionSDK/0.1.12) AliApp(TUnionSDK/0.1.12)" forHTTPHeaderField:@"User-Agent"];
        
    }
    
    
    [iWebView loadRequest:request];

    [self addSubview:iWebView];
    
}



#pragma mark-UIWebViewDelegate
/**
 *WebView开始加载资源的时候调用（开始发送请求）
 */
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSString *  currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    currentURL=[currentURL stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
   

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 如果要获取webView高度必须在网页加载完成之后获取
        NSString *  currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    if ([currentURL rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/loan/apploaninfoview#?id="]].location != NSNotFound)
    {
        NSString * jumpUrl=[NSString stringWithFormat:@"window.location.href='%@';",self.currentURL];
        [webView stringByEvaluatingJavaScriptFromString:jumpUrl];
    }
    // 方法一
  //  CGFloat height = [iWebView sizeThatFits:CGSizeZero].height;
    
    // 方法二
    CGFloat height = iWebView.scrollView.contentSize.height;
    [self.delegate didSelectedHeightAtIndex:height];
    
    // 方法三 （不推荐使用，当webView.scalesPageToFit = YES计算的高度不准确）
  //  CGFloat height = [[iWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
}
@end
