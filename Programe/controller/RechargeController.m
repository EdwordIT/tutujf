//
//  RechargeController.m
//  TTJF
//
//  Created by wbzhan on 2018/4/24.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "RechargeController.h"
#import "RechargeRecordController.h"
#import "GradientButton.h"
#import "RechargeModel.h"
#import "HomeWebController.h"
#import "UIImage+Color.h"
@interface RechargeController ()<UITextFieldDelegate,UITextViewDelegate>
Strong UIView *topView;//白色背景
Strong UILabel *amountTitle;
Strong UILabel *amountLabel;//可用余额
Strong UIView *amountBgView;//背景色
Strong UITextField *amountTextField;//输入框
Strong GradientButton *rechargeBtn;//
Strong UIButton *limitDesBtn;//快捷充值限额说明
Strong UIButton *historyBtn;//充值记录
Strong UIButton *remindTitle;
Strong UITextView *remindTextView;//温馨提示
Strong RechargeModel *rechargeModel;
@end

@implementation RechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"充值";
    [self initSubViews];

    [self getRequest];
    
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
        _amountLabel.text = @"569298.00";
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
        [_amountTextField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
        _amountTextField.delegate = self;
        _amountTextField.font = NUMBER_FONT(30);
    }
    return _amountTextField;
}
-(GradientButton *)rechargeBtn{
    if (!_rechargeBtn) {
        _rechargeBtn = InitObject(GradientButton);
        [_rechargeBtn setBackgroundImage:[UIImage imageWithColor:COLOR_Red] forState:UIControlStateNormal];
        [_rechargeBtn setBackgroundImage:[UIImage imageWithColor:COLOR_Btn_Unsel] forState:UIControlStateDisabled];
        [_rechargeBtn setTitleColor:COLOR_White forState:UIControlStateNormal];
        [_rechargeBtn addTarget:self action:@selector(rechargeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_rechargeBtn.titleLabel setFont:SYSTEMSIZE(36)];
        _rechargeBtn.layer.cornerRadius = kSizeFrom750(105)/2;
        _rechargeBtn.layer.masksToBounds = YES;
        _rechargeBtn.enabled = NO;
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
        [_remindTitle setImage:IMAGEBYENAME(@"recharge_remind") forState:UIControlStateNormal];
        [_remindTitle setTitleEdgeInsets:UIEdgeInsetsMake(0, -kSizeFrom750(20), 0, 0)];
        [_remindTitle setImageEdgeInsets:UIEdgeInsetsMake(0, -(kSizeFrom750(180) - kSizeFrom750(30) - kSizeFrom750(100)), 0, 0)];
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
        make.width.mas_equalTo(kSizeFrom750(180));
        make.height.mas_equalTo(kSizeFrom750(35));
    }];
    
    [self.remindTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.remindTitle);
        make.top.mas_equalTo(self.remindTitle.mas_bottom).offset(kSizeFrom750(20));
        make.width.mas_equalTo(kSizeFrom750(690));
    }];
}
#pragma mark--request
-(void)getRequest
{
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getRechargeInfoUrl keysArray:@[kToken] valuesArray:@[[CommonUtils getToken]] refresh:nil success:^(NSDictionary *successDic) {
        self.rechargeModel = [RechargeModel yy_modelWithJSON:successDic];
        [self loadTextView];
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
#pragma textField delegate
-(void)textFieldDidChanged:(UITextField *)textField
{
    if ([self.rechargeModel.bt_state isEqualToString:@"-1"]) {//不可充值
        self.rechargeBtn.enabled = NO;
        return;
    }
    NSString *    str = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(str.length >0)
    {
        if(![CommonUtils isNumber:str])
        {
            self.rechargeBtn.enabled = NO;
        }
        else  if([CommonUtils isNumber:str])
        {
            if(str.floatValue>=[self.rechargeModel.min_amount floatValue])
            {
                self.rechargeBtn.enabled = YES;
            }
            else
            {
                self.rechargeBtn.enabled = NO;
            }
        }
    }
    else{
        self.rechargeBtn.enabled = NO;
    }
}
#pragma mark --buttonClick
//充值
-(void)rechargeBtnClick:(UIButton *)sender{
    NSArray *keys = @[kToken,@"amount"];
    NSArray *values = @[[CommonUtils getToken],self.amountTextField.text];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:postRechargeUrl keysArray:keys valuesArray:values refresh:nil success:^(NSDictionary *successDic) {
       
        NSString * form=[NSString stringWithFormat:@"%@",[successDic objectForKey:@"form"]];//json字符串
        NSDictionary *formDic = [[HttpCommunication sharedInstance] dictionaryWithJsonString:form];//转化为json
        NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[form] forKeys:@[@"form"] ];
        NSString *signnew=[HttpSignCreate GetSignStr:dict_data];
        NSString * sign=[successDic objectForKey:@"sign"];
        if ([signnew isEqualToString:sign]) {//sign为服务器返回
            
            NSString *formUrl = [[HttpCommunication sharedInstance] getFormUrl:formDic];
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr = formUrl;
            [self.navigationController pushViewController:discountVC animated:YES];
            
        }else{
            [SVProgressHUD showInfoWithStatus:@"充值失败"];
        }
        
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
//充值限制
-(void)limitDesBtnClick:(UIButton *)sender{
    HomeWebController *web = InitObject(HomeWebController);
    web.urlStr = self.rechargeModel.recharge_quota_url;
    [self.navigationController pushViewController:web animated:YES];
}
//充值记录
-(void)historyBtnClick:(UIButton *)sender{
    RechargeRecordController *record = InitObject(RechargeRecordController);
    [self.navigationController pushViewController:record animated:YES];
}
-(void)loadTextView{
   
    if ([self.rechargeModel.bt_state isEqualToString:@"-1"]) {
        [self.rechargeBtn setBackgroundColor:COLOR_Btn_Unsel];
    }else
        [self.rechargeBtn setBackgroundColor:COLOR_Red];
    
    self.amountTextField.placeholder = self.rechargeModel.txtamount_placeholder;//提示文字
    [self.remindTitle setTitle:self.rechargeModel.prompt forState:UIControlStateNormal];
    [self.limitDesBtn setTitle:self.rechargeModel.recharge_quota_title forState:UIControlStateNormal];
    [self.historyBtn setTitle:self.rechargeModel.recharge_list_title forState:UIControlStateNormal];
    [self.rechargeBtn setTitle:self.rechargeModel.bt_name forState:UIControlStateNormal];
    [self.amountTitle setText:self.rechargeModel.amount_title];
    [self.amountLabel setText:[CommonUtils getHanleNums:self.rechargeModel.amount]];
    
    NSString *str = self.rechargeModel.prompt_content;
    if ([str rangeOfString:@"\\n"].location!=NSNotFound) {
        str = [str stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    for (PromptContentModel *model in self.rechargeModel.prompt_content_repurl) {
        NSString *matchStr = model.text;
        if ([str rangeOfString:matchStr].location!=NSNotFound) {
            [attr addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@""] range:[str rangeOfString:matchStr]];
        }
        [attr addAttribute:NSForegroundColorAttributeName value:RGB_166 range:NSMakeRange(0, str.length)];
        [attr addAttribute:NSForegroundColorAttributeName value:COLOR_LightBlue range:[str rangeOfString:matchStr]];//设置颜色
        [attr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:[str rangeOfString:matchStr]];

    }

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:kLabelSpace];
    [paragraphStyle setHeadIndent:kSizeFrom750(35)];
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];//设置行间距
    
//    self.remindTextView.selectedRange = [str rangeOfString:matchStr];
    self.remindTextView.linkTextAttributes = @{NSUnderlineColorAttributeName: COLOR_LightBlue,
                                               NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)
                                               };
    [self.remindTextView setAttributedText:attr];
    
}
//超链接被点击
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    NSArray *arr = self.rechargeModel.prompt_content_repurl;
    for (int i=0; i<arr.count; i++) {
        PromptContentModel *model = arr[i];
        if ([self.rechargeModel.prompt_content rangeOfString:model.text].location!=NSNotFound) {
            HomeWebController *web = InitObject(HomeWebController);
            web.urlStr = model.url;
            [self.navigationController pushViewController:web animated:YES];
        }
    }
   
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
