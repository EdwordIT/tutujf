//
//  MyRedEnvelopeController.m
//  TTJF
//
//  Created by wbzhan on 2018/5/16.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyRedEnvelopeController.h"
#import "MyRedEnvelopeCell.h"
#import "ZFJSegmentedControl.h"
@interface MyRedEnvelopeController ()<UITableViewDelegate,UITableViewDataSource>
Strong ZFJSegmentedControl *segmentView;//切换
Strong UIScrollView *backScroll;
Strong BaseUITableView *unuseTableView;//未使用
Strong BaseUITableView *usedTableView;//已使用
Strong BaseUITableView *overdueTableView;//已过期
Strong NSMutableArray *unusedDataArray;
Strong NSMutableArray *usedDataArray;
Strong NSMutableArray *overduedDataArray;
Assign NSInteger selectedIndex;//被选中状态
Strong NSMutableArray *dataSource;//
Assign NSInteger unusedCurrentPage;
Assign NSInteger unusedTotalPages;
Assign NSInteger usedCurrentPage;
Assign NSInteger usedTotalPages;
Assign NSInteger overduedCurrentPage;
Assign NSInteger overduedTotalPages;
Assign BOOL isused;
Assign BOOL isoverdued;
@end

@implementation MyRedEnvelopeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"红包列表";
    
    self.selectedIndex = 0;
    self.unusedCurrentPage = 1;
    self.usedCurrentPage = 1;
    self.overduedCurrentPage = 1;
    
    [self.view addSubview:self.segmentView];
    
    [self.view addSubview:self.backScroll];
    
    [self.backScroll addSubview:self.unuseTableView];
    
    [self.backScroll addSubview:self.usedTableView];
    
    [self.backScroll addSubview:self.overdueTableView];
    
    [self loadRefresh];
    
    [SVProgressHUD show];
    
    [self loadRequestAtIndex:0];
    
    // Do any additional setup after loading the view.
}
#pragma mark lazyLoading
-(ZFJSegmentedControl *)segmentView
{
    if (!_segmentView) {
        _segmentView = [[ZFJSegmentedControl alloc]initwithTitleArr:@[@"未使用", @"已使用", @"已过期"] iconArr:nil SCType:SCType_Underline];
        _segmentView.frame = RECT(0, kNavHight, screen_width, kSizeFrom750(84));
        _segmentView.backgroundColor = COLOR_White;
        _segmentView.titleColor = RGB_153;
        _segmentView.selectTitleColor = navigationBarColor;
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
-(BaseUITableView *)unuseTableView{
    if (!_unuseTableView) {
        _unuseTableView = [[BaseUITableView alloc]initWithFrame:RECT(0, 0, screen_width, self.backScroll.height) style:UITableViewStylePlain];
        _unuseTableView.delegate = self;
        _unuseTableView.dataSource = self;
        _unuseTableView.rowHeight = kSizeFrom750(375);
        
    }
    return _unuseTableView;
}
-(BaseUITableView *)usedTableView{
    if (!_usedTableView) {
        _usedTableView = [[BaseUITableView alloc]initWithFrame:RECT(screen_width, 0, screen_width, self.unuseTableView.height) style:UITableViewStylePlain];
        _usedTableView.delegate = self;
        _usedTableView.dataSource = self;
        _usedTableView.rowHeight = kSizeFrom750(375);
        
    }
    return _usedTableView;
}
-(BaseUITableView *)overdueTableView{
    if (!_overdueTableView) {
        _overdueTableView = [[BaseUITableView alloc]initWithFrame:RECT(screen_width*2, 0, screen_width, self.unuseTableView.height) style:UITableViewStylePlain];
        _overdueTableView.delegate = self;
        _overdueTableView.dataSource = self;
        _overdueTableView.rowHeight = kSizeFrom750(375);
    }
    return _overdueTableView;
}
-(void)loadRefresh{
    self.unusedDataArray = InitObject(NSMutableArray);
    self.usedDataArray = InitObject(NSMutableArray);
    self.overduedDataArray = InitObject(NSMutableArray);
    
    self.dataSource = [[NSMutableArray alloc]initWithObjects:self.unusedDataArray,self.usedDataArray,self.overduedDataArray,nil];
    WEAK_SELF;
    //未使用
    self.unuseTableView.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf.unuseTableView.mj_footer endRefreshing];
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    self.unuseTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData:weakSelf.selectedIndex];
    }];
    self.unuseTableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        weakSelf.unusedCurrentPage = 1;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    //已使用
    self.usedTableView.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf.usedTableView.mj_footer endRefreshing];
        
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    self.usedTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData:weakSelf.selectedIndex];
    }];
    self.usedTableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        weakSelf.usedCurrentPage = 1;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    //已过期
    self.overdueTableView.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf.overdueTableView.mj_footer endRefreshing];
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    self.overdueTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData:weakSelf.selectedIndex];
    }];
    self.overdueTableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        weakSelf.overduedCurrentPage = 1;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    
    //切换标签栏
    self.segmentView.selectType = ^(NSInteger selectIndex, NSString *selectIndexTitle) {
        weakSelf.selectedIndex = selectIndex;
        weakSelf.backScroll.contentOffset = CGPointMake(selectIndex*screen_width, 0);
        if (weakSelf.isused==NO&&selectIndex==1) {
            [SVProgressHUD show];
            weakSelf.isused = YES;
            [weakSelf loadRequestAtIndex:selectIndex];
        }
        else if (weakSelf.isoverdued==NO&&selectIndex==2) {
            [SVProgressHUD show];
            weakSelf.isoverdued = YES;
            [weakSelf loadRequestAtIndex:selectIndex];
        }
    };
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
    NSString *use_type = @"1";
    NSString *page = @"1";
    BaseUITableView *currentTableView;
    
    switch (index) {
        case 0:{
            use_type = @"1";//未使用
            page = [NSString stringWithFormat:@"%ld",self.unusedCurrentPage];
            currentTableView = self.unuseTableView;
        }
            break;
        case 1:{
            use_type = @"2";//已使用（待激活+激活）
            page = [NSString stringWithFormat:@"%ld",self.usedCurrentPage];
            currentTableView = self.usedTableView;
        }
            break;
        case 2:{
            use_type = @"3";//已过期
            page = [NSString stringWithFormat:@"%ld",self.overduedCurrentPage];
            currentTableView = self.overdueTableView;
        }
            break;
        default:
            break;
    }
    NSArray *keysArr = @[kToken,@"page",@"use_type"];
    NSArray *valuesArr = @[[CommonUtils getToken],page,use_type];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:myRedEnvelopeUrl keysArray:keysArr valuesArray:valuesArr refresh:currentTableView success:^(NSDictionary *successDic) {
        
        switch (index) {
            case 0:
                self.unusedTotalPages = [[successDic objectForKey:@"total_pages"] integerValue];
                break;
            case 1:
                self.usedTotalPages = [[successDic objectForKey:@"total_pages"] integerValue];
                break;
            case 2:
                self.overduedTotalPages = [[successDic objectForKey:@"total_pages"] integerValue];
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
            MyRedenvelopeModel *model = [MyRedenvelopeModel yy_modelWithJSON:dic];
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
            if (self.unusedTotalPages==self.unusedCurrentPage) {//未使用
                [self.unuseTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            self.unusedCurrentPage ++;
        }
            break;
        case 1:
        {
            if (self.usedTotalPages==self.usedCurrentPage) {//已使用
                [self.usedTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            self.usedCurrentPage ++;
        }
            break;
        case 2:
        {
            if (self.overduedTotalPages==self.overduedCurrentPage) {//已过期
                [self.overdueTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            self.overduedCurrentPage ++;
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
    static NSString *cellId = @"MyRedEnvelopeCell";
    MyRedEnvelopeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[MyRedEnvelopeCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    WEAK_SELF;
    cell.investBlock = ^{
        //切换到相应的标签栏，之后跳转
        weakSelf.tabBarController.selectedIndex = TabBarProgrameList;
        //首页还是要返回到主页面，防止页面切换
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    MyRedenvelopeModel *model = [[self.dataSource objectAtIndex:self.selectedIndex] objectAtIndex:indexPath.row];
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
