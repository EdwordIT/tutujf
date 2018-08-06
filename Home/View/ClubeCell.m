//
//  ClubeCell.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/19.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "ClubeCell.h"

@interface ClubeCell()
Strong UILabel *titleLabel;

Strong UILabel *subTitleLabel;

Strong UILabel *timeLabel;

Strong UILabel *sourceLabel;//信息来源
@end

@implementation ClubeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews{
    
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.sourceLabel];
    
    [self.contentView addSubview:self.timeLabel];
    
    [self.contentView addSubview:self.subTitleLabel];
    
    [self makeConstraints];
    
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = InitObject(UILabel);
        _titleLabel.textColor = RGB_51;
        _titleLabel.font = SYSTEMSIZE(28);
    }
    return _titleLabel;
    
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = InitObject(UILabel);
        _timeLabel.textColor = RGB_166;
        _timeLabel.font = SYSTEMSIZE(24);
        _timeLabel.text = @"2018-03-11";
    }
    return _timeLabel;
}

-(UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = InitObject(UILabel);
        _subTitleLabel.textColor = RGB_166;
        _subTitleLabel.numberOfLines = 2;
        _subTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _subTitleLabel.font = SYSTEMSIZE(24);
    }
    return _subTitleLabel;
}
-(UILabel *)sourceLabel{
    if (!_sourceLabel) {
        _sourceLabel = InitObject(UILabel);
        _sourceLabel.textColor = RGB(62, 112, 230);
        _sourceLabel.font = SYSTEMSIZE(24);
        _sourceLabel.text = @"来自：理财干货";
    }
    return _sourceLabel;
}
-(void)makeConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kSizeFrom750(34));
        make.left.mas_equalTo(kOriginLeft);
        make.width.mas_equalTo(kContentWidth);
        make.height.mas_equalTo(kSizeFrom750(28));
    }];
    
  
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kSizeFrom750(20));
        make.left.width.mas_equalTo(self.titleLabel);
//        make.height.mas_equalTo(kSizeFrom750(70));
    }];

    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(kSizeFrom750(30));
        make.left.mas_equalTo(self.subTitleLabel);
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sourceLabel.mas_right).offset(kSizeFrom750(68));
        make.width.mas_equalTo(kSizeFrom750(280));
        make.centerY.mas_equalTo(self.sourceLabel);
    }];
  
}
//如果有imgUrl，则是行业资讯，如果没有，则为公告
-(void)loadInfoWithModel:(NoticeModel *)model{
    self.titleLabel.text = model.title;
    [CommonUtils setAttString:@"国家为了让企业少借点钱，有两个办法可以做到：一是货币政策，包含提高借钱的成本，也就是加息（我们其实已经在变相加息了）以及少印钱；二是强化监管，堵住漏网之鱼。" withLineSpace:kSizeFrom750(10) titleLabel:self.subTitleLabel];
    self.timeLabel.text = model.add_time;
    self.sourceLabel.text = [NSString stringWithFormat:@"浏览次数：%@次",model.hits];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
