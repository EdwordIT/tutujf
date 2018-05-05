//
//  TotalTradesView.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/17.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "TotalTradesView.h"
#import "UICountingLabel.h"
#import <Masonry.h>
@interface TotalTradesView()
Strong UICountingLabel *titleLabel;//累计成交金额
Strong UIView *topView;
Strong UIImageView *rulerImage;
Strong UILabel *totalLabel;//说明文字
Strong UILabel *totalDaysLabel;//总运营天数
Strong UILabel *interestRateLabel;//近期利率指数

@end
@implementation TotalTradesView
{
    CGFloat totalTrade;//总交易金额
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        totalTrade = 0;
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews{
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.topView];
    
    [self.topView addSubview:self.rulerImage];
    
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.totalLabel];
    
    [self addSubview:self.totalDaysLabel];
    
    [self addSubview:self.interestRateLabel];
    
    [self makeConstraints];
}
-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:RECT(0, 0, self.width, kSizeFrom750(156))];
        _topView.backgroundColor = RGB(255, 246, 246);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_topView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(kSizeFrom750(10), kSizeFrom750(10))];//添加圆角
        //创建CALayer图层
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = _topView.bounds;
        maskLayer.path = maskPath.CGPath;
        _topView.layer.mask = maskLayer;
    }
    return _topView;
}
-(UIImageView *)rulerImage{
    if (!_rulerImage) {
        _rulerImage = [[UIImageView alloc]initWithImage:IMAGEBYENAME(@"ruler")];
        _rulerImage.frame = RECT(0, self.topView.height - kSizeFrom750(23), self.topView.width, kSizeFrom750(23));
    }
    return _rulerImage;
}
-(UICountingLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = InitObject(UICountingLabel);
        _titleLabel.font = NUMBER_FONT_BOLD(46);
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
        _totalLabel.textColor = RGB_153;
        _totalLabel.text = @"累计成交金额(元)";
    }
    return _totalLabel;
}
-(UILabel *)totalDaysLabel{
    if (!_totalDaysLabel) {
        _totalDaysLabel = InitObject(UILabel);
        _totalDaysLabel.textAlignment = NSTextAlignmentCenter;
        _totalDaysLabel.font = SYSTEMSIZE(24);
        _totalDaysLabel.textColor = RGB_153;
        _totalDaysLabel.text = @"平台运营(天)";
        _totalDaysLabel.numberOfLines = 2;

    }
    return _totalDaysLabel;
}
-(UILabel *)interestRateLabel{
    if (!_interestRateLabel) {
        _interestRateLabel = InitObject(UILabel);
        _interestRateLabel.textAlignment = NSTextAlignmentCenter;
        _interestRateLabel.font = SYSTEMSIZE(24);
        _interestRateLabel.textColor = RGB_153;
        _interestRateLabel.text = @"近期利率指数";
        _interestRateLabel.numberOfLines = 2;
    }
    return _interestRateLabel;
}
-(void)makeConstraints{
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kSizeFrom750(20));
        make.left.width.mas_equalTo(self);
        make.height.mas_equalTo(kSizeFrom750(50));
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kSizeFrom750(20));
        make.left.width.mas_equalTo(self.titleLabel);
        make.height.mas_equalTo(kSizeFrom750(26));
    }];
    [self.totalDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.totalLabel.mas_bottom).offset(kSizeFrom750(65));
        make.width.mas_equalTo(kSizeFrom750(200));
        make.left.mas_equalTo(kSizeFrom750(95));
    }];
    
    [self.interestRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.mas_equalTo(self.totalDaysLabel);
        make.right.mas_equalTo(self).offset(-kSizeFrom750(95));
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
    [self.titleLabel countFrom:0.00 to:total withDuration:1];
    NSString *days = [NSString stringWithFormat:@"%@\n%@",model.operate_day,model.operate_day_txt];
    NSMutableAttributedString *attrStr = [CommonUtils diffierentFontWithString:days rang:NSMakeRange(0, model.operate_day.length) font:NUMBER_FONT_BOLD(36) color:RGB(44, 181, 251) spacingBeforeValue:0 lineSpace:kSizeFrom750(20)];
    [self.totalDaysLabel setAttributedText:attrStr];
    
    NSString *point = [NSString stringWithFormat:@"%@\n%@",model.average_apr,model.average_apr_txt];
    NSMutableAttributedString *attrStr1 = [CommonUtils diffierentFontWithString:point rang:NSMakeRange(0, model.average_apr.length) font:NUMBER_FONT_BOLD(36) color:RGB(44, 181, 251) spacingBeforeValue:0 lineSpace:kSizeFrom750(20)];
    [self.totalDaysLabel setAttributedText:attrStr];
    [self.interestRateLabel setAttributedText:attrStr1];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
