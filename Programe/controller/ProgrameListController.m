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
#import "PPNetworkHelper.h"
#import "RushPurchaseController.h"
#import "ProgrameNewDetailController.h"
#import "CountDownManager.h"

@interface ProgrameListController ()<UITableViewDataSource, UITableViewDelegate>

Assign NSInteger currentPage;/**< 页数 */
Assign NSInteger total_pages;/**总的页数**/
Strong NSMutableArray *dataSourceArray;
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
    [self.view addSubview:self.tableView];
    
    [self loadRefresh];
    [self getRequest];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
}
-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = InitObject(NSMutableArray);
    }
    return _dataSourceArray;
}
//初始化主界面
-(BaseUITableView *)tableView{
    if (!_tableView) {
        _tableView = [[BaseUITableView alloc]initWithFrame:RECT(0, kNavHight, screen_width, kViewHeight - kStatusBarHeight) style:UITableViewStyleGrouped];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.rowHeight = kSizeFrom750(278);
            _tableView.showsVerticalScrollIndicator = NO;
        }
    return _tableView;
}
//界面表格刷新
-(void)loadRefresh{
    WEAK_SELF;
    //加载无数据页面内容
    self.tableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        self.currentPage = 1;
        [weakSelf getRequest];
    }];
    self.tableView.ly_emptyView.autoShowEmptyView = NO;
    [self.tableView ly_startLoading];
    TTJFRefreshStateHeader *header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [weakSelf getRequest];
    }];
    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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

/**表格数据操作**/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QuicklyModel * model=[_dataSourceArray objectAtIndex:indexPath.row];
    ProgrameNewDetailController * vc=[[ProgrameNewDetailController alloc] init];
    vc.loan_id=model.loan_id;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
        [weakSelf investWithModel:programeModel];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//刷新数据
-(void)getRequest{

    
    NSArray *keys = @[@"page"];
    NSArray *values = @[[NSString stringWithFormat:@"%ld",self.currentPage]];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getLoanListUrl keysArray:keys valuesArray:values refresh:self.tableView success:^(NSDictionary *successDic) {
        if(self.currentPage==1)
            [ self.dataSourceArray removeAllObjects];
        self.total_pages=[[NSString stringWithFormat:@"%@",[successDic objectForKey:@"total_pages"]] intValue];
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
//上拉加载更多数据
-(void)loadMoreData{
  if(self.currentPage<=self.total_pages)
    {
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.currentPage++;
            [weakSelf getRequest];
        });
    }
    else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

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

@end
