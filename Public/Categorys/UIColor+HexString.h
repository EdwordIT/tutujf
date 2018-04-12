//
//  UIColor+HexString.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/23.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)

/**
 *  十六进制的颜色转换为UIColor
 *
 *  @param color   十六进制的颜色
 *
 *  @return   UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)color;
@end
