//
//  WithDrawController.m
//  TTJF
//
//  Created by wbzhan on 2018/4/24.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "GetCashController.h"
#import "GetCashRecordController.h"
#import "GradientButton.h"
@interface GetCashController ()<UITextFieldDelegate,UITextViewDelegate>
Strong UIView *topView;//白色背景
Strong UILabel *amountTitle;
Strong UILabel *amountLabel;//可提现余额
Strong UIView *amountBgView;//背景色
Strong UITextField *amountTextField;//输入框
Strong GradientButton *getCashBtn;//
Strong UILabel *desLabel;//进入第三方提现
Strong UIButton *historyBtn;//提现明细
Strong UIButton *remindTitle;
Strong UITextView *remindTextView;//温馨提示
@end

@implementation GetCashController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"提现";
    [self initSubViews];
    
    [self loadTextView];
    // Do any additional setup after loading the view.
}
#pragma mark lazyLoading--
-(void)initSubViews{
    
    [self.view addSubview:self.topView];
    
    [self.topView addSubview:self.amountTitle];
    
    [self.topView addSubview:self.amountLabel];
    
    [self.topView addSubview:self.amountBgView];
    
    [self.amountBgView addSubview:self.amountTextField];
    
    [self.topView addSubview:self.getCashBtn];
    
    [self.topView addSubview:self.desLabel];
    
    [self.topView addSubview:self.historyBtn];
    
    [self.view addSubview:self.remindTitle];
    
    [self.view addSubview:self.remindTextView];
    
    [self loadLayout];
    
    [self.topView layoutIfNeeded];
    
    [self.getCashBtn setGradientColors:@[COLOR_DarkBlue,COLOR_LightBlue]];

}
-(UIView *)topView{
    if (!_topView) {
        _topView = InitObject(UIView);
        _topView.backgroundColor = COLOR_White;
    }
    return _topView;
}
-(UILabel *)amountTitle{
    if (!_amountTitle) {
        _amountTitle = InitObject(UILabel);
        _amountTitle.textAlignment = NSTextAlignmentCenter;
        _amountTitle.textColor = COLOR_Btn_Unsel;
        _amountTitle.font = SYSTEMSIZE(30);
        _amountTitle.text = @"可提现金额（元）";
    }
    return _amountTitle;
}
-(UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = InitObject(UILabel);
        _amountLabel.text = @"5698.00";
        _amountLabel.textColor = COLOR_DarkBlue;
        _amountLabel.font = NUMBER_FONT_BOLD(46);
        _amountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _amountLabel;
}
-(UIView *)amountBgView{
    if (!_amountBgView) {
        _amountBgView =  InitObject(UIView);
        _amountBgView.backgroundColor = COLOR_Background;
        _amountBgView.layer.cornerRadius = kSizeFrom750(105)/2;
        _amountBgView.layer.borderWidth = kLineHeight;
        _amountBgView.layer.masksToBounds = YES;
        _amountBgView.layer.borderColor = [RGB(220, 220, 220) CGColor];
    }
    return _amountBgView;
}
-(UITextField *)amountTextField{
    if (!_amountTextField) {
        _amountTextField = InitObject(UITextField);
        _amountTextField.placeholder = @"请输入充值金额";
        [_amountTextField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventValueChanged];
        _amountTextField.delegate = self;
        _amountTextField.font = NUMBER_FONT(30);
    }
    return _amountTextField;
}
-(GradientButton *)getCashBtn{
    if (!_getCashBtn) {
        _getCashBtn = InitObject(GradientButton);
        [_getCashBtn setTitleColor:COLOR_White forState:UIControlStateNormal];
        [_getCashBtn addTarget:self action:@selector(withDrowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_getCashBtn.titleLabel setFont:SYSTEMSIZE(36)];
        [_getCashBtn setTitle:@"确认提现" forState:UIControlStateNormal];
        _getCashBtn.layer.cornerRadius = kSizeFrom750(105)/2;
        _getCashBtn.layer.masksToBounds = YES;

    }
    return _getCashBtn;
}
-(UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = InitObject(UILabel);
        [_desLabel setTextColor:RGB_166];
        [_desLabel setText:@"即将进入第三方支付页面"];
        _desLabel.font = SYSTEMSIZE(28);
    }
    return _desLabel;
}
-(UIButton *)historyBtn{
    if (!_historyBtn) {
        _historyBtn = InitObject(UIButton);
        _historyBtn.titleLabel.font = SYSTEMSIZE(28);
        [_historyBtn addTarget:self action:@selector(historyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_historyBtn setTitle:@"提现明细" forState:UIControlStateNormal];
        [_historyBtn setTitleColor:COLOR_Red forState:UIControlStateNormal];
    }
    return _historyBtn;
}
-(UIButton *)remindTitle
{
    if (!_remindTitle) {
        _remindTitle = InitObject(UIButton);
        [_remindTitle setTitle:@"温馨提示" forState:UIControlStateNormal];
        [_remindTitle.titleLabel setFont:SYSTEMSIZE(26)];
        [_remindTitle setTitleColor:RGB_51 forState:UIControlStateNormal];
        [_remindTitle setImage:IMAGEBYENAME(@"home_club") forState:UIControlStateNormal];
        [_remindTitle setTitleEdgeInsets:UIEdgeInsetsMake(0, -kSizeFrom750(20), 0, 0)];
        [_remindTitle setImageEdgeInsets:UIEdgeInsetsMake(0, -(kSizeFrom750(180) - kSizeFrom750(30) - kSizeFrom750(100)), 0, 0)];
    }
    return _remindTitle;
}
-(UITextView *)remindTextView
{
    if (!_remindTextView) {
        _remindTextView = InitObject(UITextView);
        _remindTextView.delegate = self;
        _remindTextView.editable = NO;
        _remindTextView.selectable = YES;
        _remindTextView.scrollEnabled = NO;
        _remindTextView.dataDetectorTypes = UIDataDetectorTypeLink;
        _remindTextView.font = SYSTEMSIZE(22);
        _remindTextView.backgroundColor = [UIColor clearColor];
    }
    return _remindTextView;
}
#pragma masonry
-(void)loadLayout
{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHight);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(screen_width);
        make.height.mas_equalTo(kSizeFrom750(572));
    }];
    [self.amountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kSizeFrom750(65));
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(screen_width);
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.amountTitle.mas_bottom).offset(kSizeFrom750(20));
        make.left.width.mas_equalTo(self.amountTitle);
        make.height.mas_equalTo(kSizeFrom750(50));
    }];
    [self.amountBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.amountLabel.mas_bottom).offset(kSizeFrom750(50));
        make.left.mas_equalTo(kOriginLeft);
        make.width.mas_equalTo(kSizeFrom750(690));
        make.height.mas_equalTo(kSizeFrom750(105));
    }];
    [self.amountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kSizeFrom750(40));
        make.top.mas_equalTo(kSizeFrom750(32.5));
        make.left.mas_equalTo(kOriginLeft);
        make.width.mas_equalTo(kSizeFrom750(600));
    }];
    [self.getCashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.amountBgView.mas_bottom).offset(kSizeFrom750(42));
        make.left.width.height.mas_equalTo(self.amountBgView);
    }];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.getCashBtn);
        make.width.mas_equalTo(kSizeFrom750(500));
        make.top.mas_equalTo(self.getCashBtn.mas_bottom).offset(kSizeFrom750(30));
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    [self.historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.getCashBtn);
        make.width.mas_equalTo(kSizeFrom750(120));
        make.top.height.mas_equalTo(self.desLabel);
    }];
    
    [self.remindTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(kSizeFrom750(30));
        make.width.mas_equalTo(kSizeFrom750(180));
        make.height.mas_equalTo(kSizeFrom750(35));
    }];
    
    [self.remindTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.remindTitle);
        make.top.mas_equalTo(self.remindTitle.mas_bottom).offset(kSizeFrom750(20));
        make.width.mas_equalTo(kSizeFrom750(690));
    }];
}
#pragma textField delegate
-(void)textFieldDidChanged:(UITextField *)textField
{
    
}
#pragma mark --buttonClick
//提现
-(void)withDrowBtnClick:(UIButton *)sender{
    
}
//充值限制
-(void)limitDesBtnClick:(UIButton *)sender{
    
}
//充值记录
-(void)historyBtnClick:(UIButton *)sender{
    GetCashRecordController *withDrow = InitObject(GetCashRecordController);
    [self.navigationController pushViewController:withDrow animated:YES];
}
-(void)loadTextView{
    
    NSString *str = @"1、提取收费：手续费暂由土土金服平台垫付；\n2、资金账户由第三方支付平台汇付天下全程托管，充分保障资金安全；\n3、单日的充值金额限额以各银行为准；\n5、只能绑定一张银行卡用户快捷充值，网银充值不限。";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];

    [attr addAttribute:NSForegroundColorAttributeName value:RGB_166 range:NSMakeRange(0, str.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:kSizeFrom750(15)];
    [paragraphStyle setHeadIndent:kSizeFrom750(35)];
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];//设置行间距
    [self.remindTextView setAttributedText:attr];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
