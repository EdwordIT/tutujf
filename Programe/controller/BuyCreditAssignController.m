//
//  BuyCreditAssignController.m
//  TTJF
//
//  Created by wbzhan on 2018/4/26.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BuyCreditAssignController.h"
#import "LoanBase.h"
#import "MBProgressHUD+MP.h"
#import "SecurityModel.h"
#import "RepayModel.h"
#import "HomeWebController.h"
#import "HomeWebController.h"
#import "RechargeController.h"//充值页面
#define blackfont  RGB(111,187,255)
@interface BuyCreditAssignController ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    UILabel * title;
    UILabel * creditTotalLabel; //转让期数
    UILabel * limitLabel;//借款期限
    UILabel *investLabel;//投资金额
    UILabel *accountrepayTimeLabel;//账户余额
    UILabel * expectLabel;//预期收益金额
    UIButton * investBtn;//投资按钮
    UILabel *repayMethodLabel;//还款方式
    UILabel *repayTimeLabel;//债权转让最终时间
}
Strong UIScrollView *scrollView;
Strong UILabel *waittingLabel;//待收本金
Strong     LoanBase * baseModel;
@end

@implementation BuyCreditAssignController

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
    [self getRequest];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    
}
-(void)reloadInfo
{
    [self.scrollView removeAllSubViews];
    
    LoanInfo * info=self.baseModel.loan_info;
    self.titleString = @"投标";
    UIView * mainview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kSizeFrom750(280))];
    mainview.backgroundColor=navigationBarColor;
    [self.scrollView addSubview:mainview];
    
    //标的名称
    title = [[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, kSizeFrom750(30), kSizeFrom750(500),kSizeFrom750(35))];
    title.font = SYSTEMSIZE(32);
    title.textColor =  COLOR_White;
    title.text=info.name;
    [mainview addSubview:title];
    
    
    UILabel *repayTitle = [[UILabel alloc] initWithFrame:CGRectMake(title.left, title.bottom+kSizeFrom750(20), kSizeFrom750(200),kSizeFrom750(30))];
    repayTitle.font = SYSTEMSIZE(28);
    repayTitle.textColor =  blackfont;
    repayTitle.text=@"还款方式";
    [mainview addSubview:repayTitle];
    
    repayMethodLabel = [[UILabel alloc] initWithFrame:CGRectMake(repayTitle.left, repayTitle.bottom+kSizeFrom750(10), repayTitle.width,repayTitle.height)];
    repayMethodLabel.font = SYSTEMSIZE(28);
    repayMethodLabel.textColor =  COLOR_White;
    repayMethodLabel.text =self.baseModel.repay_type_name;
    [mainview addSubview: repayMethodLabel];
    
    UILabel *creditTitle = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2, repayTitle.top, repayTitle.width,repayTitle.height)];
    creditTitle.font = SYSTEMSIZE(28);
    creditTitle.textColor =  blackfont;
    creditTitle.text=@"转让期数";
    [mainview addSubview:creditTitle];
    
    //转让期数
    creditTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(creditTitle.left, repayMethodLabel.top, repayMethodLabel.width,repayMethodLabel.height)];
    creditTotalLabel.font = SYSTEMSIZE(28);
    creditTotalLabel.textColor =  COLOR_White;
    creditTotalLabel.text=[NSString stringWithFormat:@"%@期/共%@期",self.baseModel.transfer_ret.period,self.baseModel.transfer_ret.total_period];
    [mainview addSubview:creditTotalLabel];
    
    
    UILabel *limitTitle = [[UILabel alloc] initWithFrame:CGRectMake(repayTitle.left, repayMethodLabel.bottom+kSizeFrom750(20), repayTitle.width,repayTitle.height)];
    limitTitle.font = SYSTEMSIZE(28);
    limitTitle.textColor =  blackfont;
    limitTitle.text=@"借款期限";
    [mainview addSubview:limitTitle];
    
    //借款期限
    limitLabel = [[UILabel alloc] initWithFrame:CGRectMake(repayMethodLabel.left, limitTitle.bottom+kSizeFrom750(10), repayMethodLabel.width,repayMethodLabel.height)];
    limitLabel.font = SYSTEMSIZE(28);
    limitLabel.textColor =  COLOR_White;
    limitLabel.text=[NSString stringWithFormat:@"%@",info.period_name];
    [mainview addSubview:limitLabel];
    
    
    
    UILabel *repayTimeTitle = [[UILabel alloc] initWithFrame:CGRectMake(creditTitle.left, limitTitle.top, limitTitle.width,limitTitle.height)];
    repayTimeTitle.font = SYSTEMSIZE(28);
    repayTimeTitle.textColor =  blackfont;
    repayTimeTitle.text=@"还款期限";
    [mainview addSubview:repayTimeTitle];
    
    //还款期限(下次回款时间)
    repayTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(repayTimeTitle.left, repayTimeTitle.bottom+kSizeFrom750(10), repayTimeTitle.width,repayTimeTitle.height)];
    repayTimeLabel.font = SYSTEMSIZE(28);
    repayTimeLabel.textColor =  COLOR_White;
    repayTimeLabel.text = self.baseModel.transfer_ret.next_repay_time;
    [mainview addSubview: repayTimeLabel];
    
    self.waittingLabel = [[UILabel alloc]initWithFrame:RECT(0, mainview.bottom, screen_width, kSizeFrom750(88))];
    self.waittingLabel.backgroundColor = RGB(39, 141 ,233);
    self.waittingLabel.text = [NSString stringWithFormat:@"待收本金：%@",[@"¥" stringByAppendingString:[CommonUtils getHanleNums:self.baseModel.transfer_ret.wait_principal]]];
    self.waittingLabel.textAlignment = NSTextAlignmentCenter;
    self.waittingLabel.textColor = COLOR_White;
    [self.scrollView addSubview:self.waittingLabel];
    
#pragma mark --余额
    
    UIView * bottomView =[[UIView alloc] initWithFrame:CGRectMake(0, self.waittingLabel.bottom, screen_width, kViewHeight - self.waittingLabel.bottom)];
    
    bottomView.backgroundColor=COLOR_Background;
    bottomView.userInteractionEnabled=YES;
    [self.scrollView addSubview:bottomView];
    
    
    accountrepayTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, kSizeFrom750(20), screen_width,kSizeFrom750(30))];
    accountrepayTimeLabel.font = SYSTEMSIZE(26);
    accountrepayTimeLabel.textColor =  blackfont;
    NSString *account = [NSString stringWithFormat:@"账户余额%@元",[NSString stringWithFormat:@"%.2f",[self.baseModel.balance_amount floatValue]]];
    NSMutableAttributedString *attr = [CommonUtils diffierentFontWithString:account rang:[account rangeOfString:[NSString stringWithFormat:@"%.2f",[self.baseModel.balance_amount floatValue]]] font:NUMBER_FONT(30) color:COLOR_Red spacingBeforeValue:0 lineSpace:0];
    [accountrepayTimeLabel setAttributedText:attr];
    [bottomView addSubview:accountrepayTimeLabel];
    
    UIButton * btn1 = [[UIButton alloc]initWithFrame:CGRectMake(screen_width-kSizeFrom750(140),0, kSizeFrom750(120), kSizeFrom750(50))];
    btn1.centerY = accountrepayTimeLabel.centerY;
    [btn1 setTitle:@"充值" forState:UIControlStateNormal];
    btn1.titleLabel.font = SYSTEMSIZE(26);
    [btn1 addTarget:self action:@selector(rechargeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setBackgroundColor:COLOR_Red];
    btn1.layer.cornerRadius = kSizeFrom750(10);
    btn1.layer.masksToBounds = YES;
    btn1.tag=1;
    [bottomView addSubview:btn1];
    
    
    UIView * investView =[[UIView alloc] initWithFrame:CGRectMake(0, accountrepayTimeLabel.bottom+kSizeFrom750(20), screen_width, kSizeFrom750(80))];
    investView.backgroundColor=COLOR_White;
    [bottomView addSubview:investView];
    
    UILabel *investTitle = [[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, 0, kSizeFrom750(130),kSizeFrom750(30))];
    investTitle.centerY = investView.height/2;
    investTitle.font = SYSTEMSIZE(26);
    investTitle.textColor =  RGB_51;
    investTitle.text=@"转让价格";
    [investView addSubview:investTitle];
   
    UILabel *invest = [[UILabel alloc] initWithFrame:CGRectMake(investTitle.right, 0, kSizeFrom750(300),kSizeFrom750(30))];
    invest.centerY = investView.height/2;
    invest.font = NUMBER_FONT(26);
    invest.textColor =  COLOR_Red;
    invest.text=[NSString stringWithFormat:@"%@元",self.baseModel.transfer_ret.actual_amount];
    [investView addSubview:invest];
    
    expectLabel = [[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, investView.bottom+kSizeFrom750(20), screen_width,kSizeFrom750(30))];
    expectLabel.font = SYSTEMSIZE(26);
    expectLabel.textColor =  blackfont;
    NSString *expect =[NSString stringWithFormat:@"预期收益金额%@元",self.baseModel.transfer_ret.wait_interest];
    NSMutableAttributedString *attr1 = [CommonUtils diffierentFontWithString:expect rang:[expect rangeOfString:self.baseModel.transfer_ret.wait_interest] font:NUMBER_FONT(30) color:COLOR_Red spacingBeforeValue:0 lineSpace:0];
    [expectLabel setAttributedText:attr1];
    [bottomView addSubview:expectLabel];
    
    investBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    investBtn.frame = CGRectMake(kOriginLeft,expectLabel.bottom+kSizeFrom750(80), screen_width-kOriginLeft*2, kSizeFrom750(90));
    [investBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    investBtn.titleLabel.font = SYSTEMSIZE(32);
    [investBtn addTarget:self action:@selector(investBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [investBtn setBackgroundColor:RGB(200,226,242)];
    investBtn.layer.cornerRadius = investBtn.height/2;
    investBtn.tag=2;
    [bottomView addSubview:investBtn];
}



-(void) getRequest{
    NSArray *keys = @[@"transfer_id",kToken];
    NSArray *values = @[self.transfer_id,[CommonUtils getToken]];
    
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getCreditAssignDetailUrl keysArray:keys valuesArray:values refresh:nil success:^(NSDictionary *successDic) {
        
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
 
        //如果已经开通托管账号，去投资
        if([self.baseModel.trust_account isEqual:@"1"])
        {
            [self getFormData];
        }
        else
        {
            if ([CommonUtils isVerifyRealName]) {
                HomeWebController *discountVC = [[HomeWebController alloc] init];
                discountVC.urlStr= self.baseModel.trust_reg_url;
                [self.navigationController pushViewController:discountVC animated:YES];
            }else{
                [self goRealNameVC];
            }
        }
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//立即投资
-(void) getFormData{
    
    NSArray *keys = @[@"transfer_id",kToken];
    NSArray *values = @[self.transfer_id,[CommonUtils getToken]];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:postTransferUrl keysArray:keys valuesArray:values refresh:nil success:^(NSDictionary *successDic) {
        NSString * form=[NSString stringWithFormat:@"%@",[successDic objectForKey:@"form"]];//json字符串
        NSDictionary *formDic = [[HttpCommunication sharedInstance] dictionaryWithJsonString:form];//转化为json
        NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[form] forKeys:@[@"form"] ];
        NSString *signnew=[HttpSignCreate GetSignStr:dict_data];
        NSString * sign=[successDic objectForKey:@"sign"];
        if ([signnew isEqualToString:sign]) {
            NSArray *keys = [formDic allKeys];
            
            NSString * url_parame=@"";
            NSString * url=[formDic objectForKey:@"url"];
            for (int i=0; i<keys.count; i++) {
                NSString *key = [keys objectAtIndex:i];
                
                NSString *keyValue = [formDic objectForKey:key];
                //                NSString *  newValue = [keyValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                NSString *  newValue = [HttpSignCreate encodeString:keyValue];
                
                if ([key isEqualToString:@"url"]) {
                    continue;
                }
                if (i==keys.count-1) {
                    url_parame = [url_parame stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,newValue]];
                }else
                    url_parame = [url_parame stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,newValue]];
            }
            [HttpSignCreate encodeString:url_parame];
            [self postFormData:url_parame url:url];
            
        }else{
            [SVProgressHUD showInfoWithStatus:@"投资失败"];
        }
        
    } failure:^(NSDictionary *errorDic) {
        
    }];
}

//进入汇付支付页面
-(void) postFormData:(NSString *) postdata url:(NSString *) url
{
    
    url=[NSString stringWithFormat:@"%@?%@",url,postdata];
    HomeWebController *discountVC = [[HomeWebController alloc] init];
    discountVC.urlStr=url;
    [self.navigationController pushViewController:discountVC animated:YES];
    
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
