//
//  FoundController.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/16.
//  Copyright © 2018年 wbzhan. All rights reserved.
//

#import "FoundController.h"
#import "FoundListCell.h"
#import "DiscoverMenuModel.h"
#import "FoundListModel.h"
//#import "DisSectionView.h"
#import "HomeWebController.h"
#import "CooperationController.h"
#import "FeedbackController.h"
#import "TreasureMiddleCell.h"
@interface FoundController ()<UITableViewDataSource,UITableViewDelegate,TreasureListDelegate,TreasureMiddleDelegate>

//Strong DisSectionView *sectionsView;//顶部区块
Strong BaseUITableView *tableView;
Strong NSMutableArray *dataSourceArray;
Strong NSMutableArray *topArray;
Copy NSString *activityTitle;
Assign NSInteger currentPage;
Assign NSInteger totalPages;
@end

@implementation FoundController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"发现";
    self.currentPage = 1;
    [self.backBtn setHidden:YES];
    self.activityTitle=@"活动中心";
    [self initSubViews];
    [self getRequest];
    // Do any additional setup after loading the view.
}
-(NSMutableArray *)dataSourceArray{
    if(!_dataSourceArray){
        _dataSourceArray = InitObject(NSMutableArray);
    }
    return _dataSourceArray;
}
-(NSMutableArray *)topArray{
    if (!_topArray) {
        _topArray = InitObject(NSMutableArray);
    }
    return _topArray;
}
//-(DisSectionView *)sectionsView{
//    if (!_sectionsView) {
//        _sectionsView = InitObject(DisSectionView);
//        _sectionsView.delegate = self;
//        _sectionsView.backgroundColor = COLOR_White;
//        [self.sectionsView loadSectionWithArray:self.topArray];
//    }
//    return _sectionsView;
//}
-(BaseUITableView *)tableView{
    
    if (!_tableView) {
        _tableView =  [[BaseUITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        _tableView.rowHeight = kSizeFrom750(420);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = YES;
        WEAK_SELF;
        TTJFRefreshStateHeader *header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
            [weakSelf refreshRequest];
        }];
        _tableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
            [weakSelf refreshRequest];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.currentPage  ++;
            [weakSelf loadMoreData];
        }];
        [_tableView ly_startLoading];
        _tableView.mj_header = header;
    }
    return _tableView;
}
-(void)loadMoreData{
    if(self.currentPage<=self.totalPages)
    {
        __weak __typeof(self) weakSelf = self;
        [weakSelf getRequest];
    }
    else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}
/**表格数据操作**/
//初始化主界面
-(void)initSubViews{
    
//    [self.view addSubview:self.backScroll];
    
//    [self.view addSubview:self.sectionsView];
    
    [self.view addSubview:self.tableView];
//
//    [self.sectionsView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//        make.width.mas_equalTo(screen_width);
//        make.height.mas_equalTo(kSizeFrom750(384));
//    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHight);
        make.width.mas_equalTo(screen_width);
        make.bottom.mas_equalTo(self.view).offset(-kTabbarHeight);
    }];
//    [self.view bringSubviewToFront:self.titleView];
    
}
#pragma mark --scrollViewDeleagte
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView==self.tableView) {
//            [self.sectionsView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(MIN(kNavHight ,kNavHight-scrollView.contentOffset.y));
//            }];
//    }
//}
#pragma mark --tableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return nil;
    }else{
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kSizeFrom750(110))];
        headerView.backgroundColor =COLOR_Background;
        UILabel *textLabel = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, 0, kSizeFrom750(300),headerView.height)];
        textLabel.font = SYSTEMSIZE(32);
        textLabel.textColor = RGB_102;
        textLabel.text = self.activityTitle;
        [headerView addSubview:textLabel];
        return headerView;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    footerView.backgroundColor = COLOR_Background;
    return footerView;
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return kSizeFrom750(192)*((self.topArray.count-1)/3+1);
    }else{
        return kSizeFrom750(420);
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return [self.dataSourceArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  
    if (section==0) {
        return 0;
    }else
        return kSizeFrom750(110);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self didTreasureListDelegateIndex:indexPath.row];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        NSString *cellId = @"TreasureMiddleCell";
        TreasureMiddleCell *cell = [[TreasureMiddleCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.delegate = self;
        [cell setDataBind:self.topArray];
        return cell;
    }else{
        NSString *cellIndentifier = @"FoundListCell";
        FoundListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if(cell == nil)
        {
            cell = [[FoundListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        }
        
        if(self.dataSourceArray.count>0)
        {
            FoundListModel * tmodel1=[self.dataSourceArray objectAtIndex:indexPath.row];
            [cell setDataBind:tmodel1];
            cell.delegate=self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark 数据获取
-(void)getRequest{
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getDiscoverUrl keysArray:@[kToken] valuesArray:@[[CommonUtils getToken]] refresh:self.tableView success:^(NSDictionary *successDic) {
        [self.dataSourceArray removeAllObjects];
        [self.topArray removeAllObjects];
        NSArray * ary=[successDic objectForKey:@"top_button"];
        for(int k=0;k<[ary count];k++)
        {
            NSDictionary * dic=[ary objectAtIndex:k];
            DiscoverMenuModel * model=[DiscoverMenuModel yy_modelWithJSON:dic];
            [self.topArray addObject: model];
        }
        self.activityTitle=[successDic objectForKey:@"content_title"];
//        [self.sectionsView loadSectionWithArray:self.topArray];
        NSArray * ary1=[successDic objectForKey:@"activity_list"];
        for(int k=0;k<[ary1 count];k++)
        {
            NSDictionary * dic=[ary1 objectAtIndex:k];
            FoundListModel * model=[FoundListModel yy_modelWithJSON:dic];
            [self.dataSourceArray addObject: model];
        }
        [self.tableView reloadData];
        
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
//刷新
-(void)refreshRequest{
    
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getActivityListUrl keysArray:@[@"page"] valuesArray:@[[NSString stringWithFormat:@"%ld",self.currentPage]] refresh:self.tableView success:^(NSDictionary *successDic) {
        if (self.currentPage==1) {
            [self.dataSourceArray removeAllObjects];
        }
        self.totalPages = [[successDic objectForKey:RESPONSE_TOTALPAGES] integerValue];
        NSArray * ary1=[successDic objectForKey:RESPONSE_LIST];
        for(int k=0;k<[ary1 count];k++)
        {
            NSDictionary * dic=[ary1 objectAtIndex:k];
            FoundListModel * model=[FoundListModel yy_modelWithJSON:dic];
            [self.dataSourceArray addObject: model];
        }
        [self.tableView reloadData];
        
    } failure:^(NSDictionary *errorDic) {
        
    }];
}


-(void)didTreasureMiddleIndex:(NSInteger)index
{
    
    if (index==2) {
        //风控合作
        CooperationController *vc = InitObject(CooperationController);
        [self.navigationController pushViewController:vc animated:YES];
    } else if(index==4){
        //用户反馈
        FeedbackController *feed = InitObject(FeedbackController);
        [self.navigationController pushViewController:feed animated:YES];
    }else{
        DiscoverMenuModel * model=[self.topArray objectAtIndex:index];
        HomeWebController *discountVC = [[HomeWebController alloc] init];
        discountVC.urlStr=model.link_url;
        [self.navigationController pushViewController:discountVC animated:YES];
    }
}
-(void)didTreasureListDelegateIndex:(NSInteger)index
{
    if(index>=0)
    {
        HomeWebController *discountVC = [[HomeWebController alloc] init];
        FoundListModel * model=[self.dataSourceArray objectAtIndex:index];
        discountVC.urlStr=model.link_url;
        [self.navigationController pushViewController:discountVC animated:YES];
    }
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
