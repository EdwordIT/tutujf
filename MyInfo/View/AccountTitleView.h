//
//  AccountTitleView.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/31.
//  Copyright © 2018年 TTJF. All rights reserved.
//用户中心的头部视图

#import <UIKit/UIKit.h>
typedef void (^AccountTitleBlock)(NSInteger tag);
@interface AccountTitleView : UIView

Strong UILabel *titleLabel;

Strong UIButton *rightImage;

Copy AccountTitleBlock accountTitleBlock;
//缩放titleView
-(void)reloadNav:(CGFloat)originY;

@end
