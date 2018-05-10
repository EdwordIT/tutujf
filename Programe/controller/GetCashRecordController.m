//
//  WithDrawRecordController.m
//  TTJF
//
//  Created by wbzhan on 2018/4/25.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "GetCashRecordController.h"
#import "RechargeRecordCell.h"//充值、提现
#import "MJRefresh.h"
@interface GetCashRecordController ()<UITableViewDelegate,UITableViewDataSource>
Strong BaseUITableView *mainTab;
Strong NSMutableArray *dataSource;
Assign NSInteger currentPage;
Assign NSInteger totalPages;
@end

@implementation GetCashRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"提现记录";
    self.currentPage = 1;
    self.totalPages = 1;
    [self.view addSubview:self.mainTab];
    [self getRequest];
    // Do any additional setup after loading the view.
}
#pragma lazyLoading
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = InitObject(NSMutableArray);
    }
    return _dataSource;
}
-(BaseUITableView *)mainTab{
    if (!_mainTab) {
        _mainTab = [[BaseUITableView alloc]initWithFrame:CGRectMake(0, kNavHight, screen_width, kViewHeight) style:UITableViewStylePlain];
        _mainTab.delegate = self;
        _mainTab.dataSource = self;
        _mainTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTab.rowHeight = kSizeFrom750(140);
        WEAK_SELF;
        _mainTab.ly_emptyView = [EmptyView noDataRefreshBlock:^{
            weakSelf.currentPage = 1;
            [weakSelf getRequest];
        }];
        [_mainTab ly_startLoading];
        _mainTab.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
            weakSelf.currentPage = 1;
            [weakSelf getRequest];
        }];
        _mainTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.currentPage++;
            [weakSelf loadMoreData];
        }];
    }
    return _mainTab;
}
#pragma mark --tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"getCashCell";
    RechargeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[RechargeRecordCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    RechargeListModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell loadInfoWithModel:model];
    return cell;
}
#pragma request
//获取充值列表
-(void)getRequest{
    NSArray *keys = @[@"page",kToken];
    NSArray *values = @[[NSString stringWithFormat:@"%ld",self.currentPage],[CommonUtils getToken]];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getCashRecordUrl keysArray:keys valuesArray:values refresh:self.mainTab success:^(NSDictionary *successDic) {
        if (self.currentPage==1) {
            [self.dataSource removeAllObjects];
        }
        self.totalPages = [[successDic objectForKey:@"total_pages"] integerValue];
        for (NSDictionary *dic in [successDic objectForKey:@"items"]) {
            RechargeListModel *model = [RechargeListModel yy_modelWithJSON:dic];
            [self.dataSource addObject:model];
        }
        [self.mainTab reloadData];
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
-(void)loadMoreData{
    if(self.currentPage<=self.totalPages)
    {
        __weak __typeof(self) weakSelf = self;
        [weakSelf getRequest];
    }
    else{
        [self.mainTab.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
