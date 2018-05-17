//
//  MyInvestRecordCell.m
//  TTJF
//
//  Created by wbzhan on 2018/5/16.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "CreditAssignHistoryCell.h"

@interface CreditAssignHistoryCell()
Strong UIView *sepView;//顶部分隔栏
Strong UILabel *titleLabel;
Strong UILabel *subTitleLabel;//代还、已购、总期数
Strong UIImageView *stateImage;//状态
Strong UIButton *detailBtn;//查看详情
Strong UILabel *amountLabel;//总价值
Strong UILabel *amountTitle;//购买价格
Strong UIView *lineView;
Strong UIView *lineView1;
Strong UILabel *principalTitle;//待收本金
Strong UILabel *principalLabel;//
Strong UILabel *interestTitle;//待收利息
Strong UILabel *interestLabel;//
Strong UILabel *timeLabel;//债权转让时间
@end

@implementation CreditAssignHistoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews{
    
    [self.contentView addSubview:self.sepView];
    
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.subTitleLabel];
    
    [self.contentView addSubview:self.stateImage];
    
    [self.contentView addSubview:self.detailBtn];
    
    [self.contentView addSubview:self.amountLabel];
    
    [self.contentView addSubview:self.amountTitle];
    
    [self.contentView addSubview:self.principalLabel];
    
    [self.contentView addSubview:self.principalTitle];
    
    [self.contentView addSubview:self.interestLabel];
    
    [self.contentView addSubview:self.interestTitle];
    
    [self.contentView addSubview:self.timeLabel];
    
    [self loadLayout];
}
#pragma mark --lazyLoading
-(UIView *)sepView{
    if (!_sepView) {
        _sepView = InitObject(UIView);
        _sepView.backgroundColor = separaterColor;
    }
    return _sepView;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = InitObject(UILabel);
        _titleLabel.font = SYSTEMSIZE(28);
        _titleLabel.textColor = RGB_51;
    }
    return _titleLabel;
}
-(UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = InitObject(UILabel);
        _subTitleLabel.font = SYSTEMSIZE(26);
        _subTitleLabel.textColor = RGB_102;
    }
    return _subTitleLabel;
}
-(UIImageView *)stateImage{
    if (!_stateImage) {
        _stateImage = InitObject(UIImageView);
    }
    return _stateImage;
}
-(UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = InitObject(UILabel);
        _amountLabel.textColor = RGB(50, 186, 123);
        _amountLabel.font = NUMBER_FONT_BOLD(32);
        _amountLabel.textAlignment = NSTextAlignmentCenter;

    }
    return _amountLabel;
}
-(UILabel *)amountTitle{
    if (!_amountTitle) {
        _amountTitle = InitObject(UILabel);
        _amountTitle.textColor = RGB_183;
        _amountTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _amountTitle;
}
-(UILabel *)principalLabel{
    if (!_principalLabel) {
        _principalLabel = InitObject(UILabel);
        _principalLabel.textColor = RGB_51;
        _principalLabel.font = NUMBER_FONT(28);
        _principalLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _principalLabel;
}
-(UILabel *)principalTitle{
    if (!_principalTitle) {
        _principalTitle = InitObject(UILabel);
        _principalTitle.textColor = RGB_183;
        _principalTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _principalTitle;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = InitObject(UIView);
        _lineView.backgroundColor = separaterColor;
    }
    return _lineView;
}
-(UILabel *)interestLabel{
    if (!_interestLabel) {
        _interestLabel = InitObject(UILabel);
        _interestLabel.textColor = RGB_51;
        _interestLabel.font = NUMBER_FONT(28);
        _interestLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _interestLabel;
}
-(UILabel *)interestTitle{
    if (!_interestTitle) {
        _interestTitle = InitObject(UILabel);
        _interestTitle.textColor = RGB_183;
        _interestTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _interestTitle;
}
-(UIView *)lineView1{
    if (!_lineView1) {
        _lineView1 = InitObject(UIView);
        _lineView1.backgroundColor = separaterColor;
    }
    return _lineView1;
}
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = InitObject(UILabel);
        _timeLabel.textColor = RGB_102;
        _timeLabel.font = SYSTEMSIZE(28);
        _timeLabel.text = @"债权时间：2018/03/05 - 2018/06/05";
    }
    return _timeLabel;
}
-(void)loadLayout
{
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(kSizeFrom750(40));
    }];
    [self.stateImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-kOriginLeft);
        make.width.mas_equalTo(kSizeFrom750(130));
        make.height.mas_equalTo(kSizeFrom750(40));
        make.top.mas_equalTo(self.sepView.mas_bottom).offset(-kSizeFrom750(8));
    }];
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.height.mas_equalTo(self.stateImage);
        make.top.mas_equalTo(self.stateImage.mas_bottom).offset(kSizeFrom750(20));
        
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sepView.mas_bottom).offset(kSizeFrom750(20));
        make.left.mas_equalTo(kOriginLeft);
        make.height.mas_equalTo(kSizeFrom750(30));
        
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kSizeFrom750(20));
        make.left.height.mas_equalTo(self.titleLabel);
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(kSizeFrom750(40));
        make.height.mas_equalTo(kSizeFrom750(40));
    }];
    [self.amountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.mas_equalTo(self.amountLabel);
        make.top.mas_equalTo(self.amountLabel.mas_bottom).offset(kSizeFrom750(20));
    }];
    
    [self.principalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(screen_width/2);
        make.top.mas_equalTo(self.amountTitle.mas_bottom).offset(kSizeFrom750(40));
        make.height.mas_equalTo(kSizeFrom750(30));
        make.left.mas_equalTo(0);
    }];
    [self.principalTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.mas_equalTo(self.principalLabel);
        make.top.mas_equalTo(self.principalLabel.mas_bottom).offset(kSizeFrom750(15));
    }];
    [self.interestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.principalLabel);
        make.left.mas_equalTo(self.principalLabel.mas_right);
    }];
    [self.interestTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.mas_equalTo(self.principalTitle);
        make.left.mas_equalTo(self.interestLabel.mas_left);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.amountTitle.mas_bottom).offset(kSizeFrom750(50));
        make.left.mas_equalTo(self.principalTitle.mas_right);
        make.height.mas_equalTo(kSizeFrom750(80));
        make.width.mas_equalTo(kLineHeight);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.principalTitle.mas_bottom).offset(kSizeFrom750(70));
        make.left.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(kLineHeight);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.top.mas_equalTo(self.lineView1.mas_bottom).offset(kSizeFrom750(25));
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    
}
-(void)loadInfoWithModel:(CreditAssignHistoryModel *)model{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
