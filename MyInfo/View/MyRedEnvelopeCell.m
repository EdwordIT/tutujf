//
//  MyRedEnvelopeCell.m
//  TTJF
//
//  Created by wbzhan on 2018/5/17.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyRedEnvelopeCell.h"

@interface MyRedEnvelopeCell()
Strong UIButton *bgImage;
Strong UILabel *titleLabel;//标题
Strong UIButton *tagImage;//标签(还有XXX过期)
Strong UILabel *tagLabel;//
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
    
    [self.tagImage addSubview:self.tagLabel];
    
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
-(UIButton *)bgImage{
    if (!_bgImage) {
        _bgImage = InitObject(UIButton);
        [_bgImage setImage:IMAGEBYENAME(@"re_canuse_bg") forState:UIControlStateNormal];
        _bgImage.adjustsImageWhenHighlighted = NO;
    }
    return _bgImage;
}
-(UIButton *)tagImage{
    if (!_tagImage) {
        _tagImage = InitObject(UIButton);
        [_tagImage.titleLabel setFont:SYSTEMBOLDSIZE(20)];
    }
    return _tagImage;
}
-(UILabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = InitObject(UILabel);
        _tagLabel.font = SYSTEMBOLDSIZE(20);
        _tagLabel.textColor = COLOR_White;
        _tagLabel.textAlignment = NSTextAlignmentRight;
    }
    return _tagLabel;
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
        _amountLabel.textColor = RGBA(255, 255, 255, 0.8);
    }
    return _amountLabel;
}
-(UILabel *)amountTitle{
    if (!_amountTitle) {
        _amountTitle = InitObject(UILabel);
        _amountTitle.font = SYSTEMSIZE(28);
        _amountTitle.textColor = RGBA(255, 255, 255, 0.8);
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
        _desLabel.textColor = RGBA(255, 255, 255, 0.8);
    }
    return _desLabel;
}
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = InitObject(UILabel);
        _timeLabel.textColor = RGB_102;
        _timeLabel.font = SYSTEMSIZE(28);
    }
    return _timeLabel;
}
-(UIButton *)useBtn{
    if (!_useBtn) {
        _useBtn = InitObject(UIButton);
        _useBtn.layer.cornerRadius = kSizeFrom750(44)/2;
        _useBtn.layer.borderColor = [COLOR_Red CGColor];
        _useBtn.layer.borderWidth = 1;
        [_useBtn setTitleColor:COLOR_Red forState:UIControlStateNormal];
        _useBtn.adjustsImageWhenHighlighted = NO;
        [_useBtn.titleLabel setFont:SYSTEMSIZE(28)];
        [_useBtn setTitle:@"立即使用" forState:UIControlStateNormal];
        [_useBtn addTarget:self action:@selector(investClick:) forControlEvents:UIControlEventTouchUpInside];
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
        make.right.mas_equalTo(self.bgImage.mas_right).offset(-kSizeFrom750(13));
        make.top.mas_equalTo(kSizeFrom750(25));
        make.width.mas_equalTo(kSizeFrom750(136));
        make.height.mas_equalTo(kSizeFrom750(60));
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.right.mas_equalTo(self.tagImage);
        make.height.mas_equalTo(kSizeFrom750(40));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSizeFrom750(55));
        make.top.mas_equalTo(kSizeFrom750(25));
        make.height.mas_equalTo(kSizeFrom750(35));
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kSizeFrom750(30));
        make.left.mas_equalTo(self.titleLabel);
        make.height.mas_equalTo(kSizeFrom750(70));
    }];
    [self.amountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.amountLabel);
        make.top.mas_equalTo(self.amountLabel.mas_bottom);
        make.height.mas_equalTo(kSizeFrom750(28));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kSizeFrom750(110));
        make.left.mas_equalTo(self.amountLabel.mas_right).offset(kSizeFrom750(40));
        make.width.mas_equalTo(kLineHeight);
        make.height.mas_equalTo(kSizeFrom750(90));
    }];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kSizeFrom750(110));
        make.left.mas_equalTo(self.lineView.mas_right).offset(kSizeFrom750(50));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSizeFrom750(35));
        make.top.mas_equalTo(kSizeFrom750(250));
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    
    [self.useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgImage.mas_right).offset(-kOriginLeft);
        make.centerY.mas_equalTo(self.timeLabel.mas_centerY).offset(-kSizeFrom750(5));
        make.height.mas_equalTo(kSizeFrom750(44));
        make.width.mas_equalTo(kSizeFrom750(180));
    }];
    [self.stateImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSizeFrom750(163));
        make.height.mas_equalTo(kSizeFrom750(136));
        make.right.mas_equalTo(-kSizeFrom750(13));
        make.top.mas_equalTo(kSizeFrom750(15));
    }];
}
#pragma mark --按钮点击
-(void)investClick:(UIButton *)sender{
    if (self.investBlock) {
        self.investBlock();
    }
}
#pragma mark --数据加载
-(void)loadInfoWithModel:(MyRedenvelopeModel *)model
{
    self.titleLabel.text = model.name;
    NSInteger seconds = [CommonUtils getDifferenceByDate:[[model.end_time stringByReplacingOccurrencesOfString:@"有效期至" withString:@""] stringByAppendingString:@" 00-00-00"]];
    //计算过期时间差
    if (seconds/DAY>0&&seconds/DAY<10) {//过期时间在10天以内，则显示过期时间
        self.tagLabel.textColor = COLOR_Red;
        [self.tagLabel setText:[NSString stringWithFormat:@"%ld天后过期",seconds/DAY]];
        [self.tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tagImage);
            make.right.mas_equalTo(self.tagImage.mas_right).offset(-kSizeFrom750(5));
        }];
    }
    NSString *str = [NSString stringWithFormat:@"%@元",model.amount];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    [attr addAttribute:NSFontAttributeName value:NUMBER_FONT_BOLD(60) range:[str rangeOfString:model.amount]];
    [self.amountLabel setAttributedText:attr];
    self.amountTitle.text = model.type_name;
    [CommonUtils setAttString:[model.condition_txt stringByReplacingOccurrencesOfString:@"\\r" withString:@"\n"] withLineSpace:kLabelSpace titleLabel:self.desLabel];
    self.timeLabel.text =model.end_time;
    //状态1 可用（立刻使用）【可用】 ， 2 待激活【已使用】(等待扣款状态)， 3 激活成功【已使用】， 4 过期 ，5 失效
    if ([model.status isEqualToString:@"1"]) {//可使用
        [self.bgImage setImage:IMAGEBYENAME(@"re_canuse_bg") forState:UIControlStateNormal];
        [self.tagImage setImage:IMAGEBYENAME(@"re_overtime") forState:UIControlStateNormal];//显示过期时间
    }else if ([model.status isEqualToString:@"2"]){//待激活
        [self.tagImage setImage:IMAGEBYENAME(@"") forState:UIControlStateNormal];
        [self.tagLabel setText:model.status_name];
        self.tagLabel.textColor = COLOR_DarkBlue;
        [self.tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tagImage).offset(kSizeFrom750(5));
            make.right.mas_equalTo(self.tagImage.mas_right).offset(-kSizeFrom750(10));
        }];
        [self.bgImage setImage:IMAGEBYENAME(@"re_waitting_bg") forState:UIControlStateNormal];
    }else{
        [self.tagImage setImage:IMAGEBYENAME(@"") forState:UIControlStateNormal];
        [self.bgImage setImage:IMAGEBYENAME(@"re_overdue_bg") forState:UIControlStateNormal];//已失效、已过期
    }
    //stateImage显示状态
    if ([model.status isEqualToString:@"1"]) {
        [self.useBtn setHidden:NO];
        [self.stateImage setHidden:YES];
    }else{
        [self.useBtn setHidden:YES];
        [self.stateImage setHidden:NO];
    }
    
    if ([model.status isEqualToString:@"2"]) {//红包待激活
         [self.stateImage setImage:IMAGEBYENAME(@"")];//待激活,不显示状态图
    }
    if ([model.status isEqualToString:@"3"]) {
        [self.stateImage setImage:IMAGEBYENAME(@"re_canuse")];//激活成功
    };
    if ([model.status isEqualToString:@"4"]) {
        [self.stateImage setImage:IMAGEBYENAME(@"re_overdue")];//过期
    };
    if ([model.status isEqualToString:@"5"]) {
        [self.stateImage setImage:IMAGEBYENAME(@"re_overdue")];//失效
    };
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
