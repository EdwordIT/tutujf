//
//  RechargeRecordController.m
//  TTJF
//
//  Created by wbzhan on 2018/4/25.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "RechargeRecordController.h"
#import "RechargeRecordCell.h"
@interface RechargeRecordController ()<UITableViewDelegate,UITableViewDataSource>
Strong BaseUITableView *mainTab;
Strong NSMutableArray *dataSource;
@end

@implementation RechargeRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"充值记录";
    [self.view addSubview:self.mainTab];
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
        WEAK_SELF;
        _mainTab.ly_emptyView = [EmptyView noDataRefreshBlock:^{
            [weakSelf getRequest];
        }];
        [_mainTab ly_startLoading];
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"RechargeRecordCell";
    RechargeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[RechargeRecordCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    return cell;
}
#pragma request
-(void)getRequest{
    [[HttpCommunication sharedInstance] postSignRequestWithPath:oyUrlAddress keysArray:nil valuesArray:nil refresh:self.mainTab success:^(NSDictionary *successDic) {
        [self.mainTab reloadData];
    } failure:^(NSDictionary *errorDic) {
        
    }];
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
