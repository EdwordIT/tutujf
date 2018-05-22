//
//  MyInvestController.m
//  TTJF
//
//  Created by wbzhan on 2018/5/15.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyInvestController.h"
#import "ZFJSegmentedControl.h"
#import "MyInvestCell.h"
#import "InvestSelectView.h"
@interface MyInvestController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
Strong InvestSelectView *selectView;//筛选
Strong ZFJSegmentedControl *segmentView;//切换
Strong UIScrollView *backScroll;
Strong BaseUITableView *mainTableView;//全部
Strong BaseUITableView *paybackTableView;//回款中
Strong BaseUITableView *paiedTableView;//已回款
Strong NSMutableArray *mainDataArray;
Strong NSMutableArray *paybackDataArray;
Strong NSMutableArray *paidBackDataArray;
Assign NSInteger selectedIndex;//被选中状态
Strong NSMutableArray *dataSource;//
Assign NSInteger mainCurrentPage;
Assign NSInteger mainTotalPages;
Assign NSInteger paybackCurrentPage;
Assign NSInteger paybackTotalPages;
Assign NSInteger paidCurrentPage;
Assign NSInteger paidTotalPages;
Assign BOOL isPayback;
Assign BOOL isPaidBack;
Copy NSString *startTime;
Copy NSString *endTime;
@end

@implementation MyInvestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"我的投资";
    
    self.selectedIndex = 0;
    self.mainCurrentPage = 1;
    self.paybackCurrentPage = 1;
    self.paidCurrentPage = 1;
    self.startTime = @"";
    self.endTime = @"";
    [self.rightBtn setImage:IMAGEBYENAME(@"icons_refresh") forState:UIControlStateNormal];
    [self.rightBtn setHidden:NO];
    [self.rightBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.segmentView];
    
    [self.view addSubview:self.backScroll];
    
    [self.backScroll addSubview:self.mainTableView];
    
    [self.backScroll addSubview:self.paybackTableView];
    
    [self.backScroll addSubview:self.paiedTableView];
    
    [self loadRefresh];
    
    [self loadSelectView];
    
    [SVProgressHUD show];
    
    [self loadRequestAtIndex:0];
    
    // Do any additional setup after loading the view.
}
#pragma mark lazyLoading
-(ZFJSegmentedControl *)segmentView
{
    if (!_segmentView) {
        _segmentView = [[ZFJSegmentedControl alloc]initwithTitleArr:@[@"全部", @"还款中", @"已还款"] iconArr:nil SCType:SCType_Underline];
        _segmentView.frame = RECT(0, kNavHight, screen_width, kSizeFrom750(84));
        _segmentView.backgroundColor = COLOR_White;
        _segmentView.titleColor = RGB_153;
        _segmentView.selectTitleColor = RGB_51;
        _segmentView.selectIndex =  0;
        _segmentView.SCType_Underline_WIDTH = kSizeFrom750(40);//底部条宽度
        _segmentView.titleFont = SYSTEMSIZE(30);
    }
    return _segmentView;
}
-(UIScrollView *)backScroll{
    if (!_backScroll) {
        _backScroll = [[UIScrollView alloc]initWithFrame:RECT(0, self.segmentView.bottom, screen_width, screen_height - self.segmentView.bottom)];
        _backScroll.contentSize = CGSizeMake(screen_width*3, _backScroll.height);
        _backScroll.showsHorizontalScrollIndicator = NO;//水平
        _backScroll.pagingEnabled = YES;
        _backScroll.delegate = self;
    }
    return _backScroll;
}
-(BaseUITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[BaseUITableView alloc]initWithFrame:RECT(0, 0, screen_width, self.backScroll.height) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.rowHeight = kSizeFrom750(325);

    }
    return _mainTableView;
}
-(BaseUITableView *)paybackTableView{
    if (!_paybackTableView) {
        _paybackTableView = [[BaseUITableView alloc]initWithFrame:RECT(screen_width, 0, screen_width, self.mainTableView.height) style:UITableViewStylePlain];
        _paybackTableView.delegate = self;
        _paybackTableView.dataSource = self;
        _paybackTableView.rowHeight = kSizeFrom750(325);

    }
    return _paybackTableView;
}
-(BaseUITableView *)paiedTableView{
    if (!_paiedTableView) {
        _paiedTableView = [[BaseUITableView alloc]initWithFrame:RECT(screen_width*2, 0, screen_width, self.mainTableView.height) style:UITableViewStylePlain];
        _paiedTableView.delegate = self;
        _paiedTableView.dataSource = self;
        _paiedTableView.rowHeight = kSizeFrom750(325);
    }
    return _paiedTableView;
}
-(void)loadRefresh{
    self.mainDataArray = InitObject(NSMutableArray);
    self.paybackDataArray = InitObject(NSMutableArray);
    self.paidBackDataArray = InitObject(NSMutableArray);

   self.dataSource = [[NSMutableArray alloc]initWithObjects:self.mainDataArray,self.paybackDataArray,self.paidBackDataArray,nil];
    WEAK_SELF;
    //全部
    self.mainTableView.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf.mainTableView.mj_footer endRefreshing];
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData:weakSelf.selectedIndex];
    }];
    self.mainTableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        weakSelf.mainCurrentPage = 1;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    //还款中
    self.paybackTableView.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf.paybackTableView.mj_footer endRefreshing];

        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    self.paybackTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData:weakSelf.selectedIndex];
    }];
    self.paybackTableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        weakSelf.paybackCurrentPage = 1;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    //已还完
    self.paiedTableView.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf.paiedTableView.mj_footer endRefreshing];
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    self.paiedTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData:weakSelf.selectedIndex];
    }];
    self.paiedTableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        weakSelf.paidCurrentPage = 1;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    
    //切换标签栏
    self.segmentView.selectType = ^(NSInteger selectIndex, NSString *selectIndexTitle) {
        weakSelf.selectedIndex = selectIndex;
        weakSelf.backScroll.contentOffset = CGPointMake(selectIndex*screen_width, 0);
        if (weakSelf.isPayback==NO&&selectIndex==1) {
            [SVProgressHUD show];
            weakSelf.isPayback = YES;
            [weakSelf loadRequestAtIndex:selectIndex];
        }
       else if (weakSelf.isPaidBack==NO&&selectIndex==2) {
            [SVProgressHUD show];
            weakSelf.isPaidBack = YES;
            [weakSelf loadRequestAtIndex:selectIndex];
        }
    };
}
#pragma mark --筛选页面添加
-(void)loadSelectView{
   
    self.selectView = [[InvestSelectView alloc] initWithFrame:RECT(0, kNavHight, screen_width, kViewHeight)];
    WEAK_SELF;
    self.selectView.selectBlock = ^(NSInteger tag, NSString *startTime, NSString *endTime) {
        weakSelf.startTime = startTime;
        weakSelf.endTime = endTime;
        weakSelf.segmentView.selectIndex = tag;
        [SVProgressHUD show];
        [weakSelf loadRequestAtIndex:tag];
    };
    [self.view addSubview:self.selectView];
    [self.selectView setHidden:YES];
}
-(void)selectClick:(UIButton *)sender
{
    [self.selectView showSelectView:self.selectView.hidden];
}
#pragma mark --scrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==self.backScroll) {
        self.segmentView.selectIndex = scrollView.contentOffset.x/screen_width;
    }
}
#pragma  mark --loadRequest
-(void)loadRequestAtIndex:(NSInteger)index{
    NSString *status_nid = @"";
    NSString *page = @"1";
    BaseUITableView *currentTableView;
    
    switch (index) {
        case 0:{
            status_nid = @"";
            page = [NSString stringWithFormat:@"%ld",self.mainCurrentPage];
            currentTableView = self.mainTableView;
            }
            break;
        case 1:{
            status_nid = @"recover";//回款中
            page = [NSString stringWithFormat:@"%ld",self.paybackCurrentPage];
            currentTableView = self.paybackTableView;
        }
            break;
        case 2:{
            status_nid = @"recover_yes";//已回款
            page = [NSString stringWithFormat:@"%ld",self.paidCurrentPage];
            currentTableView = self.paiedTableView;
        }
            break;
        default:
            break;
    }
    NSArray *keysArr = @[kToken,@"page",@"status_nid",@"start_time",@"end_time"];
    NSArray *valuesArr = @[[CommonUtils getToken],page,status_nid,self.startTime,self.endTime];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getMyInvestUrl keysArray:keysArr valuesArray:valuesArr refresh:currentTableView success:^(NSDictionary *successDic) {
        
        switch (index) {
            case 0:
                self.mainTotalPages = [[successDic objectForKey:@"total_pages"] integerValue];
                break;
            case 1:
                self.paybackTotalPages = [[successDic objectForKey:@"total_pages"] integerValue];
                break;
            case 2:
                self.paidTotalPages = [[successDic objectForKey:@"total_pages"] integerValue];
                break;
            default:
                break;
        }

        NSArray *items =  [successDic objectForKey:@"items"];
        NSMutableArray *dataArr = [self.dataSource objectAtIndex:self.selectedIndex];
        if ([page integerValue]==1) {
            [dataArr removeAllObjects];
        }
        for (int i=0; i<items.count; i++) {
            NSDictionary *dic = [items objectAtIndex:i];
            MyInvestModel *model = [MyInvestModel yy_modelWithJSON:dic];
            [dataArr addObject:model];
        }
        [currentTableView reloadData];
    } failure:^(NSDictionary *errorDic) {
        
    }];

}
-(void)loadMoreData:(NSInteger)index{
    switch (index) {
        case 0:
            {
                if (self.mainTotalPages==self.mainCurrentPage) {
                    [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
                    return;
                }
                self.mainCurrentPage ++;
            }
            break;
        case 1:
        {
            if (self.mainTotalPages==self.mainCurrentPage) {
                [self.paybackTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            self.paybackCurrentPage ++;
        }
            break;
        case 2:
        {
            if (self.mainTotalPages==self.mainCurrentPage) {
                [self.paiedTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            self.paidCurrentPage ++;
        }
            break;
            
        default:
            break;
    }
    [self loadRequestAtIndex:index];
}
#pragma mark -- dataSource and Delegate
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
  return ((NSMutableArray *)[self.dataSource objectAtIndex:self.selectedIndex]).count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"MyInvestCell";
    MyInvestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[MyInvestCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    MyInvestModel *model = [[self.dataSource objectAtIndex:self.selectedIndex] objectAtIndex:indexPath.row];
    [cell loadInfoWithModel:model];
    return cell;
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
