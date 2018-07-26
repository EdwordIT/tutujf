//
//  LoginViewController.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/13.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "LoginViewController.h"
#import "UITextField+Shake.h"
#import "AppDelegate.h"
#import "HomeWebController.h"
#import "AutoLoginView.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>
Strong UIScrollView *backScrollView;
/**抬头*/
Strong UIImageView *titleImgView;
//账号
Strong UITextField *mobileTextField;
//密码
Strong UITextField *passwordTextField;
//登录按钮
Strong UIButton *loginBtn;
//注册按钮
Strong UIButton *registerBtn;
//忘记密码
Strong UIButton *forgetPdwBtn;


Strong UIButton *pwdBtn;//切换是否明文显示

@end

@implementation LoginViewController
{
    
    NSMutableURLRequest *request ;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self exitLoginStatus];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleString = @"登录";
    [self.backBtn setImage:IMAGEBYENAME(@"icons_close") forState:UIControlStateNormal];
    self.titleView.backgroundColor = [UIColor clearColor];
    [self initSubViews];
    [self makeViewConstraints];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.mobileTextField becomeFirstResponder];
}
-(void)backPressed:(UIButton *)sender{

    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark --lazyLoading
-(UIScrollView *)backScrollView{
    if (!_backScrollView) {
        _backScrollView = InitObject(UIScrollView);
        _backScrollView.bounces = NO;
    }
    return _backScrollView;
}
-(UIImageView *)titleImgView{
    if (!_titleImgView) {
        _titleImgView = InitObject(UIImageView);
        [_titleImgView setImage:IMAGEBYENAME(@"login_title")];
    }
    return _titleImgView;
}
-(UITextField*)mobileTextField{
    if (!_mobileTextField) {
        _mobileTextField = InitObject(UITextField);
        _mobileTextField.placeholder = @"请输入手机号码/邮箱";
        _mobileTextField.font = SYSTEMSIZE(28);
        if ([TTJFUserDefault strForKey:kUsername]!=nil) {
            _mobileTextField.text = [TTJFUserDefault strForKey:kUsername];
        }
        [_mobileTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _mobileTextField.delegate = self;
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, kSizeFrom750(90), kSizeFrom750(625), kLineHeight);
        layer.backgroundColor = [RGB(229, 230, 231) CGColor];
        [_mobileTextField.layer addSublayer:layer];
    }
    return _mobileTextField;
}
-(UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = InitObject(UITextField);
        _passwordTextField.placeholder = @"请输入登录密码";
        _passwordTextField.font = SYSTEMSIZE(28);
        _passwordTextField.delegate = self;
        _passwordTextField.secureTextEntry = YES;
        [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, kSizeFrom750(90), kSizeFrom750(625), kLineHeight);
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
-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = InitObject(UIButton);
        _loginBtn.adjustsImageWhenHighlighted = NO;
        [_loginBtn setBackgroundColor:RGB(200,226,242)];
        _loginBtn.userInteractionEnabled = NO;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn.titleLabel setFont:SYSTEMBOLDSIZE(36)];
        [_loginBtn addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.layer.cornerRadius = kSizeFrom750(88)/2;
        _loginBtn.layer.masksToBounds = YES;

        
    }
    return _loginBtn;
}
-(UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = InitObject(UIButton);
        _loginBtn.adjustsImageWhenHighlighted = NO;
        [_registerBtn setTitle:@"注册领取688元红包" forState:UIControlStateNormal];
        [_registerBtn setImage:IMAGEBYENAME(@"redevenlope") forState:UIControlStateNormal];
        [_registerBtn setImage:IMAGEBYENAME(@"redevenlope") forState:UIControlStateHighlighted];
        _registerBtn.layer.borderColor = [RGB(255, 46, 19) CGColor];;
        _registerBtn.layer.borderWidth = 1;
        _registerBtn.layer.cornerRadius = kSizeFrom750(88)/2;
        [_registerBtn setTitleColor:RGB(255, 46, 19) forState:UIControlStateNormal];
        [_registerBtn.titleLabel setFont:SYSTEMSIZE(28)];
        [_registerBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -kSizeFrom750(20), 0, 0)];
        [_registerBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -kSizeFrom750(20))];
        [_registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}
-(UIButton *)forgetPdwBtn{
    if (!_forgetPdwBtn) {
        _forgetPdwBtn = InitObject(UIButton);
        _forgetPdwBtn.adjustsImageWhenHighlighted =  NO;
        [_forgetPdwBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [_forgetPdwBtn setTitleColor:RGB_166 forState:UIControlStateNormal];
        [_forgetPdwBtn.titleLabel setFont:SYSTEMSIZE(28)];
        [_forgetPdwBtn addTarget:self action:@selector(forgotPwdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPdwBtn;
}
-(void)initSubViews{
    
    
    [self.view addSubview:self.backScrollView];
    
    [self.backScrollView addSubview:self.titleImgView];
    
    [self.backScrollView addSubview:self.mobileTextField];
    
    [self.backScrollView addSubview:self.passwordTextField];
    
    [self.backScrollView addSubview:self.loginBtn];
    
    [self.backScrollView addSubview:self.registerBtn];
    
    [self.backScrollView addSubview:self.forgetPdwBtn];
    
    [self.backScrollView addSubview:self.pwdBtn];//是否明文显示
    
    [self.view bringSubviewToFront:self.titleView];
}
-(void)makeViewConstraints
{

    
    [self.backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.titleImgView);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view);
    }];
    
    [self.titleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(screen_width);
        make.height.mas_equalTo(kSizeFrom750(453));
    }];
    
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSizeFrom750(625));
        make.height.mas_equalTo(kSizeFrom750(90));
        make.centerX.mas_equalTo(self.backScrollView);
        make.top.mas_equalTo(self.titleImgView.mas_bottom).offset(kSizeFrom750(60));
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.height.mas_equalTo(self.mobileTextField);
        make.top.mas_equalTo(self.mobileTextField.mas_bottom).offset(kSizeFrom750(60));
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).offset(kSizeFrom750(95));
        make.width.mas_equalTo(kSizeFrom750(625));
        make.height.mas_equalTo(kSizeFrom750(88));
        make.centerX.mas_equalTo(self.passwordTextField);
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(kSizeFrom750(60));
        make.width.height.centerX.mas_equalTo(self.loginBtn);
    }];
    
    [self.forgetPdwBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSizeFrom750(170));
        make.height.mas_equalTo(kSizeFrom750(60));
        make.top.mas_equalTo(self.registerBtn.mas_bottom).offset(kSizeFrom750(180));
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.pwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.passwordTextField);
        make.right.mas_equalTo(self.passwordTextField.mas_right);
        make.width.height.mas_equalTo(kSizeFrom750(60));
    }];
    
    [self.backScrollView layoutIfNeeded];
    
    self.backScrollView.contentSize = CGSizeMake(screen_width, self.forgetPdwBtn.bottom+kSizeFrom750(30));
}
#pragma mark --textfieldDelegate

-(void)textFieldDidChange :(UITextField *)textField{
   
    if(_mobileTextField.text.length>3&&_passwordTextField.text.length >5)
    {
        [_loginBtn setBackgroundImage:IMAGEBYENAME(@"loginBtn") forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:[UIColor clearColor]];
        _loginBtn.userInteractionEnabled = YES;

    }
    else
    {
        _loginBtn.userInteractionEnabled = NO;
        [_loginBtn setBackgroundColor:RGB(200,226,242)];
        [_loginBtn setBackgroundImage:IMAGEBYENAME(@"") forState:UIControlStateNormal];

    }
    
    if (textField.text.length > 20) {
        //限制输入长度为20
        textField.text = [textField.text substringToIndex:20];
    }
}
#pragma mark --loginMethod
-(void)pwdBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.passwordTextField.secureTextEntry = !sender.selected;
}
//登录点击事件
-(void)loginButtonClick:(UIButton *)button
{

    if (![CommonUtils checkPassword:_passwordTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"密码格式不正确"];
        [_passwordTextField shake];
        return;
    }
    //登录老用户的用户名可能是纯数字或者纯字母
    if (_mobileTextField.text.length>2)
    {
        [self getLogin];
    }
}
//登录
-(void) getLogin{
    
    [SVProgressHUD showWithStatus:@"正在登录..."];
    //默认登录webView
    AutoLoginView *loginView = [[AutoLoginView alloc]init];
    [self.view addSubview:loginView];
    [loginView getLogin:self.mobileTextField.text password:self.passwordTextField.text];
    
    loginView.autoLoginBlock = ^{
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                [self dismissViewControllerAnimated:YES completion:NULL];
            });
        });
    };
}

//注册按钮点击事件
-(void)registerBtnClick:(UIButton *)button
{
    RegisterViewController *regist = InitObject(RegisterViewController);
    [self.navigationController pushViewController:regist animated:YES];
    
}
//忘记密码点击事件
-(void)forgotPwdBtnClick:(UIButton *)button
{
    ForgetPasswordViewController *forget = InitObject(ForgetPasswordViewController);
    [self.navigationController pushViewController:forget animated:YES];
    
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
