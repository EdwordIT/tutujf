//
//  InputGestureLockController.m
//  TTJF
//
//  Created by 占碧光 on 2017/3/9.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "InputGestureLockController.h"
//#import "GestureLockView.h"
#import "AppDelegate.h"
#import "sqlite3.h"
#define DBNAME @"dingxingdai.db"
#define TABLENAME @"DxdLogin"
//#import "PPNetworkHelper.h"
#import "HttpSignCreate.h"
#import "ReturnCode.h"
//#import "OpenShowView.h"
#import "AutoLogin.h"

#define tipLabelFontSize 12

#define MarginY 5

#define TextColor RGB(153,153,153)

@interface InputGestureLockController ()<AutoLoginDelegate>
{
    sqlite3 *db;
    UIImageView  *imageView;
    NSString * username1;
    NSString * pswd1;
    UIView *_maskView;
    AutoLogin * login;
    Boolean isvalidstr;
}
@property(nonatomic, weak)UIImageView *lockViewShotView;
@property(nonatomic, weak)UILabel *tipLabel;
//@property(nonatomic, weak)GestureLockView *gestureLockView;
@property(nonatomic, weak)UIButton *resetButton;
@property(nonatomic, copy)NSString *firstLockPath;
//@property(nonatomic, copy)NSString *_saveLockPath;
@property(nonatomic, copy)NSString *secondLockPath;
@property (copy, nonatomic) NSString *databaseFilePath;

@property(nonatomic, weak)UIButton *forgetButton;

@end

@implementation InputGestureLockController


-(void)didAutoLoginSelect:(NSString *)username pswd:(NSString *)pswd isvalid:(Boolean)isvalid
{
    username1=username;
    pswd1=pswd;
    isvalidstr=isvalid;
    if(!isvalid)
    {
        [self doLogin];
    }
    else
    {
        //  [self doLogin];
        
        // [self.navigationController popViewControllerAnimated:YES];
        // [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)SetupSubviews{
    
    login=[[AutoLogin alloc] init];
    login.delegate=self;
    [login InitData];
}



-(void) OnMenuBtn:(UIButton *) sender
{
    NSInteger tag=sender.tag;
    if(tag==1)
    {
        theAppDelegate.lockLogin=@"1";
        // [self dismissViewControllerAnimated:YES completion:nil];
        if (_noticBlock) {
            _noticBlock(YES);
        }
        
    }
    else if(tag==2)
    {
        
        
    }
    
    else if(tag==3)
    {
        
        //  [self dismissViewControllerAnimated:YES completion:nil];
        if (_noticBlock) {
            _noticBlock(YES);
        }
        
    }
}

-(void)ClickForgetButton{
    
    
}


- (void)SaveLockPath:(NSString *)path{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:path forKey:@"LockPath"];
    [userDef synchronize];
}





#pragma sqllite


/*登录操作*/
-(void) doLogin
{
    NSString *urlStr = @"";
    NSString *user_name=username1;//@"客服-婵玉";
    NSString *password=pswd1;
    //   NSDictionary *dict_data = @{@"user_name":user_name,@"password":password};
    NSDictionary *dict_data=[[NSDictionary alloc] initWithObjects:@[user_name,password] forKeys:@[@"user_name",@"password"] ];
    NSString *sign=[HttpSignCreate GetSignStr:dict_data];
    user_name = [HttpSignCreate encodeString:user_name];
    password = [HttpSignCreate encodeString:password];
    urlStr = [NSString stringWithFormat:@"%@/Api/Users/Login?user_name=%@&password=%@&sign=%@",oyApiUrl,user_name,password,sign];
    NSLog(@"urlStr:%@",urlStr);
    
    
    
    
}



-(void) getUserInfo{
    //Api/Users/GetUsetInfo?user_token={user_token}&sign={sign}
    NSString *urlStr = @"";
    NSString *user_token=theAppDelegate.user_token;
    NSDictionary *dict_data=[[NSDictionary alloc] initWithObjects:@[user_token] forKeys:@[kToken]];
    
    NSString *sign=[HttpSignCreate GetSignStr:dict_data];
    urlStr = [NSString stringWithFormat:@"%@/Api/Users/GetUsetInfo?user_token=%@&sign=%@",oyApiUrl,user_token,sign];
    NSLog(@"urlStr:%@",urlStr);
   
    
}




-(void) getUserHotCount{
    NSString *urlStr = @"";
    NSString *user_token=theAppDelegate.user_token;
    //   NSDictionary *dict_data = @{@"user_name":user_name,@"password":password};
    NSDictionary *dict_data=[[NSDictionary alloc] initWithObjects:@[user_token] forKeys:@[kToken] ];
    NSString *sign=[HttpSignCreate GetSignStr:dict_data];
    urlStr = [NSString stringWithFormat:@"%@/Api/BorrowRecover/GetUserHotCount?user_token=%@&sign=%@",oyApiUrl,user_token,sign];
    NSLog(@"urlStr:%@",urlStr);
  
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
