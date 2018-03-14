//
//  TenderViewController.h
//  IPSP2P
//
//  Created by mac on 16/5/10.
//  Copyright © 2016年 xgzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
@protocol JSObjcDelegate <JSExport>
/**
 *  声明js调用oc的方法
 */
-(void)back2App:(NSString*)message;

@end
@protocol TenderWithDelegate <NSObject>
@optional
-(void)TenderResult:(NSString * )Result;

@end

@interface TenderViewController : UIViewController<UINavigationControllerDelegate,UIWebViewDelegate,JSObjcDelegate>
@property (nonatomic ,assign) id<TenderWithDelegate>delegate;
+(void)TenderWithOperationType:(NSString* )operationType MerchantID:(NSString*)merchantID Sing:(NSString *)sign Request:(NSString *)request ViewController:(UIViewController *)selfViewController Delegate:(id<TenderWithDelegate>)delegate;

@end
