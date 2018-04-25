//
//  GradientButton.h
//  TTJF
//
//  Created by wbzhan on 2018/4/25.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 背景带渐变色的button
 */
@interface GradientButton : UIButton
//设置背景渐变色
- (void)setGradientColors:(NSArray<UIColor *> *)colors;
@end
