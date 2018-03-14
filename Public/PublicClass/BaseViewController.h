//
//  BaseViewController.h
//  TTJF
//
//  Created by 占碧光 on 2017/3/13.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTJFRefreshStateHeader.h"
#import <SVProgressHUD.h>
#import "ggHttpFounction.h"
#import "HttpSignCreate.h"
#import "HttpUrlAddress.h"
/**
    基础控件
 */
@interface BaseViewController : UIViewController
+ (UIViewController *)appRootViewController;
//返回按钮（默认首页不显示，其余页面需要显示）
Strong UIImageView *titleImageView;
Strong UIView *titleView;

Strong UIButton *backBtn;

//右侧按钮布局，默认不显示
Strong UIButton *rightBtn;
//标题内容显示

Strong UILabel *titleLabel;
//设置标题
Strong NSString *titleString;

Strong UIImageView *newsMessage;//关于我的界面有新消息时候， 显示该图标
//隐藏底部tabbar
- (void)hideHomeTabBar:(BOOL)hidden;
//跳转到登录页面
-(void)goLoginVC;

//返回事件
-(void)backPressed:(UIButton *)sender;
@end
