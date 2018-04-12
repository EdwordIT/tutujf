//
//  MineViewController.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/6.
//  Copyright © 2018年 wbzhan. All rights reserved.
//

#import "MineViewController.h"
#import "HttpSignCreate.h"
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
@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,MineMenuDelegate,MIneMiddleDelegate,MineTopDelegate,
OpenShowAdvertDelegate>
{
    //如果未绑定银行卡，则弹出此框
    OpenAdvertView *advertView;
    TopScrollMode * scrollmodel;
    Boolean isFirstExe;
    MineTopCell *topcell;
    NSArray *middleMenuArray;//我的投资，我的红包，我的资金流向
    CGFloat navTitleHeight;
}
Strong AccountTitleView *accountTitleView;//导航栏视图
Strong MyAccountModel *accountModel;//数据源
Strong UIView *refreshView;//视觉上刷新
Strong UILabel *refreshLabel;//刷新内容显示
Strong UIImageView *refreshImage;//刷新箭头
@end



@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //用于区分X下和普通屏幕下的高度适配问题
    navTitleHeight = kSizeFrom750(160)+kStatusBarHeight;
    isFirstExe=FALSE;;
    [self initTableView];
    
    [self initAdvertMaskView];//托管页面
 // Do any additional setup after loading the view.
}
//
-(void) showRegMaskView
{
    NSString  * temp =[NSString stringWithFormat:@"%@",self.accountModel.is_trust_reg] ;
    if([temp isEqual:@"0"])  //显示托管
    {
        [advertView setHidden:NO];
        [advertView setImageWithUrl:self.accountModel.trust_reg_imgurl];
    }
}
//GetMyUserDatas
//视图出现时操作
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
      if([CommonUtils isLogin])
      {
        if(!isFirstExe)
        {
            isFirstExe=TRUE;
            [self GetMyUserDatas];
        }
        else if(self.accountModel!=nil)
        {
            self.accountTitleView.titleLabel.text=[CommonUtils getNikename];
         }
      }
}

//导航返回刷新
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(![CommonUtils isLogin])
    {
        self.accountTitleView.titleLabel.text=@"******";
        if(self.accountModel!=nil)
        {
            self.accountModel.total_amount=@"0.0";
            self.accountModel.to_interest_award=@"0.0";
            self.accountModel.balance_amount=@"0.00";
            if(topcell!=nil)
            [topcell setModelData:self.accountModel];
        }
    }
    else if(self.accountModel!=nil)
    {
        self.accountTitleView.hidden = NO;
        self.accountTitleView.titleLabel.text = [CommonUtils getNikename];
        
    }
    [self viewWillLayoutSubviews];
}
//添加刷新View
-(void)loadRrereshView
{
    self.refreshView = [[UIView alloc]initWithFrame:RECT(0, -screen_height, screen_width, screen_height)];
    self.refreshView.backgroundColor = navigationBarColor;
    [self.view addSubview:self.refreshView];
    
    self.refreshImage = [[UIImageView alloc]initWithFrame:RECT(0, screen_height - kSizeFrom750(90), kSizeFrom750(46), kSizeFrom750(46))];
    [self.refreshImage setImage:IMAGEBYENAME(@"refresh_mine")];
    self.refreshImage.centerX = self.refreshView.width/2;
    [self.refreshView addSubview:self.refreshImage];
    
    self.refreshLabel = [[UILabel alloc]initWithFrame:RECT(0, self.refreshImage.bottom+kSizeFrom750(10), self.refreshView.width, kSizeFrom750(30))];
    self.refreshLabel.textAlignment = NSTextAlignmentCenter;
    self.refreshLabel.textColor = [UIColor whiteColor];
    self.refreshLabel.font = SYSTEMSIZE(24);
    self.refreshLabel.text = @"下拉即可刷新";
    [self.refreshView addSubview:self.refreshLabel];
    
}
/**表格数据操作**/
//初始化主界面
-(void)initTableView{

    if(iOS11)
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -kStatusBarHeight, screen_width, screen_height+kStatusBarHeight) style:UITableViewStyleGrouped];
    }else
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-kTabbarHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor= RGB_246;
    // 设置表格尾部
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView setSeparatorColor:separaterColor];
    
    [self.view addSubview:self.tableView];
    
    [self setUpTableView];
    
    [self loadRrereshView];
    
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
                    //消息列表
                    HomeWebController *discountVC = [[HomeWebController alloc] init];
                    discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/message/list",oyUrlAddress];
                    [weakSelf.navigationController pushViewController:discountVC animated:YES];
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
    MJRefreshHeader *header  = [MJRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf GetMyUserDatas];
    }];
    header.backgroundColor = navigationBarColor;
    self.tableView.mj_header = header;
    // 马上进入刷新状态
    if ([CommonUtils isLogin]) {
        [self GetMyUserDatas];
    }

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
                return kSizeFrom750(450)+navTitleHeight;//顶部抬头+资金信息高度
            else
            {
                return kSizeFrom750(266);//中间菜单栏高度
            }
            
        }
    }else if(indexPath.section == 1){
        if (self.accountModel==nil) {
            return kSizeFrom750(125)*4;//个人相关操作标签默认高度
        }
      return  self.accountModel.bt_user_content.count*kSizeFrom750(125);
        
    }else
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    else if (section == 1) {
        return kSizeFrom750(30);
    } else if (section == 2) {
        return 0.01;
    }
    else{
        return 0.01;
    }
}




-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    headerView.backgroundColor =RGB_246;
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    footerView.backgroundColor = RGB_246;
    
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
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!self.accountModel) {
                [cell setMenuData:nil];
            }else
                [cell setMenuData:self.accountModel.bt_user_content];
        return cell;
        }
    }
   
        return nil;
}
/**在viewWillAppear方法中加入：
 [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];**/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([CommonUtils isLogin])
    {
        
    }
    else
    {
        [self goLoginVC];
    }
}
//点击顶部菜单栏
-(void)didMyTopAtIndex:(NSInteger)index
{
   if([CommonUtils isLogin])
   {
     
   }
    else
    {
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
        discountVC.returnmain=@"3"; //页返回
        [self.navigationController pushViewController:discountVC animated:YES];
    }
    else
    {
        [self goLoginVC];
    }
}

-(void)didopMineAtIndex:(NSInteger)index
{
    if([CommonUtils isLogin])
    {
        if(index==1)
        {
            AccountInfoController * account=[[AccountInfoController alloc] init];
           [self.navigationController pushViewController:account animated:YES];
        }
        else if(index==2)
        {
            HomeWebController *discountVC = [[HomeWebController alloc] init];
              discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/message/list",oyUrlAddress];
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
        }
        else if(index==3)
        {
            HomeWebController *discountVC = [[HomeWebController alloc] init];
             discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/member/account",oyUrlAddress];
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
        }
        
        else if(index==4)
        {
            HomeWebController *discountVC = [[HomeWebController alloc] init];
             discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/member/accounttwo",oyUrlAddress];
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
        }
        else if(index==5)
        {
            NSString  * temp =[NSString stringWithFormat:@"%@",self.accountModel.is_trust_reg] ;
            if([temp isEqual:@"0"])  //显示托管
            {
                HomeWebController *discountVC = [[HomeWebController alloc] init];
                discountVC.urlStr=[NSString stringWithFormat:@"%@/%@",oyUrlAddress,self.accountModel.trust_reg_link];
                discountVC.returnmain=@"3"; //页返回
                [self.navigationController pushViewController:discountVC animated:YES];
            }
            else
            {
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/member/recharge",oyUrlAddress];
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
            }
        }
        else if(index==6)
        {
             NSString  * temp =[NSString stringWithFormat:@"%@",self.accountModel.is_trust_reg] ;
            if([temp isEqual:@"0"])  //显示托管
        {
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr=[NSString stringWithFormat:@"%@/%@",oyUrlAddress,self.accountModel.trust_reg_link];
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
        }
            else
            {
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/member/cash",oyUrlAddress];
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
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
        discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/member/mytender",oyUrlAddress];
        discountVC.returnmain=@"3"; //页返回
        [self.navigationController pushViewController:discountVC animated:YES];
        }
       else if(index==1)
        {
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/member/bounty",oyUrlAddress];
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
        }
       else if(index==2)
        {
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/account/accountLog",oyUrlAddress];
            discountVC.returnmain=@"3"; //页返回
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
    //设置渐变区域高度为100
    CGFloat contentOffset = self.tableView.contentOffset.y - self.tableView.top;
    
//    NSLog(@"contentoffset = %.2f",contentOffset);
    if (contentOffset>0&&contentOffset<100) {
        
        [self.accountTitleView reloadNav:contentOffset];
    }
    if(contentOffset>=0){
        self.refreshView.top = -screen_height;
        [self.accountTitleView setBackgroundColor:navigationBarColor];//遮挡住tabView，作为导航栏显示，设置背景色
    }
   else  {
       [self.accountTitleView setBackgroundColor:[UIColor clearColor]];
        self.refreshView.top = -screen_height-contentOffset;
       if (ABS(contentOffset)<=navTitleHeight/2) {
           self.refreshImage.transform = CGAffineTransformMakeRotation(M_PI);
           self.refreshLabel.text = @"下拉刷新";
       }else{
           [UIView animateWithDuration:0.3 animations:^{
               self.refreshImage.transform = CGAffineTransformMakeRotation(M_PI*2);
           }];
           self.refreshLabel.text = @"松开即刻刷新";
       }
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


-(void)didOpenAdvertView:(NSInteger)type
{
     advertView.hidden = YES;
    if(type==2)
    {
       
    }
    else if(type==1)
    {
        HomeWebController *discountVC = [[HomeWebController alloc] init];
        discountVC.urlStr=[NSString stringWithFormat:@"%@/%@",oyUrlAddress,self.accountModel.trust_reg_link];
        discountVC.returnmain=@"3"; //页返回
        [self.navigationController pushViewController:discountVC animated:YES];
    }
}




-(void) GetMyUserDatas{
    if (![CommonUtils isLogin]) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
  __weak typeof(self) weakSelf = self;
    NSArray *keys = @[kToken];
    NSArray *values = @[[CommonUtils getToken]];
    
    [[HttpCommunication sharedInstance] getSignRequestWithPath:getMyUserDataUrl keysArray:keys valuesArray:values refresh:self.tableView success:^(NSDictionary *successDic) {
   
        [weakSelf loadInfoWithDict:successDic];
    } failure:^(NSDictionary *errorDic) {
       
    }];


}
//刷新数据
-(void)loadInfoWithDict:(NSDictionary *)dict{
    self.accountModel = [MyAccountModel yy_modelWithJSON:dict];
    //中间三个菜单按钮
    middleMenuArray = @[self.accountModel.bt_my_investment,self.accountModel.bt_my_red,self.accountModel.bt_my_capital_log];
    //消息个数
    if([self.accountModel.message integerValue]==0)
    {//隐藏消息
        self.accountTitleView.rightImage.selected = NO;
    }
    else
    {//显示红点消息
        self.accountTitleView.rightImage.selected = YES;
    }
    //设置昵称
    [TTJFUserDefault setStr:self.accountModel.user_name key:kNikename];
    self.accountTitleView.titleLabel.text = self.accountModel.user_name;
    isFirstExe=FALSE;
    [self.tableView reloadData];
    [self showRegMaskView];
}
- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

/**表格数据操作**/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
