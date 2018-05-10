//
//  MineViewController.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/6.
//  Copyright © 2018年 wbzhan. All rights reserved.
//

#import "MineViewController.h"
#import "MineTopCell.h"
#import "MIneMiddleCell.h"
#import "MineMenuCell.h"
#import "OpenAdvertView.h"
#import "HomeWebController.h"
#import "TopScrollMode.h"
#import "AccountInfoController.h"
#import "LoginViewController.h"
#import "AccountTitleView.h"//顶部导航栏
#import "MyAccountModel.h"
#import <MJRefreshNormalHeader.h>
#import "RechargeController.h"//充值
#import "GetCashController.h"//提现
#import "TTJFRefreshNormalHeader.h"
#import "MessageController.h"
@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,MineMenuDelegate,MIneMiddleDelegate,MineTopDelegate,
OpenShowAdvertDelegate>
{
    //如果未绑定银行卡，则弹出此框
    OpenAdvertView *advertView;
    TopScrollMode * scrollmodel;
    MineTopCell *topcell;
    NSArray *middleMenuArray;//我的投资，我的红包，我的资金流向
    CGFloat navTitleHeight;
}
Strong AccountTitleView *accountTitleView;//导航栏视图
Strong MyAccountModel *accountModel;//数据源

@end



@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.backgroundColor = [UIColor clearColor];
    //用于区分X下和普通屏幕下的高度适配问题
    navTitleHeight = kNavHight;
    [self initTableView];
    [self initAdvertMaskView];//托管页面
}
//
-(void) showRegMaskView
{
    NSString  * temp =[NSString stringWithFormat:@"%@",self.accountModel.is_trust_reg];
    if([temp isEqual:@"0"])  //显示托管
    {
        [advertView setHidden:NO];
        [advertView setImageWithUrl:self.accountModel.trust_reg_imgurl];
    }
}

//刷新
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if ([CommonUtils isLogin]) {
        [self getRequest];//后台刷新数据
    }else
    {
        self.accountTitleView.titleLabel.text=@"******";
        self.accountModel.total_amount=@"0.0";
        self.accountModel.to_interest_award=@"0.0";
        self.accountModel.balance_amount=@"0.00";
        self.accountModel.bt_user_content = nil;

        [self.tableView reloadData];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [advertView setHidden:YES];
}
//初始化主界面
-(void)initTableView{

    self.tableView = [[BaseUITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-kTabbarHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    // 设置表格尾部
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView setSeparatorColor:separaterColor];
    
    [self.view addSubview:self.tableView];
    
    [self setUpTableView];
    
    [self.view addSubview:self.accountTitleView];
    
        
}
//点击顶部按钮进入个人以及消息列表页面(需登录)
-(AccountTitleView *)accountTitleView{
    if (!_accountTitleView) {
        _accountTitleView = InitObject(AccountTitleView);
        _accountTitleView.frame = RECT(0, 0, screen_width, navTitleHeight);
        WEAK_SELF;
        _accountTitleView.accountTitleBlock = ^(NSInteger tag) {
          
            if ([CommonUtils isLogin]) {
                if(tag==1)
                {
                    AccountInfoController * account=[[AccountInfoController alloc] init];
                    [weakSelf.navigationController pushViewController:account animated:YES];
                }
                else if(tag==2)
                {
                    MessageController *message = InitObject(MessageController);
                    [weakSelf.navigationController pushViewController:message animated:YES];
                }
            }else{
                    [weakSelf goLoginVC];
            }
           
        };
    }
    return _accountTitleView;
}
//界面表格刷新
-(void)setUpTableView{
   
   __weak typeof(self) weakSelf = self;
    MJRefreshHeader *header  = [TTJFRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getRequest];
    }];
    self.tableView.mj_header = header;

}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section ==0 ){
        return 2;
    }
    else if (section ==1 ){
        return 1;
    }

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        {
            if(indexPath.row==0)
                return kSizeFrom750(470)+navTitleHeight;//顶部抬头+资金信息高度
            else
            {
                return kSizeFrom750(266);//中间菜单栏高度
            }
            
        }
    }else if(indexPath.section == 1){
        if (self.accountModel.bt_user_content==nil) {
            return kSizeFrom750(125)*2;//个人相关操作标签默认高度
        }
      return  self.accountModel.bt_user_content.count*kSizeFrom750(125);
        
    }else
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        return kSizeFrom750(30);
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    if (section==0) {
        headerView.backgroundColor = navigationBarColor;
    }else
        headerView.backgroundColor = COLOR_Background;
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    footerView.backgroundColor = COLOR_Background;
    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if(indexPath.row == 0)
        {
            static NSString *cellIndentifier = @"MineTopCell";
            topcell =  [[MineTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            topcell.accessoryType = UITableViewCellAccessoryNone;
            topcell.selectionStyle=UITableViewCellSelectionStyleNone;
            topcell.delegate=self;
             if(self.accountModel!=nil)
            [topcell setModelData:self.accountModel];
            return topcell;
        }
        else  if(indexPath.row == 1)
        {
            //三个菜单栏→我的投资、我的红包、资金记录
            static NSString *cellIndentifier = @"MIneMiddleCell";
            MIneMiddleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell==nil) {
                cell = [[MIneMiddleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            cell.delegate=self;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell loadInfoWithArray:middleMenuArray];
            return cell;
        }
    }
    else if (indexPath.section == 1) {
        if(indexPath.row == 0)
        {
        static NSString *cellIndentifier = @"MineMenuCell";
        MineMenuCell *cell =  [[MineMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.delegate=self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setMenuData:self.accountModel.bt_user_content];
        return cell;
        }
    }
        return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![CommonUtils isLogin]) {
        [self goLoginVC];
    }
}
//点击底部四个功能菜单
-(void)didMineMenuAtIndex:(NSInteger)index
{
    if([CommonUtils isLogin])
    {
        UserContentModel *model = [self.accountModel.bt_user_content objectAtIndex:index];
        NSString * url=model.link_url;
        HomeWebController *discountVC = [[HomeWebController alloc] init];
        discountVC.urlStr=url;
        [self.navigationController pushViewController:discountVC animated:YES];
    }
    else
    {
        [self goLoginVC];
    }
}
//点击事件
-(void)didopMineAtIndex:(NSInteger)index
{
    if([CommonUtils isLogin])
    {
        if(index==3)//总资产
        {
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr= self.accountModel.total_amount_url;
            [self.navigationController pushViewController:discountVC animated:YES];
        }
        
        else if(index==4)//累计收益
        {
            HomeWebController *discountVC = [[HomeWebController alloc] init];
             discountVC.urlStr= self.accountModel.to_interest_award_url;
            [self.navigationController pushViewController:discountVC animated:YES];
        }
        else if(index==5)//充值
        {
            if (![CommonUtils isVerifyRealName]) {
                [self goRealNameVC];
            }else{
                if ([self.accountModel.is_trust_reg isEqualToString:@"1"]) {
                    RechargeController *recharge = InitObject(RechargeController);
                    [self.navigationController pushViewController:recharge animated:YES];
                }else{
                    HomeWebController *discountVC = [[HomeWebController alloc] init];
                    discountVC.urlStr = self.accountModel.trust_reg_new_link;
                    [self.navigationController pushViewController:discountVC animated:YES];
                }
            }
        }
        else if(index==6)//提现
        {
            if (![CommonUtils isVerifyRealName]) {
                [self goRealNameVC];
            }else{
                if ([self.accountModel.is_trust_reg isEqualToString:@"1"]) {
                    GetCashController *cash = InitObject(GetCashController);
                    [self.navigationController pushViewController:cash animated:YES];
                }else{
                    HomeWebController *discountVC = [[HomeWebController alloc] init];
                    discountVC.urlStr = self.accountModel.trust_reg_new_link;
                    [self.navigationController pushViewController:discountVC animated:YES];
                }
            }
        }
    }
    else
    {
        [self goLoginVC];
    }
}
//点击我的投资、我的红包、资金记录三个按钮
-(void)didTapMIneMiddleAtIndex:(NSInteger)index
{
    if([CommonUtils isLogin])
    {
        if(index==0)
        {
        HomeWebController *discountVC = [[HomeWebController alloc] init];
        discountVC.urlStr=self.accountModel.bt_my_investment.link_url;
        [self.navigationController pushViewController:discountVC animated:YES];
        }
       else if(index==1)
        {
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr=self.accountModel.bt_my_red.link_url;
            [self.navigationController pushViewController:discountVC animated:YES];
        }
       else if(index==2)
        {
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr=self.accountModel.bt_my_capital_log.link_url;
            [self.navigationController pushViewController:discountVC animated:YES];
        }
    }
    else
    {
        [self goLoginVC];
    }
}
/**
 scrollView滑动动态改变导航栏内容高度
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //设置渐变区域高度为120
    CGFloat contentOffset = self.tableView.contentOffset.y - self.tableView.top;
    
//    NSLog(@"contentoffset = %.2f",contentOffset);
    if (contentOffset>0&&contentOffset<120) {
        
        [self.accountTitleView reloadNav:contentOffset];
    }
    if(contentOffset>=0){
        [self.accountTitleView setBackgroundColor:navigationBarColor];//遮挡住tabView，作为导航栏显示，设置背景色
    }
   else  {
       [self.accountTitleView setBackgroundColor:[UIColor clearColor]];
    }
}

//遮罩页
-(void)initAdvertMaskView
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    advertView = [[OpenAdvertView alloc] initWithFrame:keyWindow.bounds];
    advertView.delegate = self;
    [keyWindow addSubview:advertView];
    [advertView setHidden:YES];
}

//点击进入托管账户开通
-(void)didOpenAdvertView:(NSInteger)type
{
     advertView.hidden = YES;
    if(type==2)
    {
       
    }
    else if(type==1)
    {
        if (![CommonUtils isVerifyRealName]) {
            [self goRealNameVC];
        }else{
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr=self.accountModel.trust_reg_new_link;
            [self.navigationController pushViewController:discountVC animated:YES];
        }
    }
}




-(void) getRequest{
    if (![CommonUtils isLogin]) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
  __weak typeof(self) weakSelf = self;
    NSArray *keys = @[kToken];
    NSArray *values = @[[CommonUtils getToken]];
    
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getMyUserDataUrl keysArray:keys valuesArray:values refresh:self.tableView success:^(NSDictionary *successDic) {
    
        [weakSelf loadInfoWithDict:successDic];
    } failure:^(NSDictionary *errorDic) {

    }];


}
//刷新数据
-(void)loadInfoWithDict:(NSDictionary *)dict{
    self.accountModel = [MyAccountModel yy_modelWithJSON:dict];
    [TTJFUserDefault setStr:self.accountModel.is_trust_reg key:isReged];
    //中间三个菜单按钮
    middleMenuArray = @[self.accountModel.bt_my_investment,self.accountModel.bt_my_red,self.accountModel.bt_my_capital_log];
    //消息个数
    if([self.accountModel.message integerValue]==0)
    {//隐藏红点消息
        [self.accountTitleView.rightImage setImage:IMAGEBYENAME(@"icons_msg_unsel") forState:UIControlStateNormal];
    }
    else
    {//显示红点消息
        [self.accountTitleView.rightImage setImage:IMAGEBYENAME(@"icons_msg_sel") forState:UIControlStateNormal];
    }
    //设置昵称
    [TTJFUserDefault setStr:self.accountModel.user_name key:kNikename];
    self.accountTitleView.titleLabel.text = self.accountModel.user_name;
    [self.tableView reloadData];
    [self showRegMaskView];
}
//滑动到底部
//- (CGSize)intrinsicContentSize {
//    return UILayoutFittingExpandedSize;
//}

/**表格数据操作**/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
