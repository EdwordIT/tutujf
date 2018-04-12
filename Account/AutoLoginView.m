//
//  AutoLoginView.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/28.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "AutoLoginView.h"
#import "HttpSignCreate.h"
#import "HttpCommunication.h"
#import "AppDelegate.h"
static AutoLoginView *defaultView = nil;
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


+ (AutoLoginView *)defaultView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultView = [[AutoLoginView alloc] init];

    });
    return defaultView;
}
-(void) getLogin:(NSString *)user_name  password:(NSString *)password
{
    
    UIDevice* curDev = [UIDevice currentDevice];
    NSString *terminal_type=@"iphone";
    NSString *terminal_id=curDev.identifierForVendor.UUIDString;//curDev.identifierForVendor.UUIDString;
    NSString *terminal_name= [curDev.name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *terminal_model=curDev.model;
    NSString * terminal_token=[CommonUtils getDeviceToken];
    NSString *urlStr = @"";
    NSDictionary *dict_data=[[NSDictionary alloc] initWithObjects:@[user_name,password,terminal_type,terminal_id,terminal_name,terminal_model,terminal_token] forKeys:@[@"user_name",@"password",@"terminal_type",@"terminal_id",@"terminal_name",@"terminal_model",@"terminal_token"]];
    //  paixu
    NSMutableArray * paixu1=[[NSMutableArray alloc] init];
    [paixu1 addObject:@"user_name"];
    [paixu1 addObject:@"password"];
    [paixu1 addObject:@"terminal_type"];
    [paixu1 addObject:@"terminal_id"];
    [paixu1 addObject:@"terminal_name"];
    [paixu1 addObject:@"terminal_model"];
    [paixu1 addObject:@"terminal_token"];
    NSString *sign=[HttpSignCreate GetSignStr:dict_data paixu:paixu1];
    NSString *  password1=[HttpSignCreate encodeString:password];
    user_name=[HttpSignCreate encodeString:user_name];
    terminal_name=[HttpSignCreate encodeString:terminal_name];
    urlStr = [NSString stringWithFormat:loginUrl,oyApiUrl,user_name,password1,terminal_type,terminal_id,terminal_name,terminal_model,terminal_token,sign];
    
    [[HttpCommunication sharedInstance] getRequestWithURL:urlStr refresh:nil success:^(NSDictionary *successDic) {
        if(successDic!=nil)
        {
            //登陆成功
            NSString * temp=[[successDic objectForKey:@"expiration_date"] substringWithRange:NSMakeRange(0,10)];
            [TTJFUserDefault setStr:[successDic objectForKey:kToken] key:kToken];
            [TTJFUserDefault setStr:user_name key:kUsername];
            [TTJFUserDefault setStr:password key:kPassword];
            [TTJFUserDefault setStr:temp key:kExpirationTime];
            [self loginWebView];
            //登录状态改变发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:Noti_LoginChanged object:nil];
        }else{
            [self removeUserInfo];
            
        }
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
    NSDate *expirDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",extime]];
    int seconds = [CommonUtils getSecondForFromDate:[self getCurrentTime] toDate:expirDate];
    //测试当前token是否过期，如果过期，则需要重新登录，并清除token等个人信息
    if(seconds<=0)
    {
        [self cleanCaches];//清理缓存
        [self removeUserInfo];//时间过期
        [self getLogin:user_name password:password];
    }
    else
    {
        //当前token有效，不用重新更新token，也不需要重新登录
        [self removeFromSuperview];
        defaultView = nil;
        
    }
  
}
-(void)loginWebView//webView登录
{
    
    NSString *user_name=[CommonUtils getUsername];
    NSString *user_token= [TTJFUserDefault strForKey:kToken];
    NSString *urlStr = @"";
    user_name=[HttpSignCreate encodeString:user_name];
    NSDictionary *dict_data=[[NSDictionary alloc] initWithObjects:@[user_name,user_token] forKeys:@[kUsername,kToken]];
    NSMutableArray * paixu1=[[NSMutableArray alloc] init];
    [paixu1 addObject:kUsername];
    [paixu1 addObject:kToken];
    NSString *sign=[HttpSignCreate GetSignStr:dict_data paixu:paixu1];
    NSString *equipment = @"ios";
    urlStr = [NSString stringWithFormat:webLoginUrl,oyUrlAddress,user_name,user_token,sign,equipment];
    self.mainWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 0,0)];
    self.mainWebView.delegate=self;
    //伸缩内容适应屏幕尺寸
    self.mainWebView.scalesPageToFit=YES;
    [self.mainWebView setUserInteractionEnabled:YES];
    [self cleanCaches];
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"%@",urlStr);
    [self.mainWebView loadRequest:request];
    self.mainWebView.scrollView.bounces = NO;
    [self addSubview:self.mainWebView];
    
}
-(void)exitLogin//webView退出登录
{
    [self cleanCaches];
    [self removeUserInfo];
}

-(void)removeUserInfo{
    //清除token记录
    [TTJFUserDefault removeStrForKey:kToken];
    [TTJFUserDefault removeStrForKey:kPassword];
    [TTJFUserDefault removeStrForKey:kExpirationTime];
    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_LoginChanged object:nil];
}

#pragma mark webViewDelegate
/**
 *WebView加载完毕的时候调用（请求完毕）
 */
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    if (self.autoLoginBlock) {
        self.autoLoginBlock();
        [self removeFromSuperview];
        defaultView = nil;
    }
}
#pragma mark -得到当前时间
- (NSDate *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    return date;
}

- (void)cleanCaches{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
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
