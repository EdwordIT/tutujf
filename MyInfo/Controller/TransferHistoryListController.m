//
//  TransferHistoryListController.m
//  TTJF
//
//  Created by wbzhan on 2018/5/26.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "TransferHistoryListController.h"
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
        self.backgroundColor = COLOR_White;
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
@interface TransferHistoryListController ()<UITableViewDelegate,UITableViewDataSource>
Strong BaseUITableView *mainTableView;//全部
Strong NSMutableArray *mainDataArray;
Assign NSInteger mainCurrentPage;
Assign NSInteger mainTotalPages;
@end

@implementation TransferHistoryListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainCurrentPage = 1;
    self.mainTotalPages = 1;
    [self.titleView removeFromSuperview];
    [self.view addSubview:self.mainTableView];
    [self loadRefresh];
//    [self loadRequestAtIndex:self.selectedIndex];
    // Do any additional setup after loading the view.
}
-(BaseUITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[BaseUITableView alloc]initWithFrame:RECT(0, 0, screen_width, kViewHeight - kTitleHeight) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.rowHeight = kSizeFrom750(440);
        
    }
    return _mainTableView;
}
-(void)loadRefresh{
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
}
#pragma  mark --loadRequest
-(void)loadRequestAtIndex:(NSInteger)index{
    NSString *status_nid = @"";
    NSString *page = @"1";
    
    switch (index) {
        case 0:{
            status_nid = @"recover";//回款中
        }
            break;
        case 1:{
            status_nid = @"recover_yes";//已回款
        }
            break;
        case 2:{
            status_nid = @"";//全部
            
        }
            break;
        default:
            break;
    }
    NSArray *keysArr = @[kToken,@"page",@"status_nid",@"start_time",@"end_time"];
    NSArray *valuesArr = @[[CommonUtils getToken],page,status_nid];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getMyInvestUrl keysArray:keysArr valuesArray:valuesArr refresh:self.self.mainTableView success:^(NSDictionary *successDic) {

        self.mainTotalPages = [[successDic objectForKey:@"total_pages"] integerValue];
        NSArray *items =  [successDic objectForKey:@"items"];
        if ([page integerValue]==1) {
            [self.mainDataArray removeAllObjects];
        }
        for (int i=0; i<items.count; i++) {
            NSDictionary *dic = [items objectAtIndex:i];
            CreditAssignHistoryModel *model = [CreditAssignHistoryModel yy_modelWithJSON:dic];
            [self.mainDataArray addObject:model];
        }
        [self.mainTableView reloadData];
    } failure:^(NSDictionary *errorDic) {
        
    }];
    
}
-(void)loadMoreData:(NSInteger)index{

            if (self.mainTotalPages==self.mainCurrentPage) {
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            self.mainCurrentPage ++;

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
//    CreditAssignHeaderView *header = [[CreditAssignHeaderView alloc]initWithFrame:RECT(0, 0, screen_width, kSizeFrom750(300))];
//    return header;
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return kSizeFrom750(300);
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"CreditAssignHistoryCell";
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
    CreditAssignHistoryModel *model = [self.mainDataArray objectAtIndex:indexPath.row];
    CreditAssignHistoryDetailController *detail = InitObject(CreditAssignHistoryDetailController);
    detail.transfer_id = model.transfer_id;
    
    [[BaseViewController appRootViewController].navigationController pushViewController:detail animated:YES];
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
