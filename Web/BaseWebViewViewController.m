//
//  BaseWebViewViewController.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/8.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseWebViewViewController.h"
@interface BaseWebViewViewController ()<UIWebViewDelegate,JSObjcDelegate>

@end

@implementation BaseWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"ttjf"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

#pragma mark - JSObjcDelegate
//webView 与JS交互，在js代码中直接调用了ttjf.share方法，此处在webViewDidFinishLoad中截取了ttjf打头的js方法，在此处实现OC中的逻辑
- (void)share:(NSDictionary *)shareDict {
    //点击分享按钮处理
    NSLog(@"share:%@", shareDict);
    //此处应当添加分享相关代码
    // 分享成功回调js的方法shareCallback
    
//    if (0) {
        JSValue *shareCallback = self.jsContext[@"successCallBack"];
        [shareCallback callWithArguments:@[@"11111"]];
        
//    }else{
//        JSValue *shareCallback = self.jsContext[@"errorCallBack"];
//        [shareCallback callWithArguments:@[@"22222"]];
//
//    }
    
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

@end
