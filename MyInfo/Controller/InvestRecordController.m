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
Assign NSInteger payCurrentPage;
Assign NSInteger payTotalPages;
Assign NSInteger incomeCurrentPage;
Assign NSInteger incomeTotalPages;
Assign BOOL isPay;
Assign BOOL isIncome;
Weak UILabel *balanceLabel;//余额
Copy NSString *balance_amount;//账户余额
Copy NSString *balance_amount_txt;//账户余额描述
@end

@implementation InvestRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"资金记录";//查看资金流向
    
    [self.view addSubview:self.segmentView];
    
    [self.view addSubview:self.backScroll];
    
    [self.backScroll addSubview:self.accountTableView];
    
    [self.backScroll addSubview:self.payTableView];
    
    [self.backScroll addSubview:self.incomeTableView];
    
    [self loadRefresh];
    [SVProgressHUD show];
    [self loadRequestAtIndex:0];
    
    // Do any additional setup after loading the view.
}
#pragma mark lazyLoading
-(ZFJSegmentedControl *)segmentView
{
    if (!_segmentView) {
        _segmentView = [[ZFJSegmentedControl alloc]initwithTitleArr:@[@"账户余额", @"支出明细", @"收入明细"] iconArr:nil SCType:SCType_Underline];
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
-(void)loadRefresh{
    
    self.selectedIndex = 0;
    self.mainCurrentPage = 1;
    self.payCurrentPage = 1;
    self.incomeCurrentPage = 1;
    self.mainTotalPages = 1;
    self.incomeTotalPages = 1;
    self.payTotalPages = 1;
    
    self.accountDataArray = InitObject(NSMutableArray);
    self.payDataArray = InitObject(NSMutableArray);
    self.incomeDataArray = InitObject(NSMutableArray);
    
    self.dataSource = [[NSMutableArray alloc]initWithObjects:self.accountDataArray,self.payDataArray,self.incomeDataArray,nil];
    WEAK_SELF;
    //剩余金额
    self.accountTableView.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        weakSelf.mainCurrentPage = 1;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    self.accountTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData:weakSelf.selectedIndex];
    }];
    self.accountTableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        weakSelf.mainCurrentPage = 1;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    //支出
    self.payTableView.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        weakSelf.payCurrentPage = 1;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    self.payTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData:weakSelf.selectedIndex];
    }];
    self.payTableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        weakSelf.payCurrentPage = 1;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    //收入
    self.incomeTableView.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        weakSelf.incomeCurrentPage = 1;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    self.incomeTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData:weakSelf.selectedIndex];
    }];
    self.incomeTableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        weakSelf.incomeCurrentPage = 1;
        [weakSelf loadRequestAtIndex:weakSelf.selectedIndex];
    }];
    
    //切换标签栏
    self.segmentView.selectType = ^(NSInteger selectIndex, NSString *selectIndexTitle) {
        weakSelf.selectedIndex = selectIndex;
        weakSelf.backScroll.contentOffset = CGPointMake(screen_width*weakSelf.selectedIndex, 0);
        if (weakSelf.isPay==NO&&selectIndex==1) {
            [SVProgressHUD show];
            weakSelf.isPay = YES;
            [weakSelf loadRequestAtIndex:selectIndex];
        }
        else if (weakSelf.isIncome==NO&&selectIndex==2) {
            [SVProgressHUD show];
            weakSelf.isIncome = YES;
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
    NSString *money_type = @"";
    NSString *page = @"1";
    BaseUITableView *currentTabView;
    switch (index) {
        case 0:
            {
                money_type = @"";
                page = [NSString stringWithFormat:@"%ld",self.mainCurrentPage];
                currentTabView = self.accountTableView;
            }
            break;
        case 1:
        {
            money_type = @"expend";
            page = [NSString stringWithFormat:@"%ld",self.payCurrentPage];
            currentTabView = self.payTableView;

        }
            break;
        case 2:
        {
            money_type = @"income";
            page = [NSString stringWithFormat:@"%ld",self.incomeCurrentPage];
            currentTabView = self.incomeTableView;


        }
            break;
        default:
            break;
    }
    NSArray *keysArr = @[kToken,@"page",@"money_type"];
    NSArray *valuesArr = @[[CommonUtils getToken],page,money_type];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:myAccountLogUrl keysArray:keysArr valuesArray:valuesArr refresh:currentTabView success:^(NSDictionary *successDic) {
        switch (index) {
            case 0:
                self.mainTotalPages = [[successDic objectForKey:@"total_pages"] integerValue];
                
                break;
            case 1:
                self.payTotalPages = [[successDic objectForKey:@"total_pages"] integerValue];
                
                break;
            case 2:
                self.incomeTotalPages = [[successDic objectForKey:@"total_pages"] integerValue];
                break;
            default:
                break;
        }
        self.balance_amount = [successDic objectForKey:@"balance_amount"];
        self.balance_amount_txt = [successDic objectForKey:@"balance_amount_txt"];
        NSArray *items =  [successDic objectForKey:@"items"];
        NSMutableArray *dataArr = [self.dataSource objectAtIndex:self.selectedIndex];
        if ([page integerValue]==1) {
            [dataArr removeAllObjects];
        }
        for (int i=0; i<items.count; i++) {
            NSDictionary *dic = [items objectAtIndex:i];
            InvestRecordModel *model = [InvestRecordModel yy_modelWithJSON:dic];
            [dataArr addObject:model];
        }
        [currentTabView reloadData];
    } failure:^(NSDictionary *errorDic) {
        
    }];

   
}
-(void)loadMoreData:(NSInteger)index{
    switch (index) {
        case 0:
        {
            if (self.mainCurrentPage==self.mainTotalPages) {
                [self.accountTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            self.mainCurrentPage ++;
        }
            break;
        case 1:
        {
            if (self.payCurrentPage==self.payTotalPages) {
                [self.payTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            self.payCurrentPage ++;
            
        }
            break;
        case 2:
        {
            if (self.incomeCurrentPage==self.incomeTotalPages) {
                [self.incomeTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            self.incomeCurrentPage ++;
            
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
    
    NSMutableArray *selectArr = [self.dataSource objectAtIndex:self.selectedIndex];
    return selectArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"InvestRecordCell";
    InvestRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[InvestRecordCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
        InvestRecordModel *model = [[self.dataSource objectAtIndex:self.selectedIndex] objectAtIndex:indexPath.row];
        [cell loadInfoWithModel:model];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==self.accountTableView) {
        UIView *headerView = [[UIView alloc]initWithFrame:RECT(0, 0, screen_width, kSizeFrom750(210))];
        headerView.backgroundColor = COLOR_White;
        UIImageView *iconImage = InitObject(UIImageView);
        iconImage.frame = RECT(kSizeFrom750(230), kSizeFrom750(60), kSizeFrom750(120), kSizeFrom750(100));
        [iconImage setImage:IMAGEBYENAME(@"icons_nodata")];
        [headerView addSubview:iconImage];
        
        UILabel *remindL = [[UILabel alloc]init];
        remindL.textColor = RGB_51;
        remindL.font = SYSTEMSIZE(28);
        remindL.numberOfLines = 0;
        [headerView addSubview:remindL];
        
        [remindL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kSizeFrom750(400));
            make.left.mas_equalTo(iconImage.mas_right).offset(kSizeFrom750(20));
            make.centerY.mas_equalTo(iconImage);
        }];
        
        NSString *amount = [self.balance_amount stringByAppendingString:@"\n"];
        NSString *title = self.balance_amount_txt;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",amount,title]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:kLabelSpace];
        [attributedString addAttributes:@{NSFontAttributeName:SYSTEMSIZE(28),NSForegroundColorAttributeName:RGB_51} range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:COLOR_Red,NSFontAttributeName:NUMBER_FONT(35)} range:NSMakeRange(0, amount.length)];
        [remindL setAttributedText:attributedString];
        
        return headerView;
    }else
        return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==self.accountTableView) {
        return kSizeFrom750(210);
    }else
        return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kSizeFrom750(30);
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
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
