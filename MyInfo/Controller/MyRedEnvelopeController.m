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
Strong BaseUITableView *tableView;
Strong NSMutableArray *dataArray;
Strong ZFJSegmentedControl *segmentView;//切换
Strong UIScrollView *backScroll;
Strong BaseUITableView *mainTableView;//全部
Strong BaseUITableView *paybackTableView;//回款中
Strong BaseUITableView *paiedTableView;//已回款
Strong NSMutableArray *mainDataArray;
Strong NSMutableArray *pabackDataArray;
Strong NSMutableArray *paidBackDataArray;
Assign NSInteger selectedIndex;//被选中状态
Strong NSMutableArray *dataSource;//
Assign NSInteger mainCurrentPage;
Assign NSInteger mainTotalPages;
Assign NSInteger paybackCurrentPage;
Assign NSInteger paybackTotalPages;
Assign NSInteger paidCurrentPage;
Assign NSInteger paidTotalPages;
@end

@implementation MyRedEnvelopeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"红包列表";
    
    self.selectedIndex = 0;
    
    [self.view addSubview:self.segmentView];
    
    [self.view addSubview:self.backScroll];
    
    [self.backScroll addSubview:self.mainTableView];
    
    [self.backScroll addSubview:self.paybackTableView];
    
    [self.backScroll addSubview:self.paiedTableView];
    
    [self loadRefresh];
    
    // Do any additional setup after loading the view.
}
#pragma mark lazyLoading
-(NSMutableArray *)mainDataArray{
    if (!_mainDataArray) {
        _mainDataArray = InitObject(NSMutableArray);
    }
    return _mainDataArray;
}
-(NSMutableArray *)pabackDataArray {
    if (!_pabackDataArray) {
        _pabackDataArray = InitObject(NSMutableArray);
    }
    return _mainDataArray;
}
-(NSMutableArray *)paidBackDataArray{
    if (!_paidBackDataArray) {
        _paidBackDataArray = InitObject(NSMutableArray);
    }
    return _mainDataArray;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]initWithObjects:self.mainDataArray,self.pabackDataArray,self.paidBackDataArray,nil];
    }
    return _dataSource;
}
-(ZFJSegmentedControl *)segmentView
{
    if (!_segmentView) {
        _segmentView = [[ZFJSegmentedControl alloc]initwithTitleArr:@[@"未使用", @"已使用", @"已过期"] iconArr:nil SCType:SCType_Underline];
        _segmentView.frame = RECT(0, kNavHight, screen_width, kSizeFrom750(84));
        _segmentView.backgroundColor = [UIColor whiteColor];
        _segmentView.titleColor = RGB_153;
        _segmentView.selectTitleColor = RGB_51;
        _segmentView.selectIndex =  0;
        _segmentView.SCType_Underline_WIDTH = kSizeFrom750(40);//底部条宽度
        _segmentView.titleFont = SYSTEMSIZE(30);
        _segmentView.selectTitleColor=navigationBarColor;
        
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
        _mainTableView.rowHeight = kSizeFrom750(375);
        
    }
    return _mainTableView;
}
-(BaseUITableView *)paybackTableView{
    if (!_paybackTableView) {
        _paybackTableView = [[BaseUITableView alloc]initWithFrame:RECT(screen_width, 0, screen_width, self.mainTableView.height) style:UITableViewStylePlain];
        _paybackTableView.delegate = self;
        _paybackTableView.dataSource = self;
        _paybackTableView.rowHeight = kSizeFrom750(375);
        
    }
    return _paybackTableView;
}
-(BaseUITableView *)paiedTableView{
    if (!_paiedTableView) {
        _paiedTableView = [[BaseUITableView alloc]initWithFrame:RECT(screen_width*2, 0, screen_width, self.mainTableView.height) style:UITableViewStylePlain];
        _paiedTableView.delegate = self;
        _paiedTableView.dataSource = self;
        _paiedTableView.rowHeight = kSizeFrom750(375);
    }
    return _paiedTableView;
}
-(void)loadRefresh{
    
    WEAK_SELF;
    //全部
    self.mainTableView.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        weakSelf.mainCurrentPage = 0;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.mainCurrentPage++;
        [weakSelf loadMoreData:weakSelf.selectedIndex];
    }];
    self.mainTableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        weakSelf.mainCurrentPage = 0;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    //还款中
    self.paybackTableView.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        weakSelf.paybackCurrentPage = 0;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    self.paybackTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.paybackCurrentPage++;
        [weakSelf loadMoreData:weakSelf.selectedIndex];
    }];
    self.paybackTableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        weakSelf.paybackCurrentPage = 0;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    //已还完
    self.paiedTableView.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        weakSelf.paidCurrentPage = 0;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    self.paiedTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.paidCurrentPage++;
        [weakSelf loadMoreData:weakSelf.selectedIndex];
    }];
    self.paiedTableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        weakSelf.paidCurrentPage = 0;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    
    //切换标签栏
    self.segmentView.selectType = ^(NSInteger selectIndex, NSString *selectIndexTitle) {
        weakSelf.selectedIndex = selectIndex;
        weakSelf.backScroll.contentOffset = CGPointMake(screen_width*weakSelf.selectedIndex, 0);
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
    
    
}
-(void)loadMoreData:(NSInteger)index{
    
}
#pragma mark -- dataSource and Delegate
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //  return ((NSMutableArray *)[self.dataSource objectAtIndex:self.selectedIndex]).count;
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"MyInvestCell";
    MyRedEnvelopeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[MyRedEnvelopeCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    //    MyRedenvelopeModel *model = [[self.dataSource objectAtIndex:self.selectedIndex] objectAtIndex:indexPath.row];
    //    [cell loadInfoWithModel:model];
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
