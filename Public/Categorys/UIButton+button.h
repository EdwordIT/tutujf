//
//  UIButton+button.h
//  TTJF
//
//  Created by wbzhan on 2018/4/24.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import <UIKit/UIKit.h>

#define defaultInterval 0.01//默认时间间隔
@interface UIButton (button)
/**
 *  为按钮添加点击间隔 eventTimeInterval秒
 */
@property (nonatomic, assign) NSTimeInterval timeInterval;
@end
