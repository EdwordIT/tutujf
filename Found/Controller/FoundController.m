//
//  FoundController.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/16.
//  Copyright © 2018年 wbzhan. All rights reserved.
//

#import "FoundController.h"
#import "DiscoverMenuModel.h"
#import "FoundListModel.h"
#import "DisSectionView.h"
#import "DisListView.h"
#import "HomeWebController.h"
#import "CooperationController.h"
#import "FeedbackController.h"
@interface FoundController ()<DiscoverSectionDelegate,DisListViewDelegate,UIScrollViewDelegate>

Strong DisSectionView *sectionsView;//顶部区块
Strong DisListView *listView;//列表
//Strong BaseUITableView *tableView;
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
-(DisSectionView *)sectionsView{
    if (!_sectionsView) {
        _sectionsView = [[DisSectionView alloc]initWithFrame:RECT(0, -kSizeFrom750(384), screen_width, kSizeFrom750(384))];
        _sectionsView.delegate = self;
        _sectionsView.backgroundColor = COLOR_White;
        [_sectionsView loadSectionWithArray:self.topArray];
    }
    return _sectionsView;
}
-(DisListView *)listView{
    if (!_listView) {
        _listView = InitObject(DisListView);
        _listView.delegate = self;
        _listView.listDelegate = self;
        WEAK_SELF;
        TTJFRefreshStateHeader *header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
            [weakSelf refreshRequest];
        }];
        _listView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
            [weakSelf refreshRequest];
        }];
        _listView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.currentPage  ++;
            [weakSelf loadMoreData];
        }];
        [_listView ly_startLoading];
        _listView.mj_header = header;
    }
    return _listView;
}

-(void)loadMoreData{
    if(self.currentPage<=self.totalPages)
    {
        __weak __typeof(self) weakSelf = self;
        [weakSelf getRequest];
    }
    else{
        [self.listView.mj_footer endRefreshingWithNoMoreData];
    }
}
/**表格数据操作**/
//初始化主界面
-(void)initSubViews{
    
    [self.view addSubview:self.listView];
    
    [self.listView addSubview:self.sectionsView];
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHight+kSizeFrom750(384));
        make.width.mas_equalTo(screen_width);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view).offset(-kTabbarHeight);
    }];
    [self.view bringSubviewToFront:self.titleView];
    
}
#pragma mark --scrollViewDeleagte
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<=0) {
        self.sectionsView.top = -kSizeFrom750(384)+scrollView.contentOffset.y;
    }else{

        self.sectionsView.top = -kSizeFrom750(384);

        
    }
}

#pragma mark 数据获取
-(void)getRequest{
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getDiscoverUrl keysArray:@[kToken] valuesArray:@[[CommonUtils getToken]] refresh:self.listView success:^(NSDictionary *successDic) {
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
        [self.sectionsView loadSectionWithArray:self.topArray];
        NSArray * ary1=[successDic objectForKey:@"activity_list"];
        for(int k=0;k<[ary1 count];k++)
        {
            NSDictionary * dic=[ary1 objectAtIndex:k];
            FoundListModel * model=[FoundListModel yy_modelWithJSON:dic];
            [self.dataSourceArray addObject: model];
        }
        [self.listView loadInfoWithArray:self.dataSourceArray andTitle:self.activityTitle];
        
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
//刷新
-(void)refreshRequest{
    
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getActivityListUrl keysArray:@[@"page"] valuesArray:@[[NSString stringWithFormat:@"%ld",self.currentPage]] refresh:self.listView success:^(NSDictionary *successDic) {
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
        [self.listView loadInfoWithArray:self.dataSourceArray andTitle:self.activityTitle];

    } failure:^(NSDictionary *errorDic) {
        
    }];
}

#pragma mark --sectionViewDelegate
-(void)didTapSectionButton:(NSInteger)index
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
#pragma mark --listViewDelegate
-(void)didClickListButtonIndex:(NSInteger)index
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
