//
//  MessageController.m
//  TTJF
//
//  Created by wbzhan on 2018/5/9.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MessageController.h"
#import "MessageCell.h"
#import "MJRefresh.h"
#import "HomeWebController.h"
@interface MessageController ()<UITableViewDelegate,UITableViewDataSource>
Strong BaseUITableView *mainTab;
Strong NSMutableArray *dataSource;
Assign NSInteger currentPage;
Assign NSInteger totalPages;
@end

@implementation MessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"消息列表";
    self.currentPage = 1;
    self.totalPages = 1;
    [self.rightBtn setHidden:NO];
    [self.rightBtn setTitle:@"一键清除" forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = SYSTEMSIZE(26);
    [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSizeFrom750(120));
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    [self.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mainTab];
    [SVProgressHUD show];
    [self getRequest];
    // Do any additional setup after loading the view.
}
#pragma lazyLoading
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = InitObject(NSMutableArray);
    }
    return _dataSource;
}
-(BaseUITableView *)mainTab{
    if (!_mainTab) {
        _mainTab = [[BaseUITableView alloc]initWithFrame:CGRectMake(0, kNavHight, screen_width, kViewHeight) style:UITableViewStylePlain];
        _mainTab.delegate = self;
        _mainTab.dataSource = self;
        _mainTab.rowHeight = kSizeFrom750(320);
        _mainTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        WEAK_SELF;
        _mainTab.ly_emptyView = [EmptyView noDataRefreshBlock:^{
            weakSelf.currentPage = 1;
            [weakSelf getRequest];
        }];
        [_mainTab ly_startLoading];
        _mainTab.mj_header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
            weakSelf.currentPage = 1;
            [weakSelf getRequest];
        }];
        _mainTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.currentPage++;
            [weakSelf loadMoreData];
        }];
    }
    return _mainTab;
}
#pragma mark --tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kSizeFrom750(30);
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"RechargeRecordCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    MessageModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell loadInfoWithModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [self goWebViewWithPath:model.link_url];
    //点击之后，内容置灰
     model.status = @"2";
    [self.mainTab reloadData];
}
#pragma request
//获取站内信列表
-(void)getRequest{
    NSArray *keys = @[@"page",kToken];
    NSArray *values = @[[NSString stringWithFormat:@"%ld",self.currentPage],[CommonUtils getToken]];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getUserMessageUrl keysArray:keys valuesArray:values refresh:self.mainTab success:^(NSDictionary *successDic) {
        if (self.currentPage==1) {
            [self.dataSource removeAllObjects];
        }
        
        self.totalPages = [[successDic objectForKey:@"total_pages"] integerValue];
        for (NSDictionary *dic in [successDic objectForKey:@"items"]) {
            MessageModel *model = [MessageModel yy_modelWithJSON:dic];
            [self.dataSource addObject:model];
        }
        if (self.dataSource.count==0) {
            [self.rightBtn setHidden:YES];
        }else
            [self.rightBtn setHidden:NO];
        [self.mainTab reloadData];
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
-(void)loadMoreData{
    if(self.currentPage<=self.totalPages)
    {
        __weak __typeof(self) weakSelf = self;
        [weakSelf getRequest];
    }
    else{
        [self.mainTab.mj_footer endRefreshingWithNoMoreData];
    }
}
-(void)rightBtnClick:(UIButton *)sender{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否清除全部站内信？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[HttpCommunication sharedInstance] postSignRequestWithPath:postMarkedAsReadedUrl keysArray:@[kToken] valuesArray:@[[CommonUtils getToken]] refresh:nil success:^(NSDictionary *successDic) {
            [self getRequest];
        } failure:^(NSDictionary *errorDic) {
            
        }];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:alertAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
   
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
