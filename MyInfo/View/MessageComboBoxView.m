//
//  MessageComboBoxView.m
//  TTJF
//
//  Created by wbzhan on 2018/7/5.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MessageComboBoxView.h"

@implementation MessageComboBoxView
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews
{
    [self setImage:IMAGEBYENAME(@"comboBox")];
    
    NSArray *imageArr = @[@"not_read",@"readed",@"all_readed"];
    NSArray *titleArr = @[@"未读消息",@"已读消息",@"一键阅读"];
    CGFloat contentHeight = kSizeFrom750(85);
    for (int i=0; i<imageArr.count; i++) {
        UIImageView *icons = InitObject(UIImageView);
        [icons setContentMode:UIViewContentModeCenter];
        [self addSubview:icons];
        [icons setImage:IMAGEBYENAME([imageArr objectAtIndex:i])];
        [icons mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kSizeFrom750(30)+contentHeight*i);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(contentHeight);
            make.width.mas_equalTo(kSizeFrom750(110));
        }];
        
        UILabel *titleL = InitObject(UILabel);
        [titleL setTextColor:RGB_51];
        [titleL setFont:SYSTEMSIZE(30)];
        [titleL setText:[titleArr objectAtIndex:i]];
        [self addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(icons.mas_right);
            make.centerY.mas_equalTo(icons);
            make.height.mas_equalTo(kLabelHeight);
            
        }];
        
        if (i!=imageArr.count-1) {
            UIView *line = InitObject(UIView);
            [line setBackgroundColor:separaterColor];
            [self addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(icons.mas_right);
                make.height.mas_equalTo(kLineHeight);
                make.right.mas_equalTo(self);
                make.bottom.mas_equalTo(icons);
            }];
        }
       
        
        UIButton *btn = InitObject(UIButton);
        [self addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(icons);
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(contentHeight);
        }];
    }
}
-(void)buttonClick:(UIButton *)sender{
    if (self.comboxBlock) {
        self.comboxBlock(sender.tag);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
