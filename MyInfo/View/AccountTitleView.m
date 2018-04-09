//
//  AccountTitleView.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/31.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "AccountTitleView.h"


@interface AccountTitleView()
Strong UIButton *leftImage;

@end

@implementation AccountTitleView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.leftImage];
    [self addSubview:self.titleLabel];
    [self addSubview:self.rightImage];
    [self makeConstraints];
}
-(UIButton *)leftImage
{
    if (!_leftImage) {
        _leftImage = InitObject(UIButton);
        [_leftImage setImage:IMAGEBYENAME(@"icons_portrait") forState:UIControlStateNormal];
        _leftImage.adjustsImageWhenHighlighted = NO;
        _leftImage.tag =1;
        [_leftImage addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _leftImage;
}
-(UIButton *)rightImage
{
    if (!_rightImage) {
        _rightImage = InitObject(UIButton);
        [_rightImage setImage:IMAGEBYENAME(@"icons_msg_unsel") forState:UIControlStateNormal];
        [_rightImage setImage:IMAGEBYENAME(@"icons_msg_unsel") forState:UIControlStateSelected];
        _rightImage.adjustsImageWhenHighlighted = NO;
        _rightImage.tag =2;
        [_rightImage addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _rightImage;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = InitObject(UILabel);
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = NUMBER_FONT(38);
        _titleLabel.text = @"******";
    }
    return _titleLabel;
}
-(void)makeConstraints
{
    [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSizeFrom750(30));
        make.centerY.mas_equalTo(kStatusBarHeight+(self.height - kStatusBarHeight)/2);
        make.width.height.mas_equalTo(kSizeFrom750(80));
    }];
    
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-kSizeFrom750(30));
        make.centerY.mas_equalTo(self.leftImage);
        make.width.height.mas_equalTo(kSizeFrom750(50));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImage.mas_right).offset(kSizeFrom750(10));
        make.centerY.mas_equalTo(self.leftImage);
        make.height.mas_equalTo(kSizeFrom750(40));
    }];
}
-(void)resetTitle:(NSString *)title{
    
    self.titleLabel.text =  title;
}
-(void)reloadNav:(CGFloat)originY
{
    CGFloat height = kSizeFrom750(160)+kStatusBarHeight;
 //设置100高度为渐变区域，其余高度保持不变
    CGFloat percentage = originY/100;
    self.height = height - percentage*(height - kNavHight);
    [self.leftImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kSizeFrom750(80)-percentage*kSizeFrom750(20));
    }];
    [self.rightImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kSizeFrom750(50)-percentage*kSizeFrom750(10));
    }];
    self.titleLabel.font = SYSTEMSIZE(38-percentage*10);
}
-(void)buttonClick:(UIButton *)sender
{
    if (self.accountTitleBlock) {
        self.accountTitleBlock(sender.tag);
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
