//
//  ProgrameNewDetailController.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/13.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "ProgrameNewDetailController.h"
#import "DetailTop.h"
#import "DetailMiddle.h"
#import "DetailBottom.h"
#import "LoanBase.h"
#import "LoanInfo.h"
#import "RepayModel.h"
#import "TenderModel.h"
#import "SecurityModel.h"
#import "HttpSignCreate.h"
#import "HttpUrlAddress.h"
#import "ggHttpFounction.h"
#import "AppDelegate.h"
//#import "MBProgressHUD+MP.h"
#import "RushPurchaseController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "Tender.h"
#import "HomeWebController.h"

@interface ProgrameNewDetailController ()<UIScrollViewDelegate,BottomDelegate>
{
    UIScrollView *scrollView;
    UIImageView *navBarHairlineImageView;
    DetailTop * top;
    DetailMiddle * middle;
    DetailBottom * bottom;
    LoanBase * base;
    NSInteger secondsCountDown;//倒计时总时长
    NSTimer *countDownTimer;
 
}
Strong UIButton *footerBtn;//立即投资、满标待审
@end

@implementation ProgrameNewDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"项目详情";
    self.titleView.backgroundColor= RGB(6, 159, 241);
    [self doDataList];
    // Do any additional setup after loading the view.
}
#pragma 头部
-(void) initView{


    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavHight, screen_width, kViewHeight - kBottomButtonHeight )];
    scrollView.backgroundColor =RGB(242,242,242);
    
    scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    scrollView.pagingEnabled = NO; //是否翻页
    scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = YES; // 是否滑动
    scrollView.bounces = NO;
    CGSize size={screen_width,180+500+265};
    scrollView.contentSize =size;
     [self initBody];
    //  [SVProgressHUD showSuccessWithStatus:@"加载完成"];
    
   
}
#pragma  头部事件
-(void)footerBtnClick:(UIButton*)sender
{
    if([CommonUtils isLogin])
    {
        if([base.trust_account isEqual:@"1"])
        {
        RushPurchaseController * vc=[[RushPurchaseController alloc] init];
        vc.loan_id=  self.loan_id;
        vc.vistorType=@"2";
        [vc setBindData:base];
        [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr= base.trust_reg_url;
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
        }
    }
    else{
        
        [self OnLogin];
    }
    
}

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:RGB(255,255,255) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(16) range:NSMakeRange(0, title.length)];
    return title;
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --lazyLoading
-(UIButton *)footerBtn
{
    if (!_footerBtn) {
        _footerBtn = InitObject(UIButton);
        _footerBtn.frame = RECT(0, screen_height - kBottomButtonHeight, screen_width, kBottomButtonHeight);
        _footerBtn.backgroundColor = navigationBarColor;
        _footerBtn.titleLabel.font = SYSTEMSIZE(32);
        [_footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _footerBtn.adjustsImageWhenHighlighted = NO;
        [_footerBtn setTitle:@"立即投资" forState:UIControlStateNormal];
        [_footerBtn addTarget:self action:@selector(footerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerBtn;
}
#pragma  主体
-(void) initBody
{
    Boolean md=TRUE;
       if(middle==nil&&[base.loan_info.status_name isEqual:@"借款中"]&&![base.loan_info.buy_name isEqual:@"还未开始"])
           md=FALSE;
    if(top==nil)
    top=[[DetailTop alloc] initWithFrame:CGRectMake(0, 0, screen_width, 174) data:base];
    [scrollView addSubview:top];
    if(middle==nil&&!md)
        middle=[[DetailMiddle alloc] initWithFrame:CGRectMake(0, top.bottom, screen_width, 260) data:base];
    else if(middle==nil)
         middle=[[DetailMiddle alloc] initWithFrame:CGRectMake(0, top.bottom, screen_width, 215) data:base];
    [scrollView addSubview:middle];
   if(bottom==nil)
        bottom=[[DetailBottom alloc] initWithFrame:CGRectMake(0, middle.bottom, screen_width, scrollView.height - middle.bottom)];
    bottom.delegate=self;
    bottom.userInteractionEnabled=YES;
    [scrollView addSubview:bottom];
    [bottom loadBottomWithModel:base];
    
    [self.view addSubview:scrollView];
    
    [self.view addSubview:self.footerBtn];
    // 设置tableOne尾部
//    if(kDevice_Is_iPhoneX)
//    footerView = [[UIView alloc] initWithFrame:CGRectMake(0,  screen_height-50 -kBottomButtonHeight , screen_width, kBottomButtonHeight)];
//    else
    
    if(base!=nil)
        secondsCountDown = [CommonUtils getDifferenceByDate:base.loan_info.open_up_date];//倒计时秒数(48小时换算成的秒数,项目中需要从服务器获取)
    if(secondsCountDown>0)
    {
        self.footerBtn.backgroundColor=RGB(231,231,231);
        self.footerBtn.userInteractionEnabled = NO;    //设置倒计时显示的时间
        NSInteger hour=(secondsCountDown-(secondsCountDown%3600))/3600;
        NSInteger day=0;
        if(hour>24)
            day= (hour-(hour%24))/24;
        NSString *str_hour = [NSString stringWithFormat:@"%02ld",hour%24];//时
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];//分
        NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];//秒
        NSString *format_time =@"0天0时0分0秒";
        if(secondsCountDown>0)
            format_time = [NSString stringWithFormat:@"%ld天%@时%@分%@秒",day,str_hour,str_minute,str_second];
        
        [self.footerBtn setTitle:format_time forState:UIControlStateNormal];
        if(countDownTimer==nil&&secondsCountDown>0)
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 countDownAction
    }
 
  LoanInfo * info=  base.loan_info;
    if(![info.progress isEqual:@"100.00"])
    {
        //点击事件
            if(secondsCountDown==0)
            {
                self.footerBtn.userInteractionEnabled = YES;
            }
    }
    else
    {
        if([base.loan_info.status_name isEqual:@"满标待审"])
        {
            [self.footerBtn setTitle:base.loan_info.status_name forState:UIControlStateNormal];
            self.footerBtn.userInteractionEnabled = NO;//满标不可点击投资
            self.footerBtn.backgroundColor=RGB(231,231,231);
        }
        else{
            //隐藏底部框
            scrollView.frame=CGRectMake(0, kNavHight, screen_width, kViewHeight);
            self.footerBtn.hidden = YES;
            
        }
    }
   
}



-(void)didSelectedBottomAtIndex:(NSInteger)index height:(CGFloat)height
{
    bottom.height = height+60;
    //60为segmentcontrol的高度
    CGSize size={screen_width,bottom.height+middle.height+top.height};
    scrollView.contentSize =size;
  
}

-(void) doDataList{
    // [SVProgressHUD showWithStatus:@""];
    //[MBProgressHUD showIconMessage:@"" ToView:self.view RemainTime:0.3];
    NSString *urlStr = @"";
    NSString * loan_id=self.loan_id;
    NSString * user_token=@"";
    if([CommonUtils isLogin])
    user_token=[CommonUtils getToken];

    NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[loan_id,user_token] forKeys:@[@"loan_id",kToken] ];
    NSString *sign=[HttpSignCreate GetSignStr:dict_data];
    urlStr = [NSString stringWithFormat:getLoanInfoview1,oyApiUrl,loan_id,user_token,sign];
    NSData * data=  [ggHttpFounction  synHttpGet:urlStr];
    if([ggHttpFounction getJsonIsOk:data])
    {
        NSDictionary * dic1= [ggHttpFounction getJsonData1:data];
         base=[[LoanBase alloc] init];
      
       // NSArray * ary= [dic1 objectForKey:@"items"];
        
            NSDictionary * dic=[dic1 objectForKey:@"loan_info"];
        //项目详情下边儿的产品详情内容
        ProductDetailModel *loanDetailModel = [ProductDetailModel yy_modelWithJSON:[dic1 objectForKey:@"loan_details"]];
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
                  NSDictionary * dtrs=[trs objectAtIndex:k];
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
            base.trust_reg_url=[dic1 objectForKey:@"trust_reg_url"];
            base.balance_amount=[dic1 objectForKey:@"balance_amount"];
            base.loan_details = loanDetailModel;//产品详情
            base.loan_info=info;
            base.security_audit=securitys;
            base.tender_list=tenders;
            base.repay_plan=repays;
          [self initView];
            //[SVProgressHUD showSuccessWithStatus:@"加载成功~"];
    }
    else
    {
          //  [SVProgressHUD showErrorWithStatus:@"网络连接错误~"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络连接错误"  message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
   
    
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) OnLogin{
    [self goLoginVC];
}

-(void) countDownAction{
    //倒计时-1
    secondsCountDown--;
    if(secondsCountDown<=0){
        secondsCountDown=0;
        [self.footerBtn setTitle:@"立即投资" forState:UIControlStateNormal];
        self.footerBtn.backgroundColor=navigationBarColor;
        [countDownTimer invalidate];
        countDownTimer=nil;
    }
    else
    {
        NSInteger hour=secondsCountDown/3600;
        NSInteger day=(hour-(hour%24))/24;
        
        NSString *str_day = [NSString stringWithFormat:@"%0ld",day];
        NSString *str_hour = [NSString stringWithFormat:@"%02ld",hour%24];
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];
        NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];
        // NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
        //修改倒计时标签现实内容
        NSString * dsojisj=[NSString stringWithFormat:@"%@天%@时%@分%@秒",str_day,str_hour,str_minute, str_second];
        [self.footerBtn setTitle:dsojisj forState:UIControlStateNormal];
        self.footerBtn.userInteractionEnabled = NO;
    }
    
}


@end
