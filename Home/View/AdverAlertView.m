//
//  AdverAlertView.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/23.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "AdverAlertView.h"

@implementation AdverAlertView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews
{
    self.iconImage =  InitObject(UIButton);
    [self addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.iconImage addTarget:self action:@selector(iconImageClick:) forControlEvents:UIControlEventTouchUpInside];
    self.iconImage.adjustsImageWhenHighlighted = NO;
    
//
//    self.closeBtn = InitObject(UIButton);
//    self.closeBtn.frame = RECT(self.width - kSizeFrom750(60), 0, kSizeFrom750(60), kSizeFrom750(60));
//    self.closeBtn.adjustsImageWhenHighlighted = NO;
//    [self addSubview:self.closeBtn];
//
//    [self.closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)iconImageClick:(UIButton *)sender{
    if (self.adAlertBlock) {
        self.adAlertBlock();
    }
}
//-(void)closeBtnClick:(UIButton *)sender{
//    [self setHidden:YES];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
