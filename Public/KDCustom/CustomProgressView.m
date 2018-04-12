//
//  CustomProgressView.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/4/9.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "CustomProgressView.h"
@interface CustomProgressView()
@property(nonatomic ,weak)UIView *tView;
@end

@implementation CustomProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        //边框
//        UIView *borderView = [[UIView alloc] initWithFrame:self.bounds];
//        borderView.layer.cornerRadius = self.bounds.size.height * 0.5;
//        borderView.layer.masksToBounds = YES;
//        borderView.backgroundColor = [UIColor whiteColor];
//        borderView.layer.borderColor = [KProgressColor CGColor];
//        borderView.layer.borderWidth = KProgressBorderWidth;
//        [self addSubview:borderView];
        self.backgroundColor = self.defaultColor;
        self.layer.cornerRadius = self.height*0.5;
        self.layer.masksToBounds = YES;
        //进度
        UIView *tView = [[UIView alloc] init];
        tView.backgroundColor = self.progressColor;
        tView.layer.cornerRadius = self.bounds.size.height * 0.5;
        tView.layer.masksToBounds = YES;
        [self addSubview:tView];
        self.tView = tView;
    }
    
    return self;
}
-(void )setDefaultColor:(UIColor *)defaultColor{
    _defaultColor = defaultColor;
    self.backgroundColor = defaultColor;
}
-(void )setProgressColor:(UIColor *)progressColor{
    _progressColor = progressColor;
    _tView.backgroundColor = progressColor;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    CGFloat maxWidth = self.bounds.size.width;
    CGFloat heigth = self.bounds.size.height;
    
    _tView.frame = CGRectMake(0, 0, maxWidth * progress, heigth);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
