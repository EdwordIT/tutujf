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
        _titleLabel.text = @"提现失败解冻";
    }
    return _titleLabel;
}
-(UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = InitObject(UILabel);
        _subLabel.font = SYSTEMSIZE(28);
        _subLabel.textColor = RGB_158;
        _subLabel.text = @"投资成功";
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
        _balanceLabel.text = @"余额：1234.50元";
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
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.subLabel.mas_bottom).offset(kSizeFrom750(30));
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kOriginLeft);
        make.centerY.mas_equalTo(self.balanceLabel.mas_centerY);
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
}
-(void)loadInfoWithModel:(InvestRecordModel *)model{
    
    
    
}
@end