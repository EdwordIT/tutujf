//
//  UIImageView+SDImage.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/23.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "UIImageView+SDImage.h"
#import <objc/runtime.h>
@implementation UIImageView (SDImage)
static const char *UIControl_ClickBlock = "UIControl_ClickBlock";
-(instancetype)init{
    self = [super init];
    return self;
}
- (ImageClickBlock)clickBlock
{
    return objc_getAssociatedObject(self, UIControl_ClickBlock);
}

- (void)setClickBlock:(ImageClickBlock)clickBlock
{
    objc_setAssociatedObject(self, UIControl_ClickBlock, clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void)setImageWithString:(NSString *)imageUrl{
    [self sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
//设置ImageView可点击并包含点击事件
-(void)addTapGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    [tap addTarget:self action:@selector(imageClick:)];
}
-(void)imageClick:(UIGestureRecognizer *)ges{
    if (self.clickBlock) {
        self.clickBlock((UIImageView *)ges.view);
    }
}
@end
