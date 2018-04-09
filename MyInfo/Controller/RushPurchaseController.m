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
//#import  "DZWKWebViewController.h"
#import "HomeWebController.h"
#import "Tender.h"

#define lightfont RGB(255,255,255)
#define blackfont  RGB(111,187,255)
@interface RushPurchaseController ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    // UIScrollView *scrollView ;
    UILabel * title;
    UILabel * yqnhsy; //预期年化收益
    UILabel *hkfs;
    UILabel * jkqx;
    UILabel * syktje;//
    UILabel *tzje;
    UILabel *zhyelab;
    UILabel * yqsyje;
    UIImageView *navBarHairlineImageView;
    LoanBase * base;
    UIButton * toubiao;
   //UIWebView *iWebView;
}
@property (nonatomic ,strong)UITextField *phoneTextFiled;
@property (nonatomic ,strong)UITextField *passwordTextFiled;
@end

@implementation RushPurchaseController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor=separaterColor;
    if([self.vistorType isEqual:@"1"])
    {
       [self doDataList];
    }
    
    // Do any additional setup after loading the view.
}

-(void)setBindData:(LoanBase *)data
{
    
        base=data;
        [self initView];
}


-(void)initView
{
    LoanInfo * info=base.loan_info;
    self.titleString = @"投标";
//    // 头部事件
//    UILabel *navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 120, 44)];
//    navTitleLabel.numberOfLines=0;//可能出现多行的标题
//    [navTitleLabel setAttributedText:[self changeTitle:@"投标"]];
//    navTitleLabel.textAlignment = NSTextAlignmentCenter;
//    navTitleLabel.backgroundColor = [UIColor clearColor];
//    self.navigationItem.titleView = navTitleLabel;
//
//    [self.navigationController.navigationBar setBackgroundColor:RGB(17, 140, 236)];
//    self.navigationController.navigationBar.translucent = NO;
//    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
//    //  self.view.backgroundColor=RGB(17, 140, 236);
//    [self.navigationItem setLeftBarButtonItem:leftBarButton];
//    CGRect frame = self.navigationItem.leftBarButtonItem.customView.frame;
//    frame.size.width=80;
//    frame.size.height=44;
//    self.navigationItem.leftBarButtonItem.customView.frame = frame;
    
    UIView * mainview=[[UIView alloc] initWithFrame:CGRectMake(0, kNavHight, screen_width, 171)];
    mainview.backgroundColor=RGB(17, 162, 236);
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, screen_width-40,16)];
    title.font = CHINESE_SYSTEM(16);
    title.textColor =  lightfont;
    title.textAlignment=NSTextAlignmentLeft;
    title.text=info.name;
    [mainview addSubview:title];
    
    UILabel *yqnhsylab = [[UILabel alloc] initWithFrame:CGRectMake(15, 56, screen_width/2,14)];
    yqnhsylab.font = CHINESE_SYSTEM(14);
    yqnhsylab.textColor =  blackfont;
    yqnhsylab.textAlignment=NSTextAlignmentLeft;
    yqnhsylab.text=@"预期年化收益";
    [mainview addSubview:yqnhsylab];
    
    yqnhsy = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, screen_width/2,14)];
    yqnhsy.font = CHINESE_SYSTEM(14);
    yqnhsy.textColor =  lightfont;
    yqnhsy.textAlignment=NSTextAlignmentLeft;
    yqnhsy.text=[[NSString stringWithFormat:@"%@",info.apr] stringByAppendingString:@"%"];;
     [mainview addSubview:yqnhsy];
    
    UILabel *hkfs = [[UILabel alloc] initWithFrame:CGRectMake(15, 111, screen_width/2,14)];
    hkfs.font = CHINESE_SYSTEM(14);
    hkfs.textColor =   blackfont;
    hkfs.textAlignment=NSTextAlignmentLeft;
    hkfs.text=@"还款方式";
    [mainview addSubview:hkfs];

    hkfs = [[UILabel alloc] initWithFrame:CGRectMake(15, 134, screen_width/2,14)];
    hkfs.font = CHINESE_SYSTEM(14);
    hkfs.textColor =  lightfont;
    hkfs.textAlignment=NSTextAlignmentLeft;

    hkfs.text =base.repay_type_name;
   // dqhblx.text=@"54,0000,00元";
    [mainview addSubview:hkfs];
    
    UILabel *jkqxlab = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2, 56, screen_width/2,14)];
    jkqxlab.font = CHINESE_SYSTEM(14);
    jkqxlab.textColor =  blackfont;
    jkqxlab.textAlignment=NSTextAlignmentLeft;
    jkqxlab.text=@"借款期限";
    [mainview addSubview:jkqxlab];
    
    jkqx = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2, 80, screen_width/2,14)];
    jkqx.font = CHINESE_SYSTEM(14);
    jkqx.textColor =  lightfont;
    jkqx.textAlignment=NSTextAlignmentLeft;
    jkqx.text=info.period_name;
    [mainview addSubview:jkqx];
    
    UILabel *syktjelb = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2, 111, screen_width/2,14)];
    syktjelb.font = CHINESE_SYSTEM(14);
    syktjelb.textColor =  blackfont;
    syktjelb.textAlignment=NSTextAlignmentLeft;
    syktjelb.text=@"剩余可投金额";
    [mainview addSubview:syktjelb];
    
    
    syktje = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2, 134, screen_width/2,14)];
    syktje.font = CHINESE_SYSTEM(14);
    syktje.textColor =  lightfont;
    syktje.textAlignment=NSTextAlignmentLeft;
    NSString * str3=[NSString stringWithFormat:@"%@",info.left_amount];
    NSString * temp =  [NSString stringWithFormat:@"%@元",[self hanleNums:str3]];
    syktje.text =temp;
    // dqhblx.text=@"54,0000,00元";
    [mainview addSubview:syktje];
    [self.view addSubview:mainview];
    
      UIView * bhyecell=[[UIView alloc] initWithFrame:CGRectMake(0, 171, screen_width, 400)];

       bhyecell.backgroundColor=separaterColor;
       bhyecell.userInteractionEnabled=YES;
      zhyelab = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 300,13)];
       zhyelab.font = CHINESE_SYSTEM(13);
       zhyelab.textColor =  blackfont;
       zhyelab.textAlignment=NSTextAlignmentLeft;
       zhyelab.text= [NSString stringWithFormat:@"账户余额%@元",[NSString stringWithFormat:@"%.2f",[base.balance_amount floatValue]]];
    zhyelab.text=[zhyelab.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSInteger index=[ zhyelab.text rangeOfString:@"额"].location;
    NSInteger len=[ zhyelab.text  length];
     //[UIFont fontWithName:@"Helvetica" size:15]
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString: zhyelab.text];
    [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(13) range:NSMakeRange(0, index+1)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(86,86,86) range:NSMakeRange(0, index+1)];
    [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(14) range:NSMakeRange(index+1,len-index-1)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(206,14,23)  range:NSMakeRange(index+1, len-index-1)];
    [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(13) range:NSMakeRange(len-1, 1)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(86,86,86) range:NSMakeRange(len-1, 1)];
    [zhyelab setAttributedText:textColor];
     [bhyecell addSubview:zhyelab];
    
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn1.frame = CGRectMake(screen_width-65,10, 50, 25);
    [btn1 setTitle:@"充值" forState:UIControlStateNormal];
    btn1.titleLabel.font = CHINESE_SYSTEM(13);
    [btn1 addTarget:self action:@selector(OnChongZhi:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setBackgroundColor:RGB(206,14,23)];
    [btn1.layer setCornerRadius:4]; //设置矩形四个圆角半径
    btn1.tag=1;
    [bhyecell addSubview:btn1];

    [self.view addSubview:bhyecell];
    
    UIView * tzjecell=[[UIView alloc] initWithFrame:CGRectMake(0, 216, screen_width, 45)];
    tzjecell.backgroundColor=RGB(255,255,255);
    UILabel *tzjelab = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, screen_width/2,13)];
    tzjelab.font = CHINESE_SYSTEM(13);
    tzjelab.textColor =  RGB(38,38,38);
    tzjelab.textAlignment=NSTextAlignmentLeft;
    tzjelab.text=@"投资金额(元)";
    [tzjecell addSubview:tzjelab];
    
     tzje = [[UILabel alloc] initWithFrame:CGRectMake(50, 16, screen_width/2,13)];
    tzje.font = CHINESE_SYSTEM(13);
    tzje.textColor =  RGB(218,218,218);
    tzje.textAlignment=NSTextAlignmentLeft;
    tzje.text=@"需50的倍数";
   // [tzjecell addSubview:tzje];
   //借款最小金额
    _phoneTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(100, 8, 271, 30)];
    _phoneTextFiled.delegate = self;
    _phoneTextFiled.placeholder = @"需50的倍数";
    _phoneTextFiled.font =CHINESE_SYSTEM(13);
    _phoneTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_phoneTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingDidEnd];
    [tzjecell addSubview:_phoneTextFiled];
    
    if([info.password_status isEqual:@"1"])
    {
        UIView * tzjecell1=[[UIView alloc] initWithFrame:CGRectMake(0, 271, screen_width, 45)];
        tzjecell1.backgroundColor=RGB(255,255,255);
        UILabel *tzjelab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, screen_width/2,13)];
        tzjelab1.font = CHINESE_SYSTEM(13);
        tzjelab1.textColor =  RGB(38,38,38);
        tzjelab1.textAlignment=NSTextAlignmentLeft;
        tzjelab1.text=@"投资密码";
        [tzjecell1 addSubview:tzjelab1];
       
    _passwordTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(100, 8, 271, 30)];
    _passwordTextFiled.delegate = self;
    _passwordTextFiled.placeholder = @"请输入投资密码";
    _passwordTextFiled.font =CHINESE_SYSTEM(13);
    _passwordTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTextFiled.secureTextEntry = YES;
    [tzjecell1 addSubview:_passwordTextFiled];
            [self.view addSubview:tzjecell1];
    }
   
    [self.view addSubview:tzjecell];
 
    yqsyje = [[UILabel alloc] initWithFrame:CGRectMake(15, 105, 300,13)];
    if([info.password_status isEqual:@"1"])
        yqsyje.frame=CGRectMake(15, 160, 300,13);
    yqsyje.font = CHINESE_SYSTEM(13);
    yqsyje.textColor =  blackfont;
    yqsyje.textAlignment=NSTextAlignmentLeft;
    yqsyje.text=@"预期收益金额0.0元";
    
    NSInteger indexq=[ yqsyje.text rangeOfString:@"额"].location;
    NSInteger len1=[ yqsyje.text  length];
    NSMutableAttributedString *textColor1 = [[NSMutableAttributedString alloc]initWithString: yqsyje.text];
    [textColor1 addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(13) range:NSMakeRange(0, indexq+1)];
    [textColor1 addAttribute:NSForegroundColorAttributeName value:RGB(86,86,86) range:NSMakeRange(0, indexq+1)];
     [textColor1 addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(14) range:NSMakeRange(indexq+1,len1-indexq-1)];
     [textColor1 addAttribute:NSForegroundColorAttributeName value:RGB(206,14,23)  range:NSMakeRange(indexq+1, len1-indexq-1)];
      [textColor1 addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(13) range:NSMakeRange(len1-1, 1)];
    [textColor1 addAttribute:NSForegroundColorAttributeName value:RGB(86,86,86) range:NSMakeRange(len1-1, 1)];
    [yqsyje setAttributedText:textColor1];
    
    [bhyecell addSubview:yqsyje];
    
   // [self.view addSubview:tzjecell];
    
    toubiao = [UIButton buttonWithType:UIButtonTypeCustom];
    if([info.password_status isEqual:@"1"])
      toubiao.frame = CGRectMake(15,386, screen_width-30, 45);
    else
    toubiao.frame = CGRectMake(15,331, screen_width-30, 45);
    [toubiao setTitle:@"马上投标" forState:UIControlStateNormal];
    toubiao.titleLabel.font = CHINESE_SYSTEM(16);
    [toubiao addTarget:self action:@selector(OnTouZhi:) forControlEvents:UIControlEventTouchUpInside];
    [toubiao setBackgroundColor:RGB(200,226,242)];
    [toubiao.layer setCornerRadius:22.5]; //设置矩形四个圆角半径
    toubiao.tag=2;
    [self.view addSubview:toubiao];
    //    [loginButton setBackgroundColor:RGB(200,226,242)];
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
      NSString *    str = [_phoneTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(str.length >0)
    {
        if(![self isNum:str])
        {
            [self showMessage: @"投资金额必须是数字"];
               [toubiao setBackgroundColor:RGB(200,226,242)];
        }
        else  if([self isNum:str])
        {
            NSInteger num=[str intValue];
            NSString * str1=base.loan_info.tender_amount_min;
            NSInteger zuiixao= [str1 intValue];
            if(num>=zuiixao&&(num%zuiixao==0))
            {
                [toubiao setBackgroundColor:navigationBarColor];
                [self getShouYi];
            }
            else
            {
                [self showMessage: [NSString stringWithFormat:@"投资金额需大于等于%@的倍数",str1]];
                [toubiao setBackgroundColor:RGB(200,226,242)];
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
        [self showMessage: @"投资金额不能为空"];
         return FALSE;
    }
    else  if(![self isNum:str])
    {
         [self showMessage: @"投资金额必须是数字"];
         return FALSE;
    }
    else  if([self isNum:str])
    {
        NSInteger num=[str intValue];
        NSString * str1=base.loan_info.tender_amount_min;
        NSInteger zuiixao= [str1 intValue];
        if(num>=zuiixao&&(num%zuiixao==0))
        {
            [toubiao setBackgroundColor:navigationBarColor];
            // yqsyje.textColor =  blackfont;
            return TRUE;
        }
        else
        {
            [self showMessage: [NSString stringWithFormat:@"投资金额需大于等于%@的倍数",str1]];
            return FALSE;
        }
    }
       return FALSE;
}
-(void) showMessage:(NSString*) msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg  message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}


-(void) doDataList{
    [MBProgressHUD showIconMessage:@"" ToView:self.view RemainTime:0.3];
    NSString *urlStr = @"";
    NSString * loan_id=self.loan_id;
    NSString * user_token=@"";
    if([CommonUtils isLogin])
        user_token=[CommonUtils getToken];
    
    NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[loan_id,user_token] forKeys:@[@"loan_id",kToken] ];
    NSString *sign=[HttpSignCreate GetSignStr:dict_data];
    urlStr = [NSString stringWithFormat:getLoanInfoview1,oyApiUrl,loan_id,user_token,sign];
      //  urlStr=@"http://cs.api.tutujf.com/api/Loan/GetLoanInfoview?//loan_id=653&user_token=lmaqvmynascvbisfnllmxrfpuuzdwr&sign=d097e3fafaf9d1d0";
    NSData * data=  [ggHttpFounction  synHttpGet:urlStr];
    if([ggHttpFounction getJsonIsOk:data])
    {
        NSDictionary * dic1= [ggHttpFounction getJsonData1:data];
        base=[[LoanBase alloc] init];
        
        // NSArray * ary= [dic1 objectForKey:@"items"];
        
        NSDictionary * dic=[dic1 objectForKey:@"loan_info"];
        LoanInfo * info=[[LoanInfo alloc] init];
        
        info.name=[dic objectForKey:@"name"];
        info.serialno=[dic objectForKey:@"serialno"];
        info.id=[dic objectForKey:@"ind"];
        info.amount=[dic objectForKey:@"amount"];
        info.credited_amount=[dic objectForKey:@"credited_amount"];
        info.apr=[dic objectForKey:@"apr"];
        info.additional_status=[dic objectForKey:@"additional_status"];
        info.activity_url_img=[dic objectForKey:@"activity_url_img"];
        info.activity_img_width=[dic objectForKey:@"activity_img_width"];
        info.type_period_name=[dic objectForKey:@"type_period_name"];
        info.period=[dic objectForKey:@"period"];
        info.tender_amount_min=[dic objectForKey:@"tender_amount_min"];
        info.period_name=[dic objectForKey:@"period_name"];
        info.status_name=[dic objectForKey:@"status_name"];
        info.overdue_time_date=[dic objectForKey:@"overdue_time_date"];
        info.contents_url=[dic objectForKey:@"contents_url"];
        
        info.tender_count=[dic objectForKey:@"tender_count"];
        info.buy_state=[dic objectForKey:@"buy_state"];
        info.buy_name=[dic objectForKey:@"buy_name"];
        
        info.open_up_date=[dic objectForKey:@"open_up_date"];
        info.open_up_status=[dic objectForKey:@"open_up_status"];
        info.password_status=[NSString stringWithFormat:@"%@",[dic objectForKey:@"password_status"]];
        
        info.progress=[dic objectForKey:@"progress"];
        info.left_amount=[dic objectForKey:@"left_amount"];
        info.select_type_img=[dic objectForKey:@"select_type_img"];
        info.select_type_img_width=[dic objectForKey:@"select_type_img_width"];
        info.select_type_img_height=[dic objectForKey:@"select_type_img_height"];
        info.select_type_img=[dic objectForKey:@"select_type_img"];
        
        NSArray  * security_audit=[dic1 objectForKey:@"security_audit"]; //
        // NSArray  *  tender_list=[dic1 objectForKey:@"tender_list"];  //
        NSDictionary  *  repayd=[dic1 objectForKey:@"repay_plan"];//
        NSArray * repay_plan=[repayd objectForKey:@"items"];
        
        
        NSMutableArray  * securitys=[[NSMutableArray alloc] init];
        for(int k=0;k<security_audit.count;k++)
        {
            SecurityModel * security=[[SecurityModel alloc] init];
            security.title=[[security_audit objectAtIndex:k] objectForKey:@"title"];
            security.contents=[[security_audit objectAtIndex:k] objectForKey:@"contents"];
            [securitys addObject:security];
        }
        
        NSDictionary * dd= [dic1 objectForKey:@"tender_list"];
        TenderModel * tenders=[[TenderModel alloc] init];
        
        if([dd objectForKey:@"is_show_tenlist"]!=nil)
            tenders.is_show_tenlist=[dd objectForKey:@"is_show_tenlist"];
        else
            tenders.is_show_tenlist=@"";
        if([dd objectForKey:@"not_lktenlist_title"]!=nil)
            tenders.not_lktenlist_title=[dd objectForKey:@"not_lktenlist_title"];
        else
            tenders.not_lktenlist_title=@"";
        NSMutableArray  * tens=[[NSMutableArray alloc] init];
        if([dd objectForKey:@"items"]!=nil&&[tenders.not_lktenlist_title isEqual:@""])
        {
            NSArray * trs=[dd objectForKey:@"items"];
            for(int k=0;k<trs.count;k++)
            {
                Tender * tr=[[Tender alloc] init];
                NSDictionary * dtrs=[trs objectAtIndex:0];
                tr.member_name=[dtrs objectForKey:@"member_name"];
                tr.add_time=[dtrs objectForKey:@"add_time"];
                tr.amount=[dtrs objectForKey:@"amount"];
                [tens addObject:tr];
            }
        }
        tenders.items=tens;
        
        
        NSMutableArray  * repays=[[NSMutableArray alloc] init];
        for(int k=0;k<repay_plan.count;k++)
        {
            RepayModel * repay=[[RepayModel alloc] init];
            NSDictionary * dd= [repay_plan objectAtIndex:k];
            if([dd objectForKey:@"items"]!=nil)
                repay.items=[dd objectForKey:@"items"];
            else
                repay.items=@[];
            if([dd objectForKey:@"total"]!=nil)
                repay.total=[NSString stringWithFormat:@"%@",[dd objectForKey:@"total"]];
            else
                repay.total=@"";
            if([dd objectForKey:@"type_name"]!=nil)
                repay.type_name=[dd objectForKey:@"type_name"];
            else
                repay.type_name=@"";
            if([dd objectForKey:@"repay_date"]!=nil)
                repay.repay_date=[dd objectForKey:@"repay_date"];
            else
                repay.repay_date=@"";
            if([dd objectForKey:@"repay_type_name"]!=nil)
                repay.repay_type_name=[dd objectForKey:@"repay_type_name"];
            else
                repay.repay_type_name=@"";
            if([repayd objectForKey:@"display"]!=nil)
                repay.display=[repayd objectForKey:@"display"];
            else
                repay.display=@"";
            [repays addObject:repay];
        }
        
        base.loan_id=[NSString stringWithFormat:@"%@",[dic1 objectForKey:@"loan_id"]];
        base.user_token=[dic1 objectForKey:kToken];
        base.repay_type_name=[[dic1 objectForKey:@"repay_type"] objectForKey:@"name"];
        base.islogin=[dic1 objectForKey:@"islogin"];
        base.trust_account=[NSString stringWithFormat:@"%@",[dic1 objectForKey:@"trust_account"]];
        base.recharge_url=[dic1 objectForKey:@"recharge_url"];
        base.balance_amount=[dic1 objectForKey:@"balance_amount"];
        base.trust_reg_url=[dic1 objectForKey:@"trust_reg_url"];
        base.loan_info=info;
        base.security_audit=securitys;
        base.tender_list=tenders;
        base.repay_plan=repays;
        [self initView];
    }
    else
    {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络连接错误"  message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    
    
    
}
//导航返回刷新
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//       [self.navigationController.navigationBar setHidden:NO];
       self.tabBarController.tabBar.hidden=YES;
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//     self.navigationController.navigationBarHidden = NO;
//          self.tabBarController.tabBar.hidden=YES;
//    UIImageView* blackLineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
//    //默认显示黑线
//    blackLineImageView.hidden = YES;
    
}
#pragma 事件响应方法

-(void)OnChongZhi:(UIButton *) sender
{
    if([CommonUtils isLogin])
    {
        if([base.trust_account isEqual:@"1"])
        {
         HomeWebController *discountVC = [[HomeWebController alloc] init];
         discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/member/recharge",oyUrlAddress];
          discountVC.returnmain=@"3"; //页返回
          [self.navigationController pushViewController:discountVC animated:YES];
        }
        else
        {
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr= base.trust_reg_url;
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
          //            base.trust_reg_url=[dic1 objectForKey:@"trust_reg_url"];
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
        if([base.trust_account isEqual:@"1"])
        {
        [self getFormData];
        }
        else
        {
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr= base.trust_reg_url;
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
            
        }
    }
    else
    {
         [toubiao setBackgroundColor:RGB(200,226,242)];
    }
}

- (NSString *)hanleNums:(NSString *)numbers{
     numbers=[numbers stringByReplacingOccurrencesOfString:@".00" withString:@""];
    NSString *str = [numbers substringWithRange:NSMakeRange(numbers.length%3, numbers.length-numbers.length%3)];
    NSString *strs = [numbers substringWithRange:NSMakeRange(0, numbers.length%3)];
    for (int  i =0; i < str.length; i =i+3) {
        NSString *sss = [str substringWithRange:NSMakeRange(i, 3)];
        strs = [strs stringByAppendingString:[NSString stringWithFormat:@",%@",sss]];
    }
    if ([[strs substringWithRange:NSMakeRange(0, 1)] isEqualToString:@","]) {
        strs = [strs substringWithRange:NSMakeRange(1, strs.length-1)];
    }
    strs = [strs stringByAppendingString:@".00"];
    return strs;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//找查到Nav底部的黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}



////设置左边按键
//- (UIButton *)leftBtn
//{
//    UIButton *  _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
//    [_leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
//    [_leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateHighlighted];
//    [_leftBtn addTarget:self action:@selector(left_button_event:) forControlEvents:UIControlEventTouchUpInside];
//    // _leftBtn.imageView.frame=CGRectMake(10, 0, 10.5, 21);
//    _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(-6, -70, 0, 10);
//    return _leftBtn;
//}

//设置左边事件
-(void)left_button_event:(UIButton*)sender
{
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
////设置标题
//-(NSMutableAttributedString*)setTitle
//{
//    return [self changeTitle:@"投标"];
//}

//-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
//{
//    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
//    [title addAttribute:NSForegroundColorAttributeName value:RGB(255,255,255) range:NSMakeRange(0, title.length)];
//    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
//    return title;
//}

//-(void)set_Title:(NSMutableAttributedString *)title
//{
//    UILabel *navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
//    navTitleLabel.numberOfLines=0;//可能出现多行的标题
//    [navTitleLabel setAttributedText:title];
//    navTitleLabel.textAlignment = NSTextAlignmentCenter;
//    navTitleLabel.backgroundColor = [UIColor clearColor];
//    navTitleLabel.userInteractionEnabled = YES;
//
////   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleClick:)];
// //   [navTitleLabel addGestureRecognizer:tap];
//    self.navigationItem.titleView = navTitleLabel;
//}



#pragma mark -- left_button
//-(BOOL)leftButton
//{
//    BOOL isleft =  [self respondsToSelector:@selector(set_leftButton)];
//    if (isleft) {
//        UIButton *leftbutton = [self set_leftButton];
//        [leftbutton addTarget:self action:@selector(left_click:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
//        self.navigationItem.leftBarButtonItem = item;
//    }
//    return isleft;
//}
//-(void)backPressed:(UIButton *)sender{
//
//    if ([self respondsToSelector:@selector(left_button_event:)]) {
//        [self left_button_event:sender];
//    }
//}
//-(void)left_click:(id)sender
//{
//    if ([self respondsToSelector:@selector(left_button_event:)]) {
//        [self left_button_event:sender];
//    }
//}


#pragma  头部事件
//- (UIButton *)set_leftButton
//{
//    UIButton *  _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
//    [_leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
//    [_leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateHighlighted];
//    [_leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    //_leftBtn.imageView.frame=CG(10, 0, 10.5, 21);
//    _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
//    return _leftBtn;
//}
//响应事件
//-(void)leftBtnClick:(UIButton *)sender
//{
//    if([self.vistorType isEqual:@"1"])
//      [self.navigationController setNavigationBarHidden:YES animated:NO];
//    else  if([self.vistorType isEqual:@"2"])
//          [self.navigationController setNavigationBarHidden:NO animated:NO];
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
-(void)OnTapClickView:(UIGestureRecognizer*)Tap
{
    
}

-(void) getShouYi
{
    NSString *    str = [_phoneTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    LoanInfo * info=base.loan_info;
    NSString *urlStr = @"";
    NSString * amount=str;
    NSString * period=info.period; //
    NSString * apr=info.apr; //
    NSString * repay_type=base.repay_type_name; //
    
    NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[amount,period,apr,repay_type] forKeys:@[@"amount",@"period",@"apr",@"repay_type"] ];
    NSString *sign=[HttpSignCreate GetSignStr:dict_data];
    repay_type=[HttpSignCreate encodeString:repay_type];
    urlStr = [NSString stringWithFormat:investInterest,oyApiUrl,amount,period,apr,repay_type,sign];
    NSData * data=  [ggHttpFounction  synHttpGet:urlStr];
    if([ggHttpFounction getJsonIsOk:data])
    {
        NSDictionary * dic= [ggHttpFounction getJsonData1:data];
        yqsyje.text=[NSString stringWithFormat: @"预期收益金额%@元", [dic objectForKey:@"interest_total"]];
        NSInteger indexq=[ yqsyje.text rangeOfString:@"额"].location;
        NSInteger len1=[ yqsyje.text  length];
        NSMutableAttributedString *textColor1 = [[NSMutableAttributedString alloc]initWithString: yqsyje.text];
        [textColor1 addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(13) range:NSMakeRange(0, indexq+1)];
        [textColor1 addAttribute:NSForegroundColorAttributeName value:RGB(86,86,86) range:NSMakeRange(0, indexq+1)];
        [textColor1 addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(14) range:NSMakeRange(indexq+1,len1-indexq-1)];
        [textColor1 addAttribute:NSForegroundColorAttributeName value:RGB(206,14,23)  range:NSMakeRange(indexq+1, len1-indexq-1)];
        [textColor1 addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(13) range:NSMakeRange(len1-1, 1)];
        [textColor1 addAttribute:NSForegroundColorAttributeName value:RGB(86,86,86) range:NSMakeRange(len1-1, 1)];
        [yqsyje setAttributedText:textColor1];
    }
    else
    {
        //yqsyje.text=@"网络问题：预期收益金额无法获取";
    }
}

-(void) getFormData{
    
    NSString *    str = [_phoneTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    LoanInfo * info=base.loan_info;
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
                yqsyje.textColor = RGB(206,14,23);
                yqsyje.text=@"密码不能为空！";
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
         yqsyje.textColor = RGB(206,14,23);
        yqsyje.text= [ggHttpFounction getJsonMsg:data];
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
//@"key1=value1&key2=value2...."
-(void) postFormData:(NSString *) postdata url:(NSString *) url
{
 
    url=[NSString stringWithFormat:@"%@?%@",url,postdata];
    HomeWebController *discountVC = [[HomeWebController alloc] init];
    discountVC.returnmain=@"3";
    discountVC.urlStr=url;    
    [self.navigationController pushViewController:discountVC animated:YES];
  
}

-(void) OnLogin{
    [self goLoginVC];
}

//加载网页
/*
- (void)loadPage1: (NSString *) urlstr {
    if(iWebView==nil)
    {
     iWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 0,0)];
     [self.view  addSubview:iWebView];
        iWebView.delegate=self;
    }
    NSURL *url = [[NSURL alloc] initWithString:urlstr];
    NSMutableURLRequest *request ;
     [iWebView loadRequest:request];
}
*/
#pragma mark-UIWebViewDelegate
/**
 *WebView开始加载资源的时候调用（开始发送请求）
 */
/*
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSString *  currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    currentURL=[currentURL stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *  currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    currentURL=[currentURL stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
}
 */
@end
