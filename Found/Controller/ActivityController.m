//
//  ActivityController.m
//  TTJF
//
//  Created by wbzhan on 2018/7/21.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "ActivityController.h"
#import "FoundListCell.h"
@interface ActivityController ()<UITableViewDelegate,UITableViewDataSource,TreasureListDelegate>
Strong BaseUITableView *mainTab;
Strong NSMutableArray *dataSource;
Assign NSInteger currentPage;
Assign NSInteger totalPages;
@end

@implementation ActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"活动";
    [self.view addSubview:self.mainTab];
    self.currentPage = 1;
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    [self getRequest];
    // Do any additional setup after loading the view.
}
#pragma mark --lazyLoading
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = InitObject(NSMutableArray);
    }
    return _dataSource;
}
-(BaseUITableView *)mainTab{
    if (!_mainTab) {
        _mainTab = [[BaseUITableView alloc]initWithFrame:RECT(0, kNavHight, screen_width, kViewHeight) style:UITableViewStylePlain];
        _mainTab.delegate = self;
        _mainTab.dataSource = self;
        WEAK_SELF;
        TTJFRefreshStateHeader *header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
            weakSelf.currentPage = 1;
            [weakSelf getRequest];
        }];
        _mainTab.ly_emptyView = [EmptyView noDataRefreshBlock:^{
            weakSelf.currentPage = 1;
            [weakSelf getRequest];
        }];
        [_mainTab ly_startLoading];
        _mainTab.mj_header = header;
        _mainTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.currentPage  ++;
            [weakSelf loadMoreData];
        }];
    }
    return _mainTab;
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
#pragma mark --getRequest
-(void)getRequest{
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getActivityListUrl keysArray:@[@"page"] valuesArray:@[[NSString stringWithFormat:@"%ld",self.currentPage]] refresh:self.mainTab success:^(NSDictionary *successDic) {
        [self.dataSource removeAllObjects];
        self.totalPages = [[successDic objectForKey:RESPONSE_TOTALPAGES] integerValue];
        NSArray * ary1=[successDic objectForKey:RESPONSE_LIST];
        for(int k=0;k<[ary1 count];k++)
        {
            NSDictionary * dic=[ary1 objectAtIndex:k];
            FoundListModel * model=[FoundListModel yy_modelWithJSON:dic];
            [self.dataSource addObject: model];
        }
        [self.mainTab reloadData];
        
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return [self.dataSource count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return  kSizeFrom750(420);

  
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  
    return kSizeFrom750(20);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self didTreasureListDelegateIndex:indexPath.row];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIndentifier = @"FoundListCell";
    FoundListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell == nil)
    {
        cell = [[FoundListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    if(self.dataSource.count>0)
    {
        FoundListModel * tmodel1=[self.dataSource objectAtIndex:indexPath.row];
        [cell setDataBind:tmodel1];
        cell.delegate=self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)didTreasureListDelegateIndex:(NSInteger)index
{
    FoundListModel * model=[self.dataSource objectAtIndex:index];
    [self goWebViewWithPath:model.link_url];
  
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
