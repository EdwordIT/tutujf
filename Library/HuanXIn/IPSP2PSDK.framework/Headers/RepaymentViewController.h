//
//  RepaymentViewController.h
//  IPSP2P
//
//  Created by mac on 16/5/10.
//  Copyright © 2016年 xgzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
@class RepaymentViewController;
@protocol RepaymentWithDelegate <NSObject>
@optional
-(void)RepaymentResult:(NSString * )Result;

@end
@protocol JSObjcDelegate <JSExport>
/**
 *  声明js调用oc的方法
 */
-(void)back2App:(NSString*)message;

@end

@interface RepaymentViewController : UIViewController<UINavigationControllerDelegate,UIWebViewDelegate,JSObjcDelegate>
@property (nonatomic ,weak) id<RepaymentWithDelegate>delegate;
+(void)RepaymentWithOperationType:(NSString* )operationType MerchantID:(NSString*)merchantID Sing:(NSString *)sign Request:(NSString *)request ViewController:(UIViewController *)selfViewController Delegate:(id<RepaymentWithDelegate>)delegate;

@end
