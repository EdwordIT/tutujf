//
//  DMRegisterViewController.m
//  TTJF
//
//  Created by 占碧光 on 2017/4/6.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DMRegisterViewController.h"
#import "DMRegisterThreeController.h"

@interface DMRegisterViewController ()<UITextFieldDelegate>
{
  UIButton *loginButton ;
    UIButton *  codeButton;
}
@property (nonatomic ,strong)UITextField *phoneTextFiled;

@end

@implementation DMRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.view.backgroundColor=RGB(246,246,246);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    _phoneTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(30, 163, 271, 30)];
    _phoneTextFiled.delegate = self;
    _phoneTextFiled.placeholder = @"请输入您的手机号";
    _phoneTextFiled.font = [UIFont systemFontOfSize:14];
    _phoneTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_phoneTextFiled];
    
    codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    codeButton.frame = CGRectMake(screen_width-150, 170, 150, 13);
    [codeButton setTitle:@"重新发送(30)" forState:UIControlStateNormal];
    codeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [codeButton setTitleColor:RGB(184,184,184) forState:UIControlStateNormal];//title color
    [codeButton addTarget:self action:@selector(codeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeButton];
    
    UIView * line1=[[UIView alloc] initWithFrame:CGRectMake(30, 190, screen_width-60, 0.5)];
    line1.backgroundColor=RGB(225,225,225);
    [self.view addSubview:line1];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(15, 220, screen_width -30, 50);
    [loginButton setTitle:@"下一步" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundColor:RGB(69,178,247)];
    [loginButton.layer setCornerRadius:25]; //设置矩形四个圆角半径
    [self.view addSubview:loginButton];
    
}

-(void)loginButtonClick:(UIButton *)button
{
    self.navigationController.navigationBar.translucent = YES;
    DMRegisterThreeController *vc = [[DMRegisterThreeController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)codeButtonClick:(UIButton *)button
{
    
}

#pragma mark UITextFiledDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _phoneTextFiled) {
        [_phoneTextFiled resignFirstResponder];
    }
    
    return YES;
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
