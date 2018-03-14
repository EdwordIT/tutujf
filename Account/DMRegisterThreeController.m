//
//  DMRegisterThreeController.m
//  TTJF
//
//  Created by 占碧光 on 2017/4/7.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DMRegisterThreeController.h"

@interface DMRegisterThreeController ()<UITextFieldDelegate>
{
UIButton *loginButton ;
}
@property (nonatomic ,strong)UITextField *passwordTextFiled;

@end

@implementation DMRegisterThreeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void) initView
{
    UIImageView * close= [[UIImageView alloc] init];
    
    [close setImage:[UIImage imageNamed:@"Signup_iceo_return"]];
    close. frame=CGRectMake(15, 35, 8, 16);
    [close setUserInteractionEnabled:TRUE];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBack:)];
    [close addGestureRecognizer:tap1];
    [self.view addSubview:close];
    
    
    
    UILabel * lab2= [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-50, 35, 100, 15)];
    lab2.font = CHINESE_SYSTEM(15);
    lab2.textColor=RGB(184,184,184);
    lab2.textAlignment=NSTextAlignmentCenter;
    lab2.text=@"手机快速注册";
    [self.view addSubview:lab2];
    
    UIView * line1=[[UIView alloc] initWithFrame:CGRectMake(30, 190, screen_width-60, 0.5)];
    line1.backgroundColor=RGB(225,225,225);
    [self.view addSubview:line1];
    
    _passwordTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(60, 163, 271, 30)];
    _passwordTextFiled.delegate = self;
    _passwordTextFiled.placeholder = @"请输入您的密码";
    _passwordTextFiled.font = [UIFont systemFontOfSize:14];
    _passwordTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTextFiled.secureTextEntry = YES;
    [self.view addSubview:_passwordTextFiled];
    
    
    　 loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    loginButton.frame = CGRectMake(15, 220, screen_width -30, 50);
    [loginButton setTitle:@"下一步" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
   // [loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundColor:RGB(69,178,247)];
    [loginButton.layer setCornerRadius:25]; //设置矩形四个圆角半径
    [self.view addSubview:loginButton];
    
}


#pragma mark UITextFiledDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _passwordTextFiled) {
        [_passwordTextFiled resignFirstResponder];
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)OnTapBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
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
