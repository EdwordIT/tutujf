//
//  CreditAssignController.m
//  TTJF
//
//  Created by wbzhan on 2018/5/16.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "CreditAssignHistoryController.h"
#import "NavSwitchView.h"
#import "CreditAssignHistoryCell.h"
#import "CreditAssignHistoryDetailController.h"
#import "ZFJSegmentedControl.h"
#import "CreditAssignHistoryCell.h"
#import "CreditAssignHistoryDetailController.h"

@interface CreditAssignHeaderView:BaseView
Strong UIImageView *iconImage;//icon
Strong UILabel *creditAmountTitle;//
Strong UILabel *creditAmountLabel;//债权转让出让/购入总金额
Strong UILabel *creditInputTitle;//
Strong UILabel *creditInputLabel;//债权转让出让/购入盈亏
-(void)loadInfoWithModel:(CreditAssignHistoryModel *)model;
@end

@implementation CreditAssignHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        
      
    }
    return self;
}
-(void)initSubViews{
    [self addSubview:self.iconImage];
    [self addSubview:self.creditAmountLabel];
    [self addSubview:self.creditAmountTitle];
    UIView *line = [[UIView alloc]initWithFrame:RECT(self.creditAmountLabel.right, self.iconImage.bottom+kSizeFrom750(35), kLineHeight, kSizeFrom750(70))];
    [line setBackgroundColor:separaterColor];
    [self addSubview:line];
    [self addSubview:self.creditInputLabel];
    [self addSubview:self.creditInputTitle];
}
-(UIImageView *)iconImage{
    if(!_iconImage){
        _iconImage = [[UIImageView alloc]initWithFrame:RECT(0, kSizeFrom750(50), kSizeFrom750(90), kSizeFrom750(90))];
        _iconImage.centerX = screen_width/2;
        [_iconImage setImage:IMAGEBYENAME(@"transfer_record_sell")];
    }
    return _iconImage;
}
-(UILabel *)creditAmountLabel{
    if (!_creditAmountLabel) {
        _creditAmountLabel = [[UILabel alloc]initWithFrame:RECT(0, self.iconImage.bottom+kLabelHeight, screen_width/2, kSizeFrom750(40))];
        _creditAmountLabel.textColor = RGB_51;
        _creditAmountLabel.font = NUMBER_FONT_BOLD(30);
        _creditAmountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _creditAmountLabel;
}
-(UILabel *)creditAmountTitle{
    if (!_creditAmountTitle) {
        _creditAmountTitle = [[UILabel alloc]initWithFrame:RECT(self.creditAmountLabel.left, self.creditAmountLabel.bottom+kSizeFrom750(15), self.creditAmountLabel.width, kLabelHeight)];
        _creditAmountTitle.textColor = RGB_51;
        _creditAmountTitle.font = NUMBER_FONT_BOLD(30);
        _creditAmountTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _creditAmountTitle;
}
-(UILabel *)creditInputLabel{
    if (!_creditInputLabel) {
        _creditInputLabel = [[UILabel alloc]initWithFrame:RECT(screen_width, self.creditAmountLabel.top, self.creditAmountLabel.width, self.creditAmountLabel.height)];
        _creditInputLabel.textColor = RGB_51;
        _creditInputLabel.font = NUMBER_FONT_BOLD(30);
        _creditInputLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _creditInputLabel;
}
-(UILabel *)creditInputTitle{
    if (!_creditInputTitle) {
        _creditInputTitle = [[UILabel alloc]initWithFrame:RECT(self.creditInputLabel.left, self.creditInputLabel.bottom+kSizeFrom750(15), self.creditInputLabel.width, kLabelHeight)];
        _creditInputTitle.textColor = RGB_51;
        _creditInputTitle.font = NUMBER_FONT_BOLD(30);
        _creditInputTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _creditAmountTitle;
}
-(void)loadInfoWithModel:(CreditAssignHistoryModel *)model{
    
    
}
@end

@interface CreditAssignHistoryController ()<UITableViewDelegate,UITableViewDataSource>

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
Assign BOOL isBuy;//购买记录
Assign BOOL isPayback;
Assign BOOL isAll;
Strong NavSwitchView *switchView;//标题切换

@end

@implementation CreditAssignHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView addSubview:self.switchView];
    self.selectedIndex = 0;
    self.mainCurrentPage = 1;
    self.paybackCurrentPage = 1;
    self.paidCurrentPage = 1;

    [self.view addSubview:self.segmentView];
    
    [self.view addSubview:self.backScroll];
    
    [self.backScroll addSubview:self.mainTableView];
    
    [self.backScroll addSubview:self.paybackTableView];
    
    [self.backScroll addSubview:self.paiedTableView];
    
    [self loadRefresh];
    
//    [SVProgressHUD show];
    
//    [self loadRequestAtIndex:0];
    
    // Do any additional setup after loading the view.
}
#pragma mark lazyLoading
-(NavSwitchView *)switchView{
    if (!_switchView) {
        _switchView = [[NavSwitchView alloc]initWithFrame:RECT(0, 0, screen_width, kNavHight) Array:@[@"转让记录",@"购买记录"]];
        WEAK_SELF;
        _switchView.switchBlock = ^(NSInteger tag) {
            if (tag==0) {
                    [weakSelf.segmentView resetTitleArray:@[@"全部",@"可转让",@"转让中",@"已转让"]] ;
                    [SVProgressHUD show];
                    weakSelf.isBuy = YES;
            }else{
                 [weakSelf.segmentView resetTitleArray:@[@"全部",@"回款中",@"已回款"]] ;
            }
        };
    }
    return _switchView;
}
-(ZFJSegmentedControl *)segmentView
{
    if (!_segmentView) {
        _segmentView = [[ZFJSegmentedControl alloc]initwithTitleArr:@[@"全部",@"可转让",@"转让中",@"已转让"] iconArr:nil SCType:SCType_Underline];
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
-(BaseUITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[BaseUITableView alloc]initWithFrame:RECT(screen_width*2, 0, screen_width, self.backScroll.height) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.rowHeight = kSizeFrom750(440);
        
    }
    return _mainTableView;
}
-(BaseUITableView *)paybackTableView{
    if (!_paybackTableView) {
        _paybackTableView = [[BaseUITableView alloc]initWithFrame:RECT(0, 0, screen_width, self.mainTableView.height) style:UITableViewStylePlain];
        _paybackTableView.delegate = self;
        _paybackTableView.dataSource = self;
        _paybackTableView.rowHeight = kSizeFrom750(440);
        
    }
    return _paybackTableView;
}
-(BaseUITableView *)paiedTableView{
    if (!_paiedTableView) {
        _paiedTableView = [[BaseUITableView alloc]initWithFrame:RECT(screen_width, 0, screen_width, self.mainTableView.height) style:UITableViewStylePlain];
        _paiedTableView.delegate = self;
        _paiedTableView.dataSource = self;
        _paiedTableView.rowHeight = kSizeFrom750(440);
    }
    return _paiedTableView;
}
-(void)loadRefresh{
    self.mainDataArray = InitObject(NSMutableArray);
    self.paybackDataArray = InitObject(NSMutableArray);
    self.paidBackDataArray = InitObject(NSMutableArray);
    
    self.dataSource = [[NSMutableArray alloc]initWithObjects:self.paybackDataArray,self.paidBackDataArray,self.mainDataArray,nil];
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
        else if (weakSelf.isAll==NO&&selectIndex==2) {
            [SVProgressHUD show];
            weakSelf.isAll = YES;
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
    NSString *status_nid = @"";
    NSString *page = @"1";
    BaseUITableView *currentTableView;
    
    switch (index) {
        case 0:{
            status_nid = @"recover";//回款中
            page = [NSString stringWithFormat:@"%ld",self.paybackCurrentPage];
            currentTableView = self.paybackTableView;
            
        }
            break;
        case 1:{
            status_nid = @"recover_yes";//已回款
            page = [NSString stringWithFormat:@"%ld",self.paidCurrentPage];
            currentTableView = self.paiedTableView;
        }
            break;
        case 2:{
            status_nid = @"";//全部
            page = [NSString stringWithFormat:@"%ld",self.mainCurrentPage];
            currentTableView = self.mainTableView;
            
        }
            break;
        default:
            break;
    }
    NSArray *keysArr = @[kToken,@"page",@"status_nid",@"start_time",@"end_time"];
    NSArray *valuesArr = @[[CommonUtils getToken],page,status_nid];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getMyInvestUrl keysArray:keysArr valuesArray:valuesArr refresh:currentTableView success:^(NSDictionary *successDic) {
        
        switch (index) {
            case 0:
                self.paybackTotalPages = [[successDic objectForKey:@"total_pages"] integerValue];
                
                break;
            case 1:
                self.paidTotalPages = [[successDic objectForKey:@"total_pages"] integerValue];
                
                break;
            case 2:
                self.mainTotalPages = [[successDic objectForKey:@"total_pages"] integerValue];
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
            CreditAssignHistoryModel *model = [CreditAssignHistoryModel yy_modelWithJSON:dic];
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
            if (self.paybackTotalPages==self.paybackTotalPages) {
                [self.paybackTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            self.paybackCurrentPage ++;
        }
            break;
        case 1:
        {
            if (self.paidTotalPages==self.paidCurrentPage) {
                [self.paiedTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            self.paidCurrentPage ++;
            
        }
            break;
        case 2:
        {
            if (self.mainTotalPages==self.mainCurrentPage) {
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            self.mainCurrentPage ++;
            
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
    
//    return ((NSMutableArray *)[self.dataSource objectAtIndex:self.selectedIndex]).count;
    return 3;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CreditAssignHeaderView *header = [[CreditAssignHeaderView alloc]initWithFrame:RECT(0, 0, screen_width, kSizeFrom750(300))];
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kSizeFrom750(300);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"MyInvestCell";
    CreditAssignHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[CreditAssignHistoryCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
//    CreditAssignHistoryModel *model = [[self.dataSource objectAtIndex:self.selectedIndex] objectAtIndex:indexPath.row];
//    [cell loadInfoWithModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreditAssignHistoryModel *model = [[self.dataSource objectAtIndex:self.selectedIndex] objectAtIndex:indexPath.row];
    CreditAssignHistoryDetailController *detail = InitObject(CreditAssignHistoryDetailController);
    detail.transfer_id = model.transfer_id;
    [self.navigationController pushViewController:detail animated:YES];
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
