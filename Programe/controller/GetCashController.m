//
//  WithDrawController.m
//  TTJF
//
//  Created by wbzhan on 2018/4/24.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "GetCashController.h"
#import "GetCashRecordController.h"
#import "GradientButton.h"
#import "GetCashRecordController.h"
#import "HomeWebController.h"
#import "GetCashModel.h"
@interface GetCashController ()<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate,UIWebViewDelegate>
Strong UIScrollView *bgScrollView;
Strong UIView *topView;//白色背景
Strong UILabel *amountTitle;
Strong UILabel *amountLabel;//可提现余额
Strong UIView *amountBgView;//背景色
Strong UITextField *amountTextField;//输入框
Strong GradientButton *getCashBtn;//
Strong UILabel *desLabel;//进入第三方提现
Strong UIButton *historyBtn;//提现明细
Strong UIButton *remindTitle;
Strong UIWebView *remindWeb;//温馨提示
Strong GetCashModel *cashModel;
Strong UIView *sectionView;//切换普通提现、及时提现
Strong UIButton *commonBtn;//普通提现
Strong UIButton *immediatelyBtn;//即时到账提现
Strong UIButton *remindBtn;//提现手续费
@end

@implementation GetCashController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"提现";
    [self initSubViews];
    [SVProgressHUD show];
    [self getRequest];
    // Do any additional setup after loading the view.
}

#pragma mark lazyLoading--
-(void)initSubViews{
    
    [self.view addSubview:self.bgScrollView];
    
    [self.bgScrollView addSubview:self.topView];
    
    [self.topView addSubview:self.amountTitle];
    
    [self.topView addSubview:self.amountLabel];
    
    [self.topView addSubview:self.amountBgView];
    
    [self.amountBgView addSubview:self.amountTextField];
    
    [self.topView addSubview:self.sectionView];
    
    [self.sectionView addSubview:self.commonBtn];
    
    [self.sectionView addSubview:self.immediatelyBtn];
    
    [self.sectionView addSubview:self.remindBtn];
    
    [self.topView addSubview:self.getCashBtn];
    
    [self.topView addSubview:self.desLabel];
    
    [self.topView addSubview:self.historyBtn];
    
    [self.bgScrollView addSubview:self.remindTitle];
    
    [self.bgScrollView addSubview:self.remindWeb];
    
    [self loadLayout];
    
    [self.topView layoutIfNeeded];
    
    [self.getCashBtn setGradientColors:@[COLOR_DarkBlue,COLOR_LightBlue]];

}
-(UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = InitObject(UIScrollView);
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;

    }
    return _bgScrollView;
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
        _amountTitle.text = @"可提现金额（元）";
    }
    return _amountTitle;
}
-(UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = InitObject(UILabel);
        _amountLabel.textColor = COLOR_DarkBlue;
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
-(UIView *)sectionView{
    if (!_sectionView) {
        _sectionView = InitObject(UIView);
    }
    return _sectionView;
}
-(UIButton *)commonBtn{
    if (!_commonBtn) {
        _commonBtn = InitObject(UIButton);
        [_commonBtn setImage:IMAGEBYENAME(@"point_sel") forState:UIControlStateSelected];
        [_commonBtn setImage:IMAGEBYENAME(@"point_unsel") forState:UIControlStateNormal];
        [_commonBtn setTitle:@"普通提现（免费）" forState:UIControlStateNormal];
        [_commonBtn setTitle:@"普通提现（免费）" forState:UIControlStateSelected];
        [_commonBtn.titleLabel setFont:SYSTEMSIZE(28)];
        [_commonBtn setTitleColor:RGB_51 forState:UIControlStateNormal];
        _commonBtn.tag = 1;
        [_commonBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -kSizeFrom750(30), 0, 0)];
        [_commonBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -(kSizeFrom750(270) - kSizeFrom750(30) - kSizeFrom750(200)), 0, 0)];
        [_commonBtn addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
        _commonBtn.selected = YES;
    }
    return _commonBtn;
}
-(UIButton *)immediatelyBtn{
    if (!_immediatelyBtn) {
        _immediatelyBtn = InitObject(UIButton);
        [_immediatelyBtn.titleLabel setFont:SYSTEMSIZE(28)];
        [_immediatelyBtn setTitleColor:RGB_51 forState:UIControlStateNormal];
        [_immediatelyBtn setImage:IMAGEBYENAME(@"point_sel") forState:UIControlStateSelected];
        [_immediatelyBtn setImage:IMAGEBYENAME(@"point_unsel") forState:UIControlStateNormal];
        [_immediatelyBtn setTitle:@"即时提现" forState:UIControlStateNormal];
        [_immediatelyBtn setTitle:@"即时提现" forState:UIControlStateSelected];
        _immediatelyBtn.tag = 2;
        [_immediatelyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -kSizeFrom750(30), 0, 0)];
        [_immediatelyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -(kSizeFrom750(170) - kSizeFrom750(30) - kSizeFrom750(100)), 0, 0)];
        [_immediatelyBtn addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _immediatelyBtn;
}
-(UIButton *)remindBtn{
    if (!_remindBtn) {
        _remindBtn = InitObject(UIButton);
        [_remindBtn setBackgroundImage:IMAGEBYENAME(@"getCash_remind") forState:UIControlStateNormal];
        [_remindBtn setTitleColor:RGB_153 forState:UIControlStateNormal];
        [_remindBtn setTitle:@"提现手续费：0.00元" forState:UIControlStateNormal];
        [_remindBtn.titleLabel setFont:SYSTEMSIZE(24)];
        _remindBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_remindBtn setHidden:YES];
    }
    return _remindBtn;
}
-(GradientButton *)getCashBtn{
    if (!_getCashBtn) {
        _getCashBtn = InitObject(GradientButton);
        [_getCashBtn setTitleColor:COLOR_White forState:UIControlStateNormal];
        [_getCashBtn addTarget:self action:@selector(withDrowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_getCashBtn.titleLabel setFont:SYSTEMSIZE(36)];
        [_getCashBtn setTitle:@"确认提现" forState:UIControlStateNormal];
        _getCashBtn.layer.cornerRadius = kSizeFrom750(105)/2;
        _getCashBtn.layer.masksToBounds = YES;
        [_getCashBtn setGradientColors:@[COLOR_DarkBlue,COLOR_LightBlue]];
        [_getCashBtn setUntouchedColor:COLOR_Btn_Unsel];
        _getCashBtn.enabled = NO;

    }
    return _getCashBtn;
}
-(UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = InitObject(UILabel);
        [_desLabel setTextColor:RGB_166];
        [_desLabel setText:@"即将进入第三方支付页面"];
        _desLabel.font = SYSTEMSIZE(28);
    }
    return _desLabel;
}
-(UIButton *)historyBtn{
    if (!_historyBtn) {
        _historyBtn = InitObject(UIButton);
        _historyBtn.titleLabel.font = SYSTEMSIZE(28);
        [_historyBtn addTarget:self action:@selector(historyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_historyBtn setTitle:@"提现明细" forState:UIControlStateNormal];
        [_historyBtn setTitleColor:COLOR_DarkBlue forState:UIControlStateNormal];
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
-(UIWebView *)remindWeb
{
    if (!_remindWeb) {
        _remindWeb = [[UIWebView alloc]init];
        _remindWeb.delegate = self;
        _remindWeb.scrollView.bounces = NO;
        _remindWeb.scrollView.scrollEnabled = NO;
        _remindWeb.opaque = NO;
        _remindWeb.backgroundColor = [UIColor clearColor];
        _remindWeb.backgroundColor = COLOR_Background;
    }
    return _remindWeb;
}
#pragma masonry
-(void)loadLayout
{
 
    [self.bgScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHight);
        make.width.mas_equalTo(screen_width);
        make.height.mas_equalTo(kViewHeight);
        make.left.mas_equalTo(0);
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
    
    
    [self.commonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(kSizeFrom750(270));
        make.height.mas_equalTo(kSizeFrom750(50));
    }];
    
    [self.immediatelyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(self.commonBtn);
        make.width.mas_equalTo(kSizeFrom750(170));
        make.left.mas_equalTo(self.commonBtn.mas_right).offset(kSizeFrom750(60));
    }];
    [self.remindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.immediatelyBtn.mas_bottom);
        make.width.mas_equalTo(kSizeFrom750(300));
        make.height.mas_equalTo(kSizeFrom750(0));
        make.left.mas_equalTo(kSizeFrom750(190));
    }];
    
    [self.sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.amountBgView.mas_bottom).offset(kSizeFrom750(30));
        make.width.mas_equalTo(kSizeFrom750(600));
        make.left.mas_equalTo(kSizeFrom750(75));
        make.bottom.mas_equalTo(self.remindBtn.mas_bottom).offset(kSizeFrom750(30));
    }];
    
    
    [self.getCashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sectionView.mas_bottom);
        make.left.width.height.mas_equalTo(self.amountBgView);
    }];

    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.getCashBtn);
        make.width.mas_equalTo(kSizeFrom750(500));
        make.top.mas_equalTo(self.getCashBtn.mas_bottom).offset(kSizeFrom750(30));
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    [self.historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.getCashBtn);
        make.width.mas_equalTo(kSizeFrom750(120));
        make.top.height.mas_equalTo(self.desLabel);
    }];
    
    [self.remindTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(kSizeFrom750(30));
        make.width.mas_equalTo(kSizeFrom750(180));
        make.height.mas_equalTo(kSizeFrom750(35));
    }];
    
    [self.remindWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remindTitle.mas_bottom).offset(kSizeFrom750(20));
        make.width.mas_equalTo(kSizeFrom750(680));
        make.left.mas_equalTo(self.remindTitle);
        make.height.mas_equalTo(10);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(screen_width);
        make.bottom.mas_equalTo(self.historyBtn.mas_bottom).offset(kSizeFrom750(20));
    }];
}
#pragma textField delegate
-(void)textFieldDidChanged:(UITextField *)textField
{
    if ([self.cashModel.bt_state isEqualToString:@"-1"]) {//不可提现和非即时到账，都不用计算手续费
        self.getCashBtn.enabled = NO;
        return;
    }
    NSString *    str = [self.amountTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(str.length >0)
    {
        if(![CommonUtils isNumber:str])
        {
            self.getCashBtn.enabled = NO;
            
        }
        else  if([CommonUtils isNumber:str])
        {
            NSInteger num=[str intValue];
            NSString * str1=self.cashModel.min_amount;
            NSInteger minInvest= [str1 intValue];
            if(num>=minInvest&&num<=[self.cashModel.amount floatValue])
            {
                self.getCashBtn.enabled = YES;
                if (self.immediatelyBtn.selected) {
                    [self getCashFeeRequest];
                }
            }
            else
            {
                [self.remindBtn setTitle:@"提现手续费：0.00元" forState:UIControlStateNormal];
                self.getCashBtn.enabled = NO;

            }
        }
    }
    else{
       [self.remindBtn setTitle:@"提现手续费：0.00元" forState:UIControlStateNormal];
    }
}
#pragma mark--request
-(void)getRequest
{
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getCashInfoUrl keysArray:@[kToken] valuesArray:@[[CommonUtils getToken]] refresh:nil success:^(NSDictionary *successDic) {
        self.cashModel = [GetCashModel yy_modelWithJSON:successDic];
        [self loadTextView];
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
//获取即时提现手续费
-(void)getCashFeeRequest{
    
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getCashFeeAmtUrl keysArray:@[@"amount"] valuesArray:@[self.amountTextField.text] refresh:nil success:^(NSDictionary *successDic) {
       
        NSString *fee = [successDic objectForKey:@"fee_amt"];
        [self.remindBtn setTitle:[NSString stringWithFormat:@"提现手续费：%@元",fee] forState:UIControlStateNormal];
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
#pragma mark --buttonClick
//提现按钮点击
-(void)withDrowBtnClick:(UIButton *)sender{
    
    if ([self checkNum]) {
        
    }else{
        return;
    }
    NSString *withdraw =  self.commonBtn.selected?@"0":@"1";
    NSArray *keys = @[kToken,@"amount",@"withdraw_type"];
    NSArray *values = @[[CommonUtils getToken],self.amountTextField.text,withdraw];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:postCashUrl keysArray:keys valuesArray:values refresh:nil success:^(NSDictionary *successDic) {
        
        NSString * form=[NSString stringWithFormat:@"%@",[successDic objectForKey:@"form"]];//json字符串
        NSDictionary *formDic = [[HttpCommunication sharedInstance] dictionaryWithJsonString:form];//转化为json
        NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[form] forKeys:@[@"form"] ];
        NSString *signnew=[HttpSignCreate GetSignStr:dict_data];
        NSString * sign=[successDic objectForKey:@"sign"];
        if ([signnew isEqualToString:sign]) {//sign为服务器返回
            
            NSString *formUrl = [[HttpCommunication sharedInstance] getFormUrl:formDic];
            [self goWebViewWithPath:formUrl];
            
        }else{
            [SVProgressHUD showInfoWithStatus:@"提现失败"];
        }
        
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
//提现记录
-(void)historyBtnClick:(UIButton *)sender{
    GetCashRecordController *record = InitObject(GetCashRecordController);
    [self.navigationController pushViewController:record animated:YES];
}
//提现方式切换
-(void)sectionClick:(UIButton *)sender{
    
    if (sender.tag==1) {
        self.commonBtn.selected = YES;
        self.immediatelyBtn.selected = NO;
        [self.remindBtn setHidden:YES];
        [self.remindBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }else{
        self.immediatelyBtn.selected = YES;
        self.commonBtn.selected = NO;
        [self.remindBtn setHidden:NO];
        [self.remindBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kSizeFrom750(65));
        }];
        [self textFieldDidChanged:self.amountTextField];
    }
    [self.bgScrollView layoutIfNeeded];
    self.bgScrollView.contentSize = CGSizeMake(screen_width, self.remindWeb.bottom);
}
-(void)checkBankBind{
    
    if ([self.cashModel.is_bind_bank isEqualToString:@"-1"]) {//未绑定银行卡，弹出提示框，跳转到绑定银行卡页面
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.cashModel.bind_bank_txt preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self goWebViewWithPath:self.cashModel.bind_bank_url];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:alertAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
}
//数据加载
-(void)loadTextView{
   
    [self checkBankBind];
    self.amountTextField.placeholder = self.cashModel.txtamount_placeholder;//提示文字
    [self.remindTitle setTitle:self.cashModel.prompt forState:UIControlStateNormal];
    self.desLabel.text = self.cashModel.left_msg;
    [self.historyBtn setTitle:self.cashModel.cash_list_title forState:UIControlStateNormal];
    [self.getCashBtn setTitle:self.cashModel.bt_name forState:UIControlStateNormal];
    [self.amountTitle setText:self.cashModel.amount_title];
    [self.amountLabel setText:[CommonUtils getHanleNums:self.cashModel.amount]];
 
    [self.remindWeb loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.cashModel.prompt_content]]];

}
-(BOOL)checkNum{
    NSString *    str = [self.amountTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([CommonUtils isNumber:str]) {
        if ([str floatValue]>[self.cashModel.amount floatValue]) {
            [SVProgressHUD showInfoWithStatus:@"可提现余额不足"];
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}

//webView加载结束
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *webHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    CGFloat height = [webHeight floatValue];
    [self.remindWeb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    [self.bgScrollView layoutIfNeeded];
    
    self.bgScrollView.contentSize = CGSizeMake(screen_width, self.remindWeb.bottom);
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
