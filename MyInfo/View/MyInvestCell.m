//
//  MyInvestCell.m
//  TTJF
//
//  Created by wbzhan on 2018/5/15.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyInvestCell.h"
@interface MyInvestCell()
Strong UIView *sepView;//
Strong UILabel *titleLabel;//标题
Strong UIImageView *typeImage;//新手专享等提示图标
Strong UIImageView *investIcon;//投资按钮
Strong UILabel *investTimeLabel;//投资时间
Strong UIImageView *stateImage;//投资状态
Strong UIImageView *periodIcon;//期数
Strong UILabel *periodLabel;//期数
Strong NSMutableArray *titleArr;
Strong NSMutableArray *textArr;

@end
@implementation MyInvestCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = COLOR_White;
        self.titleArr = InitObject(NSMutableArray);
        self.textArr = InitObject(NSMutableArray);
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews
{
    [self.contentView addSubview:self.sepView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.typeImage];
    [self.contentView addSubview:self.stateImage];
    [self.contentView addSubview:self.investIcon];
    [self.contentView addSubview:self.investTimeLabel];
    [self.contentView addSubview:self.periodIcon];
    [self.contentView addSubview:self.periodLabel];
    for (int i=0; i<3; i++) {
        UILabel *textLabel = InitObject(UILabel);
        textLabel.font = NUMBER_FONT(30);
        textLabel.textColor = RGB_51;
        textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:textLabel];
        [self.textArr addObject:textLabel];
        UILabel *titleL = InitObject(UILabel);
        titleL.font = SYSTEMSIZE(26);
        titleL.textColor = RGB_183;
        titleL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleL];
        [self.titleArr addObject:titleL];
        
        if (i!=2) {
            UIView *line = InitObject(UIView);
            line.backgroundColor = separaterColor;
            [self.contentView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kSizeFrom750(45));
                make.left.mas_equalTo(kSizeFrom750(230)+i*kSizeFrom750(270));
                make.width.mas_equalTo(kLineHeight);
                make.height.mas_equalTo(kSizeFrom750(80));
            }];
        }
    }
    [self loadLayout];
}
#pragma mark --lazyLoading
-(UIView *)sepView{
    if (!_sepView) {
        _sepView = InitObject(UIView);
        _sepView.backgroundColor = COLOR_Background;
    }
    return _sepView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = InitObject(UILabel);
        _titleLabel= [[UILabel alloc] init];
        _titleLabel.font = SYSTEMSIZE(30);
        _titleLabel.textColor = RGB_51;
        _titleLabel.text=@"荣威17092107-02(温州总部)";
        

    }
    return _titleLabel;
}
-(UIImageView *)typeImage{
    if (!_typeImage) {
        _typeImage= [[UIImageView alloc] init];
        [_typeImage setImage:[UIImage imageNamed:@"gqzq.png"]];
    }
    return _typeImage;
}
//投资时间图片
-(UIImageView *)investIcon{
    if (!_investIcon) {
        _investIcon = InitObject(UIImageView);
        [_investIcon setImage:IMAGEBYENAME(@"myinvest_time")];
    }
    return _investIcon;
}
-(UILabel *)investTimeLabel{
    if (!_investTimeLabel) {
        _investTimeLabel = InitObject(UILabel);
        _investTimeLabel.textColor = RGB_102;
        _investTimeLabel.font = SYSTEMSIZE(26);
    }
    return _investTimeLabel;
}
-(UIImageView *)periodIcon{
    if (!_periodIcon) {
        _periodIcon = InitObject(UIImageView);
        [_periodIcon setImage:IMAGEBYENAME(@"myinvest_period")];
    }
    return _periodIcon;
}
-(UILabel *)periodLabel{
    if (!_periodLabel) {
        _periodLabel = InitObject(UILabel);
        _periodLabel.font = SYSTEMSIZE(26);
        _periodLabel.textColor = RGB_102;
        _periodLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _periodLabel;
}

-(void)loadLayout{
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(screen_width);
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.top.mas_equalTo(self.sepView.mas_bottom).offset(kSizeFrom750(25));
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    [self.typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(kSizeFrom750(130));
        make.height.mas_equalTo(kSizeFrom750(40));
        make.top.mas_equalTo(self.sepView.mas_bottom).offset(-kSizeFrom750(10));
    }];
    for (int i=0; i<self.titleArr.count; i++) {
        UILabel *title = [self.titleArr objectAtIndex:i];
        UILabel *textL = [self.textArr objectAtIndex:i];
        [textL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kSizeFrom750(230));
            make.height.mas_equalTo(kSizeFrom750(30));
            make.left.mas_equalTo(kOriginLeft+kSizeFrom750(230)*i);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kSizeFrom750(40));
        }];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(textL.mas_bottom).offset(20);
            make.left.width.height.mas_equalTo(textL);
        }];
    }
    [self.investIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kSizeFrom750(180));
        make.width.height.mas_equalTo(kSizeFrom750(20));
    }];
    [self.investTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.investIcon.mas_right).offset(kSizeFrom750(10));
        make.width.mas_equalTo(kSizeFrom750(300));
        make.height.mas_equalTo(kSizeFrom750(30));
        make.centerY.mas_equalTo(self.investIcon.mas_centerY);
    }];
    
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-kOriginLeft);
        make.height.centerY.mas_equalTo(self.investTimeLabel);
    }];
    
    [self.periodIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.periodLabel.mas_left).offset(-kSizeFrom750(10));
        make.width.height.centerY.mas_equalTo(self.investIcon);
    }];
    
}
#pragma mark --loadView
-(void)loadInfoWithModel:(MyInvestModel *)model{
    self.titleLabel.text = model.loan_name;
    self.investTimeLabel.text = model.left_bottom_txt;
    self.periodLabel.text = model.right_bottom_txt;
    NSArray *titleArr = @[model.award_interest_txt,model.amount_txt,model.apr_txt];
    NSArray *textArr = @[model.award_interest,model.amount,model.apr];
    for (int i=0; i<titleArr.count; i++) {
        UILabel *title = [self.titleArr objectAtIndex:i];
        title.text = titleArr[i];
        UILabel *textL = [self.textArr objectAtIndex:i];
        textL.text = textArr[i];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
