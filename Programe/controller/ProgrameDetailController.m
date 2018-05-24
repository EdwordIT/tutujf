//
//  ProgrameNewDetailController.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/13.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "ProgrameDetailController.h"
#import "DetailTop.h"
#import "DetailMiddle.h"
#import "DetailBottom.h"
#import "LoanBase.h"
#import "RepayModel.h"
#import "TenderModel.h"
#import "RushPurchaseController.h"
#import "HomeWebController.h"
#import "TTJFRefreshNormalHeader.h"
@interface ProgrameDetailController ()<UIScrollViewDelegate,BottomDelegate>
{
    NSInteger secondsCountDown;//倒计时总时长
}
Strong     DetailTop * topView;
Strong DetailMiddle * middleView;
Strong DetailBottom * bottomView;
Strong UIScrollView *scrollView;
Strong UIButton *footerBtn;//立即投资、满标待审
Strong LoanBase *baseModel;
@end

@implementation ProgrameDetailController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_CountDown object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_LoginChanged object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleString = @"项目详情";
    secondsCountDown = 0;
    [self.view addSubview:self.scrollView];
    [self initScrollView];
    [self.view addSubview:self.footerBtn];
    [SVProgressHUD show];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownFinished:) name:Noti_CountDownFinished object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRequest) name:Noti_LoginChanged object:nil];//登录状态变更，刷新数据
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    [self getRequest];

    
   
}
#pragma  投资按钮点击事件
-(void)footerBtnClick:(UIButton*)sender
{/***************************1.4.9**********************************************/
    //只要登录状态，就可以跳转进入购买页面，在购买页面再判断是否实名制等内容
    if([CommonUtils isLogin])
    {
        RushPurchaseController * vc=[[RushPurchaseController alloc] init];
        vc.loan_id=  self.loan_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        self.footerBtn.userInteractionEnabled = NO;//进入登陆页面不可点击
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
        _scrollView.backgroundColor =COLOR_Background;
        _scrollView.delegate = self;
        _scrollView.hidden = YES;
        WEAK_SELF;
        _scrollView.mj_header = [TTJFRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf getRequest];
        }];
    }
    return _scrollView;
}
-(UIButton *)footerBtn
{
    if (!_footerBtn) {
        _footerBtn = InitObject(UIButton);
        _footerBtn.frame = RECT(0, screen_height - kTabbarHeight, screen_width, kTabbarHeight);
        _footerBtn.titleLabel.font = SYSTEMSIZE(34);
        [_footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _footerBtn.adjustsImageWhenHighlighted = NO;
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
    
    [self loadLayoutSubViews];
}
-(void)loadLayoutSubViews
{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(kSizeFrom750(300));
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
    self.footerBtn.userInteractionEnabled = YES;//进入登陆页面不可点击
    
    [self.topView loadInfoWithModel:self.baseModel.loan_info];
    
    [self.middleView loadInfoWithModel:self.baseModel];
    
    [self.bottomView loadBottomWithModel:self.baseModel];
    
    //如果是可购买状态，则判断倒计时是否显示，如果显示倒计时，在倒计时结束之前，依然是不可购买状态
    //倒计时
    secondsCountDown = [CommonUtils getDifferenceByDate:self.baseModel.loan_info.open_up_date];//倒计时秒数(48小时换算成的秒数,项目中需要从服务器获取)
    if([self.baseModel.loan_info.open_up_status isEqualToString:@"1"])//如果含有倒计时，则为标的定时抢购
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification:) name:Noti_CountDown object:nil];//添加倒计时
        self.footerBtn.backgroundColor=COLOR_Btn_Unsel;
        self.footerBtn.userInteractionEnabled = NO;
    }else{
         [self.footerBtn setTitle:self.baseModel.loan_info.buy_name forState:UIControlStateNormal];
        //状态，3 可以购买，4满标待审，6还款中，7已还完， 其他 不可购买
        if ([self.baseModel.loan_info.buy_state isEqualToString:@"-1"]) {//满标待审、还款中，则不可点击
            self.footerBtn.backgroundColor=COLOR_Btn_Unsel;
            self.footerBtn.userInteractionEnabled = NO;
           
        }else{
            
            //如果不含倒计时或者倒计时结束，直接显示可购买
            self.footerBtn.backgroundColor=navigationBarColor;
            self.footerBtn.userInteractionEnabled = YES;
        }
    }
    
   
}

//刷新UI后重置scrollView高度
-(void)viewDidLayoutSubviews
{
    //60为segmentcontrol的高度
    CGSize size={screen_width,self.topView.height+self.middleView.height+self.bottomView.height};
    self.scrollView.contentSize =size;
}
-(void)didSelectedBottomAtIndex:(NSInteger)index height:(CGFloat)height
{
    CGFloat segmentControlHeight = kSizeFrom750(120);
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height+segmentControlHeight);
    }];
    [self.scrollView layoutIfNeeded];
    [self viewDidLayoutSubviews];
   
  
}
//获取详情页面数据
-(void) getRequest{
    
    NSArray *keys = @[@"loan_id",kToken];
    NSArray *values = @[self.loan_id,[CommonUtils getToken]];
    
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getLoanDetailUrl keysArray:keys valuesArray:values refresh:self.scrollView success:^(NSDictionary *successDic) {
        
        [[CountDownManager manager] start];
        self.baseModel = [LoanBase yy_modelWithJSON:successDic];
        self.baseModel.repay_type_name=[[successDic objectForKey:@"repay_type"] objectForKey:@"name"];
        [self reloadInfo];
        [self.scrollView setHidden:NO];
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
-(void)countDownNotification:(NSNotification *)noti{
    secondsCountDown--;
    if(secondsCountDown<=0){
        secondsCountDown=0;
        [self.footerBtn setTitle:@"立即投资" forState:UIControlStateNormal];
        self.footerBtn.backgroundColor=navigationBarColor;
        self.footerBtn.userInteractionEnabled = YES;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_CountDown object:nil];
    }
    else
    {
        [self.footerBtn setTitle:[NSString stringWithFormat:@"开抢还剩%@",[CommonUtils getCountDownTime:secondsCountDown]] forState:UIControlStateNormal];
        self.footerBtn.userInteractionEnabled = NO;
    }
}
//项目倒计时结束还未满标，则不能继续投标
-(void)countDownFinished:(NSNotification *)noti{
    [self.footerBtn setTitle:@"还款中" forState:UIControlStateNormal];
    self.footerBtn.userInteractionEnabled = NO;
    self.footerBtn.backgroundColor = COLOR_Btn_Unsel;
    
}


@end
