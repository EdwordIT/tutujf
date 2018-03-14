//
//  NumericalShopController.h
//  DingXinDai
//
//  Created by 占碧光 on 16/7/2.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface NumericalShopController : UIViewController<UIWebViewDelegate>
{
    UIWebView *iWebView;
}

@property (strong, nonatomic) JSContext *context;
@property(nonatomic, strong) NSString *urlStr;
@property(nonatomic, strong) NSString *currentURL;
@property(nonatomic, strong) NSString *isreturn;
@property(nonatomic, strong) NSString *returnmain;

//  self.tabBarController.tabBar.hidden=NO;

@end
