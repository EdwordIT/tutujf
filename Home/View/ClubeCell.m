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

Strong UIImageView *iconImageView;

Strong UILabel *timeLabel;

Strong UILabel *watchTimesLabel;//浏览次数
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
    
    [self.contentView addSubview:self.iconImageView];
    
    [self.contentView addSubview:self.timeLabel];
    
    [self.contentView addSubview:self.watchTimesLabel];
    
    [self makeConstraints];
    
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = InitObject(UILabel);
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = RGB_51;
        _timeLabel.text = @"银行要玩高风险投资，你还这么理财就危险了！";
        _titleLabel.font = SYSTEMSIZE(28);
    }
    return _titleLabel;
    
}
-(UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = InitObject(UIImageView);
        _iconImageView.layer.cornerRadius = kSizeFrom750(10);
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = InitObject(UILabel);
        _timeLabel.textColor = RGB_166;
        _timeLabel.font = NUMBER_FONT(24);
        _timeLabel.text = @"2018-03-11";
    }
    return _timeLabel;
}

-(UILabel *)watchTimesLabel{
    if (!_watchTimesLabel) {
        _watchTimesLabel = InitObject(UILabel);
        _watchTimesLabel.textColor = RGB_166;
        _watchTimesLabel.font = SYSTEMSIZE(24);
        _watchTimesLabel.text = @"浏览次数：123次";
    }
    return _watchTimesLabel;
}
-(void)makeConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kSizeFrom750(30));
        make.width.mas_equalTo(kSizeFrom750(460));
    }];
    
  
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-kSizeFrom750(30));
        make.width.mas_equalTo(kSizeFrom750(200));
        make.height.mas_equalTo(kSizeFrom750(124));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(self.contentView).offset(-kSizeFrom750(30));
        make.width.mas_equalTo(kSizeFrom750(280));
        make.height.mas_equalTo(kSizeFrom750(25));
    }];
    
    [self.watchTimesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_right);
        make.height.bottom.mas_equalTo(self.timeLabel);
    }];
}
//如果有imgUrl，则是行业资讯，如果没有，则为公告
-(void)loadInfoWithModel:(NoticeModel *)model{
    [CommonUtils setAttString:model.title withLineSpace:kLabelSpace titleLabel:self.titleLabel];
    self.timeLabel.text = model.add_time;
    self.watchTimesLabel.text = [NSString stringWithFormat:@"浏览次数：%@次",model.hits];
    if ([model isKindOfClass:[InformationModel class]]) {
        //行业资讯
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kSizeFrom750(460));
        }];
        self.iconImageView.alpha = 1;
        [self.iconImageView setImageWithString:((InformationModel *)model).pic];
    }else{
        //公告
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(screen_width - kSizeFrom750(60));
        }];
        self.iconImageView.alpha = 0;      
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
