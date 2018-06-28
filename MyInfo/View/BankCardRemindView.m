//
//  BankCardRemindView.m
//  TTJF
//
//  Created by wbzhan on 2018/6/12.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BankCardRemindView.h"

@interface BankCardRemindView()
Strong UIButton *closeBtn;

Strong UIView *mainView;

Strong UIImageView *titleImageView;

Strong UILabel *titleLabel;//标题
Strong UILabel *subLabel;//副标题
Strong UILabel *remindTitle;//查看流程

Strong UIButton *questionBtn;//点击查看

Strong UILabel *timeLabel;//客服时间
@end
@implementation BankCardRemindView
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
    self.mainView.frame = RECT(kSizeFrom750(80), kSizeFrom750(250), kSizeFrom750(590), kSizeFrom750(500));
    self.mainView.backgroundColor = COLOR_White;
    self.mainView.layer.cornerRadius = kSizeFrom750(10);
    self.mainView.layer.masksToBounds = YES;
    [self addSubview:self.mainView];
    
    
    self.titleImageView = InitObject(UIImageView);
    self.titleImageView.frame = RECT(0, 0, self.mainView.width, kSizeFrom750(188));
    [self.titleImageView setBackgroundColor:COLOR_LightBlue];
    [self.mainView addSubview:self.titleImageView];
    
    self.closeBtn = InitObject(UIButton);
    self.closeBtn.frame = RECT(self.mainView.width - kSizeFrom750(60), 0, kSizeFrom750(60), kSizeFrom750(60));
    [self.closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn setImage:IMAGEBYENAME(@"icons_close") forState:UIControlStateNormal];
    [self.mainView addSubview:self.closeBtn];
    
    self.titleLabel = InitObject(UILabel);
    self.titleLabel.frame = RECT(0, kSizeFrom750(50), self.mainView.width, kSizeFrom750(50));
    self.titleLabel.font = [UIFont boldSystemFontOfSize:kSizeFrom750(42)];
    self.titleLabel.textColor = COLOR_White;
    self.titleLabel.text = @"温馨提示";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.mainView addSubview:self.titleLabel];
    
    self.subLabel = InitObject(UILabel);
    self.subLabel.frame = RECT(0, self.titleLabel.bottom+kSizeFrom750(20), self.titleLabel.width, kSizeFrom750(40));
    self.subLabel.font = SYSTEMSIZE(32);
    self.subLabel.textColor = COLOR_White;
    self.subLabel.text = @"银行卡解绑请到电脑端操作";
    self.subLabel.textAlignment = NSTextAlignmentCenter;
    [self.mainView addSubview:self.subLabel];
    
    UIView *left = [[UIView alloc]initWithFrame:RECT(kSizeFrom750(106), 0, kSizeFrom750(70), kSizeFrom750(4))];
    left.backgroundColor = COLOR_White;
    left.centerY = self.titleLabel.centerY;
    [self.mainView addSubview:left];
    
    UIView *right = [[UIView alloc]initWithFrame:RECT(kSizeFrom750(416), 0, kSizeFrom750(70), kSizeFrom750(4))];
    right.centerY = left.centerY;
    right.backgroundColor = COLOR_White;
    [self.mainView addSubview:right];
    
    self.remindTitle = InitObject(UILabel);
    _remindTitle.frame = RECT(0, self.titleImageView.bottom+kSizeFrom750(40), self.mainView.width, kSizeFrom750(40));
    [_remindTitle setFont:SYSTEMBOLDSIZE(35)];
    [_remindTitle setTextColor:COLOR_Red];
    _remindTitle.textAlignment = NSTextAlignmentCenter;
    _remindTitle.text = @"查看银行卡解绑操作流程";
    [self.mainView addSubview:self.remindTitle];
    
    self.questionBtn = InitObject(UIButton);
    self.questionBtn.frame = RECT(0, self.remindTitle.bottom+kSizeFrom750(30), kSizeFrom750(260), kSizeFrom750(72));
    self.questionBtn.centerX = self.remindTitle.centerX;
    self.questionBtn.backgroundColor = COLOR_Red;
    [self.questionBtn setTitle:@"点击查看" forState:UIControlStateNormal];
    [self.questionBtn setTitleColor:COLOR_White forState:UIControlStateNormal];
    self.questionBtn.adjustsImageWhenHighlighted = NO;
    [self.questionBtn.titleLabel setFont:SYSTEMSIZE(30)];
    [self.questionBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.questionBtn.tag = 0;
    [CommonUtils setShadowCornerRadiusToView:self.questionBtn];
    self.questionBtn.layer.cornerRadius = kSizeFrom750(72)/2;

    [self.mainView addSubview:self.questionBtn];

    
    self.timeLabel = InitObject(UILabel);
    self.timeLabel.frame = RECT(0, self.mainView.height - kSizeFrom750(70), self.mainView.width, kSizeFrom750(70));
    self.timeLabel.backgroundColor = separaterColor;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = RGB_153;
    self.timeLabel.font = SYSTEMSIZE(26);
    NSString *str = @"客服服务热线：400-000-9899";
    NSString *matchStr = @"400-000-9899";
    [self.timeLabel setAttributedText:[CommonUtils diffierentFontWithString:str rang:[str rangeOfString:matchStr] font:NUMBER_FONT_BOLD(30) color:RGB_153 spacingBeforeValue:0 lineSpace:0]];
    [self.mainView addSubview:self.timeLabel];
    
    UIButton *rightArr = [[UIButton alloc]initWithFrame:RECT(self.mainView.width - kSizeFrom750(80), self.timeLabel.top, kSizeFrom750(80), self.timeLabel.height)];
    [rightArr setImage:IMAGEBYENAME(@"rightArrow") forState:UIControlStateNormal];
    rightArr.tag = 1;
    [rightArr addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:rightArr];
    
}
-(void)loadInfoWithModel:(RelieveRemindModel *)model{
    
    self.titleLabel.text = model.title;
    self.subLabel.text = model.title_msg;
    self.remindTitle.text = model.relieve_msg;
    NSString *str = [NSString stringWithFormat:@"%@：%@",model.cust_ser_title,model.cust_ser_num];
    [self.timeLabel setAttributedText:[CommonUtils diffierentFontWithString:str rang:[str rangeOfString:model.cust_ser_num] font:NUMBER_FONT_BOLD(30) color:RGB_153 spacingBeforeValue:0 lineSpace:0]];
    
}
-(void)closeBtnClick:(UIButton *)sender{
    
    [self setHidden:YES];
}
-(void)buttonClick:(UIButton *)sender{
    if (self.remindBlock) {
        self.remindBlock(sender.tag);//0查看解绑流程 1、打服务热线
    }
}
@end
