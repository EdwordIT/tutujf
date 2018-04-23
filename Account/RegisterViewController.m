//
//  RegisterViewController.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/19.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "RegisterViewController.h"
#import "SystemConfigModel.h"
#import "HomeWebController.h"
#import "AutoLoginView.h"
@interface RegisterViewController ()<UITextFieldDelegate,UIWebViewDelegate>
Strong UIImageView *topImageView;//
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
Strong SystemConfigModel *model;//
Strong UIWebView *loginWebView;
@end

@implementation RegisterViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mobileTextField becomeFirstResponder];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"手机快速注册";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubViews];
    // Do any additional setup after loading the view.
}
-(UIImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView = InitObject(UIImageView);
        [_topImageView setImage:IMAGEBYENAME(@"register_red")];
    }
    return _topImageView;
}
-(UITextField*)mobileTextField{
    if (!_mobileTextField) {
        _mobileTextField = InitObject(UITextField);
        _mobileTextField.placeholder = @"请输入手机号码";
        [_mobileTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
        [_codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
        _codeBtn.titleLabel.font = SYSTEMSIZE(32);
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:navigationBarColor forState:UIControlStateNormal];
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
        [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
-(UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = InitObject(UIButton);
        _registerBtn.adjustsImageWhenHighlighted = NO;
        [_registerBtn setBackgroundImage:IMAGEBYENAME(@"loginBtn") forState:UIControlStateNormal];
        [_registerBtn setTitle:@"完成注册" forState:UIControlStateNormal];
        [_registerBtn.titleLabel setFont:SYSTEMBOLDSIZE(36)];
        [_registerBtn addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _registerBtn.layer.cornerRadius = kSizeFrom750(100)/2;
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
    
    self.countDownNum = 60;
    if (_isRootVC) {
        [self.backBtn setImage:IMAGEBYENAME(@"icons_close") forState:UIControlStateNormal];
    }
    [self.view addSubview:self.topImageView];
    
    [self.view addSubview:self.mobileTextField];
    
    [self.view addSubview:self.codeTextField];//验证码
    
    [self.view addSubview:self.codeBtn];//验证码获取按钮
    
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
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSizeFrom750(258));
        make.height.mas_equalTo(kSizeFrom750(228));
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
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
-(void)textFieldDidChange :(UITextField *)textField{
    if (textField.text.length > 20) {
        //限制输入长度为20
        textField.text = [textField.text substringToIndex:20];
    }
    
}

#pragma mark --registerMethod
-(void)countDown{
    self.codeBtn.userInteractionEnabled = NO;
    self.countDownNum --;
    NSString * num = [NSString stringWithFormat:@"%lds",self.countDownNum];
    [self.codeBtn setTitle:num forState:UIControlStateNormal];
  
    CALayer *layer = self.codeBtn.layer;
    layer.frame = self.codeBtn.bounds;
    layer.cornerRadius = kSizeFrom750(25);
    layer.borderColor = [navigationBarColor CGColor];
    layer.borderWidth = kLineHeight;
    
    if (self.countDownNum == 0)
    {
        CALayer *layer = self.codeBtn.layer;
        layer.frame = self.codeBtn.bounds;
        layer.cornerRadius = kSizeFrom750(25);
        layer.borderColor = [[UIColor clearColor] CGColor];
        layer.borderWidth = 0;
        [self.codeTime invalidate];
        self.codeTime = nil;
        self.countDownNum = 60;
        [self.codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.codeBtn.userInteractionEnabled = YES;
    }
   
   

}
-(void)codeBtnClick:(UIButton *)sender{
    if ([CommonUtils checkTelNumber:self.mobileTextField.text]) {
        //发送验证码
        
        NSString *phone = self.mobileTextField.text;
        NSString *type = @"reg";
        NSString *time_stamp = [CommonUtils getCurrentTimestamp];
   
        NSArray *keys = @[@"phone",@"type",@"time_stamp"];
        NSArray *values = @[phone,type,time_stamp];
    
        [[HttpCommunication sharedInstance] postSignRequestWithPath:getMessageCodeUrl keysArray:keys valuesArray:values refresh:nil success:^(NSDictionary *successDic){
            [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
            if (self.codeTime==nil) {
                self.codeTime = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:self.codeTime forMode:NSDefaultRunLoopMode];
            }
        
            //[NSTimer timerWithTimeInterval:<#(NSTimeInterval)#> repeats:<#(BOOL)#> block:<#^(NSTimer * _Nonnull timer)block#>]此方法仅在ios10及其之后才有此方法
          
        } failure:^(NSDictionary *errorDic) {
            
        }];
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"手机号格式不正确"];
    }
    
}
-(void)dealBtnClick:(UIButton *)sender{
    
    HomeWebController *web = InitObject(HomeWebController);
    if (self.model==nil) {
        self.model = [SystemConfigModel yy_modelWithJSON:[CommonUtils getCacheDataWithKey:Cache_SystemConfig]];
    }
    web.urlStr = self.model.reg_agreement_link;
    [self.navigationController pushViewController:web animated:YES];
    
}
//注册按钮点击
-(void)registerButtonClick:(UIButton *)sender{
    
    NSString *phone = self.mobileTextField.text;
    NSString *sms_code = self.codeTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *referrer = @"";
    if (![CommonUtils checkTelNumber:phone]) {
        [SVProgressHUD showInfoWithStatus:@"手机号格式不正确"];
        return;
    }
    
    if (![CommonUtils checkPassword:password]) {
        [SVProgressHUD showInfoWithStatus:@"密码为6~15位数字和字母的组合"];
        return;
    }
    if (sms_code.length!=6) {
        [SVProgressHUD showInfoWithStatus:@"验证码错误"];
        return;
    }
   
    NSArray *keys = @[@"phone",@"password",@"sms_code",@"referrer"];
    NSArray *values = @[phone,password,sms_code,referrer];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:registerUrl keysArray:keys valuesArray:values refresh:nil success:^(NSDictionary *successDic){
        if (!IsEmptyStr([successDic objectForKey:kToken])) {
            [TTJFUserDefault setStr:phone key:kUsername];
            [TTJFUserDefault setStr:password key:kPassword];
            [TTJFUserDefault setStr:[successDic objectForKey:kToken] key:kToken];
            [TTJFUserDefault setStr:[successDic objectForKey:kExpirationTime] key:kExpirationTime];
            [[NSNotificationCenter defaultCenter] postNotificationName:Noti_LoginChanged object:nil];
        }
        //默认登录webView
        AutoLoginView *loginView = [[AutoLoginView alloc]init];
        [self.view addSubview:loginView];
        [loginView setCookie];
        loginView.autoLoginBlock = ^{
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTabbarIndex" object:@{@"tabbarIndex":@(3)}];
                    [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                    [self dismissViewControllerAnimated:YES completion:NULL];
                });
            });
            
        };
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
