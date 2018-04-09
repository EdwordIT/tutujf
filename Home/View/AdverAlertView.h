//
//  AdverAlertView.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/23.
//  Copyright © 2018年 TTJF. All rights reserved.
//首页悬浮广告按钮

#import <UIKit/UIKit.h>
#import "SystemConfigModel.h"
typedef void (^AdvertAlertBlock)(void);
@interface AdverAlertView : UIView
Copy AdvertAlertBlock adAlertBlock;
//广告图
Strong UIButton *iconImage;
//广告关闭按钮
Strong UIButton *closeBtn;
@end
