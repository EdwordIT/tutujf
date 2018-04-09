//
//  ForgetPasswordViewController.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/24.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController ()<UITextFieldDelegate>
Strong UIImageView *topImageView;//
Strong UITextField * mobileTextField;
Strong UITextField *passwordTextField;
Strong UIButton *codeBtn;//获取验证码按钮
Strong NSTimer * codeTime;//计时器
Assign NSInteger countDownNum;//倒计时数字
Strong UITextField *codeTextField;//验证码输入框
Strong UIButton *pwdBtn;//切换明文密文
Strong UIButton *completeBtn;//完成注册

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"密码找回";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubViews];
    // Do any additional setup after loading the view.
}
-(UIImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView = InitObject(UIImageView);
        [_topImageView setImage:IMAGEBYENAME(@"logo")];
    }
    return _topImageView;
}
-(UITextField*)mobileTextField{
    if (!_mobileTextField) {
        _mobileTextField = InitObject(UITextField);
        _mobileTextField.placeholder = @"请输入手机号码";
        _mobileTextField.keyboardType = UIKeyboardTypePhonePad;
        _mobileTextField.delegate = self;
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, kSizeFrom750(90), kSizeFrom750(625), kLineHeight);
        layer.backgroundColor = [RGB(229, 230, 231) CGColor];
        [_mobileTextField.layer addSublayer:layer];
        _mobileTextField.leftViewMode = UITextFieldViewModeAlways;
        UIButton *phoneImage = [[UIButton alloc] initWithFrame:CGRectMake(kSizeFrom750(0), 0,kSizeFrom750(100), kSizeFrom750(80))];
        phoneImage.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [phoneImage setImage:[UIImage imageNamed:@"mobile"] forState:UIControlStateNormal];
        _mobileTextField.leftView = phoneImage;
        
    }
    return _mobileTextField;
}
-(UITextField*)codeTextField{
    if (!_codeTextField) {
        _codeTextField = InitObject(UITextField);
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.delegate = self;
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, kSizeFrom750(90), kSizeFrom750(625), kLineHeight);
        layer.backgroundColor = [RGB(229, 230, 231) CGColor];
        [_codeTextField.layer addSublayer:layer];
        _codeTextField.leftViewMode = UITextFieldViewModeAlways;
        
        
        UIButton *phoneImage = [[UIButton alloc] initWithFrame:CGRectMake(kSizeFrom750(0), 0,kSizeFrom750(100), kSizeFrom750(80))];
        phoneImage.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [phoneImage setImage:[UIImage imageNamed:@"mobile_code"] forState:UIControlStateNormal];
        _codeTextField.leftView = phoneImage;
    }
    return _codeTextField;
}
-(UIButton *)codeBtn{
    if (!_codeBtn) {
        _codeBtn = InitObject(UIButton);
        _codeBtn.backgroundColor = [UIColor clearColor];
        _codeBtn.titleLabel.font = SYSTEMSIZE(30);
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:RGB(3, 147, 247) forState:UIControlStateNormal];
        [_codeBtn addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _codeBtn;
    
}
-(UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = InitObject(UITextField);
        _passwordTextField.placeholder = @"请设置6-15位登录密码";
        _passwordTextField.delegate = self;
        _passwordTextField.secureTextEntry = YES;
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, kSizeFrom750(90), kSizeFrom750(625), kLineHeight);
        layer.backgroundColor = [RGB(229, 230, 231) CGColor];
        [_passwordTextField.layer addSublayer:layer];
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIButton *phoneImage = [[UIButton alloc] initWithFrame:CGRectMake(kSizeFrom750(0), 0,kSizeFrom750(100), kSizeFrom750(80))];
        phoneImage.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [phoneImage setImage:[UIImage imageNamed:@"password_lock"] forState:UIControlStateNormal];
        _passwordTextField.leftView = phoneImage;
        
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
-(UIButton *)completeBtn{
    if (!_completeBtn) {
        _completeBtn = InitObject(UIButton);
        _completeBtn.adjustsImageWhenHighlighted = NO;
        [_completeBtn setBackgroundImage:IMAGEBYENAME(@"loginBtn") forState:UIControlStateNormal];
        [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_completeBtn.titleLabel setFont:SYSTEMBOLDSIZE(36)];
        [_completeBtn addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _completeBtn.layer.cornerRadius = kSizeFrom750(100)/2;
        _completeBtn.layer.masksToBounds = YES;
        
        
    }
    return _completeBtn;
}

-(void)initSubViews{
    
    self.countDownNum = 60;
    
    [self.view addSubview:self.topImageView];
    
    [self.view addSubview:self.mobileTextField];
    
    [self.view addSubview:self.codeTextField];//验证码
    
    [self.view addSubview:self.codeBtn];//验证码获取按钮
    
    [self.view addSubview:self.passwordTextField];
    
    [self.view addSubview:self.completeBtn];
    
    [self.view addSubview:self.pwdBtn];//是否明文显示
 
    [self.view bringSubviewToFront:self.titleView];
    
    [self makeViewConstraints];
    
}
-(void)makeViewConstraints
{
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSizeFrom750(232));
        make.height.mas_equalTo(kSizeFrom750(232));
        make.top.mas_equalTo(kNavHight+kSizeFrom750(75));
        make.centerX.mas_equalTo(self.view);
    }];
    
    
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSizeFrom750(625));
        make.height.mas_equalTo(kSizeFrom750(90));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.topImageView.mas_bottom).offset(kSizeFrom750(80));
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(self.mobileTextField);
        make.width.mas_equalTo(kSizeFrom750(450));
        make.top.mas_equalTo(self.mobileTextField.mas_bottom).offset(kSizeFrom750(60));
    }];
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSizeFrom750(160));
        make.centerY.mas_equalTo(self.codeTextField);
        make.height.mas_equalTo(kSizeFrom750(50));
        make.left.mas_equalTo(self.codeTextField.mas_right);
        
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.height.mas_equalTo(self.mobileTextField);
        make.top.mas_equalTo(self.codeTextField.mas_bottom).offset(kSizeFrom750(60));
    }];
    
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).offset(kSizeFrom750(100));
        make.width.mas_equalTo(kSizeFrom750(625));
        make.height.mas_equalTo(kSizeFrom750(100));
        make.centerX.mas_equalTo(self.passwordTextField);
    }];
    
    
    [self.pwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.passwordTextField);
        make.right.mas_equalTo(self.passwordTextField.mas_right);
        make.width.height.mas_equalTo(kSizeFrom750(60));
    }];
   
}
#pragma mark --textfieldDelegate

#pragma mark --registerMethod
-(void)codeBtnClick:(UIButton *)sender{
    if ([CommonUtils checkTelNumber:self.mobileTextField.text]) {
        //发送验证码
        
        NSString *phone = self.mobileTextField.text;
        NSString *type = @"resetpwd";
        NSString *time_stamp = [CommonUtils getCurrentTimestamp];
        
        
        NSArray *keys = @[@"phone",@"type",@"time_stamp"];
        NSArray *values = @[phone,type,time_stamp];
        [[HttpCommunication sharedInstance] getSignRequestWithPath:getMessageCodeUrl keysArray:keys valuesArray:values refresh:nil success:^(NSDictionary *successDic) {
            [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
            self.codeBtn.userInteractionEnabled = NO;
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
        } failure:^(NSDictionary *errorDic) {
            
        }];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确"];
    }
    
}
//找回密码按钮点击
-(void)registerButtonClick:(UIButton *)sender{
    NSString *phone = self.mobileTextField.text;
    NSString *sms_code = self.codeTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *referrer = @"";
    if (![CommonUtils checkTelNumber:phone]) {
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确"];
        return;
    }
    
    if (![CommonUtils checkPassword:password]) {
        [SVProgressHUD showErrorWithStatus:@"密码为6~15位数字和字母的组合"];
        return;
    }
    if (sms_code.length!=6) {
        [SVProgressHUD showErrorWithStatus:@"验证码错误"];
        return;
    }
    
    NSArray *keys = @[@"phone",@"sms_code",@"password",@"referrer"];
    NSArray *values = @[phone,sms_code,password,referrer];

    [[HttpCommunication sharedInstance] getSignRequestWithPath:forgetPasswordUrl keysArray:keys valuesArray:values refresh:nil success:^(NSDictionary *successDic) {
        [self exitLoginStatus];
        //如果从其他页面跳转进来，如web，则需要返回首页然后弹出登录框
        if (self.isBackToRootVC) {
            [self goLoginVC];
            
            [self.navigationController popToRootViewControllerAnimated:NO];

        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSDictionary *errorDic) {
        
    }];
    
    
    
    
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
