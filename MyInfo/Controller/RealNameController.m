//
//  RealNameController.m
//  TTJF
//
//  Created by wbzhan on 2018/4/25.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "RealNameController.h"
#import "GradientButton.h"
@interface RealNameController ()<UITextFieldDelegate>
Strong UIImageView *remindImage;
Strong UILabel *remindLabel;
Strong UIView *contentView;//中间内容
Strong GradientButton *certificationBtn;//实名认证按钮
Strong UILabel *messageLabel;
@end

@implementation RealNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"实名认证";
    [self initSubViews];
    // Do any additional setup after loading the view.
}
-(void)initSubViews
{
    
    [self.view addSubview:self.remindImage];
    
    [self.view addSubview:self.remindLabel];
    
    [self.view addSubview:self.contentView];
    
    [self.view addSubview:self.certificationBtn];
    
    [self.view addSubview:self.messageLabel];
    
    [self loadLayout];
    
    [self.view layoutIfNeeded];
    
    [self.certificationBtn setGradientColors:@[COLOR_DarkBlue,COLOR_LightBlue]];
    
    [self loadInfo];
}
#pragma mark --lazyLoading
-(UIImageView *)remindImage{
    if (!_remindImage) {
        _remindImage = InitObject(UIImageView);
    }
    return _remindImage;
}
-(UILabel *)remindLabel{
    if (!_remindLabel) {
        _remindLabel = InitObject(UILabel);
        _remindLabel.textColor = RGB_166;
        _remindLabel.numberOfLines = 0;
        _remindLabel.font = SYSTEMSIZE(26);
    }
    return _remindLabel;
}
-(UIView *)contentView{
    if (!_contentView) {
        _contentView = InitObject(UIView);
        _contentView.backgroundColor = COLOR_White;
    }
    return _contentView;
}
-(GradientButton *)certificationBtn{
    if (!_certificationBtn) {
        _certificationBtn = InitObject(GradientButton);
        [_certificationBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_certificationBtn setTitleColor:COLOR_White forState:UIControlStateNormal];
        [_certificationBtn.titleLabel setFont:SYSTEMSIZE(32)];
        [_certificationBtn addTarget:self action:@selector(certificationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _certificationBtn.layer.cornerRadius = kSizeFrom750(40);
        _certificationBtn.layer.masksToBounds = YES;
    }
    return _certificationBtn;
}
-(UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = InitObject(UILabel);
        _messageLabel.textColor = RGB_166;
        _messageLabel.font = SYSTEMSIZE(26);
        _messageLabel.numberOfLines = 0;

    }
    return _messageLabel;
}
-(void)loadLayout
{
    [self.remindImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.top.mas_equalTo(kNavHight + kSizeFrom750(30));
        make.width.height.mas_equalTo(kSizeFrom750(30));
    }];
    
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.remindImage.mas_right).offset(kSizeFrom750(20));
        make.top.mas_equalTo(self.remindImage);
        make.width.mas_equalTo(kSizeFrom750(640));
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remindLabel.mas_bottom).offset(kSizeFrom750(30));
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(screen_width);
        make.height.mas_equalTo(kSizeFrom750(270));
    }];
    [self.certificationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.right.mas_equalTo(-kOriginLeft);
        make.top.mas_equalTo(self.contentView.mas_bottom).offset(kSizeFrom750(50));
        make.height.mas_equalTo(kSizeFrom750(80));
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.certificationBtn);
        make.top.mas_equalTo(self.certificationBtn.mas_bottom).offset(kSizeFrom750(20));
    }];
    
}
-(void)loadInfo
{
    NSString *remindText = @"根据国家监管要求，土土金服已经接入汇付资金存管系统。用户实名认证、绑定银行卡、投资、充值、提现，转让前需先开通汇付存管账户。";
    NSString *nextText = @"点击下一步后，您将跳转到<汇付资金存管系统>进行存管账户的开通";
    [CommonUtils setAttString:remindText withLineSpace:kLabelSpace titleLabel:self.remindLabel];
    [CommonUtils setAttString:nextText withLineSpace:kLabelSpace titleLabel:self.messageLabel];
    NSString *regText = @"您的资产由汇付支付托管系统全程监管";
    CGFloat ww=[regText length]*SYSTEMSIZE(25).lineHeight;
    UILabel * title= [[UILabel alloc] initWithFrame:CGRectMake((screen_width-ww)/2, screen_height - kSizeFrom750(80),ww,kSizeFrom750(30))];
    title.textAlignment=NSTextAlignmentCenter;
    title.textColor=RGB_166;
    title.font=SYSTEMSIZE(25);
    title.text=regText;
    [self.view addSubview:title];
    UIImageView *typeimgsrc= [[UIImageView alloc] initWithFrame:CGRectMake((screen_width-ww)/2-kSizeFrom750(50), 0,kSizeFrom750(35), kSizeFrom750(39))];
    typeimgsrc.centerY = title.centerY;
    [typeimgsrc setImage:[UIImage imageNamed:@"y.png"]];
    [self.view addSubview:typeimgsrc];
    
    NSArray *nameArr = @[@"真实姓名",@"证件类型",@"证件号码"];
    NSArray *placeholderArr = @[@"请输入您的真实姓名",@"",@"请输入您的身份证号码"];
    for (int i=0; i<3; i++) {
        UILabel *title = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, kOriginLeft+(kSizeFrom750(90)*i), kSizeFrom750(160), kSizeFrom750(30))];
        [title setFont:SYSTEMSIZE(30)];
        [title setTextColor:RGB_51];
        title.text = nameArr[i];
        [self.contentView addSubview:title];
        
        UITextField *textField = [[UITextField alloc]initWithFrame:RECT(title.right, title.top, kSizeFrom750(530), title.height)];
        textField.textColor = RGB_51;
        textField.placeholder = placeholderArr[i];
        textField.font = SYSTEMSIZE(30);
        textField.tag = i;
        [self.contentView addSubview:textField];
        textField.delegate = self;
        if (i==1) {
            textField.text = @"身份证";
            textField.userInteractionEnabled = NO;
        }
        if (i!=2) {
            UIView *line = [[UIView alloc]initWithFrame:RECT(title.left, kSizeFrom750(90)*(i+1), kContentWidth, kLineHeight)];
            line.backgroundColor = separaterColor;
            [self.contentView addSubview:line];
        }
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //真实姓名
    if (textField.tag==0) {
        
    }else{
        //身份证号
        if(![CommonUtils checkUserIdCard:textField.text]){
            [SVProgressHUD showInfoWithStatus:@"身份证号码错误"];
        }
    }
}
-(void)certificationBtnClick:(UIButton *)sender{
    //点击进行实名认证
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
