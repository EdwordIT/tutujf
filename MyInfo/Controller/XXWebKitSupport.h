//
//  XXWebKitSupport.h
//  DingXinDai
//
//  Created by 占碧光 on 2017/8/20.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface XXWebKitSupport : NSObject

@property (nonatomic, strong,readonly) WKProcessPool *processPool;
+ (instancetype)sharedSupport;
+ (WKWebViewConfiguration *)createSharableWKWebView;
@end

