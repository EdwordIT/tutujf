//
//  MineViewController.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/6.
//  Copyright © 2018年 wbzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTJFRefreshStateHeader.h"
#import <SVProgressHUD.h>
#import "ggHttpFounction.h"
#import "HttpSignCreate.h"
#import "HttpUrlAddress.h"
#import "HttpCommunication.h"
#import "BaseView.h"
/**
    基础控件
 */
@interface BaseViewController : UIViewController
//Strong UIImageView *titleImageView;
Strong UIView *titleView;
//返回按钮（默认首页不显示，其余页面需要显示）
Strong UIButton *backBtn;
//右侧按钮布局，默认不显示
Strong UIButton *rightBtn;
//标题内容显示
Strong UILabel *titleLabel;
//设置标题
Strong NSString *titleString;
//关于我的界面有新消息时候， 显示该图标
Strong UIImageView *newsMessage;

 Assign BOOL isBackToRootVC;//用于web页面跳转到详情页面，之后点击返回，则略过web页面直接返回到列表
//隐藏底部tabbar
- (void)hideHomeTabBar:(BOOL)hidden;
//跳转到登录页面
-(void)goLoginVC;
//清除登录记录
-(void)exitLoginStatus;
//跳转实名认证窗口
-(void)goRealNameVC;
//跳转到webView
-(void)goWebViewWithPath:(NSString *)urlPath;

//返回事件
-(void)backPressed:(UIButton *)sender;

+ (UIViewController *)appRootViewController;
@end
