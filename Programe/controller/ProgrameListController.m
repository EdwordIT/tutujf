//
//  ProgrameListController.m
//  TTJF
//
//  Created by 占碧光 on 2017/10/3.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "ProgrameListController.h"
#import "MJRefresh.h"
#import "QuicklyCell.h"
#import "QuicklyModel.h"
#import "HomeWebController.h"
#import "PPNetworkHelper.h"
#import "RushPurchaseController.h"
#import "ProgrameNewDetailController.h"
#import "CountDownManager.h"

@interface ProgrameListController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger currentPage;/**< 页数 */
  
    NSInteger total_pages;/**总的页数**/
}
Strong   NSMutableArray *dataSourceArray;
@end

@implementation ProgrameListController
-(void)dealloc{
    [[CountDownManager manager] cancel];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"项目列表";
    [self.backBtn setHidden:YES];
    currentPage = 1;//默认选项
    total_pages=1;
    self.dataSourceArray=[[NSMutableArray alloc] init];
    [self initTableView];
    // Do any additional setup after loading the view.
}

/**表格数据操作**/
//初始化主界面
-(void)initTableView{

    if(iOS11)
        self.tableView = [[BaseUITableView alloc] initWithFrame:CGRectMake(0, kNavHight, screen_width, kViewHeight) style:UITableViewStyleGrouped];
    else
         self.tableView = [[BaseUITableView alloc] initWithFrame:CGRectMake(0, kNavHight, screen_width, kViewHeight-kTabbarHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = kSizeFrom750(278);
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setSeparatorColor:separaterColor];
    [self.view addSubview:self.tableView];
    [self loadRefresh];
   
}

//界面表格刷新
-(void)loadRefresh{

    WEAK_SELF;
    TTJFRefreshStateHeader *header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        self->currentPage = 1;
        [weakSelf getRequest];
    }];
    
    //加载无数据页面内容
    self.tableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        self->currentPage = 1;
        [weakSelf getRequest];
    }];
    self.tableView.mj_header = header;

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
   
    [self getRequest];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
    headerView.backgroundColor = RGB_246;
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    footerView.backgroundColor =RGB_246;
    return footerView;
}

/**表格数据操作**/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //当手指离开某行时，就让某行的选中状态消失
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {

        [self didSelectedQuicklyAtIndex1:indexPath.row];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *cellIndentifier = @"QuicklyCell";
    QuicklyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell == nil)
    {
        cell = [[QuicklyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }

    QuicklyModel * programeModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    [cell setQuicklyModel:programeModel];
    WEAK_SELF;
    cell.investBlock = ^{
        [weakSelf investWithModel:programeModel];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//刷新数据
-(void)getRequest{

    
    NSArray *keys = @[@"page"];
    NSArray *values = @[[NSString stringWithFormat:@"%ld",currentPage]];
    [[HttpCommunication sharedInstance] getSignRequestWithPath:getLoanListUrl keysArray:keys valuesArray:values refresh:self.tableView success:^(NSDictionary *successDic) {
        if(self->currentPage==1)
            [ self->_dataSourceArray removeAllObjects];
        self->total_pages=[[NSString stringWithFormat:@"%@",[successDic objectForKey:@"total_pages"]] intValue];
        NSArray * ary= [successDic objectForKey:@"items"];
        for(NSInteger k=0;k<[ary count];k++)
        {
            NSDictionary * dic=[ary objectAtIndex:k];
            QuicklyModel * model=[QuicklyModel yy_modelWithJSON:dic];
            model.nrid=[NSString stringWithFormat:@"%ld",k+((self->currentPage-1)*15)];
            [self->_dataSourceArray addObject: model];
        }
        [self.tableView.mj_footer endRefreshing];
        [[CountDownManager manager] start];
        [self.tableView reloadData];
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
//上拉加载更多数据
-(void)loadMoreData{
  if(currentPage<=total_pages)
    {
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self->currentPage++;
            [weakSelf getRequest];
        });
    }
    else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

//点击进详情
-(void)didSelectedQuicklyAtIndex1:(NSInteger)index
{
    QuicklyModel * model=[_dataSourceArray objectAtIndex:index];
    ProgrameNewDetailController * vc=[[ProgrameNewDetailController alloc] init];
    vc.loan_id=model.loan_id;
    [self.navigationController pushViewController:vc animated:YES];
}

//点击抢购
-(void)investWithModel:(QuicklyModel *)model
{
    if(![CommonUtils isLogin])
    {
        [self OnLogin];
        return;
    }
    RushPurchaseController * vc=[[RushPurchaseController alloc] init];
    vc.loan_id=model.loan_id;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) OnLogin{
    [self goLoginVC];
}
- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

@end
