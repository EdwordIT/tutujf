//
//  GuideRegisterCell.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/19.
//  Copyright © 2018年 TTJF. All rights reserved.
//未登录状态下引导注册土土金服

#import <UIKit/UIKit.h>
typedef void (^RegisterBlock)(void);
@interface GuideRegisterCell : UITableViewCell
Copy RegisterBlock registerBlock;

@end
