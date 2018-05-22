//
//  InvestRecordController.m
//  TTJF
//
//  Created by wbzhan on 2018/5/18.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "InvestRecordController.h"
#import "ZFJSegmentedControl.h"
#import "InvestRecordCell.h"
@interface InvestRecordController ()<UITableViewDelegate,UITableViewDataSource>
Strong BaseUITableView *tableView;
Strong NSMutableArray *dataArray;
Strong ZFJSegmentedControl *segmentView;//切换
Strong UIScrollView *backScroll;
Strong BaseUITableView *accountTableView;//账户余额
Strong BaseUITableView *payTableView;//支出明细
Strong BaseUITableView *incomeTableView;//收入明细
Strong NSMutableArray *accountDataArray;
Strong NSMutableArray *payDataArray;
Strong NSMutableArray *incomeDataArray;
Assign NSInteger selectedIndex;//被选中状态
Strong NSMutableArray *dataSource;//
Assign NSInteger mainCurrentPage;
Assign NSInteger mainTotalPages;
Assign NSInteger paybackCurrentPage;
Assign NSInteger paybackTotalPages;
Assign NSInteger paidCurrentPage;
Assign NSInteger paidTotalPages;
Weak UILabel *balanceLabel;//余额
Strong UIView *sectionHeaderView;//
@end

@implementation InvestRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"资金记录";//查看资金流向
    
    self.selectedIndex = 0;
    
    [self.view addSubview:self.segmentView];
    
    [self.view addSubview:self.backScroll];
    
    [self.backScroll addSubview:self.accountTableView];
    
    [self.backScroll addSubview:self.payTableView];
    
    [self.backScroll addSubview:self.incomeTableView];
    
    [self loadRefresh];
        
    [self loadRequestAtIndex:0];
    
    // Do any additional setup after loading the view.
}
#pragma mark lazyLoading
-(NSMutableArray *)accountDataArray{
    if (!_accountDataArray) {
        _accountDataArray = InitObject(NSMutableArray);
    }
    return _accountDataArray;
}
-(NSMutableArray *)payDataArray {
    if (!_payDataArray) {
        _payDataArray = InitObject(NSMutableArray);
    }
    return _accountDataArray;
}
-(NSMutableArray *)incomeDataArray{
    if (!_incomeDataArray) {
        _incomeDataArray = InitObject(NSMutableArray);
    }
    return _accountDataArray;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]initWithObjects:self.accountDataArray,self.payDataArray,self.incomeDataArray,nil];
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
-(BaseUITableView *)accountTableView{
    if (!_accountTableView) {
        _accountTableView = [[BaseUITableView alloc]initWithFrame:RECT(0, 0, screen_width, self.backScroll.height) style:UITableViewStyleGrouped];
        _accountTableView.delegate = self;
        _accountTableView.dataSource = self;
        _accountTableView.rowHeight = kSizeFrom750(220);
        
    }
    return _accountTableView;
}
-(BaseUITableView *)payTableView{
    if (!_payTableView) {
        _payTableView = [[BaseUITableView alloc]initWithFrame:RECT(screen_width, 0, screen_width, self.accountTableView.height) style:UITableViewStyleGrouped];
        _payTableView.delegate = self;
        _payTableView.dataSource = self;
        _payTableView.rowHeight = kSizeFrom750(220);
        
    }
    return _payTableView;
}
-(BaseUITableView *)incomeTableView{
    if (!_incomeTableView) {
        _incomeTableView = [[BaseUITableView alloc]initWithFrame:RECT(screen_width*2, 0, screen_width, self.accountTableView.height) style:UITableViewStyleGrouped];
        _incomeTableView.delegate = self;
        _incomeTableView.dataSource = self;
        _incomeTableView.rowHeight = kSizeFrom750(220);
    }
    return _incomeTableView;
}
-(UIView *)sectionHeaderView{
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[UIView alloc]initWithFrame:RECT(0, 0, screen_width, kSizeFrom750(210))];
        _sectionHeaderView.backgroundColor = separaterColor;
        UIImageView *iconImage = InitObject(UIImageView);
        iconImage.frame = RECT(kSizeFrom750(230), kSizeFrom750(60), kSizeFrom750(120), kSizeFrom750(100));
        [iconImage setImage:IMAGEBYENAME(@"icons_nodata")];
        [_sectionHeaderView addSubview:iconImage];
        
        UILabel *remindL = [[UILabel alloc]initWithFrame:RECT(iconImage.right, iconImage.top, kSizeFrom750(200), kSizeFrom750(70))];
        remindL.textColor = RGB_153;
        remindL.font = SYSTEMSIZE(28);
        remindL.numberOfLines = 0;
        [_sectionHeaderView addSubview:remindL];
        self.balanceLabel = remindL;
    }
    return _sectionHeaderView;
}
-(void)loadRefresh{
    
    WEAK_SELF;
    //全部
    self.accountTableView.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        weakSelf.mainCurrentPage = 0;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    self.accountTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.mainCurrentPage++;
        [weakSelf loadMoreData:weakSelf.selectedIndex];
    }];
    self.accountTableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        weakSelf.mainCurrentPage = 0;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    //还款中
    self.payTableView.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        weakSelf.paybackCurrentPage = 0;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    self.payTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.paybackCurrentPage++;
        [weakSelf loadMoreData:weakSelf.selectedIndex];
    }];
    self.payTableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        weakSelf.paybackCurrentPage = 0;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    //已还完
    self.incomeTableView.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        weakSelf.paidCurrentPage = 0;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    self.incomeTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.paidCurrentPage++;
        [weakSelf loadMoreData:weakSelf.selectedIndex];
    }];
    self.incomeTableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
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
    
    NSString *amount = @"11192.50\n";
    NSString *title = @"当前账户余额（元）";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",amount,title]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:kLabelSpace];
    [attributedString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSBackgroundColorAttributeName:COLOR_Red,NSFontAttributeName:NUMBER_FONT(30)} range:NSMakeRange(0, amount.length)];
    self.balanceLabel.attributedText = attributedString;
}
-(void)loadMoreData:(NSInteger)index{
    
}
#pragma mark -- dataSource and Delegate
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //  return ((NSMutableArray *)[self.dataSource objectAtIndex:self.selectedIndex]).count;
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"MyInvestCell";
    InvestRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[InvestRecordCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
//        InvestRecordModel *model = [[self.dataSource objectAtIndex:self.selectedIndex] objectAtIndex:indexPath.row];
//        [cell loadInfoWithModel:model];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionHeaderView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSizeFrom750(210);
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
