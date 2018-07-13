//
//  CreditAssignCell.m
//  TTJF
//
//  Created by wbzhan on 2018/4/26.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "CreditAssignCell.h"
@interface CreditAssignCell()
Strong UILabel *titleLabel;
Strong UILabel *rateLabel;
Strong UILabel *rateTitle;
Strong UILabel *amountLabel;//转让金额
Strong UIButton *buyBtn;//购买债权
Strong UILabel *partLabel;//分期
Strong UILabel *partTitle;
Strong UIView *sepView;//分割线


@end
@implementation CreditAssignCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews{
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.rateLabel];
    
    [self.contentView addSubview:self.rateTitle];
    
    [self.contentView addSubview:self.amountLabel];
    
    [self.contentView addSubview:self.partLabel];
    
    [self.contentView addSubview:self.partTitle];
    
    [self.contentView addSubview:self.buyBtn];
    
    [self.contentView addSubview:self.sepView];
    
    [self loadLayout];
}
#pragma lazyLoading
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = InitObject(UILabel);
        _titleLabel.textColor = RGB_51;
        _titleLabel.font = SYSTEMSIZE(30);
    }
    return _titleLabel;
}
-(UILabel *)rateLabel{
    if (!_rateLabel) {
        _rateLabel = InitObject(UILabel);
        _rateLabel.textColor = COLOR_Red;
        _rateLabel.font = NUMBER_FONT(30);
    }
    return _rateLabel;
}
//预期利率标题
-(UILabel *)rateTitle{
    if (!_rateTitle) {
        _rateTitle = InitObject(UILabel);
        _rateTitle.font = SYSTEMSIZE(24);
        _rateTitle.textColor=RGB_183;
    }
    return _rateTitle;
}
//债权价值
-(UILabel *)amountLabel
{
    if (!_amountLabel) {
        _amountLabel = InitObject(UILabel);
        _amountLabel.font = SYSTEMSIZE(26);
        _amountLabel.textColor = RGB_102;
    }
    return _amountLabel;
}
//剩余期限
-(UILabel *)partLabel{
    if (!_partLabel) {
        _partLabel = InitObject(UILabel);
        _partLabel.font = SYSTEMSIZE(26);
        _partLabel.textColor = RGB_51;
        _partLabel.text = @"1/3月";
        _partLabel.textAlignment = NSTextAlignmentCenter;

    }
    return _partLabel;
}
-(UILabel *)partTitle
{
    if (!_partTitle) {
        _partTitle = InitObject(UILabel);
        _partTitle.font = SYSTEMSIZE(24);
        _partTitle.textColor=RGB_183;
        _partTitle.text=@"剩余期限";
        _partTitle.textAlignment = NSTextAlignmentCenter;

    }
    return _partTitle;
}

-(UIButton *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = InitObject(UIButton);
        _buyBtn.timeInterval = 2;//默认点击间隔2秒
        [_buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _buyBtn.tag=1;
        _buyBtn.adjustsImageWhenHighlighted = NO;
        [_buyBtn setTitle:@"购买债权" forState:UIControlStateNormal];
        [_buyBtn.titleLabel setFont:SYSTEMSIZE(30)];
        [_buyBtn setTitleColor:COLOR_White forState:UIControlStateNormal];
        _buyBtn.backgroundColor=COLOR_Red;
        _buyBtn.layer.masksToBounds = YES;
        [_buyBtn.layer setCornerRadius:kSizeFrom750(60)/2];
    }
    return _buyBtn;
}
-(UIView *)sepView{
    if (!_sepView) {
        _sepView = InitObject(UIView);
        _sepView.backgroundColor = COLOR_Background;
    }
    return _sepView;
}
-(void)loadLayout
{

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.top.mas_equalTo(kSizeFrom750(30));
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    
    [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(kSizeFrom750(100));
        make.width.mas_equalTo(kSizeFrom750(150));
        make.height.mas_equalTo(kSizeFrom750(32));
    }];

    [self.rateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.rateLabel);
        make.top.mas_equalTo(self.rateLabel.mas_bottom).offset(kSizeFrom750(15));
        make.height.mas_equalTo(kSizeFrom750(25));
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rateTitle);
        make.top.mas_equalTo(self.rateTitle.mas_bottom).offset(kSizeFrom750(20));
        make.width.mas_equalTo(kSizeFrom750(450));
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    
    [self.partLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.height.mas_equalTo(self.rateLabel);
    }];
    
    [self.partTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.partLabel);
        make.top.height.mas_equalTo(self.rateTitle);
    }];
    
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kSizeFrom750(100));
        make.width.mas_equalTo(kSizeFrom750(184));
        make.height.mas_equalTo(kSizeFrom750(60));
        make.right.mas_equalTo(self.contentView).offset(-kOriginLeft);
    }];
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(kSizeFrom750(20));
    }];
    

    
}
#pragma mark --
-(void)buyBtnClick:(UIButton *)sender{
    //点击抢购债权
    if (self.buyBlock) {
        self.buyBlock();
    }
}
-(void)loadInfoWithModel:(CreditModel *)model{
    self.titleLabel.text = model.loan_name;
    self.rateTitle.text = model.apr_txt;
    self.rateLabel.text = model.apr;

    NSString *amountStr = [CommonUtils getNumberFromString:model.actual_amount];
    [self.amountLabel setAttributedText:[CommonUtils diffierentFontWithString:model.actual_amount rang:[model.actual_amount rangeOfString:amountStr] font:NUMBER_FONT(28) color:self.amountLabel.textColor spacingBeforeValue:0 lineSpace:0]];
    self.partTitle.text = model.expire_date_txt;
    self.partLabel.text = model.expire_date;
    [self.buyBtn setTitle:model.status_name forState:UIControlStateNormal];
    if ([model.status isEqualToString:@"1"]) {
        self.buyBtn.userInteractionEnabled = YES;
        self.buyBtn.backgroundColor = COLOR_Red;

    }else{
        self.buyBtn.userInteractionEnabled = NO;
        self.buyBtn.backgroundColor = COLOR_Btn_Unsel;

    }
    //数据加载
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
