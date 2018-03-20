//
//  DMLoginViewController.m
//  TTJF
//
//  Created by 占碧光 on 2017/3/9.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DMLoginViewController.h"
#import "DMRegisterViewController.h"
#import "UITextField+Shake.h"
#import "ForgotPassWordViewController.h"
#import "WinChageType.h"
#import "AppDelegate.h"
#import "HttpSignCreate.h"
#import "ggHttpFounction.h"
#import "HttpUrlAddress.h"
#import "HomeWebController.h"
#import "MBProgressHUD+MP.h"
#import "SVProgressHUD.h"
#import <WebKit/WebKit.h>
#import "XXWebKitSupport.h"

@interface DMLoginViewController ()<UITextFieldDelegate,UIWebViewDelegate,MBProgressHUDDelegate>
@property (nonatomic ,strong)UITextField *phoneTextFiled;
@property (nonatomic ,strong)UITextField *passwordTextFiled;


@end

@implementation DMLoginViewController
{
    UIButton *registerButton;
    UIButton *loginButton ;
    UIButton *forgetButton;
    UIImageView * yanjing;
    UIWebView * iWebView;
     NSInteger *couTimer;
       NSMutableURLRequest *request ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    couTimer=0;
    self.view.backgroundColor=RGB(246,246,246);
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setHidden:TRUE];
    [self initView];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setHidden:TRUE];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


-(void) initView
{
    UIImageView * close= [[UIImageView alloc] init];
    
    [close setImage:[UIImage imageNamed:@"login_iceo_Close"]];
    if(kDevice_Is_iPhoneX)
    {
          close.frame=CGRectMake(25, 45, 16, 16);
    }
    else
    close.frame=CGRectMake(15, 35, 16, 16);
    [close setUserInteractionEnabled:TRUE];

    [self.view addSubview:close];
    
    UIButton * btn4=[[UIButton alloc] initWithFrame:CGRectMake(10, 15, 60, 40)];
    if(kDevice_Is_iPhoneX)
    {
        btn4.frame=CGRectMake(10, 15, 80, 60);
    }
    [btn4 setBackgroundColor:[UIColor clearColor]];
    btn4.tag=2;
    [btn4 addTarget:self action:@selector(OnTapBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
    UIImageView * lg= [[UIImageView alloc] init];
    
    [lg setImage:[UIImage imageNamed:@"user01.png"]];
    lg.frame=CGRectMake(screen_width/2-47.5, 88, 95, 95);
    [self.view addSubview:lg];
    
    UIView * line1=[[UIView alloc] initWithFrame:CGRectMake(40, 258, screen_width-80, 0.5)];
    line1.backgroundColor=RGB(218,218,218);
     [self.view addSubview:line1];
    
    UIView * line2=[[UIView alloc] initWithFrame:CGRectMake(40, 318, screen_width-80, 0.5)];
    line2.backgroundColor=RGB(218,218,218);
    [self.view addSubview:line2];
    //user01.png
    
    UIImageView * imgico1= [[UIImageView alloc] init];
    [imgico1 setImage:[UIImage imageNamed:@"logo_ico05.png"]];
    imgico1.frame=CGRectMake(40, 230, 20, 20);
    [self.view addSubview:imgico1];
    
    UIImageView * yanjing1= [[UIImageView alloc] init];
    
    [yanjing1 setImage:[UIImage imageNamed:@"colse.png"]];
    yanjing1.frame=CGRectMake(screen_width-65, 232, 2, 15);
  //  [self.view addSubview:yanjing1];
    
    _phoneTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(64, 226, 271, 30)];
    _phoneTextFiled.delegate = self;
    _phoneTextFiled.placeholder = @"请输入您的账号";
    _phoneTextFiled.font = [UIFont systemFontOfSize:14];
    _phoneTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
   [_phoneTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_phoneTextFiled];
    
    UIImageView * imgico2= [[UIImageView alloc] init];
    [imgico2 setImage:[UIImage imageNamed:@"logo_ico02.png"]];
    imgico2.frame=CGRectMake(40, 290, 20, 20);
    [self.view addSubview:imgico2];
    
    yanjing= [[UIImageView alloc] init];
    
    [yanjing setImage:[UIImage imageNamed:@"Password_iceo_turnon"]];
    yanjing.frame=CGRectMake(screen_width-65, 292, 18, 12);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImage:)];
    yanjing.tag=0;
    yanjing.userInteractionEnabled=YES;
    [yanjing addGestureRecognizer:tap];
  //  [self.view addSubview:yanjing];
    
    
    _passwordTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(64, 285, 271, 30)];
    _passwordTextFiled.delegate = self;
    _passwordTextFiled.placeholder = @"请输入您的密码";
    _passwordTextFiled.font = [UIFont systemFontOfSize:14];
    _passwordTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTextFiled.secureTextEntry = YES;
    [_passwordTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.view addSubview:_passwordTextFiled];
    
    
   
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];

     loginButton.frame = CGRectMake(40, 345, screen_width -80, 45);
    [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundColor:RGB(200,226,242)];
    [loginButton.layer setCornerRadius:25]; //设置矩形四个圆角半径
    [self.view addSubview:loginButton];
    // RGB(69,178,247)
    
    forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];

    forgetButton.frame = CGRectMake(screen_width/2-90, 404, 75, 14);
    
    [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetButton setTitleColor:RGB(91,91,91) forState:UIControlStateNormal];//title color
    [forgetButton addTarget:self action:@selector(forgotPwdButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetButton];
    
    registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(screen_width/2-28, 404, 150, 14);
    [registerButton setTitle:theAppDelegate.globed.register_txt forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [registerButton setTitleColor:RGB(252,18,18) forState:UIControlStateNormal];//title color
    [registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    UIView * line3=[[UIView alloc] initWithFrame:CGRectMake(screen_width/2-16, 402, 0.5, 16)];
    line3.backgroundColor=RGB(218,218,218);
    [self.view addSubview:line3];
    
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    hud = nil;
}


//返回按钮点击事件
-(void)backBtnClick:(UIButton *)button
{
   // theAppDelegate.webLogin=0;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    // exit(0);
}
//注册按钮点击事件
-(void)registerButtonClick:(UIButton *)button
{
   //http://www.tutujf.com/wap/system/register2

    HomeWebController *discountVC = [[HomeWebController alloc] init];
   // discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/system/register2",urlCheckAddress];
    discountVC.urlStr=theAppDelegate.globed.register_link;//[NSString stringWithFormat:@"%@/wap/system/register2",urlCheckAddress];
    //https://cs.www.tutujf.com/wap/system/login2
    discountVC.returnmain=@"4"; //页返回
    [self presentViewController:discountVC animated:YES completion:nil];

}
//忘记密码点击事件
-(void)forgotPwdButtonClick:(UIButton *)button
{
    //http://www.tutujf.com/wap/system/searchPwd

    HomeWebController *discountVC = [[HomeWebController alloc] init];
    discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/system/searchPwd",urlCheckAddress];
    
    discountVC.returnmain=@"4"; //页返回
  [self presentViewController:discountVC animated:YES completion:nil];
  
}
//登录点击事件
-(void)loginButtonClick:(UIButton *)button
{
    if (_phoneTextFiled.text.length>1 && _passwordTextFiled.text.length >1 ) {
       // [MBProgressHUD showAutoMessage:@"正在登录..." ToView:nil];
           [SVProgressHUD showWithStatus:@"正在登录..."];
        [self getLogin];
        return ;
    }
    /*
    if (_passwordTextFiled.text.length < 6|| _passwordTextFiled.text.length > 16) {
        [_passwordTextFiled shake];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入正确的密码格式" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
     */
    if (_phoneTextFiled.text.length <2) {
        [_phoneTextFiled shake];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入正确的账号" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if (_passwordTextFiled.text.length <2) {
        [_passwordTextFiled shake];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入正确的密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
    

    [self.navigationController popViewControllerAnimated:YES];
    
    
}


#pragma mark UITextFiledDelegate



-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    if(_passwordTextFiled.text.length>0&&_phoneTextFiled.text.length >0)
    {
        [loginButton setBackgroundColor:navigationBarColor];
        
    }
    else
    {
        [loginButton setBackgroundColor:RGB(200,226,242)];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _phoneTextFiled) {
        [_phoneTextFiled resignFirstResponder];
    }
    if (textField == _passwordTextFiled) {
        [_passwordTextFiled resignFirstResponder];
    }
   
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)OnTapBack:(id)sender{
 //   UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    /*
    WinChageType * wtype=[[WinChageType alloc] init];
    wtype.lgointype=@"1"; //
    wtype.logindeep=@"2"; //初始化
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:wtype];
     */
    [self dismissViewControllerAnimated:YES completion:nil];
 // [self.navigationController popViewControllerAnimated:YES];
}

-(void) OnTapImage:(id)sender{
    
}


-(void) getYUancheng{
    //Api/Users/GetUsetInfo?user_token={user_token}&sign={sign}
    NSString *user_name=theAppDelegate.user_name;
     NSString *user_token=theAppDelegate.user_token;
    NSString *urlStr = @"";
    
    user_name=[HttpSignCreate encodeString:user_name];
     NSDictionary *dict_data=[[NSDictionary alloc] initWithObjects:@[user_name,user_token] forKeys:@[@"user_name",kToken]];
    NSMutableArray * paixu1=[[NSMutableArray alloc] init];
    [paixu1 addObject:@"user_name"];
    [paixu1 addObject:kToken];
    NSString *sign=[HttpSignCreate GetSignStr:dict_data paixu:paixu1];
    urlStr = [NSString stringWithFormat:webLoginUrl,urlCheckAddress,user_name,user_token,sign];
    [self loadPage1:urlStr];

    
}

-(void) getLogin{
    UIDevice* curDev = [UIDevice currentDevice];
    NSString *terminal_type=@"iphone";
    NSString *terminal_id=curDev.identifierForVendor.UUIDString;//curDev.identifierForVendor.UUIDString;
    NSString *terminal_name= [curDev.name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *terminal_model=curDev.model;
    NSString * terminal_token=theAppDelegate.device_token;
    NSString *urlStr = @"";
    NSString * user_name=[_phoneTextFiled text];
    NSString *  password=[_passwordTextFiled text];
    
    terminal_name=[terminal_name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    /*  test
    terminal_type=@"iphone";
   terminal_id=@"1EEDE7A1-E953-4FC3-B903-D590D68CA97A";//curDev.identifierForVendor.UUIDString;
   terminal_name=@"一二A";
   terminal_model=@"iPhone";
  terminal_token=@"f3cad1be866d192819a65708111707fd931882bf807b3c452c3b61ac6d3e5556";
    user_name=@"tt13707985381";
    password=@"ncepu789";
 */
    //   NSString *password1=@"123456";
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
    terminal_name= [terminal_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *  password1=[HttpSignCreate encodeString:[_passwordTextFiled text]];
    urlStr = [NSString stringWithFormat:loginUrl,oyApiUrl,user_name,password1,terminal_type,terminal_id,terminal_name,terminal_model,terminal_token,sign];
    
    NSData * data=  [ggHttpFounction  synHttpGet:urlStr];
    if([ggHttpFounction getJsonIsOk:data])
    {
        NSDictionary * dir= [ggHttpFounction getJsonData1:data];
        if(dir!=nil)
        {
            
            theAppDelegate.user_token=  [dir objectForKey:kToken];
            theAppDelegate.user_name= user_name;
            NSString * temp=[[dir objectForKey:@"expiration_date"] substringWithRange:NSMakeRange(0,10)];
            theAppDelegate.expirationdate=temp;
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            [userDef setObject:temp forKey:@"LoginTime"];
            [userDef setObject:user_name forKey:@"LoginAccount"];
            [userDef setObject:password forKey:@"LoginPassword"];
            //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
            [userDef setObject:@"1" forKey:@"IsSet"];
            [userDef synchronize];
            theAppDelegate.IsLogin=TRUE;
            [TTJFUserDefault setStr:[dir objectForKey:kToken] key:kToken];//存储登录成功token值
            [self getYUancheng];
        }
        
    }
    else
    {
        // [MBProgressHUD showAutoMessage:@"登录失败" ToView:nil];
        NSString * msg=[ggHttpFounction getJsonMsg:data];
        [SVProgressHUD showErrorWithStatus:msg];
        /*
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:[ggHttpFounction getJsonMsg:data] message:nil preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
         [alert addAction:action];
         [self presentViewController:alert animated:YES completion:nil];
         */
        
    }

   
    

}

//加载网页
- (void)loadPage1: (NSString *) urlstr {
    
    iWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 0,0)];
    
    iWebView.delegate=self;
    //伸缩内容适应屏幕尺寸
    iWebView.scalesPageToFit=YES;
    [iWebView setUserInteractionEnabled:YES];
    
    [self cleanCaches];
    NSURL *url = [[NSURL alloc] initWithString:urlstr];
    //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
 
    request = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"%@",urlstr);
    
    //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    /*
    NSMutableString *cookies = [NSMutableString string];
    NSArray *tmp = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie * cookie in tmp) {
        [cookies appendFormat:@"%@=%@;",cookie.name,cookie.value];
    }
    [request setHTTPShouldHandleCookies:YES];
    // 注入Cookie
    [request setValue:cookies forHTTPHeaderField:@"Cookie"];
     */
    
    [iWebView loadRequest:request];
    iWebView.scrollView.bounces = NO;
    [self.view addSubview:iWebView];
    //  [iWebView isHidden:TRUE];
    
}


/**
 *WebView加载完毕的时候调用（请求完毕）
 */
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            //将上述数据全部存储到NSUserDefaults中
      ;
            [SVProgressHUD showSuccessWithStatus:@"登录成功~"];
            [self dismissViewControllerAnimated:YES completion:NULL];
        });
    });
    /*

    if(couTimer==2)
    {
     dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            //将上述数据全部存储到NSUserDefaults中
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
            [userDefaults setObject:@"1" forKey:@"IsSet"];
            [SVProgressHUD showSuccessWithStatus:@"登录成功~"];
            [self dismissViewControllerAnimated:YES completion:NULL];
        });
      });
    }
    else
    {
        couTimer++;
            [iWebView loadRequest:request];
    }
    */
}



-(void)webViewDidStartLoad:(UIWebView *)webView
{
//  BBUserDefault.isNoFirstLaunch=YES;
}

/**
 *  清理缓存
 */
// 根据路径删除文件  删除cookies文件

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
/**
 *WebView加载完毕的时候调用（请求完毕）
 */
/*
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            //将上述数据全部存储到NSUserDefaults中
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
            [userDefaults setObject:@"1" forKey:@"IsSet"];
            [SVProgressHUD showSuccessWithStatus:@"登录成功~"];
            [self dismissViewControllerAnimated:YES completion:NULL];
        });
    });

  
}


-(void)webViewDidStartLoad:(UIWebView *)webView
{
   
}
 */
@end
