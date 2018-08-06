//
//  TotolAmountCell.m
//  TTJF
//
//  Created by wbzhan on 2018/8/4.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "TotolAmountCell.h"
#import "UICountingLabel.h"
@interface TotolAmountCell()
Strong UICountingLabel *titleLabel;//累计成交金额
Strong UILabel *totalLabel;//说明文字
Strong UILabel *totalDaysLabel;//总运营天数
Strong UILabel *interestRateLabel;//近期利率指数
Strong UILabel *totalDaysTitle;
Strong UILabel *interestRateTitle;

@end
 @implementation TotolAmountCell
{
    CGFloat totalTrade;//总交易金额
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        totalTrade = 0;
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews{
    
    self.contentView.backgroundColor = COLOR_White;
    
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.totalLabel];
    
    [self.contentView addSubview:self.totalDaysTitle];
    
    [self.contentView addSubview:self.interestRateTitle];
    
    [self.contentView addSubview:self.totalDaysLabel];
    
    [self.contentView addSubview:self.interestRateLabel];
    
    [self makeConstraints];
}
-(UICountingLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = InitObject(UICountingLabel);
        _titleLabel.font = NUMBER_FONT_BOLD(54);
        _titleLabel.textColor = COLOR_Red;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.format = @"%.2f";
        _titleLabel.positiveFormat = @"###,###.00";
        
    }
    return _titleLabel;
}

-(UILabel *)totalLabel{
    if (!_totalLabel) {
        _totalLabel = InitObject(UILabel);
        _totalLabel.textAlignment = NSTextAlignmentCenter;
        _totalLabel.font = SYSTEMSIZE(24);
        _totalLabel.textColor = HEXCOLOR(@"#999999");
        _totalLabel.text = @"累计交易金额(元)";
    }
    return _totalLabel;
}
-(UILabel *)totalDaysLabel{
    if (!_totalDaysLabel) {
        _totalDaysLabel = InitObject(UILabel);
        _totalDaysLabel.font = NUMBER_FONT_BOLD(36);
        _totalDaysLabel.textColor = RGB_51;
        
    }
    return _totalDaysLabel;
}
-(UILabel *)totalDaysTitle{
    if (!_totalDaysTitle) {
        _totalDaysTitle = InitObject(UILabel);
        _totalDaysTitle.font = SYSTEMSIZE(24);
        _totalDaysTitle.textColor = RGB_153;
        _totalDaysTitle.text = @"平台安全运营";
        
    }
    return _totalDaysTitle;
}
-(UILabel *)interestRateLabel{
    if (!_interestRateLabel) {
        _interestRateLabel = InitObject(UILabel);
        _interestRateLabel.font = NUMBER_FONT_BOLD(36);
        _interestRateLabel.textColor = RGB_51;
    }
    return _interestRateLabel;
}
-(UILabel *)interestRateTitle{
    if (!_interestRateTitle) {
        _interestRateTitle = InitObject(UILabel);
        _interestRateTitle.font = SYSTEMSIZE(24);
        _interestRateTitle.textColor = RGB_153;
        _interestRateTitle.text = @"近期利率指数";
    }
    return _interestRateTitle;
}
-(void)makeConstraints{
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kSizeFrom750(40));
        make.left.width.mas_equalTo(self);
        make.height.mas_equalTo(kSizeFrom750(54));
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kSizeFrom750(30));
        make.left.width.mas_equalTo(self.titleLabel);
        make.height.mas_equalTo(kSizeFrom750(26));
    }];
    UIView *lineV = InitObject(UIView);
    lineV.backgroundColor = separaterColor;
    [self.contentView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.totalLabel.mas_bottom).offset(kSizeFrom750(30));
        make.left.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    [self.interestRateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSizeFrom750(56));
        make.top.mas_equalTo(lineV.mas_bottom).offset(kSizeFrom750(25));
        make.height.mas_equalTo(kSizeFrom750(36));
    }];
    
    [self.interestRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.interestRateTitle.mas_right).offset(kSizeFrom750(26));
        make.centerY.height.mas_equalTo(self.interestRateTitle);
    }];
    
    [self.totalDaysTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.interestRateLabel.mas_right).offset(kSizeFrom750(96));
        make.top.mas_equalTo(lineV.mas_bottom).offset(kSizeFrom750(25));
        make.height.mas_equalTo(kSizeFrom750(36));
    }];
    
    [self.totalDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.mas_equalTo(self.totalDaysTitle);
        make.left.mas_equalTo(self.totalDaysTitle.mas_right).offset(kSizeFrom750(26));
    }];
 
    
}
-(void)countTradeNum
{
    if (totalTrade>0) {
        [self.titleLabel countFrom:0.00 to:totalTrade withDuration:1];
    }
}
//数据加载
-(void)loadInfoWithModel:(HomepageModel *)model{
    
    CGFloat total = [model.trans_num doubleValue]*1.00;
    totalTrade = total;
    self.totalLabel.text = model.trans_num_txt;
    [self.titleLabel countFrom:0.00 to:total withDuration:2];
    self.totalDaysTitle.text = model.operate_day_txt;
    self.interestRateTitle.text = model.average_apr_txt;
    
    NSString *days = [NSString stringWithFormat:@"%@天",model.operate_day];
    NSMutableAttributedString *attrStr = [CommonUtils diffierentFontWithString:days rang:[days rangeOfString:@"天"] font:SYSTEMSIZE(24) color:nil spacingBeforeValue:0 lineSpace:0];
    [self.totalDaysLabel setAttributedText:attrStr];
    
    
    NSMutableAttributedString *attrStr1 = [CommonUtils diffierentFontWithString:model.average_apr rang:[model.average_apr rangeOfString:@"%"] font:SYSTEMSIZE(24) color:nil spacingBeforeValue:0 lineSpace:kSizeFrom750(15)];
    [self.totalDaysLabel setAttributedText:attrStr];
    [self.interestRateLabel setAttributedText:attrStr1];
    
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
