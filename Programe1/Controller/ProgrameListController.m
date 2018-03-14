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
#import "QuicklyXsCell.h"
#import "QuicklyModel.h"
//#import "Programe1Model.h"
#import "HomeWebController.h"
#import "PPNetworkHelper.h"
#import "HttpSignCreate.h"
#import "HttpUrlAddress.h"
#import "ggHttpFounction.h"
#import "DMLoginViewController.h"
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
       UIView * loading;
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
//    if(kDevice_Is_iPhoneX)
//    {
//           self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, screen_width, screen_height-50) style:UITableViewStyleGrouped];
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
//    else
//    {
//    if(iOS11)
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-64) style:UITableViewStyleGrouped];
//    else
         self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHight, screen_width, kViewHeight) style:UITableViewStyleGrouped];
//    }
    loading=[[UIView alloc] init];
    loading.frame=CGRectMake(0, 0, screen_width, screen_height);
    loading.backgroundColor=[UIColor clearColor];
    [loading setHidden:TRUE];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor=separaterColor;
    [self.tableView setSeparatorColor:separaterColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:loading];
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
            return 135;
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
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == 0) {
//        return 0.1;
//    }
//    return 0.1;
//}
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
//          QuicklyModel * tmodel1=[_dataSourceArray objectAtIndex:indexPath.row];
       // if(![tmodel1.status isEqual: @"3"])
        [self didSelectedQuicklyAtIndex1:indexPath.row];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
         NSString *cellIndentifier =[@"Quickly" stringByAppendingString:[NSString stringWithFormat:@"%ld",indexPath.row]];
        //QuicklyCell *cell = [[QuicklyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        QuicklyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
       if(cell == nil)
        {
            cell = [[QuicklyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
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
    
    
    //    footerView.backgroundColor = [UIColor yellowColor];
    return footerView;
}

-(void)loadNewData{
 
    if(_page<=total_pages)
    {
      
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _page=1;
            [weakSelf doLoanList];
        });
    }
    else{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
}

-(void)loadMoreData{
  if(_page<=total_pages)
    {
     
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
                [weakSelf doLoanList];
               _page++;
        });
    }
    else{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
}

-(void) doLoanList{
    NSString *urlStr = @"";
    dispatch_async(dispatch_get_main_queue(), ^{
        [loading setHidden:FALSE];
    });
    if(_page==1)
        [ _dataSourceArray removeAllObjects];
    
    NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[[NSString stringWithFormat:@"%ld",_page]] forKeys:@[@"page"] ];
    NSString *sign=[HttpSignCreate GetSignStr:dict_data];
    urlStr = [NSString stringWithFormat:loanList,oyApiUrl,_page,sign];
       NSData * data=  [ggHttpFounction  synHttpGet:urlStr];
    if([ggHttpFounction getJsonIsOk:data])
    {
        NSDictionary * dic1= [ggHttpFounction getJsonData1:data];
        
       total_pages=[[NSString stringWithFormat:@"%@",[dic1 objectForKey:@"total_pages"]] intValue];
        NSArray * ary= [dic1 objectForKey:@"items"];
        for(NSInteger k=0;k<[ary count];k++)
        {
            NSDictionary * dic=[ary objectAtIndex:k];
            QuicklyModel * model=[[QuicklyModel alloc] init];
             model.nrid=[NSString stringWithFormat:@"%ld",k+((_page-1)*15)];
            model.loanid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            model.additional_apr=[dic objectForKey:@"additional_apr"];
            model.name=[dic objectForKey:@"name"];
            model.activity_url_img=[dic objectForKey:@"activity_url_img"];
            model.apr=[dic objectForKey:@"apr"];
            model.additional_apr=[dic objectForKey:@"additional_apr"];
            model.period=[dic objectForKey:@"period"];
            model.progress=[dic objectForKey:@"progress"];
            model.amount=[dic objectForKey:@"amount"];
            model.repay_type_name=[dic objectForKey:@"repay_type_name"];
            model.status_name=[dic objectForKey:@"status_name"];
            model.status=[dic objectForKey:@"status"];
            model.open_up_date=[dic objectForKey:@"open_up_date"];
            model.open_up_status=[NSString stringWithFormat:@"%@",[dic objectForKey:@"open_up_status"]];
            model.link_url=[dic objectForKey:@"link_url"];
            model.bt_link_url=[dic objectForKey:@"bt_link_url"];
            model.activity_img_width=[NSString stringWithFormat:@"%@",[dic objectForKey:@"activity_img_width"]];
            model.activity_url_img_height=[NSString stringWithFormat:@"%@",[dic objectForKey:@"activity_url_img_height"]];
            [_dataSourceArray addObject: model];
        }
        if([NSThread isMainThread]){
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [loading setHidden:TRUE];
        }else dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [loading setHidden:TRUE];
        });
       
    }
    else
    {
        if([NSThread isMainThread]){
            [loading setHidden:TRUE];
        }else dispatch_async(dispatch_get_main_queue(), ^{
            [loading setHidden:TRUE];
        });
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络连接错误"  message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
        //请求失败
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
   
    
    
    
}

-(void)didSelectedQuicklyAtIndex1:(NSInteger)index
{
    /*
    self.hidesBottomBarWhenPushed=YES;
    HomeWebController *discountVC = [[HomeWebController alloc] init];
    QuicklyModel * model=[_dataSourceArray objectAtIndex:index];
    
    discountVC.urlStr=model.link_url;
    
    discountVC.returnmain=@"5"; //页返回
    [self.navigationController pushViewController:discountVC animated:YES];
    
    self.hidesBottomBarWhenPushed=NO;
     */
       QuicklyModel * model=[_dataSourceArray objectAtIndex:index];
    ProgrameNewDetailController * vc=[[ProgrameNewDetailController alloc] init];
    vc.loan_id=model.loanid;
    [self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.tabBarController.tabBar setHidden:TRUE];
}

//
-(void)didSelectedQuicklyAtIndex:(NSInteger)index
{
    if(!theAppDelegate.IsLogin)
    {
        [self OnLogin];
        return;
    }
    /*
    self.hidesBottomBarWhenPushed=YES;
    HomeWebController *discountVC = [[HomeWebController alloc] init];
    QuicklyModel * model=[_dataSourceArray objectAtIndex:index];
    
    discountVC.urlStr=model.bt_link_url;
    
    discountVC.returnmain=@"5"; //页返回
    [self.navigationController pushViewController:discountVC animated:YES];

    self.hidesBottomBarWhenPushed=NO;
     */
    QuicklyModel * model=[_dataSourceArray objectAtIndex:index];
    RushPurchaseController * vc=[[RushPurchaseController alloc] init];
    vc.vistorType=@"1";
       vc.loan_id=model.loanid;
       self.tabBarController.tabBar.hidden=YES;
    [self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void) OnLogin{
    //创建动画
    CATransition * transition = [CATransition animation];
    //设置动画类型（这个是字符串，可以搜索一些更好看的类型）
    transition.type = @"moveOut";
    //动画出现类型
    transition.subtype = @"fromCenter";
    //动画时间
    transition.duration = 0.2;
    //移除当前window的layer层的动画
    [self.view.window.layer removeAllAnimations];
    //将定制好的动画添加到当前控制器window的layer层
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    DMLoginViewController *next=[[DMLoginViewController alloc]init];
    //把当前控制器作为背景
    self.definesPresentationContext = YES;
    [self presentViewController:next animated:YES completion:nil];
    // [self presentViewController:searchVC animated:YES completion:NULL];
    //   [self.navigationController pushViewController:next animated:YES];
}
- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

@end
