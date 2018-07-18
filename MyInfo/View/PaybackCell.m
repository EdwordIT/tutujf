//
//  PaybackCell.m
//  TTJF
//
//  Created by wbzhan on 2018/7/7.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "PaybackCell.h"
@interface PaybackCell()
Strong UIView *sepView;//
Strong UILabel *titleLabel;//标题
Strong UIImageView *investIcon;//投资按钮
Strong UILabel *investTimeLabel;//还款时间
Strong UIImageView *stateImage;//还款状态
Strong UIImageView *periodIcon;//期数
Strong UILabel *periodLabel;//期数
Strong NSMutableArray *titleArr;
Strong NSMutableArray *textArr;
Strong UILabel *subLabel;
@end
@implementation PaybackCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
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
    [self.contentView addSubview:self.stateImage];
    [self.contentView addSubview:self.investIcon];
    [self.contentView addSubview:self.investTimeLabel];
    [self.contentView addSubview:self.periodIcon];
    [self.contentView addSubview:self.periodLabel];
    for (int i=0; i<2; i++) {
        UILabel *textLabel = InitObject(UILabel);
        textLabel.font = NUMBER_FONT(48);
        textLabel.textColor = RGB_51;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = [CommonUtils getHanleNums:@"101200"];
        [self.contentView addSubview:textLabel];
        [self.textArr addObject:textLabel];
        UILabel *titleL = InitObject(UILabel);
        titleL.font = SYSTEMSIZE(26);
        titleL.textColor = RGB_183;
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.text = @"年化收益率";
        [self.contentView addSubview:titleL];
        [self.titleArr addObject:titleL];
        
        if (i==0) {
            UIView *line = InitObject(UIView);
            line.backgroundColor = separaterColor;
            [self.contentView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kSizeFrom750(45));
                make.left.mas_equalTo(kSizeFrom750(320)+i*kSizeFrom750(270));
                make.width.mas_equalTo(kLineHeight);
                make.height.mas_equalTo(kSizeFrom750(80));
            }];
        }else{
            _subLabel = InitObject(UILabel);
            _subLabel.font = NUMBER_FONT(24);
            _subLabel.textColor = RGB_183;
            _subLabel.textAlignment = NSTextAlignmentCenter;
            _subLabel.text = @"本金1,000元";
            [self.contentView addSubview:self.subLabel];
            
            [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.width.height.mas_equalTo(titleL);
                make.top.mas_equalTo(titleL.mas_bottom).offset(kSizeFrom750(10));
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
        _investTimeLabel.text = @"还款时间：2018-07-29";
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
        _periodLabel.text = @"期数/总期数：1/1";
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
        make.top.mas_equalTo(self.sepView.mas_bottom).offset(kSizeFrom750(40));
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    for (int i=0; i<self.titleArr.count; i++) {
        UILabel *title = [self.titleArr objectAtIndex:i];
        UILabel *textL = [self.textArr objectAtIndex:i];
        [textL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(i==0?kSizeFrom750(320):kSizeFrom750(430));
            make.height.mas_equalTo(kSizeFrom750(40));
            make.left.mas_equalTo(kOriginLeft+kSizeFrom750(320)*i);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kSizeFrom750(40));
        }];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(textL.mas_bottom).offset(10);
            make.left.width.mas_equalTo(textL);
            make.height.mas_equalTo(kSizeFrom750(30));
        }];
    }
    [self.investIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.bottom.mas_equalTo(self.contentView).offset(-kSizeFrom750(40));
        make.width.height.mas_equalTo(kSizeFrom750(20));
    }];
    [self.investTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.investIcon.mas_right).offset(kSizeFrom750(10));
        make.width.mas_equalTo(kSizeFrom750(300));
        make.height.mas_equalTo(kSizeFrom750(30));
        make.centerY.mas_equalTo(self.investIcon.mas_centerY);
    }];
    [self.periodIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSizeFrom750(407));
        make.width.height.centerY.mas_equalTo(self.investIcon);
    }];
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.periodIcon.mas_right).offset(kSizeFrom750(20));
        make.height.centerY.mas_equalTo(self.investTimeLabel);
    }];
    
   
    
}
#pragma mark --loadView
-(void)loadInfoWithModel:(PaybackModel *)model{

    for (int i=0; i<self.titleArr.count; i++){
        UILabel *textL = [self.textArr objectAtIndex:i];
        if (i==0) {
            [textL setAttributedText:[CommonUtils diffierentFontWithString:@"10.2%" rang:[@"10.2%" rangeOfString:@"%"] font:NUMBER_FONT(30) color:RGB_51 spacingBeforeValue:0 lineSpace:0]];

        }else{
            NSString *rangeTxt = [[CommonUtils getHanleNums:@"101200"] stringByAppendingString:@"元"];
            [textL setAttributedText:[CommonUtils diffierentFontWithString:rangeTxt rang:[rangeTxt rangeOfString:@"元"] font:SYSTEMSIZE(24) color:RGB_51 spacingBeforeValue:0 lineSpace:0]];

        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
