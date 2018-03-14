//
//  DZWKWebViewController.h
//  DingXinDai
//
//  Created by 占碧光 on 2017/8/11.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <JavaScriptCore/JavaScriptCore.h>

@interface DZWKWebViewController : UIViewController

//@property (strong, nonatomic) JSContext *context;
@property(nonatomic, strong) NSString *urlStr;
@property(nonatomic, strong) NSString *currentURL;
@property(nonatomic, strong) NSString *isreturn;
@property(nonatomic, strong) NSString *returnmain;

@end
