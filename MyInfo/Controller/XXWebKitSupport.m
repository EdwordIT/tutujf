//
//  XXWebKitSupport.m
//  DingXinDai
//
//  Created by 占碧光 on 2017/8/20.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "XXWebKitSupport.h"


@interface XXWebKitSupport ()
@property (nonatomic, strong) WKProcessPool *processPool;

@end

@implementation XXWebKitSupport

+ (instancetype)sharedSupport {
    static XXWebKitSupport *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [XXWebKitSupport new];
    });
    return  _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.processPool = [WKProcessPool new];
    }
    return self;
}

+ (WKWebViewConfiguration *)createSharableWKWebView {
    
    WKUserContentController* userContentController = [WKUserContentController new];
    
    NSMutableString *cookies = [NSMutableString string];
    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource:[cookies copy]
                                                         injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                      forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    // 一下两个属性是允许H5视屏自动播放,并且全屏,可忽略
    configuration.allowsInlineMediaPlayback = YES;
    configuration.mediaPlaybackRequiresUserAction = NO;

    // 全局使用同一个processPool
    configuration.processPool = [[XXWebKitSupport sharedSupport] processPool];
    configuration.userContentController = userContentController;
    
   /// WKWebView *wk_webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    
    return configuration;
}
@end
