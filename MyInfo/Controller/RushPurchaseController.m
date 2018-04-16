//
//  RushPurchaseController.m
//  TTJF
//
//  Created by 占碧光 on 2017/10/24.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "RushPurchaseController.h"
#import "HttpSignCreate.h"
#import "HttpUrlAddress.h"
#import "ggHttpFounction.h"
#import "MBProgressHUD+MP.h"
#import "SecurityModel.h"
#import "RepayModel.h"
#import "AppDelegate.h"
#import "HomeWebController.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "SVProgressHUD.h"
#import "HomeWebController.h"
#import "Tender.h"

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
    UIButton * investBtn;//投资按钮
    UILabel *repayMethodLabel;//还款方式
    UILabel *remainLabel;//剩余可投资金额
   //UIWebView *iWebView;
}
@property (nonatomic ,strong)UITextField *phoneTextFiled;
@property (nonatomic ,strong)UITextField *passwordTextFiled;
Strong     LoanBase * baseModel;


@end

@implementation RushPurchaseController

- (void)viewDidLoad {
    [super viewDidLoad];
       [self getRequest];
}
-(void)initView
{
    LoanInfo * info=self.baseModel.loan_info;
    self.titleString = @"投标";
    UIView * mainview=[[UIView alloc] initWithFrame:CGRectMake(0, kNavHight, screen_width, kSizeFrom750(280))];
    mainview.backgroundColor=navigationBarColor;
    [self.view addSubview:mainview];
    
    //标的名称
    title = [[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, kSizeFrom750(30), kSizeFrom750(500),kSizeFrom750(35))];
    title.font = SYSTEMSIZE(32);
    title.textColor =  COLOR_White;
    title.text=info.name;
    [mainview addSubview:title];
    
    UILabel *ratTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(title.left, title.bottom+kSizeFrom750(20), kSizeFrom750(200),kSizeFrom750(30))];
    ratTitleLabel.font = SYSTEMSIZE(28);
    ratTitleLabel.textColor =  blackfont;
    ratTitleLabel.text=@"预期利率";
    [mainview addSubview:ratTitleLabel];
    
    rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(ratTitleLabel.left, ratTitleLabel.bottom+kSizeFrom750(10), ratTitleLabel.width,ratTitleLabel.height)];
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
    
    
    UILabel *repayTitle = [[UILabel alloc] initWithFrame:CGRectMake(rateLabel.left, rateLabel.bottom+kSizeFrom750(20), ratTitleLabel.width,ratTitleLabel.height)];
    repayTitle.font = SYSTEMSIZE(28);
    repayTitle.textColor =  blackfont;
    repayTitle.text=@"还款方式";
    [mainview addSubview:repayTitle];
    
    repayMethodLabel = [[UILabel alloc] initWithFrame:CGRectMake(repayTitle.left, repayTitle.bottom+kSizeFrom750(10), repayTitle.width,repayTitle.height)];
    repayMethodLabel.font = SYSTEMSIZE(28);
    repayMethodLabel.textColor =  COLOR_White;
    repayMethodLabel.text =self.baseModel.repay_type_name;
    [mainview addSubview: repayMethodLabel];
    
  
    
    UILabel *remainTitle = [[UILabel alloc] initWithFrame:CGRectMake(limitTitle.left, repayTitle.top, repayTitle.width,repayTitle.height)];
    remainTitle.font = SYSTEMSIZE(28);
    remainTitle.textColor =  blackfont;
    remainTitle.text=@"剩余可投金额";
    [mainview addSubview:remainTitle];
    
    
    remainLabel = [[UILabel alloc] initWithFrame:CGRectMake(remainTitle.left, remainTitle.bottom+kSizeFrom750(10), remainTitle.width,remainTitle.height)];
    remainLabel.font = SYSTEMSIZE(28);
    remainLabel.textColor =  COLOR_White;
    NSString * str3=[NSString stringWithFormat:@"%@",info.left_amount];
    NSString * temp =  [NSString stringWithFormat:@"%@元",[CommonUtils getHanleNums:str3]];
     remainLabel.text =temp;
    [mainview addSubview: remainLabel];
    

#pragma mark --余额
    
      UIView * bottomView =[[UIView alloc] initWithFrame:CGRectMake(0, mainview.bottom, screen_width, kViewHeight - mainview.bottom)];

       bottomView.backgroundColor=RGB_246;
       bottomView.userInteractionEnabled=YES;
        [self.view addSubview:bottomView];

    
    accountRemainLabel = [[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, kSizeFrom750(20), screen_width,kSizeFrom750(30))];
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
    [btn1 addTarget:self action:@selector(OnChongZhi:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setBackgroundColor:RGB(206,14,23)];
    btn1.layer.cornerRadius = kSizeFrom750(10);
    btn1.layer.masksToBounds = YES;
    btn1.tag=1;
    [bottomView addSubview:btn1];

    
    UIView * investView =[[UIView alloc] initWithFrame:CGRectMake(0, accountRemainLabel.bottom+kSizeFrom750(20), screen_width, kSizeFrom750(70))];
    investView.backgroundColor=COLOR_White;
    [bottomView addSubview:investView];
    
    UILabel *investTitle = [[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, 0, kSizeFrom750(170),kSizeFrom750(30))];
    investTitle.centerY = investView.height/2;
    investTitle.font = SYSTEMSIZE(26);
    investTitle.textColor =  RGB(38,38,38);
    investTitle.text=@"投资金额(元)";
    [investView addSubview:investTitle];
    
   //借款最小金额
    _phoneTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(investTitle.right, investTitle.top, kSizeFrom750(500), kSizeFrom750(30))];
    _phoneTextFiled.delegate = self;
    _phoneTextFiled.placeholder = [NSString stringWithFormat:@"投资金额需为%@的倍数",self.baseModel.loan_info.tender_amount_min];
    _phoneTextFiled.font =SYSTEMSIZE(26);
    _phoneTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_phoneTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [investView addSubview:_phoneTextFiled];
    //已经设定投资密码
    if([info.password_status isEqual:@"1"])
    {
        UIView * investPwdView = [[UIView alloc] initWithFrame:CGRectMake(0, investView.bottom, screen_width, investView.height)];
        investPwdView.backgroundColor=COLOR_White;
        [bottomView addSubview:investPwdView];

        UILabel *investPwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, investTitle.top, investTitle.width,investTitle.height)];
        investPwdLabel.font = SYSTEMSIZE(26);
        investPwdLabel.textColor =  RGB(38,38,38);
        investPwdLabel.textAlignment=NSTextAlignmentLeft;
        investPwdLabel.text=@"投资密码";
        [investPwdView addSubview:investPwdLabel];
       
        _passwordTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(_phoneTextFiled.left, investPwdLabel.top, _phoneTextFiled.width, _phoneTextFiled.height)];
        _passwordTextFiled.delegate = self;
        _passwordTextFiled.placeholder = @"请输入投资密码";
        _passwordTextFiled.font =SYSTEMSIZE(26);
        _passwordTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextFiled.secureTextEntry = YES;
        [investPwdView addSubview:_passwordTextFiled];
    }
   
 
    expectLabel = [[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, [info.password_status isEqualToString:@"1"]?(investView.bottom+investView.height+kSizeFrom750(20)):(investView.bottom+kSizeFrom750(20)), screen_width,kSizeFrom750(30))];
    expectLabel.font = SYSTEMSIZE(26);
    expectLabel.textColor =  blackfont;
    NSString *expect = @"预期收益金额0.0元";
    NSMutableAttributedString *attr1 = [CommonUtils diffierentFontWithString:expect rang:[expect rangeOfString:@"0.0"] font:NUMBER_FONT(30) color:COLOR_Red spacingBeforeValue:0 lineSpace:0];
    [expectLabel setAttributedText:attr1];
   [bottomView addSubview:expectLabel];
    
    investBtn = [UIButton buttonWithType:UIButtonTypeCustom];
 
    investBtn.frame = CGRectMake(kOriginLeft,expectLabel.bottom+kSizeFrom750(80), screen_width-kOriginLeft*2, kSizeFrom750(90));
    [investBtn setTitle:@"马上投标" forState:UIControlStateNormal];
    investBtn.titleLabel.font = SYSTEMSIZE(32);
    [investBtn addTarget:self action:@selector(OnTouZhi:) forControlEvents:UIControlEventTouchUpInside];
    [investBtn setBackgroundColor:RGB(200,226,242)];
    investBtn.layer.cornerRadius = investBtn.height/2;
    investBtn.tag=2;
    [bottomView addSubview:investBtn];
}
-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    //点击完成按钮提示内容
    NSString *    str = [_phoneTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(str.length >0)
    {
        if(![self isNum:str])
        {
            [SVProgressHUD showErrorWithStatus: @"投资金额必须是数字"];
            [investBtn setBackgroundColor:RGB(200,226,242)];
            investBtn.userInteractionEnabled = NO;
        }
        else  if([self isNum:str])
        {
            NSInteger num=[str intValue];
            NSString * str1=self.baseModel.loan_info.tender_amount_min;
            NSInteger zuiixao= [str1 intValue];
            if(num>=zuiixao&&(num%zuiixao==0))
            {
                [investBtn setBackgroundColor:navigationBarColor];
                investBtn.userInteractionEnabled = YES;
                [self getInterest];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"投资金额需大于等于%@的倍数",str1]];
                [investBtn setBackgroundColor:RGB(200,226,242)];
                investBtn.userInteractionEnabled = NO;

            }
        }
        
    }
    else{
        
    }
    
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    NSString *    str = [_phoneTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(str.length >0)
    {
        if(![self isNum:str])
        {
            [investBtn setBackgroundColor:RGB(200,226,242)];
            investBtn.userInteractionEnabled = NO;

        }
        else  if([self isNum:str])
        {
            NSInteger num=[str intValue];
            NSString * str1=self.baseModel.loan_info.tender_amount_min;
            NSInteger zuiixao= [str1 intValue];
            if(num>=zuiixao&&(num%zuiixao==0))
            {
                [investBtn setBackgroundColor:navigationBarColor];
                investBtn.userInteractionEnabled = YES;

            }
            else
            {
                [investBtn setBackgroundColor:RGB(200,226,242)];
                investBtn.userInteractionEnabled = NO;
            }
        }
        
    }
    else{
        
        }
}
-(BOOL)checkNum{
  NSString *    str = [_phoneTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(str.length ==0)
    {
        [SVProgressHUD showErrorWithStatus:@"投资金额不能为空"];
         return FALSE;
    }
    else  if(![self isNum:str])
    {
         [SVProgressHUD showErrorWithStatus: @"投资金额必须是数字"];
         return FALSE;
    }
    else  if([self isNum:str])
    {
        NSInteger num=[str intValue];
        NSString * str1=self.baseModel.loan_info.tender_amount_min;
        NSInteger zuiixao= [str1 intValue];
        if(num>=zuiixao&&(num%zuiixao==0))
        {
            [investBtn setBackgroundColor:navigationBarColor];
            return TRUE;
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"投资金额需大于等于%@的倍数",str1]];
            return FALSE;
        }
    }
       return FALSE;
}
- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}


-(void) getRequest{
    NSArray *keys = @[@"loan_id",kToken];
    NSArray *values = @[self.loan_id,[CommonUtils getToken]];
    
    [[HttpCommunication sharedInstance] getSignRequestWithPath:getLoanDetailUrl keysArray:keys valuesArray:values refresh:nil success:^(NSDictionary *successDic) {
        
        self.baseModel = [LoanBase yy_modelWithJSON:successDic];
        self.baseModel.repay_type_name=[[successDic objectForKey:@"repay_type"] objectForKey:@"name"];
        [self initView];
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
-(void)OnChongZhi:(UIButton *) sender
{
    if([CommonUtils isLogin])
    {
        if([self.baseModel.trust_account isEqual:@"1"])
        {
         HomeWebController *discountVC = [[HomeWebController alloc] init];
         discountVC.urlStr=self.baseModel.recharge_url;
          [self.navigationController pushViewController:discountVC animated:YES];
        }
        else
        {
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr= self.baseModel.trust_reg_url;
            [self.navigationController pushViewController:discountVC animated:YES];
        }
    }
    else
    {
        [self OnLogin];
    }
   
}

-(void) OnTouZhi:(UIButton *)sender
{
    BOOL chk=[self checkNum];
    if(chk)
    {
        //如果已经开通托管账号，去投资
        if([self.baseModel.trust_account isEqual:@"1"])
        {
            [self getFormData];
        }
        else
        {
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr= self.baseModel.trust_reg_url;
            [self.navigationController pushViewController:discountVC animated:YES];
            
        }
    }
    else
    {
         [investBtn setBackgroundColor:RGB(200,226,242)];
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
    [[HttpCommunication sharedInstance] getSignRequestWithPath:investUrl keysArray:keys valuesArray:values refresh:nil success:^(NSDictionary *successDic) {
        NSString *interest = [successDic objectForKey:@"interest_total"];
        NSString *expectStr = [NSString stringWithFormat:@"预期收益金额%@元",interest];
        NSMutableAttributedString *attr1 = [CommonUtils diffierentFontWithString:expectStr rang:[expectStr rangeOfString:interest] font:NUMBER_FONT(30) color:COLOR_Red spacingBeforeValue:0 lineSpace:0];
        [self->expectLabel setAttributedText:attr1];
        
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
//
-(void) getFormData{
    
    NSString *    str = [_phoneTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    LoanInfo * info=self.baseModel.loan_info;
    NSString *urlStr = @"";
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
                expectLabel.textColor = RGB(206,14,23);
                expectLabel.text=@"密码不能为空！";
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
    NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[loan_id,amount,loan_password,user_token] forKeys:@[@"loan_id",@"amount",@"loan_password",kToken] ];
    NSMutableArray * array=[[NSMutableArray alloc] init];
    [array addObject:@"loan_id"];
    [array addObject:@"amount"];
    [array addObject:@"loan_password"];
    [array addObject:kToken];
    NSString *sign=[HttpSignCreate GetSignStr:dict_data paixu:array];
    urlStr = [NSString stringWithFormat:tenderNow,oyApiUrl,loan_id,amount,loan_password,user_token,sign];
    NSData * data=  [ggHttpFounction  synHttpGet:urlStr];
    if([ggHttpFounction getJsonIsOk:data])
    {
        NSDictionary * dic= [ggHttpFounction getJsonData1:data];
        NSString * form=[NSString stringWithFormat:@"%@",[dic objectForKey:@"form"]];
       
           NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[form] forKeys:@[@"form"] ];
          NSString *signnew=[HttpSignCreate GetSignStr:dict_data];
        NSString * sigh=[dic objectForKey:@"sign"];
        NSString * url_parame=@"";
        if([signnew isEqual:sigh])
        {
            NSDictionary * postd= [self dictionaryWithJsonString:form ];
             NSString * url=[postd objectForKey:@"url"];
           
            NSString * Version=[postd objectForKey:@"Version"];
            url_parame = [url_parame stringByAppendingFormat:@"%@=%@&",@"Version", Version];
            NSString * CmdId=[postd objectForKey:@"CmdId"];
            url_parame = [url_parame stringByAppendingFormat:@"%@=%@&",@"CmdId", CmdId];
            NSString * MerCustId=[postd objectForKey:@"MerCustId"];
            url_parame = [url_parame stringByAppendingFormat:@"%@=%@&",@"MerCustId", MerCustId];
            NSString * OrdId=[postd objectForKey:@"OrdId"];
            url_parame = [url_parame stringByAppendingFormat:@"%@=%@&",@"OrdId", OrdId];
            NSString * OrdDate=[postd objectForKey:@"OrdDate"];
              OrdDate=[HttpSignCreate encodeString:OrdDate];
            url_parame = [url_parame stringByAppendingFormat:@"%@=%@&",@"OrdDate", OrdDate];
            NSString * TransAmt=[postd objectForKey:@"TransAmt"];
            url_parame = [url_parame stringByAppendingFormat:@"%@=%@&",@"TransAmt", TransAmt];
            NSString * UsrCustId=[postd objectForKey:@"UsrCustId"];
            url_parame = [url_parame stringByAppendingFormat:@"%@=%@&",@"UsrCustId", UsrCustId];
            NSString * MaxTenderRate=[postd objectForKey:@"MaxTenderRate"];
            url_parame = [url_parame stringByAppendingFormat:@"%@=%@&",@"MaxTenderRate", MaxTenderRate];
            NSString * BorrowerDetails=[postd objectForKey:@"BorrowerDetails"];
               BorrowerDetails=[HttpSignCreate encodeString:BorrowerDetails];
            url_parame = [url_parame stringByAppendingFormat:@"%@=%@&",@"BorrowerDetails", BorrowerDetails];
            NSString * IsFreeze=[postd objectForKey:@"IsFreeze"];
            url_parame = [url_parame stringByAppendingFormat:@"%@=%@&",@"IsFreeze", IsFreeze];
            NSString * FreezeOrdId=[postd objectForKey:@"FreezeOrdId"];
            url_parame = [url_parame stringByAppendingFormat:@"%@=%@&",@"FreezeOrdId", FreezeOrdId];
            NSString * RetUrl=[postd objectForKey:@"RetUrl"];
              RetUrl=[HttpSignCreate encodeString:RetUrl];
            url_parame = [url_parame stringByAppendingFormat:@"%@=%@&",@"RetUrl", RetUrl];
            NSString * BgRetUrl=[postd objectForKey:@"BgRetUrl"];
              BgRetUrl=[HttpSignCreate encodeString:BgRetUrl];
            url_parame = [url_parame stringByAppendingFormat:@"%@=%@&",@"BgRetUrl", BgRetUrl];
            NSString * MerPriv=[postd objectForKey:@"MerPriv"];
            url_parame = [url_parame stringByAppendingFormat:@"%@=%@&",@"MerPriv", MerPriv];
            NSString * PageType=[postd objectForKey:@"PageType"];
            url_parame = [url_parame stringByAppendingFormat:@"%@=%@&",@"PageType", PageType];
            NSString * ChkValue=[postd objectForKey:@"ChkValue"];
            url_parame = [url_parame stringByAppendingFormat:@"%@=%@",@"ChkValue", ChkValue];
            [self postFormData:url_parame url:url];
        }
        
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[ggHttpFounction getJsonMsg:data]];//错误提示
    }
}

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
-(void) postFormData:(NSString *) postdata url:(NSString *) url
{
 
    url=[NSString stringWithFormat:@"%@?%@",url,postdata];
    HomeWebController *discountVC = [[HomeWebController alloc] init];
    discountVC.urlStr=url;
    [self.navigationController pushViewController:discountVC animated:YES];
  
}

-(void) OnLogin{
    [self goLoginVC];
}
@end
