//
//  RegisterViewController.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/19.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
Strong UITextField * mobileTextField;
Strong UITextField *passwordTextField;
Strong UIButton *codeBtn;//获取验证码按钮
Strong NSTimer * codeTime;//计时器
Assign NSInteger countDownNum;//倒计时数字
Strong UITextField *codeTextField;//验证码输入框
Strong UIButton *pwdBtn;//切换明文密文
Strong UIButton *registerBtn;//完成注册
Strong UILabel *remindLabel;//
Strong UIButton *dealBtn;//协议
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"手机号码快速注册";
    [self initSubViews];
    // Do any additional setup after loading the view.
}
-(UITextField*)mobileTextField{
    if (!_mobileTextField) {
        _mobileTextField = InitObject(UITextField);
        _mobileTextField.placeholder = @"请输入手机号码";
        [_mobileTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _mobileTextField.keyboardType = UIKeyboardTypePhonePad;
        _mobileTextField.delegate = self;
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, kSizeFrom750(90), kSizeFrom750(625), 1);
        layer.backgroundColor = [RGB(229, 230, 231) CGColor];
        [_mobileTextField.layer addSublayer:layer];
    }
    return _mobileTextField;
}
-(UITextField*)codeTextField{
    if (!_codeTextField) {
        _codeTextField = InitObject(UITextField);
        _codeTextField.placeholder = @"请输入验证码";
        [_codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _codeTextField.keyboardType = UIKeyboardTypePhonePad;
        _codeTextField.delegate = self;
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, kSizeFrom750(90), kSizeFrom750(625), 1);
        layer.backgroundColor = [RGB(229, 230, 231) CGColor];
        [_codeTextField.layer addSublayer:layer];
    }
    return _codeTextField;
}
-(UIButton *)codeBtn{
    if (!_codeBtn) {
        _codeBtn = InitObject(UIButton);
        _codeBtn.backgroundColor = [UIColor clearColor];
        _codeBtn.titleLabel.font = SYSTEMSIZE(32);
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:RGB(3, 147, 247) forState:UIControlStateNormal];
        [_codeBtn addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        _codeBtn.layer.cornerRadius = kSizeFrom750(32)/2;
//        _codeBtn.layer.masksToBounds = YES;
//        _codeBtn.layer.borderWidth = kSizeFrom750(1);
//        _codeBtn.layer.borderColor = RGB(3, 147, 247).CGColor;
    }
    return _codeBtn;
    
}
-(UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = InitObject(UITextField);
        _passwordTextField.placeholder = @"请设置6-15位登录密码";
        _passwordTextField.delegate = self;
        _passwordTextField.secureTextEntry = YES;
        [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, kSizeFrom750(90), kSizeFrom750(625), 1);
        layer.backgroundColor = [RGB(229, 230, 231) CGColor];
        [_passwordTextField.layer addSublayer:layer];
        
    }
    return _passwordTextField;
}
-(UIButton *)pwdBtn{
    if (!_pwdBtn) {
        _pwdBtn = InitObject(UIButton);
        [_pwdBtn setImage:IMAGEBYENAME(@"eye_close") forState:UIControlStateNormal];
        [_pwdBtn setImage:IMAGEBYENAME(@"eye_open") forState:UIControlStateSelected];
        [_pwdBtn addTarget:self action:@selector(pwdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _pwdBtn;
}
-(UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = InitObject(UIButton);
        _registerBtn.adjustsImageWhenHighlighted = NO;
        [_registerBtn setBackgroundImage:IMAGEBYENAME(@"loginBtn") forState:UIControlStateNormal];
        [_registerBtn setTitle:@"完成注册" forState:UIControlStateNormal];
        [_registerBtn.titleLabel setFont:SYSTEMBOLDSIZE(32)];
        [_registerBtn addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _registerBtn.layer.cornerRadius = kSizeFrom750(88)/2;
        _registerBtn.layer.masksToBounds = YES;
        
        
    }
    return _registerBtn;
}
-(UILabel *)remindLabel{
    if (!_remindLabel) {
        _remindLabel = InitObject(UILabel);
        _remindLabel.textColor = RGB_153;
        _remindLabel.font = SYSTEMSIZE(28);
        _remindLabel.text = @"注册即表示您同意";
        _remindLabel.textAlignment = NSTextAlignmentRight;
    }
    return _remindLabel;
}
-(UIButton *)dealBtn{
    if (!_dealBtn) {
        _dealBtn = InitObject(UIButton);
        [_dealBtn setTitle:@"“土土金服用户协议”" forState:UIControlStateNormal];
        _dealBtn.showsTouchWhenHighlighted = NO;
        [_dealBtn.titleLabel setFont:SYSTEMSIZE(28)];
        [_dealBtn setTitleColor:RGB(66, 179, 246) forState:UIControlStateNormal];
        [_dealBtn addTarget:self action:@selector(dealBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _dealBtn;
}
-(void)initSubViews{
    
    if (_isRootVC) {
        [self.backBtn setImage:IMAGEBYENAME(@"close_white") forState:UIControlStateNormal];
    }
    
    [self.view addSubview:self.mobileTextField];
    
    [self.view addSubview:self.codeTextField];//验证码
    
    [self.codeTextField addSubview:self.codeBtn];//验证码获取按钮
    
    [self.view addSubview:self.passwordTextField];
        
    [self.view addSubview:self.registerBtn];
    
    [self.view addSubview:self.pwdBtn];//是否明文显示
    
    [self.view addSubview:self.remindLabel];
    
    [self.view addSubview:self.dealBtn];
    
    [self.view bringSubviewToFront:self.titleView];
    
    [self makeViewConstraints];
    
}
-(void)makeViewConstraints
{
   
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSizeFrom750(625));
        make.height.mas_equalTo(kSizeFrom750(90));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.titleView.mas_bottom).offset(kSizeFrom750(250));
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(self.mobileTextField);
        make.width.mas_equalTo(kSizeFrom750(450));
        make.top.mas_equalTo(self.mobileTextField.mas_bottom).offset(kSizeFrom750(60));
    }];
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSizeFrom750(160));
        make.centerY.mas_equalTo(self.codeTextField);
        make.height.mas_equalTo(kSizeFrom750(32));
        make.left.mas_equalTo(self.codeTextField.mas_right);
        
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.height.mas_equalTo(self.mobileTextField);
        make.top.mas_equalTo(self.codeTextField.mas_bottom).offset(kSizeFrom750(60));
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).offset(kSizeFrom750(100));
        make.width.mas_equalTo(kSizeFrom750(625));
        make.height.mas_equalTo(kSizeFrom750(88));
        make.centerX.mas_equalTo(self.passwordTextField);
    }];

    
    [self.pwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.passwordTextField);
        make.right.mas_equalTo(self.passwordTextField.mas_right);
        make.width.height.mas_equalTo(kSizeFrom750(60));
    }];
    
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSizeFrom750(354));
        make.height.mas_equalTo(kSizeFrom750(30));
        make.top.mas_equalTo(self.registerBtn.mas_bottom).offset(kSizeFrom750(55));
    }];
    [self.dealBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.remindLabel.mas_right);
        make.top.height.mas_equalTo(self.remindLabel);
        make.width.mas_equalTo(kSizeFrom750(280));
    }];
    
    
}
#pragma mark --textfieldDelegate
-(void)backPressed:(UIButton *)sender{
    if (_isRootVC) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
}
#pragma mark --registerMethod
-(void)codeBtnClick:(UIButton *)sender{
    if ([CommonUtils checkTelNumber:self.mobileTextField.text]) {
        //发送验证码
        self.codeTime = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            self.countDownNum --;
            NSString * num = [NSString stringWithFormat:@"%lds",self.countDownNum];
            [self.codeBtn setTitle:num forState:UIControlStateNormal];
            if (self.countDownNum == 0)
            {
                [self.codeTime invalidate];
                self.countDownNum = 60;
                [self.codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = YES;
            }
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确"];
    }
    
}
-(void)dealBtnClick:(UIButton *)sender{
    
    
}
//注册按钮点击
-(void)registerButtonClick:(UIButton *)sender{
    NSString *mobile = self.mobileTextField.text;
    NSString *code = self.codeTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (![CommonUtils checkTelNumber:mobile]) {
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确"];
        return;
    }
    
    if (![CommonUtils checkPassword:password]) {
        [SVProgressHUD showErrorWithStatus:@"密码为6~15位数字和字母的组合"];
        return;
    }
    if (code.length<4) {
        [SVProgressHUD showErrorWithStatus:@"验证码错误"];
        return;
    }
    
    
    
}
-(void)pwdBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.passwordTextField.secureTextEntry = !sender.selected;
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
