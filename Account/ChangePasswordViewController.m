//
//  ChangePasswordViewController.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/28.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>
Strong UIScrollView *backScrollView;
Strong UIImageView *topImageView;//
Strong UITextField *oldPasswordTextField;//旧密码
Strong UITextField *passwordTextField;//新密码
Strong UITextField *insurePasswordTextField;//新密码

Strong UIButton *pwdBtn;//切换明文密文
Strong UIButton *pwdBtn1;//切换明文密文
Strong UIButton *pwdBtn2;//切换明文密文

Strong UIButton *completeBtn;//完成注册

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"密码修改";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubViews];
    // Do any additional setup after loading the view.
}
-(UIScrollView *)backScrollView{
    if (!_backScrollView) {
        _backScrollView = InitObject(UIScrollView);
        _backScrollView.showsVerticalScrollIndicator = NO;

    }
    return _backScrollView;
}
-(UIImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView = InitObject(UIImageView);
        [_topImageView setImage:IMAGEBYENAME(@"logo")];
    }
    return _topImageView;
}

-(UITextField *)oldPasswordTextField{
    if (!_oldPasswordTextField) {
        _oldPasswordTextField = InitObject(UITextField);
        _oldPasswordTextField.placeholder = @"请输入原密码";
        _oldPasswordTextField.font = SYSTEMSIZE(28);
        _oldPasswordTextField.delegate = self;
        _oldPasswordTextField.secureTextEntry = YES;
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, kSizeFrom750(90), kSizeFrom750(625), kLineHeight);
        layer.backgroundColor = [RGB(229, 230, 231) CGColor];
        [_oldPasswordTextField.layer addSublayer:layer];
        [_oldPasswordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        _oldPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    
        
    }
    return _oldPasswordTextField;
}
-(UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = InitObject(UITextField);
        _passwordTextField.placeholder = @"请输入新密码";
        _passwordTextField.delegate = self;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.font = SYSTEMSIZE(28);
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, kSizeFrom750(90), kSizeFrom750(625), kLineHeight);
        layer.backgroundColor = [RGB(229, 230, 231) CGColor];
        [_passwordTextField.layer addSublayer:layer];
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        
    }
    return _passwordTextField;
}
-(UITextField *)insurePasswordTextField{
    if (!_insurePasswordTextField) {
        _insurePasswordTextField = InitObject(UITextField);
        _insurePasswordTextField.placeholder = @"请确认新密码";
        _insurePasswordTextField.font = SYSTEMSIZE(28);
        _insurePasswordTextField.delegate = self;
        [_insurePasswordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        _insurePasswordTextField.secureTextEntry = YES;
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, kSizeFrom750(90), kSizeFrom750(625), kLineHeight);
        layer.backgroundColor = [RGB(229, 230, 231) CGColor];
        [_insurePasswordTextField.layer addSublayer:layer];
        _insurePasswordTextField.leftViewMode = UITextFieldViewModeAlways;
        
        
    }
    return _insurePasswordTextField;
}
-(UIButton *)pwdBtn{
    if (!_pwdBtn) {
        _pwdBtn = InitObject(UIButton);
        [_pwdBtn setImage:IMAGEBYENAME(@"eye_close") forState:UIControlStateNormal];
        [_pwdBtn setImage:IMAGEBYENAME(@"eye_open") forState:UIControlStateSelected];
        _pwdBtn.tag = 0;
        [_pwdBtn addTarget:self action:@selector(pwdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _pwdBtn;
}
-(UIButton *)pwdBtn1{
    if (!_pwdBtn1) {
        _pwdBtn1 = InitObject(UIButton);
        [_pwdBtn1 setImage:IMAGEBYENAME(@"eye_close") forState:UIControlStateNormal];
        [_pwdBtn1 setImage:IMAGEBYENAME(@"eye_open") forState:UIControlStateSelected];
        _pwdBtn1.tag = 1;

        [_pwdBtn1 addTarget:self action:@selector(pwdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _pwdBtn1;
}
-(UIButton *)pwdBtn2{
    if (!_pwdBtn2) {
        _pwdBtn2 = InitObject(UIButton);
        [_pwdBtn2 setImage:IMAGEBYENAME(@"eye_close") forState:UIControlStateNormal];
        [_pwdBtn2 setImage:IMAGEBYENAME(@"eye_open") forState:UIControlStateSelected];
        _pwdBtn2.tag = 2;
        [_pwdBtn2 addTarget:self action:@selector(pwdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _pwdBtn2;
}
-(UIButton *)completeBtn{
    if (!_completeBtn) {
        _completeBtn = InitObject(UIButton);
        _completeBtn.adjustsImageWhenHighlighted = NO;
        [_completeBtn setBackgroundImage:IMAGEBYENAME(@"loginBtn") forState:UIControlStateNormal];
        [_completeBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        [_completeBtn.titleLabel setFont:SYSTEMBOLDSIZE(36)];
        [_completeBtn addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _completeBtn.layer.cornerRadius = kSizeFrom750(100)/2;
        _completeBtn.layer.masksToBounds = YES;
        
        
    }
    return _completeBtn;
}

-(void)initSubViews{
    
    
    [self.view addSubview:self.backScrollView];
    
    [self.backScrollView addSubview:self.topImageView];
    
    [self.backScrollView addSubview:self.oldPasswordTextField];//旧密码
    
    [self.backScrollView addSubview:self.passwordTextField];
    
    [self.backScrollView addSubview:self.insurePasswordTextField];//确认密码

    [self.backScrollView addSubview:self.completeBtn];
    
    [self.backScrollView addSubview:self.pwdBtn];//是否明文显示
    
    [self.backScrollView addSubview:self.pwdBtn1];//是否明文显示

    [self.backScrollView addSubview:self.pwdBtn2];//是否明文显示

    
    [self.view bringSubviewToFront:self.titleView];
    
    [self makeViewConstraints];
    
}
-(void)makeViewConstraints
{
    
    [self.backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHight);
        make.width.mas_equalTo(screen_width);
        make.height.mas_equalTo(kViewHeight);
    }];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSizeFrom750(232));
        make.height.mas_equalTo(kSizeFrom750(232));
        make.top.mas_equalTo(kSizeFrom750(75));
        make.centerX.mas_equalTo(self.view);
    }];
    
    
    [self.oldPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSizeFrom750(625));
        make.height.mas_equalTo(kSizeFrom750(90));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.topImageView.mas_bottom).offset(kSizeFrom750(80));
    }];
 
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.height.mas_equalTo(self.oldPasswordTextField);
        make.top.mas_equalTo(self.oldPasswordTextField.mas_bottom).offset(kSizeFrom750(60));
    }];
    
    [self.insurePasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.height.mas_equalTo(self.passwordTextField);
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).offset(kSizeFrom750(60));
    }];
    
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.insurePasswordTextField.mas_bottom).offset(kSizeFrom750(100));
        make.width.mas_equalTo(kSizeFrom750(625));
        make.height.mas_equalTo(kSizeFrom750(100));
        make.centerX.mas_equalTo(self.passwordTextField);
    }];
    
    
    [self.pwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.oldPasswordTextField);
        make.right.mas_equalTo(self.oldPasswordTextField.mas_right);
        make.width.height.mas_equalTo(kSizeFrom750(60));
    }];
    
    [self.pwdBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.passwordTextField);
        make.right.mas_equalTo(self.passwordTextField.mas_right);
        make.width.height.mas_equalTo(kSizeFrom750(60));
    }];
    
    [self.pwdBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.insurePasswordTextField);
        make.right.mas_equalTo(self.insurePasswordTextField.mas_right);
        make.width.height.mas_equalTo(kSizeFrom750(60));
    }];
    
    [self.backScrollView layoutIfNeeded];
    
    self.backScrollView.contentSize = CGSizeMake(screen_width, self.completeBtn.bottom+kSizeFrom750(30));
    
}
#pragma mark --textfieldDelegate
-(void)textFieldDidChange :(UITextField *)textField{
    if (textField.text.length > 20) {
        //限制输入长度为20
        textField.text = [textField.text substringToIndex:20];
    }
}
#pragma mark --registerMethod
//找回密码按钮点击
-(void)registerButtonClick:(UIButton *)sender{
    NSString *password = self.oldPasswordTextField.text;
    NSString *new_password = self.passwordTextField.text;
    NSString *insure_Pwd = self.insurePasswordTextField.text;
    if (![CommonUtils checkPassword:new_password]) {
        [SVProgressHUD showInfoWithStatus:@"密码为6~15位数字和字母的组合"];
        return;
    }
    if (![CommonUtils checkPassword:insure_Pwd]) {
        [SVProgressHUD showInfoWithStatus:@"密码为6~15位数字和字母的组合"];
        return;
    }
    if (![new_password isEqualToString:new_password]) {
        [SVProgressHUD showInfoWithStatus:@"两次输入密码不一致！"];
        return;
    }
 
    NSArray *keys = @[kToken,@"password",@"new_password"];
    NSArray *values = @[[CommonUtils getToken],password,new_password];
    
    [[HttpCommunication sharedInstance] postSignRequestWithPath:changePasswordUrl keysArray:keys valuesArray:values refresh:nil success:^(NSDictionary *successDic) {
        [SVProgressHUD showSuccessWithStatus:@"密码修改成功，请重新登录"];
        [self performSelector:@selector(changePwdSuccess) withObject:nil afterDelay:1];
    } failure:^(NSDictionary *errorDic) {
        
    }];
    
}
-(void)changePwdSuccess{
    [self exitLoginStatus];
    [self goLoginVC];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}
-(void)pwdBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case 0:
            {
                self.oldPasswordTextField.secureTextEntry = !sender.selected;

            }
            break;
        case 1:
        {
            self.passwordTextField.secureTextEntry = !sender.selected;
        }
            break;
        case 2:
        {
            self.insurePasswordTextField.secureTextEntry = !sender.selected;
        }
            break;
            
        default:
            break;
    }
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
