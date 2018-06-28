//
//  MyBankCardCell.m
//  TTJF
//
//  Created by wbzhan on 2018/6/12.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyBankCardCell.h"
#import "GradientButton.h"
#import <UIButton+WebCache.h>
@interface AddBankCardCell()
Strong UIButton *addBtn;//添加银行卡
Assign BOOL isCanAdd;//是否可添加银行卡
@end

@implementation AddBankCardCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = COLOR_White;
        self.addBtn = [[UIButton alloc]initWithFrame:RECT(kOriginLeft*2, kOriginLeft, kContentWidth - kOriginLeft*2, kSizeFrom750(110))];
        [self.contentView addSubview:self.addBtn];
        _addBtn.layer.cornerRadius = kSizeFrom750(5);
        _addBtn.layer.borderColor = [RGB_183 CGColor];
        _addBtn.layer.borderWidth = kLineHeight;
        [_addBtn setTitle:@"添加银行卡" forState:UIControlStateNormal];
        [_addBtn setImage:IMAGEBYENAME(@"logo") forState:UIControlStateNormal];
        [_addBtn setBackgroundColor:RGB(249, 250, 251)];
        [_addBtn setTitleColor:RGB_183 forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)loadInfoWithModel:(AddBankCardModel *)model{
    
    [self.addBtn setTitle:model.btaddname forState:UIControlStateNormal];
}
-(void)addClick:(UIButton *)sender{
    
    if (self.addBankCardBlock) {
        self.addBankCardBlock();
    }
}
@end
@interface MyBankCardCell()
Strong GradientButton *bgView;
Strong UIImageView *iconImage;
Strong UILabel *titleL;
Strong UILabel *subTitleL;
Strong UIButton *unlinkBtn;//解绑
Strong UILabel *cardNumL;//银行卡号
Strong BankCardModel *bankCardModel;
@end
@implementation MyBankCardCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = COLOR_White;
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews
{
    [self.contentView addSubview:self.bgView];
    
    [self.bgView addSubview:self.iconImage];
    
    [self.bgView addSubview:self.titleL];
    
    [self.bgView addSubview:self.subTitleL];
    
    [self.bgView addSubview:self.unlinkBtn];
    
    [self.bgView addSubview:self.cardNumL];
    
    [self loadLayout];
    
}
-(GradientButton *)bgView{
    if (!_bgView) {
        _bgView = [[GradientButton alloc]initWithFrame:RECT(kOriginLeft*2, kOriginLeft, kContentWidth - kOriginLeft*2, kSizeFrom750(220))];
        [_bgView setGradientColors:@[COLOR_DarkBlue,COLOR_LightBlue]];
    }
    return _bgView;
}
-(UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = InitObject(UIImageView);
        _iconImage.layer.cornerRadius = kSizeFrom750(100)/2;
        _iconImage.layer.masksToBounds = YES;
    }
    return _iconImage;
}
-(UILabel *)titleL{
    if (!_titleL) {
        _titleL =  InitObject(UILabel);
        _titleL.textColor = COLOR_White;
        _titleL.font = SYSTEMBOLDSIZE(32);
    }
    return _titleL;
}
-(UILabel *)subTitleL{
    if (!_subTitleL) {
        _subTitleL =  InitObject(UILabel);
        _subTitleL.textColor = COLOR_White;
        _subTitleL.font = SYSTEMSIZE(28);
    }
    return _subTitleL;
}
-(UIButton *)unlinkBtn{
    if (!_unlinkBtn) {
        _unlinkBtn = InitObject(UIButton);
         NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:@"点击解绑"];
        [attr setAttributes:@{NSUnderlineColorAttributeName: COLOR_LightBlue,
                              NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid),NSFontAttributeName:SYSTEMSIZE(28),NSForegroundColorAttributeName:RGB(179,254,246)} range:NSMakeRange(0, 4)];
        [_unlinkBtn addTarget:self action:@selector(unlinkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_unlinkBtn setAttributedTitle:attr forState:UIControlStateNormal];
        _unlinkBtn.adjustsImageWhenHighlighted = NO;
    }
    return _unlinkBtn;
}
-(UILabel *)cardNumL{
    if (!_cardNumL) {
        _cardNumL = InitObject(UILabel);
        _cardNumL.textColor = COLOR_White;
        _cardNumL.font = NUMBER_FONT(45);
    }
    return _cardNumL;
}
-(void)loadLayout{
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kSizeFrom750(20));
        make.width.height.mas_equalTo(kSizeFrom750(100));
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImage.mas_right).offset(kSizeFrom750(20));
        make.top.mas_equalTo(kSizeFrom750(35));
    }];
    
    [self.subTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleL);
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(kSizeFrom750(20));
    }];
    
    [self.unlinkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImage);
        make.right.mas_equalTo(-kSizeFrom750(20));
        
    }];
    
    [self.cardNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-kSizeFrom750(20));
        make.left.mas_equalTo(self.iconImage);
    }];
    
}
-(void)loadInfoWithModel:(BankCardModel *)model{
    [self.iconImage setImageWithString:model.bank_logo];
    [self.titleL setText:model.bank_name];
    [self.subTitleL setText:model.express_flag_txt];
    [self.unlinkBtn setTitle:model.relieve_txt forState:UIControlStateNormal];
    [self.cardNumL setText:model.show_card_id];
    self.bankCardModel = model;
}
-(void)unlinkBtnClick:(UIButton *)sender{
    
    if (self.unlinkBankCardBlock) {
        self.unlinkBankCardBlock(self.bankCardModel.card_id);
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
