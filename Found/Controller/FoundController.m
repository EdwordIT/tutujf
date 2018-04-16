//
//  FoundController.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/16.
//  Copyright © 2018年 wbzhan. All rights reserved.
//

#import "FoundController.h"
#import "TreasureMiddleCell.h"
#import "FoundListCell.h"
#import "AppDelegate.h"
#import "FoundListModel.h"
#import "DiscoverMenuModel.h"
#import "FoundListModel.h"
#import "HomeWebController.h"
#import "LoginViewController.h"


@interface FoundController ()<UITableViewDataSource,UITableViewDelegate,TreasureMiddleDelegate,TreasureListDelegate>
{
  
        NSInteger currentIndex;/**< 记录当前分类按钮的下标 */
    NSInteger selectIndex;/**< 记录当前分类按钮的下标 */
    Boolean isExeute ;
    NSString * content_title;
}
@property(nonatomic, strong) BaseUITableView *tableView;
Strong NSMutableArray *dataSourceArray;
Strong NSMutableArray *topArray;

@end

@implementation FoundController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"发现";
    [self.backBtn setHidden:YES];
    [self initData];
    [self initTableView];
    // Do any additional setup after loading the view.
}


-(void)initData{
    self.dataSourceArray = [[NSMutableArray alloc] init];
    self.topArray= [[NSMutableArray alloc] init];
    currentIndex = 0;
    selectIndex=0;
    isExeute=FALSE;
    content_title=@"活动中心";
}
-(void) OnLogin{
    [self goLoginVC];
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
    self.tableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        [weakSelf loadNewData];
    }];
    self.tableView.mj_header = header;
    [self loadNewData];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    headerView.backgroundColor =separaterColor;

    if (section==1) {
        headerView.height = kSizeFrom750(110);
        UILabel *textLabel = [[UILabel alloc]initWithFrame:RECT(0, 0, screen_width,headerView.height)];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = SYSTEMSIZE(32);
        textLabel.textColor = RGB_166;
        textLabel.text = content_title;
        [headerView addSubview:textLabel];
        return headerView;
    }
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    footerView.backgroundColor = separaterColor;
    return footerView;
}

-(void)loadNewData{
    
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(!self->isExeute)
        [weakSelf doFindList];
    });
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     if (section ==0 ){
          return 1;
     }
    return [self.dataSourceArray count];
 
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        {
                return  kSizeFrom750(420);
        }
    }
    else{
     
        return kSizeFrom750(192)*self.topArray.count/3;
      
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        
        return kSizeFrom750(110);
        
    }
    
    else{
        return 0.01;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        return 0.01;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //当手指离开某行时，就让某行的选中状态消失
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        [self didTreasureListDelegateIndex:indexPath.row];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        static  NSString *cellIndentifier1 = @"TreasureMiddleCell";
        TreasureMiddleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier1];
        if(cell == nil){
            cell = [[TreasureMiddleCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier1];
        }
        cell.delegate=self;
        if([self.topArray count]>0)
            [cell setDataBind:self.topArray];
        return cell;
    }
    if (indexPath.section ==1) {
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
    return nil;
}


#pragma mark 数据获取
-(void) doFindList{
    isExeute=TRUE;
    [[HttpCommunication sharedInstance] getSignRequestWithPath:getDiscoverUrl keysArray:@[kToken] valuesArray:@[[CommonUtils getToken]] refresh:self.tableView success:^(NSDictionary *successDic) {
        [self.dataSourceArray removeAllObjects];
        [self.topArray removeAllObjects];
        NSArray * ary=[successDic objectForKey:@"top_button"];
        for(int k=0;k<[ary count];k++)
        {
            NSDictionary * dic=[ary objectAtIndex:k];
            DiscoverMenuModel * model=[DiscoverMenuModel yy_modelWithJSON:dic];
            [self.topArray addObject: model];
        }
        self->content_title=[successDic objectForKey:@"content_title"];
        
        NSArray * ary1=[successDic objectForKey:@"activity_list"];
        for(int k=0;k<[ary1 count];k++)
        {
            NSDictionary * dic=[ary1 objectAtIndex:k];
            FoundListModel * model=[FoundListModel yy_modelWithJSON:dic];
            [self.dataSourceArray addObject: model];
        }
        //在主线程中刷新UI
        MainThreadFunction([self.tableView reloadData]);
        
        [self.tableView.mj_header endRefreshing];
        self->isExeute=FALSE;
    } failure:^(NSDictionary *errorDic) {
       
    }];
}


-(void)didTreasureMiddleIndex:(NSInteger)index
{

        HomeWebController *discountVC = [[HomeWebController alloc] init];
        DiscoverMenuModel * model=[self.topArray objectAtIndex:index];
        discountVC.urlStr=model.link_url;
        if(![CommonUtils isLogin])
        {
            [self OnLogin];
            return ;
        }
        [self.navigationController pushViewController:discountVC animated:YES];
   
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
