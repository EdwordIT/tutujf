//
//  RechargeController.m
//  TTJF
//
//  Created by wbzhan on 2018/4/24.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "RechargeController.h"

@interface RechargeController ()<UITextFieldDelegate,UITextViewDelegate>
Strong UIView *topView;//白色背景
Strong UILabel *amountTitle;
Strong UILabel *amountLabel;//可用余额
Strong UIView *amountBgView;//背景色
Strong UITextField *amountTextField;//输入框
Strong UIButton *rechargeBtn;//
Strong UIButton *limitDesBtn;//快捷充值限额说明
Strong UIButton *historyBtn;//充值记录
Strong UIButton *remindTitle;
Strong UITextView *remindTextView;//温馨提示
@end

@implementation RechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"充值";
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
    
    [self.topView addSubview:self.rechargeBtn];
    
    [self.topView addSubview:self.limitDesBtn];
    
    [self.topView addSubview:self.historyBtn];
    
    [self.view addSubview:self.remindTitle];
    
    [self.view addSubview:self.remindTextView];
    
    [self loadLayout];
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
        _amountTitle.text = @"可用余额（元）";
    }
    return _amountTitle;
}
-(UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = InitObject(UILabel);
        _amountLabel.text = @"5698.00";
        _amountLabel.textColor = COLOR_Red;
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
-(UIButton *)rechargeBtn{
    if (!_rechargeBtn) {
        _rechargeBtn = InitObject(UIButton);
        _rechargeBtn.backgroundColor = COLOR_Red;
        [_rechargeBtn setTitleColor:COLOR_White forState:UIControlStateNormal];
        [_rechargeBtn addTarget:self action:@selector(rechargeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_rechargeBtn.titleLabel setFont:SYSTEMSIZE(36)];
        _rechargeBtn.layer.cornerRadius = kSizeFrom750(105)/2;
        _rechargeBtn.layer.masksToBounds = YES;
        [_rechargeBtn setTitle:@"确认充值" forState:UIControlStateNormal];
    }
    return _rechargeBtn;
}
-(UIButton *)limitDesBtn
{
    if (!_limitDesBtn) {
        _limitDesBtn = InitObject(UIButton);
        [_limitDesBtn setTitleColor:COLOR_Red forState:UIControlStateNormal];
        [_limitDesBtn addTarget:self action:@selector(limitDesBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_limitDesBtn setTitle:@"快捷充值限额说明" forState:UIControlStateNormal];

        _limitDesBtn.titleLabel.font = SYSTEMSIZE(28);
    }
    return _limitDesBtn;
}
-(UIButton *)historyBtn{
    if (!_historyBtn) {
        _historyBtn = InitObject(UIButton);
        _historyBtn.titleLabel.font = SYSTEMSIZE(28);
        [_historyBtn addTarget:self action:@selector(historyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_historyBtn setTitle:@"充值记录" forState:UIControlStateNormal];
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
        [_remindTitle setImageEdgeInsets:UIEdgeInsetsMake(0, -(kSizeFrom750(150) - kSizeFrom750(30) - kSizeFrom750(100)), 0, 0)];
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
    [self.rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.amountBgView.mas_bottom).offset(kSizeFrom750(42));
        make.left.width.height.mas_equalTo(self.amountBgView);
    }];
    [self.limitDesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSizeFrom750(130));
        make.width.mas_equalTo(kSizeFrom750(300));
        make.top.mas_equalTo(self.rechargeBtn.mas_bottom).offset(kSizeFrom750(30));
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    UIView *lineView = InitObject(UIView);
    lineView.backgroundColor = COLOR_Red;
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.limitDesBtn.mas_right);
        make.top.height.mas_equalTo(self.limitDesBtn);
        make.width.mas_equalTo(kLineHeight);
        
    }];
    [self.historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineView.mas_right);
        make.width.mas_equalTo(kSizeFrom750(180));
        make.top.height.mas_equalTo(lineView);
    }];
    
    [self.remindTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(kSizeFrom750(30));
        make.width.mas_equalTo(kSizeFrom750(150));
        make.height.mas_equalTo(kSizeFrom750(35));
    }];
    
    [self.remindTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.remindTitle);
        make.top.mas_equalTo(self.remindTitle.mas_bottom).offset(kSizeFrom750(20));
        make.width.mas_equalTo(kSizeFrom750(690));
//        make.height.mas_equalTo(kSizeFrom750(100));
    }];
}
#pragma textField delegate
-(void)textFieldDidChanged:(UITextField *)textField
{
    
}
#pragma mark --buttonClick
//充值
-(void)rechargeBtnClick:(UIButton *)sender{
    
}
//充值限制
-(void)limitDesBtnClick:(UIButton *)sender{
    
}
//充值记录
-(void)historyBtnClick:(UIButton *)sender{
    
}
-(void)loadTextView{
    
    NSString *str = @"1、因国家政策，银行对外支付渠道的限制，有部分银行卡将会充值失败的用户，需开通银联无卡支付业务才能进行充值，目前尚未开通银联无卡支付业务的银行卡用户，点击查看银联开通步骤说明\n2、提取收费：手续费暂由土土金服平台垫付；\n3、资金账户由第三方支付平台汇付天下全程托管，充分保障资金安全；\n4、单日的充值金额限额以各银行为准；\n5、只能绑定一张银行卡用户快捷充值，网银充值不限。";
    NSString *matchStr = @"点击查看银联开通步骤说明";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    if ([str rangeOfString:matchStr].location!=NSNotFound) {
        [attr addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@""] range:[str rangeOfString:matchStr]];
    }
    [attr addAttribute:NSForegroundColorAttributeName value:RGB_166 range:NSMakeRange(0, str.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:COLOR_LightBlue range:[str rangeOfString:matchStr]];//设置颜色
    [attr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:[str rangeOfString:matchStr]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:kSizeFrom750(10)];
    [paragraphStyle setHeadIndent:kSizeFrom750(35)];
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];//设置行间距
    
    self.remindTextView.selectedRange = [str rangeOfString:matchStr];
    self.remindTextView.linkTextAttributes = @{NSUnderlineColorAttributeName: COLOR_LightBlue,
                                               NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)
                                               };
    [self.remindTextView setAttributedText:attr];
    
}
//超链接被点击
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    NSLog(@"click");
    return NO;
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
