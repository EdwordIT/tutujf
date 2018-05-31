//
//  MyInvestRecordCell.m
//  TTJF
//
//  Created by wbzhan on 2018/5/16.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "CreditAssignHistoryCell.h"

@interface CreditAssignHistoryCell()
Strong UIView *sepView;//顶部分隔栏
Strong UILabel *titleLabel;
Strong UILabel *subTitleLabel;//代还、已购、总期数
Strong UIImageView *stateImage;//状态
//Strong UIButton *detailBtn;//查看详情
Strong UILabel *amountLabel;//总价值
Strong UILabel *amountTitle;//购买价格
Strong UIView *lineView;
Strong UILabel *principalTitle;//待收本金
Strong UILabel *principalLabel;//
Strong UILabel *interestTitle;//待收利息
Strong UILabel *interestLabel;//
Strong UIButton *qBtn1;//
Strong UIButton *qBtn2;//
Strong UIButton *qBtn3;//
Strong MyTransferModel *baseModel;

@end

@implementation CreditAssignHistoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = COLOR_White;
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews{
    
    [self.contentView addSubview:self.sepView];
    
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.subTitleLabel];
    
    [self.contentView addSubview:self.stateImage];
    
    [self.contentView addSubview:self.amountLabel];
    
    [self.contentView addSubview:self.amountTitle];
    
    [self.contentView addSubview:self.principalLabel];
    
    [self.contentView addSubview:self.principalTitle];
    
    [self.contentView addSubview:self.interestLabel];
    
    [self.contentView addSubview:self.interestTitle];
    
    [self.contentView addSubview:self.lineView];
    
    [self.contentView addSubview:self.qBtn1];
    [self.contentView addSubview:self.qBtn2];
    [self.contentView addSubview:self.qBtn3];

    
    [self loadLayout];
}
#pragma mark --lazyLoading
-(UIView *)sepView{
    if (!_sepView) {
        _sepView = InitObject(UIView);
        _sepView.backgroundColor = separaterColor;
    }
    return _sepView;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = InitObject(UILabel);
        _titleLabel.font = SYSTEMSIZE(28);
        _titleLabel.textColor = RGB_51;
        _titleLabel.text = @"债权转让3月标";
    }
    return _titleLabel;
}
-(UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = InitObject(UILabel);
        _subTitleLabel.font = SYSTEMSIZE(26);
        _subTitleLabel.textColor = RGB_102;
        _subTitleLabel.text = @"还款时间：2018-03-04";
    }
    return _subTitleLabel;
}
-(UIImageView *)stateImage{
    if (!_stateImage) {
        _stateImage = InitObject(UIImageView);
        [_stateImage setImage:IMAGEBYENAME(@"transfer_record_selling")];
    }
    return _stateImage;
}
-(UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = InitObject(UILabel);
        _amountLabel.textColor = COLOR_DarkBlue;
        _amountLabel.font = SYSTEMSIZE(30);
        _amountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _amountLabel;
}
-(UILabel *)amountTitle{
    if (!_amountTitle) {
        _amountTitle = InitObject(UILabel);
        _amountTitle.textColor = RGB_183;
        _amountTitle.textAlignment = NSTextAlignmentCenter;
        _amountTitle.font = SYSTEMSIZE(28);
    }
    return _amountTitle;
}
-(UILabel *)principalLabel{
    if (!_principalLabel) {
        _principalLabel = InitObject(UILabel);
        _principalLabel.textColor = RGB_51;
        _principalLabel.font = NUMBER_FONT(30);
        _principalLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _principalLabel;
}
-(UILabel *)principalTitle{
    if (!_principalTitle) {
        _principalTitle = InitObject(UILabel);
        _principalTitle.textColor = RGB_183;
        _principalTitle.textAlignment = NSTextAlignmentCenter;
        _principalTitle.font = SYSTEMSIZE(28);

    }
    return _principalTitle;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = InitObject(UIView);
        _lineView.backgroundColor = separaterColor;
    }
    return _lineView;
}
-(UILabel *)interestLabel{
    if (!_interestLabel) {
        _interestLabel = InitObject(UILabel);
        _interestLabel.textColor = RGB_51;
        _interestLabel.font = NUMBER_FONT(30);
        _interestLabel.textAlignment = NSTextAlignmentCenter;

        
    }
    return _interestLabel;
}
-(UILabel *)interestTitle{
    if (!_interestTitle) {
        _interestTitle = InitObject(UILabel);
        _interestTitle.textColor = RGB_183;
        _interestTitle.textAlignment = NSTextAlignmentCenter;
        _interestTitle.font = SYSTEMSIZE(28);


    }
    return _interestTitle;
}
-(UIButton *)qBtn1{
    if (!_qBtn1) {
        _qBtn1 = InitObject(UIButton);
        [_qBtn1 setImage:IMAGEBYENAME(@"transfer_record_question") forState:UIControlStateNormal];
        _qBtn1.adjustsImageWhenHighlighted = NO;
        [_qBtn1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _qBtn1.tag = 0;
    }
    return _qBtn1;
}
-(UIButton *)qBtn2{
    if (!_qBtn2) {
        _qBtn2 = InitObject(UIButton);
        _qBtn2.adjustsImageWhenHighlighted = NO;
        [_qBtn2 setImage:IMAGEBYENAME(@"transfer_record_question") forState:UIControlStateNormal];
        [_qBtn2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _qBtn2.tag = 1;
    }
    return _qBtn2;
}
-(UIButton *)qBtn3{
    if (!_qBtn3) {
        _qBtn3 = InitObject(UIButton);
        _qBtn3.adjustsImageWhenHighlighted = NO;
        [_qBtn3 setImage:IMAGEBYENAME(@"transfer_record_question") forState:UIControlStateNormal];
        [_qBtn3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _qBtn3.tag = 2;
    }
    return _qBtn3;
}
-(void)loadLayout
{
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(kSizeFrom750(40));
    }];
    [self.stateImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-kOriginLeft);
        make.width.mas_equalTo(kSizeFrom750(130));
        make.height.mas_equalTo(kSizeFrom750(40));
        make.top.mas_equalTo(self.sepView.mas_bottom).offset(-kSizeFrom750(8));
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sepView.mas_bottom).offset(kSizeFrom750(30));
        make.left.mas_equalTo(kOriginLeft);
        make.height.mas_equalTo(kLabelHeight);
        
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kSizeFrom750(20));
        make.left.height.mas_equalTo(self.titleLabel);
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(kSizeFrom750(45));
        make.height.mas_equalTo(kSizeFrom750(35));
    }];
    [self.amountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.height.mas_equalTo(self.amountLabel);
        make.top.mas_equalTo(self.amountLabel.mas_bottom).offset(kSizeFrom750(20));
    }];
    
    [self.principalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(screen_width/2);
        make.top.mas_equalTo(self.amountTitle.mas_bottom).offset(kSizeFrom750(40));
        make.height.mas_equalTo(kSizeFrom750(30));
        make.left.mas_equalTo(0);
    }];
    [self.principalTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.height.mas_equalTo(self.principalLabel);
        make.top.mas_equalTo(self.principalLabel.mas_bottom).offset(kSizeFrom750(15));
    }];
    [self.interestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.principalLabel);
        make.top.mas_equalTo(self.principalLabel);
        make.left.mas_equalTo(self.principalLabel.mas_right);
    }];
    [self.interestTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(self.principalTitle);
        make.centerX.mas_equalTo(self.interestLabel);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.amountTitle.mas_bottom).offset(kSizeFrom750(50));
        make.left.mas_equalTo(self.principalLabel.mas_right);
        make.height.mas_equalTo(kSizeFrom750(80));
        make.width.mas_equalTo(kLineHeight);
    }];
 
    [self.qBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kSizeFrom750(60));
        make.centerY.mas_equalTo(self.amountTitle);
        make.left.mas_equalTo(self.amountTitle.mas_right);
    }];
    [self.qBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kSizeFrom750(60));
        make.centerY.mas_equalTo(self.principalTitle);
        make.left.mas_equalTo(self.principalTitle.mas_right);
    }];
    [self.qBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kSizeFrom750(60));
        make.centerY.mas_equalTo(self.interestTitle);
        make.left.mas_equalTo(self.interestTitle.mas_right);
    }];
}
-(void)buttonClick:(UIButton *)sender{
    if (self.alertBlock) {
        self.alertBlock(sender.tag);
    }
}
-(void)loadInfoWithModel:(MyTransferModel *)model{
    if (model.isBuy) {
        self.amountLabel.textColor = RGB(51, 184, 124);
        [self.qBtn1 setHidden:YES];
        [self.qBtn2 setHidden:YES];
        [self.qBtn3 setHidden:YES];
        switch ([model.status intValue]) {//-1回收中 1、已回收
            case -1:
                {
                    [self.stateImage setImage:IMAGEBYENAME(@"transfer_record_repay")];
                }
                break;
            case 1:
            {
               [self.stateImage setImage:IMAGEBYENAME(@"transfer_record_paidback")];
            }
                break;
            default:
                break;
        }
    }else{
        switch ([model.status intValue]) {//-1 不可转让，1 可以转让 2 转让中 3 已转让
            case -1:
            {
                [self.stateImage setImage:IMAGEBYENAME(@"transfer_record_cantSell")];
            }
                break;
            case 1:
            {
                [self.stateImage setImage:IMAGEBYENAME(@"transfer_record_canSell")];
            }
                break;
            case 2:
            {
                [self.stateImage setImage:IMAGEBYENAME(@"transfer_record_selling")];
            }
                break;
            case 3:
            {
                [self.stateImage setImage:IMAGEBYENAME(@"transfer_record_sold")];
            }
                break;
                
            default:
                break;
        }
    }
   
    self.baseModel = model;
    self.titleLabel.text = model.loan_name;
    self.subTitleLabel.text = model.expire_time;
    //判断内容，如果是文字，则不加千分位符号
    if ([model.transfer_amount rangeOfString:@"."].location==NSNotFound) {
        self.amountLabel.text = model.transfer_amount;
        self.amountLabel.font = SYSTEMSIZE(30);
    }else{
        self.amountLabel.text =[@"￥" stringByAppendingString:[CommonUtils getHanleNums:model.transfer_amount]];
        self.amountLabel.font = NUMBER_FONT(40);
    }
    self.amountTitle.text = model.transfer_amount_txt;
    if ([model.actual_amount_money isEqualToString:@"-"]) {
        self.principalLabel.text = @"-";
    }else
        self.principalLabel.text =[@"￥" stringByAppendingString: [CommonUtils getHanleNums:model.actual_amount_money]];
    self.principalTitle.text = model.actual_amount_money_txt;
    if ([model.repay_amount isEqualToString:@"-"]) {
        self.interestLabel.text = @"-";
    }else
        self.interestLabel.text =[@"￥" stringByAppendingString: [CommonUtils getHanleNums:model.repay_amount]];
    self.interestTitle.text = model.repay_amount_txt;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
