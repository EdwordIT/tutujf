//
//  UIImageView+SDImage.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/23.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "UIImageView+SDImage.h"
@implementation UIImageView (SDImage)
-(void)setImageWithString:(NSString *)imageUrl{
    [self sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
//设置ImageView可点击并包含点击事件
-(void)addGesture:(SEL)touch{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    [tap addTarget:self action:touch];
}
@end
