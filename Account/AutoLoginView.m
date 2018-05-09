//
//  AutoLoginView.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/28.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "AutoLoginView.h"
#import "HttpCommunication.h"
#import "AppDelegate.h"
#import "HttpSignCreate.h"
#import <WebKit/WebKit.h>
@interface AutoLoginView()<UIWebViewDelegate>
Strong UIWebView *mainWebView;
@end
@implementation AutoLoginView
-(instancetype)init{
    self.frame = CGRectMake(0, 0, 0, 0);
    self = [super init];
    if (self) {
    }
    return self;
}

-(void) getLogin:(NSString *)user_name  password:(NSString *)password
{
   /* user_name    string    用户名
    password    string    密码
    terminal_type    string    (终端类型)： android安卓,ios    苹果
    terminal_id    string    安卓时传入接受人设备的：IMEI,  苹果时传入接受人设备的：UUID
    terminal_name    string    (设备名称)：如 iPhone 6S
    terminal_model    string    (设备型号)：iPhone 6S
    terminal_token    string    推送token（为：device_token）
    sign    string    加密符号
    */
    
    NSArray *keys =@[@"user_name",@"password",@"terminal_type",@"terminal_id",@"terminal_name",@"terminal_model",@"terminal_token"];
    NSArray *values = @[user_name,password,@"ios",[CommonUtils getUUID],[UIDevice currentDevice].name,[CommonUtils getDeviceVersion],[CommonUtils getDeviceToken]];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:loginUrl keysArray:keys valuesArray:values refresh:nil success:^(NSDictionary *successDic) {
        //登陆成功
            NSString * temp=[[successDic objectForKey:kExpirationTime] substringToIndex:10];
            [TTJFUserDefault setStr:[successDic objectForKey:kToken] key:kToken];
            [TTJFUserDefault setStr:user_name key:kUsername];
            [TTJFUserDefault setStr:password key:kPassword];
            [TTJFUserDefault setStr:temp key:kExpirationTime];
            [TTJFUserDefault setStr:[successDic objectForKey:@"realname_status"] key:isCertificationed];//保存是否已经实名认证过的信息
            [self setCookie];
        
    } failure:^(NSDictionary *errorDic) {
        [self removeUserInfo];
    }];
}

-(void)autoLogin//自动登录
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //根据键值取出name
    NSString *extime = [TTJFUserDefault strForKey:kExpirationTime];
    NSString *user_name = [TTJFUserDefault strForKey:kUsername];
    NSString *password = [TTJFUserDefault strForKey:kPassword];
    if(extime==nil)
        extime=@"2015-01-01";
    NSDate *expirDate = [dateFormatter dateFromString:extime];
    int seconds = [CommonUtils getSecondForFromDate:[self getCurrentTime] toDate:expirDate];
    //测试当前token是否过期，如果过期，则需要重新登录，并清除token等个人信息
    if(seconds<=0)
    {
        [self exitLogin];
        [self getLogin:user_name password:password];
    }
    else
    {
//        //当前token有效，不用重新更新token，也不需要重新登录,More
        [self setCookie];
    }
  
}
- (void)setCookie{//向webView中写入cookie值
    //根据键值取出name
    NSString *user_name = [TTJFUserDefault strForKey:kUsername];
    NSString *password = [TTJFUserDefault strForKey:kPassword];
    
    NSMutableDictionary *name = [NSMutableDictionary dictionary];
    [name setObject:@"remember-name" forKey:NSHTTPCookieName];
    [name setObject:user_name forKey:NSHTTPCookieValue];
    [name setObject:dominUrl forKey:NSHTTPCookieDomain];
    [name setObject:[[NSDate date] dateByAddingTimeInterval:2592000] forKey:NSHTTPCookieExpires];
    [name setObject:@"/" forKey:NSHTTPCookiePath];
    [name setObject:@"0" forKey:NSHTTPCookieVersion];
    
    NSHTTPCookie *cookName = [NSHTTPCookie cookieWithProperties:name];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookName];
    
    NSMutableDictionary *pwd = [NSMutableDictionary dictionary];
    [pwd setObject:@"remember-pwd" forKey:NSHTTPCookieName];
    [pwd setObject:[@"ttapp:" stringByAppendingString:password] forKey:NSHTTPCookieValue];
    [pwd setObject:dominUrl forKey:NSHTTPCookieDomain];
    [pwd setObject:[[NSDate date] dateByAddingTimeInterval:2592000] forKey:NSHTTPCookieExpires];
    [pwd setObject:@"/" forKey:NSHTTPCookiePath];
    [pwd setObject:@"0" forKey:NSHTTPCookieVersion];
    
    NSHTTPCookie *cookiePwd = [NSHTTPCookie cookieWithProperties:pwd];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookiePwd];
    
    self.mainWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 0,0)];
    self.mainWebView.delegate=self;
    //伸缩内容适应屏幕尺寸
    self.mainWebView.scalesPageToFit=YES;
    [self.mainWebView setUserInteractionEnabled:YES];
    self.mainWebView.scrollView.bounces = NO;
    [self addSubview:self.mainWebView];
    
    NSURL *url = [[NSURL alloc] initWithString:oyUrlAddress];
    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:url];
    NSMutableString *cookies = [NSMutableString string];
    NSArray *tmp = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie * cookie in tmp) {
        [cookies appendFormat:@"%@=%@;",cookie.name,cookie.value];
    }
    // 注入Cookie，识别webView登录状态
    [request setValue:cookies forHTTPHeaderField:@"Cookie"];
//    [request setValue:@"Mozilla/5.0 (iPhone; CPU iPhone like Mac OS X; zh-CN;) AppleWebKit/537.51.1 (KHTML, like Gecko) Mobile/14C92 TutuBrowser/1.1.1 Mobile AliApp(TUnionSDK/0.1.12) AliApp(TUnionSDK/0.1.12)" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPShouldHandleCookies:YES];
    
    [self.mainWebView loadRequest:request];
}
-(void)exitLogin//webView退出登录
{
    [self cleanCaches];
    [self removeUserInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_LoginChanged object:nil];//登录状态变更，刷新首页数据
}

-(void)removeUserInfo{
    //清除token记录
    [TTJFUserDefault removeStrForKey:kToken];
    [TTJFUserDefault removeStrForKey:kPassword];
    [TTJFUserDefault removeStrForKey:kExpirationTime];
    [TTJFUserDefault removeStrForKey:isCertificationed];
    [TTJFUserDefault removeStrForKey:isReged];
}

#pragma mark webViewDelegate
/**
 *WebView加载完毕的时候调用（请求完毕）
 */
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
   
    if (self.autoLoginBlock) {
        self.autoLoginBlock();
    }
    [self performSelector:@selector(loginChanged) withObject:nil afterDelay:1.5];
    //登录状态改变发送通知,延时发送
   
}
//登录状态发生改变
-(void)loginChanged{
    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_LoginChanged object:nil];
}
#pragma mark -得到当前时间
- (NSDate *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    return date;
}

/*
 清除缓存
 */
- (void)cleanCaches{
    //清除缓存和cookie
    NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookiesArray) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    if ([UIDevice currentDevice].systemVersion.doubleValue<9.0) {//ios9以下
        
        
    }else{
        //            NSSet *websiteDataTypes = [NSSet setWithArray:@[
        //
        //                                    WKWebsiteDataTypeDiskCache,
        //
        //                                    WKWebsiteDataTypeOfflineWebApplicationCache,
        //
        //                                    WKWebsiteDataTypeMemoryCache,
        //
        //                                    WKWebsiteDataTypeLocalStorage,
        //
        //                                    WKWebsiteDataTypeCookies,
        //
        //                                    WKWebsiteDataTypeSessionStorage,
        //
        //                                    //WKWebsiteDataTypeIndexedDBDatabases,
        //
        //                                    //WKWebsiteDataTypeWebSQLDatabases
        //
        //                                    ]];
        //清除的缓存类型
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:[NSDate dateWithTimeIntervalSince1970:0] completionHandler:^{
            
        }];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
