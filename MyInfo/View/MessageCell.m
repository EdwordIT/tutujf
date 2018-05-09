//
//  MessageCell.m
//  TTJF
//
//  Created by wbzhan on 2018/5/9.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MessageCell.h"
@interface MessageCell()

Strong UIView *bgView;

Strong UILabel *titleLabel;

Strong UILabel *contentLabel;

Strong UILabel *subTitleLabel;

Strong UIView *lineView;

Strong UIImageView *pointView;

Strong UIImageView *arrowImage;

@end
@implementation MessageCell

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
    [self.contentView addSubview:self.bgView];
    
    [self.bgView addSubview:self.titleLabel];
    
    [self.bgView addSubview:self.contentLabel];
    
    [self.bgView addSubview:self.subTitleLabel];
    
    [self.bgView addSubview:self.lineView];
    
    [self.bgView addSubview:self.pointView];
    
    [self.bgView addSubview:self.arrowImage];
    
    [self loadLayout];
    
}
#pragma mark --lazyLoading
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = InitObject(UIView);
        _bgView.backgroundColor = COLOR_White;
        _bgView.layer.cornerRadius = kSizeFrom750(10);
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = InitObject(UILabel);
        _titleLabel.textColor = RGB_51;
        _titleLabel.font = SYSTEMSIZE(30);
    }
    return _titleLabel;
}
-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = InitObject(UILabel);
        _contentLabel.textColor = RGB_102;
        _contentLabel.font = SYSTEMSIZE(26);
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
-(UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = InitObject(UILabel);
        _subTitleLabel.textColor = RGB_51;
        _subTitleLabel.font = SYSTEMSIZE(28);
    }
    return _subTitleLabel;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = InitObject(UIView);
        _lineView.backgroundColor = separaterColor;
    }
    return _lineView;
}
-(UIImageView *)pointView{
    if (!_pointView) {
        _pointView = InitObject(UIImageView);
        [_pointView setBackgroundColor:COLOR_Red];
        _pointView.layer.cornerRadius = 2;
        _pointView.layer.masksToBounds = YES;
    }
    return _pointView;
}
-(UIImageView *)arrowImage{
    if (!_arrowImage) {
        _arrowImage = InitObject(UIImageView);
        [_arrowImage setImage:IMAGEBYENAME(@"rightArrow")];
    }
    return _arrowImage;
}
-(void)loadLayout
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.right.mas_equalTo(-kOriginLeft);
        make.top.mas_equalTo(kSizeFrom750(20));
        make.height.mas_equalTo(kSizeFrom750(200));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.top.mas_equalTo(kSizeFrom750(20));
        make.width.mas_equalTo(kContentWidth - kOriginLeft*2);
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kSizeFrom750(20));
        make.height.mas_equalTo(kSizeFrom750(70));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(kSizeFrom750(20));
        make.height.mas_equalTo(kLineHeight);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lineView);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(kSizeFrom750(10));
        make.width.mas_equalTo(kSizeFrom750(150));
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    
    
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kOriginLeft);
        make.width.mas_equalTo(kSizeFrom750(15));
        make.height.mas_equalTo(kSizeFrom750(28));
        make.centerY.mas_equalTo(self.subTitleLabel.mas_centerY);
    }];
    
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowImage.mas_left).offset(-kSizeFrom750(10));
        make.width.height.mas_equalTo(4);
        make.centerY.mas_equalTo(self.subTitleLabel.mas_centerY);
    }];
}
-(void)loadInfoWithModel:(MessageModel *)model
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
