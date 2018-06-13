//
//  RushPurchaseController.m
//  TTJF
//
//  Created by 占碧光 on 2017/10/24.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "RushPurchaseController.h"
#import "MBProgressHUD+MP.h"
#import "SecurityModel.h"
#import "RepayModel.h"
#import "LoanBase.h"
#import "HomeWebController.h"
#import "HomeWebController.h"
#import "RechargeController.h"//充值页面
#import "GradientButton.h"
#define blackfont  RGB(111,187,255)
@interface RushPurchaseController ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    // UIScrollView *scrollView ;
    UILabel * title;
    UILabel * rateLabel; //预期年化收益
    UILabel * limitLabel;//借款期限
    UILabel *investLabel;//投资金额
    UILabel *accountRemainLabel;//账户余额
    UILabel * expectLabel;//预期收益金额
    GradientButton * investBtn;//投资按钮
    UILabel *repayMethodLabel;//还款方式
    UILabel *remainLabel;//剩余可投资金额
   //UIWebView *iWebView;
}
Strong UIScrollView *scrollView;
@property (nonatomic ,strong)UITextField *phoneTextFiled;
@property (nonatomic ,strong)UITextField *passwordTextFiled;
Strong     LoanBase * baseModel;



@end

@implementation RushPurchaseController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self getRequest];//下单页面刷新内容
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}
-(void)initSubViews
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:RECT(0, kNavHight, screen_width, screen_height)];
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    WEAK_SELF;
    self.scrollView.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf getRequest];
    }];
   
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    
}
-(void)reloadInfo
{
    [self.scrollView removeAllSubViews];
    
    CGFloat sectionSpace = kSizeFrom750(40);
    CGFloat rowSpace = kSizeFrom750(20);
    LoanInfo * info=self.baseModel.loan_info;
    self.titleString = @"投标";
    UIView * mainview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kSizeFrom750(380))];
    mainview.backgroundColor=navigationBarColor;
    [self.scrollView addSubview:mainview];
    
    //标的名称
    title = [[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, rowSpace, kSizeFrom750(500),kSizeFrom750(35))];
    title.font = SYSTEMSIZE(32);
    title.textColor =  COLOR_White;
    title.text=info.name;
    [mainview addSubview:title];
    
    UILabel *ratTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(title.left, title.bottom+sectionSpace, kSizeFrom750(200),kSizeFrom750(30))];
    ratTitleLabel.font = SYSTEMSIZE(28);
    ratTitleLabel.textColor =  blackfont;
    ratTitleLabel.text=@"预期利率";
    [mainview addSubview:ratTitleLabel];
    
    rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(ratTitleLabel.left, ratTitleLabel.bottom+rowSpace, ratTitleLabel.width,ratTitleLabel.height)];
    rateLabel.font = SYSTEMSIZE(28);
    rateLabel.textColor =  COLOR_White;
    rateLabel.text=[[NSString stringWithFormat:@"%@",info.apr] stringByAppendingString:@"%"];;
     [mainview addSubview:rateLabel];
    
    UILabel *limitTitle = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2, ratTitleLabel.top, ratTitleLabel.width,ratTitleLabel.height)];
    limitTitle.font = SYSTEMSIZE(28);
    limitTitle.textColor =  blackfont;
    limitTitle.text=@"借款期限";
    [mainview addSubview:limitTitle];
    
    limitLabel = [[UILabel alloc] initWithFrame:CGRectMake(limitTitle.left, rateLabel.top, rateLabel.width,rateLabel.height)];
    limitLabel.font = SYSTEMSIZE(28);
    limitLabel.textColor =  COLOR_White;
    limitLabel.text=info.period_name;
    [mainview addSubview:limitLabel];
    
    
    UILabel *repayTitle = [[UILabel alloc] initWithFrame:CGRectMake(rateLabel.left, rateLabel.bottom+sectionSpace, ratTitleLabel.width,ratTitleLabel.height)];
    repayTitle.font = SYSTEMSIZE(28);
    repayTitle.textColor =  blackfont;
    repayTitle.text=@"还款方式";
    [mainview addSubview:repayTitle];
    
    repayMethodLabel = [[UILabel alloc] initWithFrame:CGRectMake(repayTitle.left, repayTitle.bottom+rowSpace, repayTitle.width,repayTitle.height)];
    repayMethodLabel.font = SYSTEMSIZE(28);
    repayMethodLabel.textColor =  COLOR_White;
    repayMethodLabel.text =self.baseModel.repay_type_name;
    [mainview addSubview: repayMethodLabel];
    
  
    
    UILabel *remainTitle = [[UILabel alloc] initWithFrame:CGRectMake(limitTitle.left, repayTitle.top, repayTitle.width,repayTitle.height)];
    remainTitle.font = SYSTEMSIZE(28);
    remainTitle.textColor =  blackfont;
    remainTitle.text=@"剩余可投金额";
    [mainview addSubview:remainTitle];
    
    
    remainLabel = [[UILabel alloc] initWithFrame:CGRectMake(remainTitle.left, repayMethodLabel.top, repayMethodLabel.width,repayMethodLabel.height)];
    remainLabel.font = SYSTEMSIZE(28);
    remainLabel.textColor =  COLOR_White;
    NSString * str3=[NSString stringWithFormat:@"%@",info.left_amount];
    NSString * temp =  [NSString stringWithFormat:@"%@元",[CommonUtils getHanleNums:str3]];
     remainLabel.text =temp;
    [mainview addSubview: remainLabel];
    
    [investBtn setTitle:info.buy_name forState:UIControlStateNormal];

#pragma mark --余额
    
    UIView * bottomView =[[UIView alloc] initWithFrame:CGRectMake(0, mainview.bottom, screen_width, kViewHeight - mainview.bottom)];

    bottomView.backgroundColor=COLOR_Background;
    bottomView.userInteractionEnabled=YES;
    [self.scrollView addSubview:bottomView];

    
    accountRemainLabel = [[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, sectionSpace, screen_width,kSizeFrom750(40))];
    accountRemainLabel.font = SYSTEMSIZE(26);
    accountRemainLabel.textColor =  blackfont;
    NSString *account = [NSString stringWithFormat:@"账户余额%@元",[NSString stringWithFormat:@"%.2f",[self.baseModel.balance_amount floatValue]]];
   NSMutableAttributedString *attr = [CommonUtils diffierentFontWithString:account rang:[account rangeOfString:[NSString stringWithFormat:@"%.2f",[self.baseModel.balance_amount floatValue]]] font:NUMBER_FONT(30) color:COLOR_Red spacingBeforeValue:0 lineSpace:0];
    [accountRemainLabel setAttributedText:attr];
     [bottomView addSubview:accountRemainLabel];
    
    UIButton * btn1 = [[UIButton alloc]initWithFrame:CGRectMake(screen_width-kSizeFrom750(140),0, kSizeFrom750(120), kSizeFrom750(50))];
    btn1.centerY = accountRemainLabel.centerY;
    [btn1 setTitle:@"充值" forState:UIControlStateNormal];
    btn1.titleLabel.font = SYSTEMSIZE(26);
    [btn1 addTarget:self action:@selector(rechargeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setBackgroundColor:COLOR_Red];
    btn1.layer.cornerRadius = kSizeFrom750(50)/2;
    btn1.layer.masksToBounds = YES;
    btn1.tag=1;
    [bottomView addSubview:btn1];

    
    UIView * investView =[[UIView alloc] initWithFrame:CGRectMake(0, accountRemainLabel.bottom+sectionSpace, screen_width, kSizeFrom750(80))];
    investView.backgroundColor=COLOR_White;
    [bottomView addSubview:investView];
    
    UILabel *investTitle = [[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, 0, kSizeFrom750(170),kSizeFrom750(30))];
    investTitle.centerY = investView.height/2;
    investTitle.font = SYSTEMSIZE(26);
    investTitle.textColor =  RGB(38,38,38);
    investTitle.text=@"投资金额(元)";
    [investView addSubview:investTitle];
    
   //借款最小金额
    _phoneTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(investTitle.right, investTitle.top, screen_width - investTitle.right - kOriginLeft, kSizeFrom750(50))];
    _phoneTextFiled.centerY = investTitle.centerY;
    _phoneTextFiled.delegate = self;
    _phoneTextFiled.keyboardType = UIKeyboardTypeNumberPad;//纯数字;
    _phoneTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//内容垂直居中
    _phoneTextFiled.placeholder = [NSString stringWithFormat:@"投资金额需为%@的倍数",self.baseModel.loan_info.tender_amount_min];
    _phoneTextFiled.font =SYSTEMSIZE(26);
    _phoneTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_phoneTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [investView addSubview:_phoneTextFiled];
    //已经设定投资密码
    if([info.password_status isEqual:@"1"])
    {
        UIView * investPwdView = [[UIView alloc] initWithFrame:CGRectMake(0, investView.bottom+kSizeFrom750(20), screen_width, investView.height)];
        investPwdView.backgroundColor=COLOR_White;
        [bottomView addSubview:investPwdView];

        UILabel *investPwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, investTitle.top, investTitle.width,investTitle.height)];
        investPwdLabel.font = SYSTEMSIZE(26);
        investPwdLabel.textColor =  RGB(38,38,38);
        investPwdLabel.textAlignment=NSTextAlignmentLeft;
        investPwdLabel.text=@"投资密码";
        [investPwdView addSubview:investPwdLabel];
       
        _passwordTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(_phoneTextFiled.left, investPwdLabel.top, _phoneTextFiled.width, _phoneTextFiled.height)];
        _passwordTextFiled.centerY = investPwdLabel.centerY;
        _passwordTextFiled.delegate = self;
        _passwordTextFiled.placeholder = @"请输入投资密码";
        _passwordTextFiled.font =SYSTEMSIZE(26);
        _passwordTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//内容垂直居中

        _passwordTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextFiled.secureTextEntry = YES;
        [investPwdView addSubview:_passwordTextFiled];
    }
   
 
    expectLabel = [[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, [info.password_status isEqualToString:@"1"]?(investView.bottom+investView.height+kSizeFrom750(40)):(investView.bottom+kSizeFrom750(20)), screen_width,kSizeFrom750(30))];
    expectLabel.font = SYSTEMSIZE(26);
    expectLabel.textColor =  blackfont;
    NSString *expect = @"预期收益金额0.0元";
    NSMutableAttributedString *attr1 = [CommonUtils diffierentFontWithString:expect rang:[expect rangeOfString:@"0.0"] font:NUMBER_FONT(30) color:COLOR_Red spacingBeforeValue:0 lineSpace:0];
    [expectLabel setAttributedText:attr1];
   [bottomView addSubview:expectLabel];
    
    investBtn = InitObject(GradientButton);
    investBtn.frame = CGRectMake(kOriginLeft,expectLabel.bottom+kSizeFrom750(80), screen_width-kOriginLeft*2, kSizeFrom750(90));
    [investBtn setTitle:@"马上投标" forState:UIControlStateNormal];
    investBtn.titleLabel.font = SYSTEMSIZE(32);
    [investBtn addTarget:self action:@selector(investBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    investBtn.layer.cornerRadius = investBtn.height/2;
    investBtn.layer.masksToBounds =YES;
    [investBtn setGradientColors:@[COLOR_DarkBlue,COLOR_LightBlue]];
    [investBtn setUntouchedColor:COLOR_Btn_Unsel];
    investBtn.enabled = NO;
    [bottomView addSubview:investBtn];
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    NSString *    str = [_phoneTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(str.length >0)
    {
        if(![CommonUtils isNumber:str])
        {
          investBtn.enabled = NO;
            
        }
        else  if([CommonUtils isNumber:str])
        {
            NSInteger num=[str intValue];
            NSString * str1=self.baseModel.loan_info.tender_amount_min;
            NSInteger minInvest= [str1 intValue];
            if(num>=minInvest&&(num%minInvest==0))
            {
               investBtn.enabled = YES;
                 [self getInterest];
            }
            else
            {
                investBtn.enabled = NO;
            }
        }
        
    }
    else{
        
        }
}
-(BOOL)checkNum{
  NSString *    str = [_phoneTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([CommonUtils isNumber:str]) {
        if ([str floatValue]>[self.baseModel.balance_amount floatValue]) {
            [SVProgressHUD showInfoWithStatus:@"可用余额不足，请先充值"];
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}

-(void) getRequest{
    NSArray *keys = @[@"loan_id",kToken];
    NSArray *values = @[self.loan_id,[CommonUtils getToken]];
    
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getLoanDetailUrl keysArray:keys valuesArray:values refresh:nil success:^(NSDictionary *successDic) {
        
        self.baseModel = [LoanBase yy_modelWithJSON:successDic];
        self.baseModel.repay_type_name=[[successDic objectForKey:@"repay_type"] objectForKey:@"name"];
        [self reloadInfo];
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
-(void)rechargeBtnClick:(UIButton *) sender
{
    if([CommonUtils isLogin])
    {
        if([self.baseModel.trust_account isEqual:@"1"])
        {
            RechargeController *recharge = InitObject(RechargeController);
            [self.navigationController pushViewController:recharge animated:YES];
        }
        else
        {
            //如果未创建托管账户
            //是否已经实名认证
            if([CommonUtils isVerifyRealName])
            {
                HomeWebController *discountVC = [[HomeWebController alloc] init];
                discountVC.urlStr= self.baseModel.trust_reg_url;
                [self.navigationController pushViewController:discountVC animated:YES];
            }
            else
            {
                [self goRealNameVC];
            }
        }
    }
    else
    {
        [self goLoginVC];
    }
   
}

-(void) investBtnClick:(UIButton *)sender
{
   
        //是否已经实名认证
        if([CommonUtils isVerifyRealName])
        {
            //是否开通汇付
            if ([self.baseModel.trust_account isEqualToString:@"1"]) {
                if ([self checkNum]) {
                    
                    [self getFormData];
                }
            }else{
                [self goWebViewWithPath:self.baseModel.trust_reg_url];
            }
           
        }
        else
        {
            [self goRealNameVC];
            
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获取预期收益
-(void) getInterest
{
    NSString *    str = [_phoneTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    LoanInfo * info=self.baseModel.loan_info;
    NSString * amount=str;
    NSString * period=info.period; //
    NSString * apr=info.apr; //
    NSString * repay_type=self.baseModel.repay_type_name;
    
    NSArray *keys = @[@"amount",@"period",@"apr",@"repay_type"];
    NSArray *values = @[amount,period,apr,repay_type];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getExpectInvestUrl keysArray:keys valuesArray:values refresh:nil success:^(NSDictionary *successDic) {
        NSString *interest = [successDic objectForKey:@"interest_total"];
        NSString *expectStr = [NSString stringWithFormat:@"预期收益金额%@元",interest];
        NSMutableAttributedString *attr1 = [CommonUtils diffierentFontWithString:expectStr rang:[expectStr rangeOfString:interest] font:NUMBER_FONT(30) color:COLOR_Red spacingBeforeValue:0 lineSpace:0];
        [self->expectLabel setAttributedText:attr1];
        
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
//立即投资
-(void) getFormData{
    
    NSString *  str = [_phoneTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    LoanInfo * info=self.baseModel.loan_info;
    NSString * amount=str;
    NSString * loan_id=self.loan_id; //
    NSString * loan_password=@""; //
    NSString * user_token=[CommonUtils getToken]; //
      if([info.password_status isEqual:@"1"])
        {
              loan_password=[_passwordTextFiled text];
             loan_password=  [loan_password stringByReplacingOccurrencesOfString:@" " withString:@""];
            if([loan_password isEqualToString:@""])
            {
                [SVProgressHUD showInfoWithStatus:@"密码不能为空"];
                return;
            }
            //loan_password=[@"a123123123"];
        }
    /*
    NSMutableDictionary *dict_data =[[NSMutableDictionary alloc] init];
    [dict_data setObject:loan_id forKey:@"loan_id"];
    [dict_data setObject:amount forKey:@"amount"];
    [dict_data setObject:loan_password forKey:@"loan_password"];
    [dict_data setObject:user_token forKey:kToken];
   */
    NSArray *keys = @[@"version",@"loan_id",@"amount",@"loan_password",kToken];
    NSArray *values = @[LocalVersion,loan_id,amount,loan_password,user_token];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:tenderUrl keysArray:keys valuesArray:values refresh:nil success:^(NSDictionary *successDic) {


        NSString * form=[NSString stringWithFormat:@"%@",[successDic objectForKey:@"form"]];//json字符串
        NSDictionary *formDic = [[HttpCommunication sharedInstance] dictionaryWithJsonString:form];//转化为json
        NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[form] forKeys:@[@"form"] ];
        NSString *signnew=[HttpSignCreate GetSignStr:dict_data];
        NSString * sign=[successDic objectForKey:@"sign"];
        if ([signnew isEqualToString:sign]) {//sign为服务器返回
            NSString *formUrl = [[HttpCommunication sharedInstance] getFormUrl:formDic];
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr=formUrl;
            [self.navigationController pushViewController:discountVC animated:YES];
            
        }else{
            [SVProgressHUD showInfoWithStatus:@"投资失败"];
        }
        
    } failure:^(NSDictionary *errorDic) {
        
    }];
}

@end
