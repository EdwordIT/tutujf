//
//  CreditAssignDetailController.m
//  TTJF
//
//  Created by wbzhan on 2018/4/26.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "CreditAssignDetailController.h"
#import "DetailTop.h"
#import "DetailMiddle.h"
#import "DetailBottom.h"
#import "LoanBase.h"
#import "RepayModel.h"
#import "TenderModel.h"
#import "BuyCreditAssignController.h"
#import "HomeWebController.h"
#import "TTJFRefreshNormalHeader.h"
@interface CreditAssignDetailController ()<UIScrollViewDelegate,BottomDelegate>

Strong     DetailTop * topView;
Strong DetailMiddle * middleView;
Strong DetailBottom * bottomView;
Strong UIScrollView *scrollView;
Strong UIButton *footerBtn;//立即购买
Strong LoanBase *baseModel;
@end

@implementation CreditAssignDetailController
-(void)dealloc{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleString = @"债权详情";
    [self.view addSubview:self.scrollView];
    [self initScrollView];
    [self.view addSubview:self.footerBtn];
    [SVProgressHUD show];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    [self getRequest];
    
    
    
}
#pragma  投资按钮点击事件
-(void)footerBtnClick:(UIButton*)sender
{
    if([CommonUtils isLogin])
    {
        if([self.baseModel.trust_account isEqual:@"1"])
        {
            BuyCreditAssignController * vc=[[BuyCreditAssignController alloc] init];
            vc.transfer_id=  self.transfer_id;
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
        make.height.mas_equalTo(kSizeFrom750(370));
    }];
    
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.width.mas_equalTo(self.topView);
        make.height.mas_equalTo(kSizeFrom750(610));
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
    [self.topView loadCreditInfoWithModel:self.baseModel];
    
    [self.middleView loadCreditInfoWithModel:self.baseModel];
    
    [self.bottomView loadBottomWithModel:self.baseModel];
    
    [self.footerBtn setTitle:self.baseModel.transfer_ret.buy_name forState:UIControlStateNormal];
    
    if([self.baseModel.transfer_ret.buy_state isEqualToString:@"-1"])//不可购买状态
    {
        self.footerBtn.backgroundColor=COLOR_Btn_Unsel;
        self.footerBtn.userInteractionEnabled = NO;
    }else{
     
        self.footerBtn.backgroundColor=navigationBarColor;
        self.footerBtn.userInteractionEnabled = YES;
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
    
    NSArray *keys = @[@"transfer_id",kToken];
    NSArray *values = @[self.transfer_id,[CommonUtils getToken]];
    
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getCreditAssignDetailUrl keysArray:keys valuesArray:values refresh:self.scrollView success:^(NSDictionary *successDic) {
        self.baseModel = [LoanBase yy_modelWithJSON:successDic];
        self.baseModel.repay_type_name=[[successDic objectForKey:@"repay_type"] objectForKey:@"name"];
        [self reloadInfo];
        [self.scrollView setHidden:NO];
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

@end
