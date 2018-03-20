//
//  FoundController.m
//  TTJF
//
//  Created by 占碧光 on 2017/11/18.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "FoundController.h"
#import "TreasureMiddleCell.h"
#import "FoundListCell.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "FoundListModel.h"
#import "HttpSignCreate.h"
#import "HttpUrlAddress.h"
#import "ggHttpFounction.h"
#import "XunBaoMenuModel.h"
#import "FoundListModel.h"
#import "HomeWebController.h"
#import "LoginViewController.h"


@interface FoundController ()<UITableViewDataSource,UITableViewDelegate,TreasureMiddleDelegate,TreasureListDelegate>
{
    NSInteger page;/**< 页数 */
    NSInteger pagenum;/**< 每页的个数 */
    NSInteger  total_pages;
    NSMutableArray *dataSourceArray;
    NSMutableArray *topArray;
    NSMutableArray *dataheight;
    NSInteger currentIndex;/**< 记录当前分类按钮的下标 */
    NSInteger selectIndex;/**< 记录当前分类按钮的下标 */
    Boolean isExeute ;
    NSString * content_title;
}

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
    dataSourceArray = [[NSMutableArray alloc] init];
    topArray= [[NSMutableArray alloc] init];
    dataheight=[[NSMutableArray alloc] init];
    page = 1;
    pagenum = 20;
    currentIndex = 0;
    selectIndex=0;
    total_pages=0;
    isExeute=FALSE;
    content_title=@"活动中心";
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=NO;
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    if ( self.navigationController.navigationBarHidden == YES)
//    {
//
//        [self.view setBounds:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//    }
//    else
//    {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    // self.title = @"项目列表";//设置navigationbar的title；
    //  self.tabBarController.title = [NSString stringWithFormat:@"项目列表"];//来设置tab的title
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSInteger topIndex=theAppDelegate.xbindex;
    if(topIndex!=-1)
    {
        theAppDelegate.xbindex=-1;
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:topIndex];
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if([theAppDelegate.jumpLogin isEqual:@"1"])
    {
        theAppDelegate.jumpLogin=@"";
        [self OnLogin];
    }
      
}
-(void) OnLogin{
    [self goLoginVC];
}
/**表格数据操作**/
//初始化主界面
-(void)initTableView{
    if(kDevice_Is_iPhoneX)
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,kNavHight, screen_width, screen_height-124) style:UITableViewStyleGrouped];
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
//        if(iOS11)
//            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHight, screen_width, screen_height-64) style:UITableViewStyleGrouped];
//        else
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHight, screen_width, kViewHeight) style:UITableViewStyleGrouped];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    //  [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor=separaterColor;
    //   self.tableView.userInteractionEnabled =YES;
    // 设置表格尾部
    // [self.tableView setSeparatorColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.01]];
    [self.tableView setSeparatorColor:separaterColor];
    [self.view addSubview:self.tableView];
    [self setUpTableView];
}

//界面表格刷新
-(void)setUpTableView{
//    //添加下拉的动画图片
//    //设置普通状态的动画图片    //样式二：设置多张图片（有动画效果）
//    NSMutableArray *idleImages = [NSMutableArray array];
//    for (NSUInteger i = 1; i<=3; ++i) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%ld",i]];
//        [idleImages addObject:image];
//    }
//    //设置即将刷新状态的动画图片
//    NSMutableArray *refreshingImages = [NSMutableArray array];
//    for (NSInteger i = 3; i<=21; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%ld",i]];
//        [refreshingImages addObject:image];
//    }
//    NSMutableArray *pullingImages =[NSMutableArray array];
//    for (NSInteger i = 3; i<=3; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%ld",i]];
//        [pullingImages addObject:image];
//    }
//    //    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(animationRefresh)];
//
//    //-------以下是使用block方法【不包含animationRefresh方法】,动画设置在上面的部分代码---------
    
    __weak typeof(self) weakSelf = self;
    TTJFRefreshStateHeader *header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    self.tableView.mj_header = header;
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [ self.tableView.mj_footer setHidden:TRUE];
#pragma mark --- 下面两个设置根据各自需求设置
    //    // 隐藏更新时间
    header.lastUpdatedTimeLabel.hidden = YES;
    //
    //    // 隐藏刷新状态
    header.stateLabel.hidden = YES;
    
#pragma mark --- 自定义刷新状态和刷新时间文字【当然了，对应的Label不能隐藏】
    
    
    // 马上进入刷新状态
    [header beginRefreshing];
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
    
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        page=1;
        if(!isExeute)
        [weakSelf doFindList];
    });
}

-(void)loadMoreData{
//    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
     
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
    if (section ==1 ){
        
        return [dataSourceArray count]+1;
        
        // return 4;
    }
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        {
            if(indexPath.row==0)
                return  55;
            else
            {
                if([dataheight count]==0)
                return  210;
                else
                {
                    NSString * hh=[dataheight objectAtIndex: indexPath.row-1];
                    return [hh floatValue]+114;
                }
            }
        }
    }
    else{
     
        return 192;
      
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        return 0.1;
        
    }
    
    else{
        return 0.1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    else
    return 15;
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
    if (indexPath.section == 1) {
         if(indexPath.row>0)
        [self didTreasureListDelegateIndex:indexPath.row-1];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     if (indexPath.section ==0) {
            NSString *cellIndentifier1 =[@"TreasureMiddleCell" stringByAppendingString:[NSString stringWithFormat:@"%ld",indexPath.row]];
                 TreasureMiddleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier1];
         if(cell == nil)
         {
             cell = [[TreasureMiddleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier1];
         }
         cell.delegate=self;
         if([topArray count]>0)
         [cell setDataBind:topArray];
           return cell;
     }
    if (indexPath.section ==1) {
        NSString *cellIndentifier =[@"FoundListCell" stringByAppendingString:[NSString stringWithFormat:@"%ld",indexPath.row]];
        FoundListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if(indexPath.row==0)
        {
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            cell.textLabel.text = content_title;
            cell.textLabel.font=CHINESE_SYSTEM(16);
            cell.textLabel.textColor=RGB(180, 180, 180);
            cell.backgroundColor=separaterColor;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            //点击事件
          //  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self /action:@selector(OnTapClickView:)];
           // [cell addGestureRecognizer:tap];
          //  cell.tag=20;
            return cell;
        }
        else{
        if(cell == nil)
        {
            cell = [[FoundListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        }
        
        if(dataSourceArray.count>0)
        {
            FoundListModel * tmodel1=[dataSourceArray objectAtIndex:indexPath.row-1];
            int count=[dataSourceArray count]-1;
            int len=indexPath.row-1;
            if(count==len)
                [cell setDataBind:tmodel1 IsLast:TRUE];
            else
            [cell setDataBind:tmodel1 IsLast:FALSE];
             cell.delegate=self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
    return nil;
}



#pragma mark 数据获取

-(void) doFindList{
    NSString *urlStr = @"";
    isExeute=TRUE;
   // NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[@"3"] forKeys:@[@"top"] ];
  //  NSString *sign=[HttpSignCreate GetSignStr:dict_data];
    NSString * user_token=@"";
    NSString * sign=@"";
    if([CommonUtils isLogin])
    {
        user_token= [CommonUtils getToken];
        NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[user_token] forKeys:@[kToken]];
        sign=[HttpSignCreate GetSignStr:dict_data];
    }
    urlStr = [NSString stringWithFormat:getFindActivity,oyApiUrl,user_token,sign];
    
    NSData * data=  [ggHttpFounction  synHttpGet:urlStr];
    if([ggHttpFounction getJsonIsOk:data])
    {
        [dataSourceArray removeAllObjects];
        [topArray removeAllObjects];
        [dataheight removeAllObjects];
        NSDictionary * dir= [ggHttpFounction getJsonData1:data];
        NSArray * ary=[dir objectForKey:@"top_button"];
        for(int k=0;k<[ary count];k++)
        {
            XunBaoMenuModel * model=[[XunBaoMenuModel alloc] init];
            NSDictionary * dic=[ary objectAtIndex:k];
            model.title=[dic objectForKey:@"title"];
            model.width=[dic objectForKey:@"width"];
            model.height=[dic objectForKey:@"height"];
            model.pic_url=[dic objectForKey:@"pic_url"];
            model.link_url=[dic objectForKey:@"link_url"];
           [topArray addObject: model];
        }
        content_title=[dir objectForKey:@"content_title"];
        
         NSArray * ary1=[dir objectForKey:@"activity_list"];
        for(int k=0;k<[ary1 count];k++)
        {
            NSDictionary * dic=[ary1 objectAtIndex:k];
            FoundListModel * model=[[FoundListModel alloc] init];
            model.title=[dic objectForKey:@"title"];
            model.date=[dic objectForKey:@"date"];
            model.pic_url=[dic objectForKey:@"pic_url"];
            model.link_url=[dic objectForKey:@"link_url"];
            model.width=[dic objectForKey:@"width"];
            model.height=[dic objectForKey:@"height"];
            CGFloat hh=0;
            hh=([model.height floatValue]/[model.width floatValue])*screen_width;
            [dataheight addObject:[NSString stringWithFormat:@"%.1f",hh]];
            
            [dataSourceArray addObject: model];
        }
      
        
//        if ([NSThread currentThread]== [NSThread mainThread]) {
//            [self.tableView reloadData];
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
//        }
//
        
        MainThreadFunction([self.tableView reloadData]);
        
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            isExeute=FALSE;
        
    }
    else
    {
        
    }
    
}


-(void)didTreasureMiddleIndex:(NSInteger)index
{
    int cur=index-10000;
     if([topArray count]>=cur)
    {
        self.hidesBottomBarWhenPushed=YES;
        HomeWebController *discountVC = [[HomeWebController alloc] init];
        XunBaoMenuModel * model=[topArray objectAtIndex:cur-1];
        discountVC.urlStr=model.link_url;
        if([model.link_url rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/feedback/add"]].location != NSNotFound)
        {
            if(![CommonUtils isLogin])
            {
                [self OnLogin];
                return ;
            }
        }
        discountVC.returnmain=@"3"; //页返回
        [self.navigationController pushViewController:discountVC animated:YES];
//        self.title=@"发现";
        self.hidesBottomBarWhenPushed=NO;
    }
    
}

-(void)didTreasureListDelegateIndex:(NSInteger)index
{
    if(index>=0)
    {
        self.hidesBottomBarWhenPushed=YES;
        HomeWebController *discountVC = [[HomeWebController alloc] init];
        FoundListModel * model=[dataSourceArray objectAtIndex:index];
        theAppDelegate.tabindex=2;
        discountVC.urlStr=model.link_url;
        discountVC.returnmain=@"3"; //页返回
        [self.navigationController pushViewController:discountVC animated:YES];
        self.title=@"发现";
        self.hidesBottomBarWhenPushed=NO;
        
        //OnLogin
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
