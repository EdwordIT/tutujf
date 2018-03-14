//
//  IPSP2PViewController.h
//  IPSP2P
//
//  Created by mac on 16/5/9.
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
@protocol IPSP2PWithDelegate <NSObject>
@optional
-(void)IPSP2PResult:(NSString * )Result;

@end

@interface IPSP2PViewController : UIViewController<UIWebViewDelegate,JSObjcDelegate>
@property (nonatomic ,assign) id<IPSP2PWithDelegate>delegate;
+(void)IPSP2PwithOperationType:(NSString* )operationType MerchantID:(NSString*)merchantID Sing:(NSString *)sign Request:(NSString *)request ViewController:(UIViewController *)selfViewController Delegate:(id<IPSP2PWithDelegate>)delegate;

+(void)IPSP2PRechargeWithOperationType:(NSString* )operationType MerchantID:(NSString*)merchantID DepositType:(NSString*)depositType Sign:(NSString*)sign Request:(NSString*)request fromScheme:(NSString*)fromScheme ViewController:(UIViewController *)selfViewController Delegate:(id<IPSP2PWithDelegate>)delegate;
//@property(nonatomic,strong)UIWebView * webView;
@end
