//
//  MyRedEnvelopeCell.m
//  TTJF
//
//  Created by wbzhan on 2018/5/17.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyRedEnvelopeCell.h"

@interface MyRedEnvelopeCell()
Strong UIImageView *bgImage;
Strong UILabel *titleLabel;//标题
Strong UIButton *tagImage;//标签(还有XXX过期)
Strong UILabel *amountLabel;//金额
Strong UILabel *amountTitle;
Strong UIView *lineView;//分割线
Strong UILabel *desLabel;//说明
Strong UILabel *timeLabel;//有效期
Strong UIButton *useBtn;//立即使用
Strong UIImageView *stateImage;//激活成功、已失效
@end

@implementation MyRedEnvelopeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews
{
    [self.contentView addSubview:self.bgImage];
    
    [self.bgImage addSubview:self.tagImage];
    
    [self.bgImage addSubview:self.titleLabel];
    
    [self.bgImage addSubview:self.amountLabel];
    
    [self.bgImage addSubview:self.amountTitle];
    
    [self.bgImage addSubview:self.lineView];
    
    [self.bgImage addSubview:self.desLabel];
    
    [self.bgImage addSubview:self.timeLabel];
    
    [self.bgImage addSubview:self.useBtn];
    
    [self.bgImage addSubview:self.stateImage];
    
    [self loadLayout];
}
-(UIImageView *)bgImage{
    if (!_bgImage) {
        _bgImage = InitObject(UIImageView);
    }
    return _bgImage;
}
-(UIButton *)tagImage{
    if (!_tagImage) {
        _tagImage = InitObject(UIButton);
        [_tagImage setTitle:@"5天后过期" forState:UIControlStateNormal];
        [_tagImage.titleLabel setFont:SYSTEMBOLDSIZE(20)];
    }
    return _tagImage;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = InitObject(UILabel);
        _titleLabel.textColor = COLOR_White;
        _titleLabel.font = SYSTEMSIZE(30);
    }
    return _titleLabel;
}

-(UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = InitObject(UILabel);
        _amountLabel.font = SYSTEMSIZE(30);
    }
    return _amountLabel;
}
-(UILabel *)amountTitle{
    if (!_amountTitle) {
        _amountTitle = InitObject(UILabel);
        _amountTitle.font = SYSTEMSIZE(26);
        _amountTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _amountTitle;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = InitObject(UIView);
        _lineView.backgroundColor = COLOR_White;
    }
    return _lineView;
}
-(UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = InitObject(UILabel);
        _desLabel.numberOfLines = 0;
        _desLabel.font = SYSTEMSIZE(28);
        _desLabel.textColor = COLOR_White;
    }
    return _desLabel;
}
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = InitObject(UILabel);
        _timeLabel.textColor = RGB_102;
        _timeLabel.font = SYSTEMSIZE(26);
    }
    return _timeLabel;
}
-(UIButton *)useBtn{
    if (!_useBtn) {
        _useBtn = InitObject(UIButton);
        _useBtn.layer.cornerRadius = kSizeFrom750(52)/2;
        _useBtn.layer.borderColor = [COLOR_Red CGColor];
        _useBtn.layer.borderWidth = kLineHeight;
        [_useBtn setTitleColor:COLOR_Red forState:UIControlStateNormal];
        _useBtn.adjustsImageWhenHighlighted = NO;
        [_useBtn.titleLabel setFont:SYSTEMSIZE(28)];
        [_useBtn setTitle:@"立即使用" forState:UIControlStateNormal];
    }
    return _useBtn;
}
//状态图片
-(UIImageView *)stateImage{
    if (!_stateImage) {
        _stateImage = InitObject(UIImageView);
        [_stateImage setHidden:YES];
    }
    return _stateImage;
}
-(void)loadLayout
{
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kOriginLeft);
        make.left.mas_equalTo(kOriginLeft);
        make.right.mas_equalTo(-kOriginLeft);
        make.height.mas_equalTo(kSizeFrom750(325));
    }];
    [self.tagImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(kSizeFrom750(25));
        make.width.mas_equalTo(kSizeFrom750(138));
        make.height.mas_equalTo(kSizeFrom750(40));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSizeFrom750(55));
        make.top.mas_equalTo(kSizeFrom750(25));
        make.height.mas_equalTo(kSizeFrom750(35));
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kSizeFrom750(30));
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kSizeFrom750(230));
        make.height.mas_equalTo(kSizeFrom750(70));
    }];
    [self.amountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.amountLabel);
        make.top.mas_equalTo(self.amountLabel.mas_bottom);
        make.height.mas_equalTo(kSizeFrom750(28));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kSizeFrom750(110));
        make.left.mas_equalTo(kSizeFrom750(235));
        make.width.mas_equalTo(kLineHeight);
        make.height.mas_equalTo(kSizeFrom750(90));
    }];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kSizeFrom750(116));
        make.left.mas_equalTo(self.lineView.mas_right).offset(kSizeFrom750(50));
        make.width.mas_equalTo(kSizeFrom750(375));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSizeFrom750(35));
        make.top.mas_equalTo(kSizeFrom750(255));
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    
    [self.useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kOriginLeft);
        make.centerY.mas_equalTo(self.timeLabel);
        make.height.mas_equalTo(kSizeFrom750(52));
        make.width.mas_equalTo(kSizeFrom750(180));
    }];
    [self.stateImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSizeFrom750(175));
        make.height.mas_equalTo(kSizeFrom750(140));
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(kSizeFrom750(20));
    }];
}
#pragma mark --数据加载
-(void)loadInfoWithModel:(MyRedenvelopeModel *)model
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
