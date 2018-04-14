//
//  AutoLoginView.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/28.
//  Copyright © 2018年 TTJF. All rights reserved.
//登录、退出登录相关

#import <UIKit/UIKit.h>
typedef void (^AutoLoginBlock)(void);
@interface AutoLoginView : UIView

Copy AutoLoginBlock autoLoginBlock;
-(void) getLogin:(NSString *)user_name  password:(NSString *)password;
-(void)autoLogin;//自动登录
-(void)loginWebView;//webView登录
-(void)exitLogin;//退出登录
@end
