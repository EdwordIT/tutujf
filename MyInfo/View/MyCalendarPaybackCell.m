//
//  MyCalendarPaybackCell.m
//  TTJF
//
//  Created by wbzhan on 2018/7/12.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyCalendarPaybackCell.h"

@interface MyCalendarPaybackCell()
Strong UILabel *titleL;
Strong UILabel *subL;
Strong UILabel *nameL;
Strong UILabel *amountL;
Strong UILabel *amountDesL;
@end
@implementation MyCalendarPaybackCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = COLOR_White;
        [self initSuViews];
    }
    return self;
}
-(void)initSuViews
{
    [self.contentView addSubview:self.titleL];
    
    [self.contentView addSubview:self.subL];
    
    [self.contentView addSubview:self.nameL];
    
    [self.contentView addSubview:self.amountL];
    
    [self.contentView addSubview:self.amountDesL];
    
    [self loadLayout];
    
}
-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = InitObject(UILabel);
        _titleL.font =  SYSTEMSIZE(28);
        _titleL.textColor = RGB_153;
        _titleL.text = @"回款项目：";
    }
    return _titleL;
}
-(UILabel *)subL{
    if (!_subL) {
        _subL = InitObject(UILabel);
        _subL.font =  SYSTEMSIZE(28);
        _subL.textColor = RGB_153;
        _titleL.text = @"回款总额：";

    }
    return _subL;
}
-(UILabel *)nameL{
    if (!_nameL) {
        _nameL = InitObject(UILabel);
        _nameL.font =  SYSTEMSIZE(28);
        _nameL.textColor = RGB_102;
        _nameL.textAlignment = NSTextAlignmentRight;
        _nameL.text = @"玛莎拉蒂190921(温州)";
    }
    return _nameL;
}
-(UILabel *)amountL{
    if (!_amountL) {
        _amountL = InitObject(UILabel);
        _amountL.font =  SYSTEMSIZE(28);
        _amountL.textColor = RGB_102;
        _amountL.textAlignment = NSTextAlignmentRight;
        _amountL.text = @"10110.00元";

    }
    return _amountL;
}
-(UILabel *)amountDesL{
    if (!_amountDesL) {
        _amountDesL = InitObject(UILabel);
        _amountDesL.font =  SYSTEMSIZE(22);
        _amountDesL.textColor = RGB_153;
        _amountDesL.textAlignment = NSTextAlignmentRight;
        _amountDesL.text = @"本金10000.00元+利息110.00元";

    }
    return _amountDesL;
}
-(void)loadLayout{
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kOriginLeft);
        make.height.mas_equalTo(kLabelHeight);
    }];
    
    [self.subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(self.titleL);
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(kSizeFrom750(20));
    }];
    
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kOriginLeft);
        make.top.height.mas_equalTo(self.titleL);
    }];
    
    [self.amountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.mas_equalTo(self.nameL);
        make.top.mas_equalTo(self.subL);
    }];
    [self.amountDesL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.mas_equalTo(self.amountL);
        make.top.mas_equalTo(self.amountL.mas_bottom).offset(kSizeFrom750(10));
    }];
    
}
-(void)loadInfoWithModel:(PaybackModel *)model{
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
