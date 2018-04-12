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
#import "AppDelegate.h"
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
    [self initSubViews];
    [self getRequest];
    // Do any additional setup after loading the view.
}
#pragma 头部
-(void) initSubViews{


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
        bottom=[[DetailBottom alloc] initWithFrame:CGRectMake(0, middle.bottom, screen_width, kSizeFrom750(400))];
    bottom.delegate=self;
    bottom.userInteractionEnabled=YES;
    [scrollView addSubview:bottom];
    [bottom loadBottomWithModel:base];
    
    [self.view addSubview:scrollView];
    
    [self.view addSubview:self.footerBtn];
    
    if(base!=nil)
        secondsCountDown = [CommonUtils getDifferenceByDate:base.loan_info.open_up_date];//倒计时秒数(48小时换算成的秒数,项目中需要从服务器获取)
    if(secondsCountDown>0)
    {
        self.footerBtn.backgroundColor=RGB(231,231,231);
        self.footerBtn.userInteractionEnabled = NO;    //设置倒计时显示的时间
        NSInteger hour=(secondsCountDown-(secondsCountDown%HOUR))/HOUR;
        NSInteger day=0;
        if(hour>24)
            day= (hour-(hour%24))/24;
        NSString *str_hour = [NSString stringWithFormat:@"%02ld",hour%24];//时
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%HOUR)/MINUTE];//分
        NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%MINUTE];//秒
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
    bottom.height = height+kSizeFrom750(120);
    //60为segmentcontrol的高度
    CGSize size={screen_width,bottom.height+middle.height+top.height};
    scrollView.contentSize =size;
  
}
//获取详情页面数据
-(void) getRequest{
    
    
    NSArray *keys = @[@"loan_id",kToken];
    NSArray *values = @[self.loan_id,[CommonUtils getToken]];
    
    [[HttpCommunication sharedInstance] getSignRequestWithPath:getLoanDetailUrl keysArray:keys valuesArray:values refresh:nil success:^(NSDictionary *successDic) {
        
        base = [LoanBase yy_modelWithJSON:successDic];
        base.repay_type_name=[[successDic objectForKey:@"repay_type"] objectForKey:@"name"];
        [self initBody];
        
    } failure:^(NSDictionary *errorDic) {
        
    }];
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
        NSInteger hour=secondsCountDown/HOUR;
        NSInteger day=(hour-(hour%24))/24;
        
        NSString *str_day = [NSString stringWithFormat:@"%0ld",day];
        NSString *str_hour = [NSString stringWithFormat:@"%02ld",hour%24];
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%HOUR)/MINUTE];
        NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%MINUTE];
        // NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
        //修改倒计时标签现实内容
        NSString * dsojisj=[NSString stringWithFormat:@"%@天%@时%@分%@秒",str_day,str_hour,str_minute, str_second];
        [self.footerBtn setTitle:dsojisj forState:UIControlStateNormal];
        self.footerBtn.userInteractionEnabled = NO;
    }
    
}


@end
