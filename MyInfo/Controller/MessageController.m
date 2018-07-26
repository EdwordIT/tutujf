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
#import "MessageComboBoxView.h"
@interface MessageController ()<UITableViewDelegate,UITableViewDataSource>
Strong MessageComboBoxView *comboxView;
Strong BaseUITableView *mainTab;
Strong NSMutableArray *dataSource;
Assign NSInteger currentPage;
Assign NSInteger totalPages;
Copy NSString *status;//状态
@end

@implementation MessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"消息列表";
    self.status = @"0";
    self.currentPage = 1;
    self.totalPages = 1;
    [self.rightBtn setHidden:NO];
    [self.rightBtn setImage:IMAGEBYENAME(@"more") forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(kSizeFrom750(80));
//        make.height.mas_equalTo(kSizeFrom750(30));
//    }];
    [self.view addSubview:self.mainTab];
    [self.view addSubview:self.comboxView];
    [self.comboxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kSizeFrom750(15) + kSizeFrom750(180));
        make.top.mas_equalTo(self.rightBtn.mas_bottom).offset(-kSizeFrom750(180));
        make.width.mas_equalTo(kSizeFrom750(348));
        make.height.mas_equalTo(kSizeFrom750(300));
    }];
    [SVProgressHUD show];

    [self getRequest];
    // Do any additional setup after loading the view.
}
#pragma lazyLoading
-(MessageComboBoxView *)comboxView{
    if (!_comboxView) {
        _comboxView = [[MessageComboBoxView alloc]init];
        _comboxView.layer.anchorPoint = CGPointMake(1, 0);
        _comboxView.transform = CGAffineTransformScale(self.comboxView.transform,0.01,0.01);
        _comboxView.hidden = YES;
        WEAK_SELF;
        //消息处理事件
        _comboxView.comboxBlock = ^(NSInteger tag) {
            [weakSelf showComboxView:NO];
            switch (tag) {
                case 0:
                    {
                        weakSelf.status = @"1";//未读消息
                        [weakSelf getRequest];
                    }
                    break;
                case 1:
                {
                    weakSelf.status = @"2";//已读消息
                    [weakSelf getRequest];

                }
                    break;
                    
                default:{
                    [weakSelf reloadMessage];//一键阅读
                    
                }
                    break;
            }
        };
    }
    return _comboxView;
}
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
//        _mainTab.estimatedRowHeight = kSizeFrom750(410);
        [_mainTab registerClass:[MessageCell class] forCellReuseIdentifier:@"MessageCell"];
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
    static NSString *cellId = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    MessageModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell loadInfoWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //普通的计算高度，不进行缓存
//    return [tableView fd_heightForCellWithIdentifier:@"MessageCell" configuration:^(id cell) {
////        ((MessageCell *)cell).fd_enforceFrameLayout = NO;
//    }];
  return  [tableView fd_heightForCellWithIdentifier:@"MessageCell" cacheByIndexPath:indexPath configuration:^(MessageCell *cell) {
        [cell loadInfoWithModel:[self.dataSource objectAtIndex:indexPath.row]];
    }];
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
    NSArray *keys = @[@"version",@"page",kToken,@"status"];
    NSArray *values = @[@"20",[NSString stringWithFormat:@"%ld",self.currentPage],[CommonUtils getToken],self.status];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getUserMessageUrl keysArray:keys valuesArray:values refresh:self.mainTab success:^(NSDictionary *successDic) {
        if (self.currentPage==1) {
            [self.dataSource removeAllObjects];
        }
        
        self.totalPages = [[successDic objectForKey:RESPONSE_TOTALPAGES] integerValue];
        for (NSDictionary *dic in [successDic objectForKey:RESPONSE_LIST]) {
            MessageModel *model = [MessageModel yy_modelWithJSON:dic];
            [self.dataSource addObject:model];
        }
        
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
    BOOL isHidden = self.comboxView.hidden;
    if (isHidden) {
        self.comboxView.hidden = NO;
    }
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
            self.comboxView.transform = CGAffineTransformScale(self.comboxView.transform,isHidden?100:0.01,isHidden?100:0.01);

    } completion:^(BOOL finished) {
        self.comboxView.hidden = !isHidden;
    }];
    
}
-(void)showComboxView:(BOOL)isShow{
    
    BOOL isHidden = self.comboxView.hidden;
    if (isHidden) {
        self.comboxView.hidden = NO;
    }
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        self.comboxView.transform = CGAffineTransformScale(self.comboxView.transform,isHidden?100:0.01,isHidden?100:0.01);
        
    } completion:^(BOOL finished) {
        self.comboxView.hidden = !isHidden;
    }];
}

-(void)reloadMessage{
  
    [[HttpCommunication sharedInstance] postSignRequestWithPath:postMarkedAsReadedUrl keysArray:@[kToken] valuesArray:@[[CommonUtils getToken]] refresh:nil success:^(NSDictionary *successDic) {
       
        self.currentPage = 1;
        [self getRequest];
        
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
