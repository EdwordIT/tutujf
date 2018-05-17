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
#import <MJRefresh.h>
@interface CreditAssignHistoryController ()<UITableViewDelegate,UITableViewDataSource>

Assign NSInteger currentPage;/**当前页数 */
Assign NSInteger total_pages;/**总的页数**/
Assign BOOL isBuyRecord;//购买记录
Strong NSMutableArray *dataSourceArray;
Strong NSMutableArray *transferDataArray;//债权转让数据
Strong NavSwitchView *switchView;//标题切换
Strong BaseUITableView *tableView;//转让记录
Strong UIView *messageView;//信息
Strong UIImageView *iconImage;//icon
Strong UILabel *creditAmountTitle;//
Strong UILabel *creditAmountLabel;//债权转让出让/购入总金额
Strong UILabel *creditInputTitle;//
Strong UILabel *creditInputLabel;//债权转让出让/购入盈亏

@end

@implementation CreditAssignHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNav];
    
    [self.view addSubview:self.messageView];
    [self.messageView addSubview:self.iconImage];
    [self.messageView addSubview:self.creditAmountLabel];
    [self.messageView addSubview:self.creditAmountTitle];
    [self.messageView addSubview:self.creditInputLabel];
    [self.messageView addSubview:self.creditInputTitle];
    
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}
#pragma mark -- lazyLoading
-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = InitObject(NSMutableArray);
    }
    return _dataSourceArray;
}
-(UIView *)messageView{
    if (!_messageView) {
        _messageView = [[UIView alloc]initWithFrame:RECT(0, kNavHight, screen_width, kSizeFrom750(260))];
        UIView *line = [[UIView alloc]initWithFrame:RECT(screen_width/2, kSizeFrom750(175), kLineHeight, kSizeFrom750(80))];
        [line setBackgroundColor:separaterColor];
        [_messageView addSubview:line];
    }
    return _messageView;
}
-(UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]initWithFrame:RECT((screen_width - kSizeFrom750(90))/2, kSizeFrom750(50), kSizeFrom750(90), kSizeFrom750(90))];
        [_iconImage setImage:IMAGEBYENAME(@"")];
    }
    return _iconImage;
}
-(UILabel *)creditAmountLabel{
    if (!_creditAmountLabel) {
        _creditAmountLabel = [[UILabel alloc]initWithFrame:RECT(0, kSizeFrom750(160), screen_width/2, kSizeFrom750(40))];
        _creditAmountLabel.font = NUMBER_FONT_BOLD(30);
        _creditAmountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _creditAmountLabel;
}
-(UILabel *)creditAmountTitle{
    if (!_creditAmountTitle) {
        _creditAmountTitle = [[UILabel alloc]initWithFrame:RECT(0,self.creditAmountLabel.bottom+kSizeFrom750(15), screen_width/2, kSizeFrom750(30))];
        _creditAmountTitle.font = SYSTEMSIZE(28);
        _creditAmountTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _creditAmountTitle;
}

-(UILabel *)creditInputLabel{
    if (!_creditInputLabel) {
        _creditInputLabel = [[UILabel alloc]initWithFrame:RECT(self.creditAmountTitle.right, self.creditAmountLabel.top, self.creditAmountLabel.width, self.creditAmountLabel.height)];
        _creditInputLabel.font = NUMBER_FONT_BOLD(30);
        _creditInputLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _creditInputLabel;
}
-(UILabel *)creditInputTitle{
    if (!_creditInputTitle) {
        _creditInputTitle = [[UILabel alloc]initWithFrame:RECT(self.creditInputLabel.left,self.creditAmountTitle.top, self.creditAmountTitle.width, self.creditAmountTitle.height)];
        _creditInputTitle.font = SYSTEMSIZE(28);
        _creditInputTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _creditInputTitle;
}
-(NavSwitchView *)switchView{
    if (!_switchView) {
        _switchView = [[NavSwitchView alloc]initWithFrame:RECT(0, 0, screen_width, kNavHight) Array:@[@"转让记录",@"购买记录"]];
        WEAK_SELF;
        _switchView.switchBlock = ^(NSInteger tag) {
            if (tag==1) {
                if (!weakSelf.isBuyRecord) {
                    [SVProgressHUD show];
                    weakSelf.isBuyRecord = YES;
                    
                    [weakSelf getRequest];
                }
            }
        };
    }
    return _switchView;
}
//投资列表
-(BaseUITableView *)tableView{
    if (!_tableView) {
        _tableView = [[BaseUITableView alloc]initWithFrame:RECT(0, 0, screen_width, kViewHeight - kSizeFrom750(260)) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kSizeFrom750(278);
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
-(void)loadNav{
    self.currentPage = 1;//默认选项
    self.total_pages=1;

}
//界面表格刷新
-(void)loadRefresh{
    WEAK_SELF;
    //加载无数据页面内容
    self.tableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        self.currentPage = 1;
        [weakSelf getRequest];
    }];
    [self.tableView ly_startLoading];
    
    self.tableView.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [weakSelf getRequest];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [weakSelf loadMoreData];
    }];
 
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isBuyRecord) {
        return [self.transferDataArray count];
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
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.tableView) {
        CreditAssignHistoryModel * model=[_dataSourceArray objectAtIndex:indexPath.row];
        CreditAssignHistoryDetailController * vc=[[CreditAssignHistoryDetailController alloc] init];
        vc.transfer_id=model.transfer_id;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //购买记录
        CreditAssignHistoryModel * model=[_dataSourceArray objectAtIndex:indexPath.row];
        CreditAssignHistoryDetailController * vc=[[CreditAssignHistoryDetailController alloc] init];
        vc.transfer_id=model.transfer_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static  NSString *cellIndentifier = @"QuicklyCell";
        CreditAssignHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if(cell == nil)
        {
            cell = [[CreditAssignHistoryCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
        }
        
        CreditAssignHistoryModel * model=[self.dataSourceArray objectAtIndex:indexPath.row];
        [cell loadInfoWithModel:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
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
            CreditAssignHistoryModel * model=[CreditAssignHistoryModel yy_modelWithJSON:dic];
            [self.dataSourceArray addObject: model];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        
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
