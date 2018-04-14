//
//  AccountSettingCell.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/4/12.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "AccountSettingCell.h"
@interface AccountSettingCell()

@end
@implementation AccountSettingCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = COLOR_White;
        [self initSubViews];
    }
    return self;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = InitObject(UILabel);
        _titleLabel.font = SYSTEMSIZE(28);
        _titleLabel.textColor = RGB_51;
    }
    return _titleLabel;
}
-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = InitObject(UILabel);
        _contentLabel.font = SYSTEMSIZE(28);
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.textColor = RGB_153;
    }
    return _contentLabel;
}
-(UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = InitObject(UIImageView);
        [_iconImage setHidden:YES];
    }
    return _iconImage;
}
-(UIImageView *)codeImage{
    if (!_codeImage) {
        _codeImage = InitObject(UIImageView);
        [_codeImage setHidden:YES];
    }
    return _codeImage;
}
-(UIImageView *)rightArrow{
    if (!_rightArrow) {
        _rightArrow = InitObject(UIImageView);
        [_rightArrow setImage:IMAGEBYENAME(@"rightArrow")];
    }
    return _rightArrow;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = InitObject(UIView);
        _lineView.backgroundColor = separaterColor;
    }
    return _lineView;
}
-(void)initSubViews
{
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.contentLabel];
    
    [self.contentView addSubview:self.codeImage];
    
    [self.contentView addSubview:self.rightArrow];
    
    [self.contentView addSubview:self.iconImage];
    
    [self.contentView addSubview:self.lineView];
    
    [self makeConstanint];
}
-(void)makeConstanint{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(kSizeFrom750(35));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-kSizeFrom750(60));
        make.centerY.height.mas_equalTo(self.titleLabel);
    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kSizeFrom750(80));
        make.centerY.mas_equalTo(self.contentLabel);
        make.right.mas_equalTo(self.contentView).offset(-kOriginLeft);
    }];
    
    
    [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSizeFrom750(14));
        make.height.mas_equalTo(kSizeFrom750(28));
        make.right.mas_equalTo(self.iconImage);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
    
    [self.codeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kSizeFrom750(30));
        make.right.mas_equalTo(self.rightArrow.mas_left).offset(-kSizeFrom750(20));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.right.mas_equalTo(-kOriginLeft);
        make.height.mas_equalTo(kLineHeight);
        make.bottom.mas_equalTo(self.contentView);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
