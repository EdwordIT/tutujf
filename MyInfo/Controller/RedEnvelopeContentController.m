//
//  RedEnvelopeContentController.m
//  TTJF
//
//  Created by wbzhan on 2018/7/3.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "RedEnvelopeContentController.h"
#import "MyRedEnvelopeCell.h"
@interface RedEnvelopeContentController ()<UITableViewDelegate,UITableViewDataSource>
Strong BaseUITableView *mainTableView;//全部
Strong NSMutableArray *mainDataArray;
Assign NSInteger mainCurrentPage;
Assign NSInteger mainTotalPages;
Strong UIButton *remindButton;//
@end

@implementation RedEnvelopeContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainCurrentPage = 1;
    self.mainTotalPages = 1;
    [self.titleView setHidden:YES];
    [self.view addSubview:self.mainTableView];
    [self loadRefresh];
    [self loadRequestAtIndex:self.selectedIndex];
    // Do any additional setup after loading the view.
}
-(NSMutableArray *)mainDataArray{
    if (!_mainDataArray) {
        _mainDataArray = InitObject(NSMutableArray);
    }
    return _mainDataArray;
}

-(BaseUITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[BaseUITableView alloc]initWithFrame:RECT(0,0, screen_width, kViewHeight-kTitleHeight) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.rowHeight = kSizeFrom750(375);
        
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
-(void)loadRequestAtIndex:(NSInteger)index{
    NSString *use_type = @"1";
    NSString *page = [NSString stringWithFormat:@"%ld",self.mainCurrentPage];
    
    switch (index) {
        case 0:{
            use_type = @"1";//未使用
        }
            break;
        case 1:{
            use_type = @"2";//已使用（待激活+激活）
        }
            break;
        case 2:{
            use_type = @"3";//已过期
        }
            break;
        default:
            break;
    }
    NSArray *keysArr = @[kToken,@"page",@"use_type"];
    NSArray *valuesArr = @[[CommonUtils getToken],page,use_type];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:myRedEnvelopeUrl keysArray:keysArr valuesArray:valuesArr refresh:self.mainTableView success:^(NSDictionary *successDic) {
        //红包规则
        [self.remindButton setTitle:[successDic objectForKey:@"rule_txt"] forState:UIControlStateNormal];
       self.mainTotalPages = [[successDic objectForKey:@"total_pages"] integerValue];
        NSArray *items =  [successDic objectForKey:@"items"];
       
        if ([page integerValue]==1) {
            [self.mainDataArray removeAllObjects];
        }
        for (int i=0; i<items.count; i++) {
            NSDictionary *dic = [items objectAtIndex:i];
            MyRedenvelopeModel *model = [MyRedenvelopeModel yy_modelWithJSON:dic];
            [self.mainDataArray addObject:model];
        }
        [self.mainTableView reloadData];
    } failure:^(NSDictionary *errorDic) {
        
    }];
    
}
-(void)loadMoreData:(NSInteger)index{
    
    if (self.mainTotalPages==self.mainCurrentPage) {//未使用
        [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    self.mainCurrentPage ++;
    [self loadRequestAtIndex:index];
}
#pragma mark -- dataSource and Delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:RECT(0, 0, screen_width, kSizeFrom750(60))];
    
    self.remindButton = [[UIButton alloc]initWithFrame:RECT(kSizeFrom750(30), kSizeFrom750(30), kSizeFrom750(690), kSizeFrom750(30))];
    [self.remindButton setImage:IMAGEBYENAME(@"remind_blue") forState:UIControlStateNormal];
    self.remindButton.userInteractionEnabled = NO;
    [self.remindButton setTitleEdgeInsets:UIEdgeInsetsMake(0, kSizeFrom750(10), 0, 0)];
    [self.remindButton setTitle:@"用户投资成功后，请等待标的满审通过红包将自动激活。" forState:UIControlStateNormal];
    [self.remindButton setTitleColor:RGB_153 forState:UIControlStateNormal];
    [self.remindButton.titleLabel setFont:SYSTEMSIZE(25)];
    [view addSubview:self.remindButton];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kSizeFrom750(60);
}
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.mainDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"MyRedEnvelopeCell";
    MyRedEnvelopeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[MyRedEnvelopeCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.investBlock = ^{
        //首页还是要返回到主页面，防止页面切换
        [[BaseViewController appRootViewController].navigationController popToRootViewControllerAnimated:NO];
        //切换到相应的标签栏，之后跳转
        [BaseViewController appRootViewController].tabBarController.selectedIndex = TabBarProgrameList;

    };
    MyRedenvelopeModel *model = [self.mainDataArray objectAtIndex:indexPath.row];
    [cell loadInfoWithModel:model];
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
