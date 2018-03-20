//
//  DetailProduct.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DetailProduct.h"
#import "MBProgressHUD.h"

@interface DetailProduct()<UIWebViewDelegate>
Strong UIWebView *proWebView;
@end
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
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
       self.proWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.width,100)];
    self.proWebView.delegate=self;
//    [self.proWebView sizeToFit];
    //伸缩内容适应屏幕尺寸
    self.proWebView.scalesPageToFit=YES;
    [self.proWebView setUserInteractionEnabled:YES];
    self.proWebView.scrollView.scrollEnabled = NO;
    self.proWebView.backgroundColor = [UIColor whiteColor];
    self.proWebView.opaque = NO; //去掉下面黑线
    self.proWebView.scrollView.bounces = NO;
    self.proWebView.scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.proWebView];
    [self.proWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

}
-(void) setLoaUrl:(NSString *) url
{
       self.currentURL=url;
        [self loadPage1:url];
}


//加载网页
- (void)loadPage1: (NSString *) urlstr {
    
    NSURL *url = [[NSURL alloc] initWithString:urlstr];
    NSMutableURLRequest *request ;
    request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"Mozilla/5.0 (iPhone; CPU iPhone like Mac OS X; zh-CN;) AppleWebKit/537.51.1 (KHTML, like Gecko) Mobile/14C92 TutuBrowser/1.1.1 Mobile AliApp(TUnionSDK/0.1.12) AliApp(TUnionSDK/0.1.12)" forHTTPHeaderField:@"User-Agent"];
    [self.proWebView loadRequest:request];
}



#pragma mark-UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    // 如果要获取webView高度必须在网页加载完成之后获取
    CGFloat webViewHeight =[webView.scrollView contentSize].height;
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    webView.frame = newFrame;
    

}
//通过监听获取webView高度变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize fittingSize = [self.proWebView sizeThatFits:CGSizeZero];
        self.proWebView.height = fittingSize.height;
        [self.delegate didSelectedHeightAtIndex:fittingSize.height];
    }
}
-(void)dealloc{

    [self.proWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}
@end
