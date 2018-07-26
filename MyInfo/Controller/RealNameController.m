//
//  RealNameController.m
//  TTJF
//
//  Created by wbzhan on 2018/4/25.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "RealNameController.h"
#import "GradientButton.h"
#import "RealnameModel.h"
#import "HomeWebController.h"
@interface RealNameController ()
Strong UIImageView *remindImage;
Strong UILabel *remindLabel;
Strong UIView *contentView;//中间内容
Strong GradientButton *certificationBtn;//实名认证按钮
Strong UILabel *messageLabel;
Strong RealnameModel *model;
Weak UITextField *nameTextField;
Weak UITextField *certificationTextField;
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
    
    [self getRequest];
    
    [self.view layoutIfNeeded];
    
    [self.certificationBtn setGradientColors:@[COLOR_DarkBlue,COLOR_LightBlue]];
    
}
#pragma mark --lazyLoading
-(UIImageView *)remindImage{
    if (!_remindImage) {
        _remindImage = InitObject(UIImageView);
        [_remindImage setImage:IMAGEBYENAME(@"remind_blue")];
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
-(void)getRequest{
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getRealnameInfoUrl keysArray:@[kToken] valuesArray:@[[CommonUtils getToken]] refresh:nil success:^(NSDictionary *successDic) {
        self.model = [RealnameModel yy_modelWithJSON:successDic];
        [self loadInfo:self.model];
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
-(void)loadInfo:(RealnameModel *)model
{
    NSString *remindText = self.model.top_title;
    NSString *nextText = self.model.bottom_title;
    [CommonUtils setAttString:remindText withLineSpace:kLabelSpace titleLabel:self.remindLabel];
    [CommonUtils setAttString:nextText withLineSpace:kLabelSpace titleLabel:self.messageLabel];
    NSString *regText = @"您的资产由汇付支付托管系统全程监管";
    
    UIButton *btn = [[UIButton alloc]initWithFrame:RECT(0, screen_height - kSizeFrom750(80), screen_width, kSizeFrom750(40))];
    [btn setTitle:regText forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    [btn.titleLabel setFont:SYSTEMSIZE(25)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -kSizeFrom750(10))];
    [btn setImage:IMAGEBYENAME(@"icons_safe") forState:UIControlStateNormal];
    [btn setTitleColor:RGB_153 forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
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
        if (i==0) {
            self.nameTextField = textField;
        }else if (i==1) {
            textField.text = @"身份证";
            textField.userInteractionEnabled = NO;
       }else{
           self.certificationTextField = textField;
       }
        
        if (i!=2) {
            UIView *line = [[UIView alloc]initWithFrame:RECT(title.left, kSizeFrom750(90)*(i+1), kContentWidth, kLineHeight)];
            line.backgroundColor = separaterColor;
            [self.contentView addSubview:line];
        }
    }
    
}
-(void)certificationBtnClick:(UIButton *)sender{
    //身份证号
    if(![CommonUtils checkUserIdCard:self.certificationTextField.text]){
        [SVProgressHUD showInfoWithStatus:@"身份证号码错误"];
        return;
    }
    //点击进行实名认证
    if (self.model) {
        [SVProgressHUD show];
        [[HttpCommunication sharedInstance] postSignRequestWithPath:postCertificationUrl keysArray:@[kToken,@"card_id",@"realname"] valuesArray:@[[CommonUtils getToken],self.certificationTextField.text,self.nameTextField.text] refresh:nil success:^(NSDictionary *successDic) {
            [TTJFUserDefault setStr:@"1" key:isCertificationed];
            
            [SVProgressHUD showSuccessWithStatus:@"实名认证成功！"];
            [self performSelector:@selector(goReg) withObject:nil afterDelay:1];
            
        } failure:^(NSDictionary *errorDic) {
            
        }];
        
    }
}
//去开通托管账户
-(void)goReg{
    
    HomeWebController *web = InitObject(HomeWebController);
    web.isJumped = YES;
    web.urlStr = self.model.trust_reg_url;
    [self.navigationController pushViewController:web animated:YES];
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
