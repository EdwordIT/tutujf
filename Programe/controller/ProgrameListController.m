//
//  ProgrameListController.m
//  TTJF
//
//  Created by 占碧光 on 2017/10/3.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "ProgrameListController.h"
#import "MJRefresh.h"
#import "QuicklyCell.h"
#import "QuicklyModel.h"
#import "HomeWebController.h"
#import "RushPurchaseController.h"
#import "ProgrameNewDetailController.h"
#import "CountDownManager.h"
#import "NavSwitchView.h"
#import "CreditAssignCell.h"
#import "CreditAssignDetailController.h"//债权详情
#import "BuyCreditAssignController.h"//债权购买
#import "CreditModel.h"
@interface ProgrameListController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>
Assign  BOOL isGetCredit;
Assign NSInteger currentPage;/**< 页数 */
Assign NSInteger total_pages;/**总的页数**/
Assign NSInteger creditPage;
Assign NSInteger creDitTotlaPages;//债权总页数
Strong NSMutableArray *dataSourceArray;
Strong NSMutableArray *creditDataArray;//债权转让数据
Strong NavSwitchView *switchView;//标题切换
Strong UIScrollView *backScroll;//
Strong BaseUITableView *creditTabView;//债权转让
@end

@implementation ProgrameListController
-(void)dealloc{
   
    [[CountDownManager manager] cancel];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"项目列表";
    [self.backBtn setHidden:YES];
    self.currentPage = 1;//默认选项
    self.total_pages=1;
    self.creditPage = 1;
    self.creDitTotlaPages = 1;
    
    [self.view addSubview:self.backScroll];
    [self.view addSubview:self.switchView];
    [self.backScroll addSubview:self.tableView];//投资列表
    [self.backScroll addSubview:self.creditTabView];//债权转让
    [self loadRefresh];
    [self getRequest];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
}
#pragma mark -- lazyLoading
-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = InitObject(NSMutableArray);
    }
    return _dataSourceArray;
}
-(NSMutableArray *)creditDataArray{
    if (!_creditDataArray) {
        _creditDataArray = InitObject(NSMutableArray);
    }
    return _creditDataArray;
}
-(NavSwitchView *)switchView{
    if (!_switchView) {
        _switchView = [[NavSwitchView alloc]initWithFrame:RECT(0, 0, screen_width, kNavHight) Array:@[@"投资专区",@"债券转让"]];
        WEAK_SELF;
        _switchView.switchBlock = ^(NSInteger tag) {
            if (tag==1) {
                if (!weakSelf.isGetCredit) {
                    weakSelf.isGetCredit = YES;
                    [weakSelf getCreditRequest];
                }
            }
          //切换视图
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.backScroll.contentOffset = CGPointMake(screen_width*tag, 0);
            }];
           
        };
    }
    return _switchView;
}
-(UIScrollView *)backScroll{
    if (!_backScroll) {
        _backScroll = [[UIScrollView alloc]initWithFrame:RECT(0, kNavHight, screen_width, kViewHeight - kTabbarHeight)];
        _backScroll.contentSize = CGSizeMake(screen_width*2, _backScroll.height);
        _backScroll.showsHorizontalScrollIndicator = NO;//水平
        _backScroll.pagingEnabled = YES;
        _backScroll.delegate = self;
    }
    return _backScroll;
}
//投资列表
-(BaseUITableView *)tableView{
    if (!_tableView) {
        _tableView = [[BaseUITableView alloc]initWithFrame:RECT(0, 0, screen_width, self.backScroll.height) style:UITableViewStyleGrouped];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.rowHeight = kSizeFrom750(278);
            _tableView.showsVerticalScrollIndicator = NO;
        }
    return _tableView;
}
//债券转让
-(BaseUITableView *)creditTabView{
    if (!_creditTabView) {
        _creditTabView = [[BaseUITableView alloc]initWithFrame:RECT(screen_width, 0, screen_width, self.backScroll.height) style:UITableViewStyleGrouped];
        _creditTabView.delegate = self;
        _creditTabView.dataSource = self;
        _creditTabView.rowHeight = kSizeFrom750(278);
        _creditTabView.showsVerticalScrollIndicator = NO;
    }
    return _creditTabView;
}
//界面表格刷新
-(void)loadRefresh{
    WEAK_SELF;
    //加载无数据页面内容
    self.tableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        self.currentPage = 1;
        [weakSelf getRequest];
    }];
    self.creditTabView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        self.creditPage = 1;
        [weakSelf getCreditRequest];
    }];
    [self.tableView ly_startLoading];
    [self.creditTabView ly_startLoading];
    
    //投资列表
     self.tableView.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [weakSelf getRequest];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [weakSelf loadMoreData];
    }];
  //债权转让
    self.creditTabView.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        self.creditPage = 1;
        [weakSelf getCreditRequest];
    }];
    
    self.creditTabView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.creditPage++;
        [weakSelf loadMoreCreditData];
    }];
}
#pragma mark --UIScrollViewDelegate
//拖动结束调用此方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==self.backScroll) {
        self.switchView.selectIndex = scrollView.contentOffset.x/screen_width;
    }
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.creditTabView) {
        return [self.creditDataArray count];
    }else
        return [self.dataSourceArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kSizeFrom750(20);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    headerView.backgroundColor = COLOR_Background;
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    footerView.backgroundColor =COLOR_Background;
    return footerView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (tableView==self.tableView) {
        QuicklyModel * model=[_dataSourceArray objectAtIndex:indexPath.row];
        ProgrameNewDetailController * vc=[[ProgrameNewDetailController alloc] init];
        vc.loan_id=model.loan_id;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //债权转让
        CreditModel *model = [self.creditDataArray objectAtIndex:indexPath.row];
        CreditAssignDetailController *detail = InitObject(CreditAssignDetailController);
        detail.transfer_id = model.transfer_id;
        [self.navigationController pushViewController:detail animated:YES];
    }
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.tableView) {
        static  NSString *cellIndentifier = @"QuicklyCell";
        QuicklyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if(cell == nil)
        {
            cell = [[QuicklyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
        }
        
        QuicklyModel * programeModel=[self.dataSourceArray objectAtIndex:indexPath.row];
        [cell setQuicklyModel:programeModel];
        WEAK_SELF;
        cell.investBlock = ^{
            [weakSelf investWithModel:programeModel];//抢购
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        //债权转让
        static NSString *cellId = @"CreditAssignCell";
        CreditAssignCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell = [[CreditAssignCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        }
        CreditModel *model = [self.creditDataArray objectAtIndex:indexPath.row];
        [cell loadInfoWithModel:model];
        WEAK_SELF;
        cell.buyBlock = ^{
            [weakSelf buyCreditWithModel:model];
        };
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        
        return cell;
    }
   
}

#pragma mark --数据获取request
//获取投资列表数据
-(void)getRequest{

    NSArray *keys = @[@"page"];
    NSArray *values = @[[NSString stringWithFormat:@"%ld",self.currentPage]];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getLoanListUrl keysArray:keys valuesArray:values refresh:self.tableView success:^(NSDictionary *successDic) {
        if(self.currentPage==1)
            [ self.dataSourceArray removeAllObjects];
        self.total_pages=[[NSString stringWithFormat:@"%@",[successDic objectForKey:@"total_pages"]] intValue];//总页数
        NSArray * ary= [successDic objectForKey:@"items"];
        for(NSInteger k=0;k<[ary count];k++)
        {
            NSDictionary * dic=[ary objectAtIndex:k];
            QuicklyModel * model=[QuicklyModel yy_modelWithJSON:dic];
            [self.dataSourceArray addObject: model];
        }
        [self.tableView.mj_footer endRefreshing];
        [[CountDownManager manager] start];
        [self.tableView reloadData];
       
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
//获取债权转让数据
-(void)getCreditRequest{
    NSArray *keys = @[@"page",kToken];
    NSArray *values = @[[NSString stringWithFormat:@"%ld",self.creditPage],[CommonUtils getToken]];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getCreditAssignListUrl keysArray:keys valuesArray:values refresh:self.creditTabView success:^(NSDictionary *successDic) {
        if(self.creditPage==1)
            [ self.creditDataArray removeAllObjects];
        
        self.creDitTotlaPages =[[NSString stringWithFormat:@"%@",[successDic objectForKey:@"total_pages"]] intValue];//债权转让总页数
        NSArray * ary= [successDic objectForKey:@"items"];
        for(NSInteger k=0;k<[ary count];k++)
        {
            NSDictionary * dic=[ary objectAtIndex:k];
            CreditModel * model=[CreditModel yy_modelWithJSON:dic];
            [self.creditDataArray addObject: model];
        }
        [self.creditTabView.mj_footer endRefreshing];
        [self.creditTabView reloadData];
        
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
//上拉加载更多数据
-(void)loadMoreData{
  if(self.currentPage<=self.total_pages)
    {
        __weak __typeof(self) weakSelf = self;
        [weakSelf getRequest];
    }
    else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}
-(void)loadMoreCreditData{
    if(self.creditPage<=self.creDitTotlaPages)
    {
        __weak __typeof(self) weakSelf = self;
        [weakSelf getCreditRequest];
    }
    else{
        [self.creditTabView.mj_footer endRefreshingWithNoMoreData];
    }
}
#pragma mark --buttonClick
//点击抢购
-(void)investWithModel:(QuicklyModel *)model
{
    if(![CommonUtils isLogin])
    {
        [self goLoginVC];
    }else{
        RushPurchaseController * vc=[[RushPurchaseController alloc] init];
        vc.loan_id=model.loan_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//点击投资债权转让
-(void)buyCreditWithModel:(CreditModel *)model{
    
    if(![CommonUtils isLogin])
    {
        [self goLoginVC];
    }else{
        
        BuyCreditAssignController * vc=[[BuyCreditAssignController alloc] init];
        vc.transfer_id=model.transfer_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
