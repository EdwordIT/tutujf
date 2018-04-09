//
//  CustomerServiceView.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/20.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "CustomerServiceView.h"

@interface CustomerServiceView()

Strong UIButton *closeBtn;

Strong UIView *mainView;

Strong UIImageView *titleImageView;

Strong UILabel *titleLabel;//标题

Strong UILabel *telNumberLabel;//客服电话

Strong UIButton *questionBtn;//常见问题

Strong UIButton *calServiceBtn;//立即拨打

Strong UILabel *timeLabel;//客服时间
@end
@implementation CustomerServiceView
-(instancetype )initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews
{
    
    self.backgroundColor = RGBA(0, 0, 0, 0.5);
    
    self.mainView = InitObject(UIView);
    self.mainView.frame = RECT(kSizeFrom750(80), kSizeFrom750(250), kSizeFrom750(590), kSizeFrom750(590));
    self.mainView.backgroundColor = [UIColor whiteColor];
    self.mainView.layer.cornerRadius = kSizeFrom750(10);
    self.mainView.layer.masksToBounds = YES;
    [self addSubview:self.mainView];
    
    
    self.titleImageView = InitObject(UIImageView);
    self.titleImageView.frame = RECT(0, 0, self.mainView.width, kSizeFrom750(245));
    [self.titleImageView setImage:IMAGEBYENAME(@"service_top")];
    [self.mainView addSubview:self.titleImageView];
    
    self.closeBtn = InitObject(UIButton);
    self.closeBtn.frame = RECT(self.mainView.width - kSizeFrom750(60), 0, kSizeFrom750(60), kSizeFrom750(60));
    [self.closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn setImage:IMAGEBYENAME(@"close_white") forState:UIControlStateNormal];
    [self.mainView addSubview:self.closeBtn];
    
    self.titleLabel = InitObject(UILabel);
    self.titleLabel.frame = RECT(0, kSizeFrom750(250), self.mainView.width, kSizeFrom750(32));
    self.titleLabel.font = SYSTEMSIZE(30);
    self.titleLabel.textColor = RGB_51;
    self.titleLabel.text = @"客户服务热线";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.mainView addSubview:self.titleLabel];
    
    self.telNumberLabel = InitObject(UILabel);
    _telNumberLabel.frame = RECT(0, self.titleLabel.bottom+kSizeFrom750(30), self.mainView.width, kSizeFrom750(40));
    [_telNumberLabel setFont:SYSTEMBOLDSIZE(40)];
    [_telNumberLabel setTextColor:COLOR_Red];
    _telNumberLabel.textAlignment = NSTextAlignmentCenter;
    _telNumberLabel.text = @"400-000-9899";
    [self.mainView addSubview:self.telNumberLabel];
    
    self.questionBtn = InitObject(UIButton);
    self.questionBtn.frame = RECT(kSizeFrom750(40), self.telNumberLabel.bottom+kSizeFrom750(46), kSizeFrom750(240), kSizeFrom750(70));
    [self.questionBtn setTitle:@"常见问题" forState:UIControlStateNormal];
    [self.questionBtn setTitleColor:COLOR_LightBlue forState:UIControlStateNormal];
    self.questionBtn.adjustsImageWhenHighlighted = NO;
    [self.questionBtn.titleLabel setFont:SYSTEMSIZE(30)];
    self.questionBtn.layer.cornerRadius = kSizeFrom750(70)/2;
    self.questionBtn.layer.masksToBounds = YES;
    self.questionBtn.layer.borderColor = [COLOR_LightBlue CGColor];
    self.questionBtn.layer.borderWidth = 1;
    [self.questionBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.questionBtn.tag = 0;
    [self.mainView addSubview:self.questionBtn];
    
    self.calServiceBtn = InitObject(UIButton);
    self.calServiceBtn.frame = RECT(self.mainView.width -kSizeFrom750(240)-kSizeFrom750(40), self.questionBtn.top,self.questionBtn.width,self.questionBtn.height);
    [self.calServiceBtn setTitle:@"立即拨打" forState:UIControlStateNormal];
    [self.calServiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.calServiceBtn.adjustsImageWhenHighlighted = NO;
    [self.calServiceBtn setBackgroundColor:COLOR_LightBlue];
    [self.calServiceBtn.titleLabel setFont:SYSTEMSIZE(30)];
    [CommonUtils setShadowCornerRadiusToView:self.calServiceBtn];
    self.calServiceBtn.layer.cornerRadius = kSizeFrom750(70)/2;
//    self.calServiceBtn.layer.masksToBounds = YES;
    self.calServiceBtn.tag =1;
    [self.calServiceBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.mainView addSubview:self.calServiceBtn];
    
    self.timeLabel = InitObject(UILabel);
    self.timeLabel.frame = RECT(0, self.mainView.height - kSizeFrom750(66), self.mainView.width, kSizeFrom750(66));
    self.timeLabel.backgroundColor = separaterColor;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = RGB_153;
    self.timeLabel.font = SYSTEMSIZE(20);
    self.timeLabel.text = @"客服服务时间：09:00 - 18:00（工作日）";
    [self.mainView addSubview:self.timeLabel];

}
-(void)reloadInfoWithModel:(SystemConfigModel *)model{
    
    self.timeLabel.text = model.cust_serv_time;
    self.telNumberLabel.text = model.cust_serv_tel;
    
}
-(void)closeBtnClick:(UIButton *)sender{
    
    [self setHidden:YES];
}
-(void)buttonClick:(UIButton *)sender{
    if (self.serviceBlock) {
        self.serviceBlock(sender.tag);
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
