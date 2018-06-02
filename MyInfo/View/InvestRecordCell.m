//
//  InvestRecordCell.m
//  TTJF
//
//  Created by wbzhan on 2018/5/18.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "InvestRecordCell.h"

@interface InvestRecordCell()

Strong UIView *sepView;//分隔条

Strong UILabel *titleLabel;

Strong UILabel *subLabel;//

Strong UILabel *timeLabel;

Strong UILabel *typeLabel;//状态

Strong UILabel *balanceLabel;//余额

Strong UILabel *amountLabel;
@end

@implementation InvestRecordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        self.contentView.backgroundColor = COLOR_White;
    }
    return self;
}
-(void)initSubViews{
    
    [self.contentView addSubview:self.sepView];
    
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.subLabel];
    
    [self.contentView addSubview:self.timeLabel];
    
    [self.contentView addSubview:self.balanceLabel];
    
    [self.contentView addSubview:self.amountLabel];
    
    [self loadLayout];
}
-(UIView *)sepView{
    if (!_sepView) {
        _sepView = InitObject(UIView);
        _sepView.backgroundColor = COLOR_Background;
    }
    return _sepView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = InitObject(UILabel);
        _titleLabel.font = SYSTEMSIZE(28);
        _titleLabel.textColor = RGB_51;
    }
    return _titleLabel;
}
-(UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = InitObject(UILabel);
        _subLabel.font = SYSTEMSIZE(28);
        _subLabel.textColor = RGB_158;
    }
    return _subLabel;
}
-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = InitObject(UILabel);
        _timeLabel.textColor = RGBCOLOR(220, 220, 220);
        _timeLabel.font = SYSTEMSIZE(28);
    }
    return _timeLabel;
}
-(UILabel *)balanceLabel{
    if (!_balanceLabel) {
        _balanceLabel = InitObject(UILabel);
        _balanceLabel.font = SYSTEMSIZE(26);
        _balanceLabel.textColor = RGB_166;
    }
    return _balanceLabel;
}
-(UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = InitObject(UILabel);
        _amountLabel.textColor = RGB_158;
        _amountLabel.font = SYSTEMSIZE(28);
    }
    return _amountLabel;
}
-(void)loadLayout
{
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.top.mas_equalTo(self.sepView.mas_bottom).offset(kSizeFrom750(20));
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kOriginLeft);
        make.height.mas_equalTo(kSizeFrom750(30));
        make.centerY.mas_equalTo(self.titleLabel);
    }];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kSizeFrom750(30));
    }];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kSizeFrom750(20));
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kOriginLeft);
        make.centerY.mas_equalTo(self.balanceLabel.mas_centerY);
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
}
-(void)loadInfoWithModel:(InvestRecordModel *)model{
    
    self.titleLabel.text = model.fee_name;
    self.subLabel.text = model.loan_name;
    self.timeLabel.text = model.add_time;
    self.balanceLabel.text = model.balance_txt;
    self.amountLabel.text = model.oper_amount_txt;
    //string    资金颜色，blue 蓝色；red 红色；green 绿色
    if ([model.money_color isEqualToString:@"blue"]) {
        self.amountLabel.textColor = COLOR_DarkBlue;
    }
    if ([model.money_color isEqualToString:@"red"]) {
        self.amountLabel.textColor = COLOR_Red;
    }
    if ([model.money_color isEqualToString:@"green"]) {
        self.amountLabel.textColor = RGB(51, 184, 124);
    }
}
@end
