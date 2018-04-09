//
//  HomeWebController.h
//  TTJF
//
//  Created by 占碧光 on 2017/4/21.
//  Copyright © 2017年 占碧光. All rights reserved.
//webView基础类

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
//#import "SDScanViewController.h"

#define  webUrl [oyUrlAddress stringByAppendingString:@"/trust/back/backRecharge"];

#define s2SUrl  [oyUrlAddress stringByAppendingString:@"/trust/back/noftifyRecharge"];

#define merchantID1  @"1921470025";
// 3DES加密密钥
#define DES_KEY  @"mLQEQmy53ffJXQBZNu6ShwkU";
// 3DES加密向量
#define DES_IV  @"vnlN5Dre";
// 商户MD5数字证书
#define MD5_CERT   @"8fJPaXNUNjB6K4rxHOCw72PPRZV4v5k2emqMPh73oRlUSE3tN4qbBhCVOO1nZ4QfOGkrWXP4NHTJQqVRNBvdnps1xMtalWSxCsuvMDOhUlHU7gznJESLVv7u3yGyJh00";

@interface HomeWebController : BaseViewController
{
    NSTimer *timer;
}

@property (retain,nonatomic) CLLocationManager *locManager;
@property (nonatomic, copy) NSString *orderNum;
@property (nonatomic, copy) NSString *qCodeString;
@property (nonatomic, copy) NSString *callbackScan;

@property (nonatomic, copy) NSString *Returnurl;
//旧代码方法，暂时未发现有地方使用，下个版本删除
//-(void)sendPay2:(NSString *)mysubject body:(NSString *) mybody  orderId:(NSString *) myorderId price:(NSString *) myprice;
@property (strong, nonatomic) HomeWebController *mainViewController;


@property(nonatomic, strong) NSString *urlStr;
@property(nonatomic, strong) NSString *currentURL;
@property(nonatomic, strong) NSString *returnmain;

@end
