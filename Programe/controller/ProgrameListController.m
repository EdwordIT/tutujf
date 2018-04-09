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
#import "HttpSignCreate.h"
#import "HttpUrlAddress.h"
#import "ggHttpFounction.h"
#import "AppDelegate.h"
#import "RushPurchaseController.h"
#import "ProgrameNewDetailController.h"
#import "TTJFRefreshStateHeader.h"


@interface ProgrameListController ()<UITableViewDataSource, UITableViewDelegate,QuicklyDelegate>
{
    NSInteger _page;/**< 页数 */
    NSInteger _limit;/**< 每页的个数 */
    
    NSMutableArray *_dataSourceArray;
    NSInteger _topindex;/**< 每页的个数 */
        NSInteger _charge;/**当前的选项 */
    NSInteger total_pages;/**总的页数**/
}

@end

@implementation ProgrameListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"项目列表";
    [self.backBtn setHidden:YES];
    _topindex=0;
    _page = 1;//默认选项
    total_pages=1;
    _dataSourceArray=[[NSMutableArray alloc] init];
    [self initTableView];
    // Do any additional setup after loading the view.
}

/**表格数据操作**/
//初始化主界面
-(void)initTableView{

    if(iOS11)
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHight, screen_width, kViewHeight) style:UITableViewStyleGrouped];
    else
         self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHight, screen_width, kViewHeight-kTabbarHeight) style:UITableViewStyleGrouped];
    

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor=separaterColor;
    [self.tableView setSeparatorColor:separaterColor];
    [self.view addSubview:self.tableView];
    [self setUpTableView];
   
}

//界面表格刷新
-(void)setUpTableView{

    __weak typeof(self) weakSelf = self;
    TTJFRefreshStateHeader *header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    self.tableView.mj_header = header;

     self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 马上进入刷新状态
    [header beginRefreshing];
}



#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0 ){
         return [_dataSourceArray count];
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        {
            return kSizeFrom750(278);
        }
    }
    else{
        return 70.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
              return 10;
    }
    else{
        return 5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
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
    if (indexPath.section == 0) {
//         NSString *cellIndentifier =[@"Quickly" stringByAppendingString:[NSString stringWithFormat:@"%ld",indexPath.row]];
      static  NSString *cellIndentifier = @"QuicklyCell";
        
        QuicklyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
       if(cell == nil)
        {
            cell = [[QuicklyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
       }
        if(_dataSourceArray.count>0)
        {
            QuicklyModel * tmodel1=[_dataSourceArray objectAtIndex:indexPath.row];
            [cell setQuicklyModel:tmodel1];
            if([tmodel1.status isEqual: @"3"])
            {
                cell.delegate=self;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    headerView.backgroundColor =separaterColor;
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    footerView.backgroundColor = separaterColor;
    return footerView;
}
//刷新数据
-(void)loadNewData{
    _page = 1;
    [self.tableView.mj_footer endRefreshing];
    [self doLoanList];
}
//上拉加载更多数据
-(void)loadMoreData{
  if(_page<=total_pages)
    {
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _page++;
            [weakSelf doLoanList];
        });
    }
    else{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

-(void) doLoanList{
    if(_page==1)
        [ _dataSourceArray removeAllObjects];
    NSArray *keys = @[@"page"];
    NSArray *values = @[[NSString stringWithFormat:@"%ld",_page]];
    [[HttpCommunication sharedInstance] getSignRequestWithPath:getLoanListUrl keysArray:keys valuesArray:values refresh:self.tableView.mj_header success:^(NSDictionary *successDic) {
        
        total_pages=[[NSString stringWithFormat:@"%@",[successDic objectForKey:@"total_pages"]] intValue];
        NSArray * ary= [successDic objectForKey:@"items"];
        for(NSInteger k=0;k<[ary count];k++)
        {
            NSDictionary * dic=[ary objectAtIndex:k];
            QuicklyModel * model=[QuicklyModel yy_modelWithJSON:dic];
            model.nrid=[NSString stringWithFormat:@"%ld",k+((_page-1)*15)];
            [_dataSourceArray addObject: model];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSDictionary *errorDic) {

    }];
}

-(void)didSelectedQuicklyAtIndex1:(NSInteger)index
{
    QuicklyModel * model=[_dataSourceArray objectAtIndex:index];
    ProgrameNewDetailController * vc=[[ProgrameNewDetailController alloc] init];
    vc.loan_id=model.loan_id;
    [self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.tabBarController.tabBar setHidden:TRUE];
}

//
-(void)didSelectedQuicklyAtIndex:(NSInteger)index
{
    if(![CommonUtils isLogin])
    {
        [self OnLogin];
        return;
    }
    QuicklyModel * model=[_dataSourceArray objectAtIndex:index];
    RushPurchaseController * vc=[[RushPurchaseController alloc] init];
    vc.vistorType=@"1";
    vc.loan_id=model.loan_id;
    [self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void) OnLogin{
    [self goLoginVC];
}
- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

@end
