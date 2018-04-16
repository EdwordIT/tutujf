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
    UIImageView *navBarHairlineImageView;

    NSInteger secondsCountDown;//倒计时总时长
    NSTimer *countDownTimer;
 
}
Strong     DetailTop * topView;
Strong DetailMiddle * middleView;
Strong DetailBottom * bottomView;
Strong UIScrollView *scrollView;
Strong UIButton *footerBtn;//立即投资、满标待审
Strong LoanBase *baseModel;
@end

@implementation ProgrameNewDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"项目详情";
    self.titleView.backgroundColor= navigationBarColor;
    
    [self.view addSubview:self.scrollView];
    
    [self initScrollView];
    
    [self.view addSubview:self.footerBtn];
    
    [self.scrollView setHidden:YES];
    [self getRequest];
    // Do any additional setup after loading the view.
}
#pragma  投资按钮点击事件
-(void)footerBtnClick:(UIButton*)sender
{
    if([CommonUtils isLogin])
    {
        if([self.baseModel.trust_account isEqual:@"1"])
        {
        RushPurchaseController * vc=[[RushPurchaseController alloc] init];
        vc.loan_id=  self.loan_id;
        [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr= self.baseModel.trust_reg_url;
            [self.navigationController pushViewController:discountVC animated:YES];
        }
    }
    else{
        [self goLoginVC];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --lazyLoading
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavHight, screen_width, kViewHeight - kTabbarHeight)];
        _scrollView.backgroundColor =RGB(242,242,242);
        _scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
        _scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
        _scrollView.delegate = self;
    }
    return _scrollView;
}
-(UIButton *)footerBtn
{
    if (!_footerBtn) {
        _footerBtn = InitObject(UIButton);
        _footerBtn.frame = RECT(0, screen_height - kTabbarHeight, screen_width, kTabbarHeight);
        _footerBtn.backgroundColor = navigationBarColor;
        _footerBtn.titleLabel.font = SYSTEMSIZE(34);
        [_footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _footerBtn.adjustsImageWhenHighlighted = NO;
//        [_footerBtn setTitle:@"立即投资" forState:UIControlStateNormal];
        [_footerBtn addTarget:self action:@selector(footerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerBtn;
}
-(DetailTop *)topView{
    if (!_topView) {
        _topView = InitObject(DetailTop);
    }
    return _topView;
}
-(DetailMiddle *)middleView{
    if (!_middleView) {
        _middleView = InitObject(DetailMiddle);
    }
    return _middleView;
}
-(DetailBottom *)bottomView{
    if (!_bottomView) {
        _bottomView = InitObject(DetailBottom);
        _bottomView.delegate=self;
        _bottomView.userInteractionEnabled=YES;
    }
    return _bottomView;
}
-(void)initScrollView{
    [self.scrollView addSubview:self.topView];
    
    [self.scrollView addSubview:self.middleView];
    
    [self.scrollView addSubview:self.bottomView];
    
    [self loadLayout];
}
-(void)loadLayout
{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(kSizeFrom750(370));
    }];
    
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.width.mas_equalTo(self.topView);
        make.height.mas_equalTo(kSizeFrom750(520));
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.middleView);
        make.top.mas_equalTo(self.middleView.mas_bottom);
        make.height.mas_equalTo(kSizeFrom750(400));
    }];
}
#pragma  主体
-(void) reloadInfo
{
    [self.topView loadInfoWithModel:self.baseModel.loan_info];
    
    [self.middleView loadInfoWithModel:self.baseModel];
    
    [self.bottomView loadBottomWithModel:self.baseModel];
    
    //状态，3 可以购买，4满标待审，6还款中，7已还完， 其他 不可购买
    if ([self.baseModel.loan_info.buy_state isEqualToString:@"-1"]) {//不可购买状态
        self.footerBtn.backgroundColor=RGB(231,231,231);
        self.footerBtn.userInteractionEnabled = NO;
        [self.footerBtn setTitle:self.baseModel.loan_info.status_name forState:UIControlStateNormal];
    }else{
        //如果是可购买状态，则判断倒计时是否显示，如果显示倒计时，在倒计时结束之前，依然是不可购买状态
        //倒计时
        secondsCountDown = [CommonUtils getDifferenceByDate:self.baseModel.loan_info.open_up_date];//倒计时秒数(48小时换算成的秒数,项目中需要从服务器获取)
        if(secondsCountDown>0)
        {
            if(countDownTimer==nil)
                countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
            [countDownTimer fire];
        }else{//如果不含倒计时或者倒计时结束，直接显示可购买
            self.footerBtn.backgroundColor=navigationBarColor;
            self.footerBtn.userInteractionEnabled = YES;
            [self.footerBtn setTitle:self.baseModel.loan_info.status_name forState:UIControlStateNormal];

        }
        
    }
   
   
}



-(void)didSelectedBottomAtIndex:(NSInteger)index height:(CGFloat)height
{
    CGFloat segmentControlHeight = kSizeFrom750(120);
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height+segmentControlHeight);
    }];
//    [self.view layoutIfNeeded];
    //60为segmentcontrol的高度
    CGSize size={screen_width,height+segmentControlHeight+self.middleView.height+self.topView.height};
    self.scrollView.contentSize =size;
  
}
//获取详情页面数据
-(void) getRequest{
    
    
    NSArray *keys = @[@"loan_id",kToken];
    NSArray *values = @[self.loan_id,[CommonUtils getToken]];
    
    [[HttpCommunication sharedInstance] getSignRequestWithPath:getLoanDetailUrl keysArray:keys valuesArray:values refresh:self.scrollView success:^(NSDictionary *successDic) {
    
        self.baseModel = [LoanBase yy_modelWithJSON:successDic];
        self.baseModel.repay_type_name=[[successDic objectForKey:@"repay_type"] objectForKey:@"name"];
        [self reloadInfo];
        [self.scrollView setHidden:NO];
    } failure:^(NSDictionary *errorDic) {
        
    }];
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
        self.footerBtn.userInteractionEnabled = YES;
    }
    else
    {
        NSInteger hour=secondsCountDown/HOUR;
        NSInteger day=(hour-(hour%24))/24;
        
        NSString *str_day = [NSString stringWithFormat:@"%0ld",day];
        NSString *str_hour = [NSString stringWithFormat:@"%02ld",hour%24];
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%HOUR)/MINUTE];
        NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%MINUTE];
        //修改倒计时标签现实内容
        NSString * dsojisj=[NSString stringWithFormat:@"%@天%@时%@分%@秒",str_day,str_hour,str_minute, str_second];
        [self.footerBtn setTitle:dsojisj forState:UIControlStateNormal];
        self.footerBtn.userInteractionEnabled = NO;
    }
    
}


@end
