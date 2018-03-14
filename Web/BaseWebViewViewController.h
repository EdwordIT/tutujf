//
//  BaseWebViewViewController.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/8.
//  Copyright © 2018年 TTJF. All rights reserved.
//webView与js交互的基础类

#import "BaseViewController.h"
#import<JavaScriptCore/JavaScriptCore.h>
@protocol JSObjcDelegate<JSExport>
- (void)share:(NSDictionary *)shareDict;
@end
@interface BaseWebViewViewController : BaseViewController

@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, strong)  UIWebView *webView;
@property(nonatomic,assign) id<JSObjcDelegate>jsDelegate;
@end
