//
//  MainViewController.m
//    改版的B版效果 是参照国美在线头部搜索 C 版 是 我主良缘
//
//  Created by 占碧光 on 2017/2/26.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "MainViewController.h"
#import "NavHomeView.h"
#import "HttpSignCreate.h"
#import "MJRefresh.h"
#import "NSBundle+MJRefresh.h"
#import "MJExtension.h"
#import "DMLoginViewController.h"
#import "HomeBanner.h"
#import "BannerModel.h"
#import "ReturnCode.h"
#import "HotProgramCell.h"
#import "ImmediateCell.h"
#import "QuicklyCell.h"
#import "OpenAdvertView.h"
#import "WinChageType.h"
#import "NewsDynamicsCell.h"
#import "NewsDynamicsModel.h"
#import "HomeWebController.h"
#import "HttpUrlAddress.h"
#import "PPNetworkHelper.h"
#import "ggHttpFounction.h"
#import "AutoLogin.h"
#import "UpdateVersion.h"
#import "RushPurchaseController.h"
#import "ProgrameNewDetailController.h"
#import "TTJFRefreshStateHeader.h"


@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,UIWebViewDelegate,BannerDelegate,ImmediateDelegate,ProgramDelegate,QuicklyDelegate,OpenShowAdvertDelegate,NewsDynamicsDelegate,QuicklyDelegate,AutoLoginDelegate,OpenVersionDelegate>
{
    UIWebView *iWebView;
   // NSMutableArray *_menuArray;//
    NSMutableArray *_kstzArray;//快速投资
  
    NSMutableArray *_albumTopArray;/*轮播图下面的数据**/
    NSMutableArray *_albumListArray;/**< 第二个轮播图片URL数据 */
    NSMutableArray *_albumImgurlArray;/**< 第二个轮播图片URL数据 */
    
    NSMutableArray *_lijiTouZiArray; //立即投资
    NSMutableArray * tArray;
    NSMutableArray * daibanArrayURL;
    
   //    NSMutableArray * _newsDynamicsArray;
    
    UILabel* ptjyje ;//平台交易金额
    UIView *_maskView;
     UIView *_maskView1;
    OpenAdvertView *advertView;
    UpdateVersion *versionView;
    NewsDynamicsCell *newcell ;
    HomeBanner *bannercell ;
    
    NSInteger  additionalstatus;
    UIView *footerView ;
    Boolean isExeute;
    AutoLogin * autolog;

}
@property (nonatomic ,strong) NavHomeView *navView; //导航栏视图
@end


@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.view.backgroundColor =RGB(243,243,243);
    additionalstatus=1;//1 有数据  0无数据
    isExeute=FALSE;
     footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 34)];
    [self initData];
    // [self setNav];
    /**数据广告**/
    [self getAdvertData];
   /**数据广告**/
    /****自动登录****/
    if (BBUserDefault.isNoFirstLaunch)
    {
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *isSet = [userDefaultes stringForKey:@"IsSet"];
        if(isSet !=nil)
        {
            autolog=[[AutoLogin alloc] init];
            autolog.delegate=self;
            [autolog InitData];
        }
    }
     /****自动登录****/
    
    theAppDelegate.tabindex=0; //栏目当前的底部位置
    
     /****头部渐变****/
    self.navView = [[NavHomeView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kNavHight)];
    [self.view addSubview:self.navView];
  //  [self initAdvertMaskView];
     /****头部渐变****/
   /**版本判断**/
    if(theAppDelegate. IsUpdate)
    {
        [self initVersionMaskView];
    }
   
   
}
//视图出现时操作
-(void)viewWillAppear:(BOOL)animated{
     [self.navigationController setNavigationBarHidden:YES animated:NO];
     self.tabBarController.tabBar.hidden=NO;
    if(newcell!=nil)
    {
        [newcell setXuanZhuanDh];
    }
    if(theAppDelegate.IsWebRegdit)
    {
       self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:3];
    }
}


//设置头部数据变化
-(void) setBanndrNum
{
    if(bannercell!=nil)
    {
        HotQueueModel * tmodel1=[_lijiTouZiArray objectAtIndex:0];
        if(tmodel1!=nil)
        {
        CGFloat num=[tmodel1.trans_num intValue];
        [bannercell setTopJinE:num];
        }
        
    }
}
/****
-(void)viewWillAppear:(BOOL)animated{
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(void+++)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
****/
/**iOS导航栏的正确隐藏方式**/
/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}*/
/**iOS导航栏的正确隐藏方式**/
/**界面初始化操作**/
//导航返回刷新
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    theAppDelegate.tabindex=0;
    NSInteger topIndex=theAppDelegate.xbindex;
    self.tabBarController.tabBar.hidden=NO;
   [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if(topIndex!=-1)
    {
        theAppDelegate.xbindex=-1;
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:topIndex];
    }
    [self viewWillLayoutSubviews];
    if([theAppDelegate.jumpLogin isEqual:@"1"])
    {
        theAppDelegate.jumpLogin=@"";
        [self OnLogin];
    }
}

//初始化数据
-(void)initData{
    _kstzArray = [[NSMutableArray alloc] init];
    _lijiTouZiArray= [[NSMutableArray alloc] init];
    daibanArrayURL=[[NSMutableArray alloc] init];
    tArray=[[NSMutableArray alloc] init];
    _albumTopArray= [[NSMutableArray alloc] init];
    _albumListArray= [[NSMutableArray alloc] init];
    _albumImgurlArray= [[NSMutableArray alloc] init];
    
   // _newsDynamicsArray= [[NSMutableArray alloc] init];//最新动态数据模板

}
//初始化主界面
-(void)initTableView{
    if(kDevice_Is_iPhoneX)
    {
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, screen_width, screen_height-50) style:UITableViewStyleGrouped];
        
        self.tableView.contentInsetAdjustmentBehavior  = UIScrollViewContentInsetAdjustmentNever;
   
    }
    else
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -kStatusBarHeight, screen_width, screen_height+kStatusBarHeight) style:UITableViewStyleGrouped];
  
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;

    self.tableView.backgroundColor=separaterColor;
    // 设置表格尾部

   
    footerView.backgroundColor=separaterColor;
    [self.tableView setTableFooterView:footerView];
    // [self.tableView setSeparatorColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.01]];
    [self.tableView setSeparatorColor:separaterColor];
    [self.view addSubview:self.tableView];
    [self setUpTableView];
}
//界面表格刷新
-(void)setUpTableView{
 
    __weak typeof(self) weakSelf = self;
   
    self.tableView.mj_header =  [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];;
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

//重复刷新
-(void)refreshData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        // [self getHttpDatta:@"839" top:@"5"];
       // [self getDaiBang];
        dispatch_async(dispatch_get_main_queue(), ^{
            //update UI
            [self getAdvertData];
     
        });
    });
    
    
}

-(void)loadNewData
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        // [self getHttpDatta:@"839" top:@"5"];
        // [self getDaiBang];
        dispatch_async(dispatch_get_main_queue(), ^{
            //update UI
            if(isExeute)
            {
                [self getAdvertData];
            }
            else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            }
        });
    });
    
}
/**界面初始化操作**/

/**表格数据操作**/

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section ==0 ){
        //return _hotQueueData.count+1;
        return 3;
    }
    else if (section ==1 ){
        return 1;
    }
    else if (section ==2 ){
        return _kstzArray.count+1;
    }
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        {
            if(indexPath.row==0)
                return 215;
           else if(indexPath.row==1)
                return 60;
            else
            {
                if(additionalstatus==1)
                    return 80;
                    else
                return 80; //85
            }
        
        }
    }else if(indexPath.section == 1){
           if(additionalstatus==1)
               return 190;
               else
        return  0.1; //190
        
    }else if (indexPath.section == 2){
       
        if(indexPath.row==0)
            return 40;
        else
            return 135;
        
    }
   
    else{
        return 70.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    else if (section == 1) {
         if(additionalstatus==1)
             return 5;
        else
        return 0.1;  //5
    } else if (section == 2) {
        return 0.1;
    }
    else{
        return 5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if(additionalstatus==1)
            return 5;
        else
        return 0.1; //5
    }
    else if (section == 1) {
        return 0.1;
    } else if (section == 2) {
        return 0.1;
    }
    else{
        return 15;
    }
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
      
        
        if(indexPath.row == 0)
        {
            static NSString *cellIndentifier = @"menubanner";
            if(bannercell==nil)
            bannercell =  [[HomeBanner alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            if(_albumImgurlArray.count>0&&_lijiTouZiArray.count>0)
            {
                [bannercell setModelArray:_albumImgurlArray];
                HotQueueModel * tmodel1=[_lijiTouZiArray objectAtIndex:0];
                CGFloat num=[tmodel1.trans_num intValue];
                [bannercell setTopJinE:num];
            }
            bannercell.selectionStyle = UITableViewCellSelectionStyleNone;
            bannercell.delegate=self;
            return bannercell;
  
        }
        else  if(indexPath.row == 1)
        {
            static NSString *cellIndentifier = @"NewsDynamics";
            if(newcell==nil)
            newcell =  [[NewsDynamicsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            if(daibanArrayURL.count>0)
            {
                [newcell setDaiBangSj:daibanArrayURL];
             
            }
            newcell.delegate=self;
            newcell.selectionStyle = UITableViewCellSelectionStyleNone;
            [newcell setXuanZhuanDh];
            return newcell;
        }
        
        
      else  if(indexPath.row == 2)
        {
            static NSString *cellIndentifier = @"HotProgram";
            HotProgramCell *cell =  [[HotProgramCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            if(_lijiTouZiArray.count>0)
            {
                HotQueueModel * tmodel1=[_lijiTouZiArray objectAtIndex:0];
                [cell setHotQueueData:tmodel1];
            }
              cell.delegate=self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                      return cell;
        }
        
    }else if (indexPath.section == 1){
        
        if(indexPath.row == 0)
        {
            static NSString *cellIndentifier = @"Immediate";
            ImmediateCell *cell = [[ImmediateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            if(tArray.count>0)
            {
                ImmediateModel * tmodel1=[tArray objectAtIndex:0];
                [cell setImmediateModel:tmodel1];
            }
              cell.delegate=self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(additionalstatus==1)
           [cell setHidden:FALSE];
                else
            [cell setHidden:TRUE];
            return cell;
        }
       
        
        
    }
    else if(indexPath.section ==2){
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"newTitleCell";
            UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.text=@"";
            
           UIImageView *typeimgsrc= [[UIImageView alloc] initWithFrame:CGRectMake(15, 14,4, 15)];
           [typeimgsrc setImage:[UIImage imageNamed:@"Hone_Column_Rapidinvestment_"]];
           [cell addSubview:typeimgsrc];
            
            UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(28, 14.5,110, 14)];
            title.text = @"快速投资";
            title.font=CHINESE_SYSTEM(14);
            title.textAlignment=NSTextAlignmentLeft;
            title.textColor=RGB(31,31,31);
            [cell addSubview:title];
            [cell setBackgroundColor:separaterColor];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //点击事件
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapClickView:)];
            [cell addGestureRecognizer:tap];
            
            cell.tag=10;
            
            return cell;
            
        }else{
            
           // static NSString *cellIndentifier = @"Quickly";
            NSString *cellIndentifier =[@"1Quickly" stringByAppendingString:[NSString stringWithFormat:@"%ld",indexPath.row-1]];
           QuicklyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if(cell == nil)
            {
                cell = [[QuicklyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            //  QuicklyCell *cell = [[QuicklyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            if(_kstzArray.count>0)
            {
                QuicklyModel * tmodel1=[_kstzArray objectAtIndex:indexPath.row-1];
                [cell setQuicklyModel:tmodel1];
                    if([tmodel1.status isEqual: @"3"])
                    {
                           cell.delegate=self;
                    }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
            return cell;
            
        }
        
    }
    
    return nil;
}




#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //当手指离开某行时，就让某行的选中状态消失
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        
        if(indexPath.row>0)
        {
           
        }
        
    }
   else  if (indexPath.section == 2) {
        
        if(indexPath.row>0)
        {
//            QuicklyModel * tmodel1=[_kstzArray objectAtIndex:indexPath.row-1];
           // if(![tmodel1.status isEqual: @"3"])
            [self  didSelectedQuicklyAtIndex1:indexPath.row-1];
        }
        
    }
   else  if (indexPath.section == 3) {
       
       if(indexPath.row>0)
       {
          
       }
       
   }
   else  if (indexPath.section == 4) {
       
       if(indexPath.row>0)
       {
           
       }
       
   }

}


/**表格数据操作**/

/**表格内部委托事件出触发**/

//轮播图事件
-(void)didSelectedBannerAtIndex:(NSInteger)index
{
    BannerModel * model=[_albumListArray objectAtIndex:index];
    self.title=@"";
    self.hidesBottomBarWhenPushed=YES;
    HomeWebController *discountVC = [[HomeWebController alloc] init];
    
    if ([model.link_url rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/loan/loantender"]].location != NSNotFound)
    {
            self.title=@"首页";
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
        return;
    }
    else
    discountVC.urlStr=model.link_url;
    
    discountVC.returnmain=@"3"; //页返回
    [self.navigationController pushViewController:discountVC animated:YES];
    self.title=@"首页";
    self.hidesBottomBarWhenPushed=NO;
}

//最新项目
-(void)didSelectedProgramAtIndex:(NSInteger)index
{
    if(index==1)
    {
        if(!theAppDelegate.IsLogin)
        {
            [self OnLogin];
            return;
        }
     HotQueueModel * model= [_lijiTouZiArray objectAtIndex:0];
            self.title=@"";
             self.hidesBottomBarWhenPushed=YES;
        HomeWebController *discountVC = [[HomeWebController alloc] init];
        
        discountVC.urlStr=model.left_link_url;
        
        discountVC.returnmain=@"5"; //页返回
        [self.navigationController pushViewController:discountVC animated:YES];
        self.title=@"首页";
             self.hidesBottomBarWhenPushed=NO;
    }
    else if(index==2)
    {
         HotQueueModel * model= [_lijiTouZiArray objectAtIndex:0];
        self.title=@"";
           self.hidesBottomBarWhenPushed=YES;
        HomeWebController *discountVC = [[HomeWebController alloc] init];
         discountVC.urlStr=model.right_link_url;
      //  discountVC.urlStr=@"http://www.tutujf.com/wap/page/getPage?action=noviceguide";
        
        discountVC.returnmain=@"5"; //页返回
        [self.navigationController pushViewController:discountVC animated:YES];
         self.title=@"首页";
             self.hidesBottomBarWhenPushed=NO;
    }
}

//立即投资
-(void)didSelectedImmediateAtIndex:(NSInteger)index
{
      if(!theAppDelegate.IsLogin)
      {
          [self OnLogin];
          return;
      }
    /*
      self.title=@"";
      self.hidesBottomBarWhenPushed=YES;
      HomeWebController *discountVC = [[HomeWebController alloc] init];
          ImmediateModel * model=[tArray objectAtIndex:0];
      
      discountVC.urlStr=model.bt_link_url;
      
      discountVC.returnmain=@"5"; //页返回
      [self.navigationController pushViewController:discountVC animated:YES];
      self.title=@"首页";
      self.hidesBottomBarWhenPushed=NO;
     */
   ImmediateModel * model=[tArray objectAtIndex:0];
    RushPurchaseController * vc=[[RushPurchaseController alloc] init];
    vc.vistorType=@"1";
    vc.loan_id=model.loanid;
        self.tabBarController.tabBar.hidden=YES;
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
  
}
-(void)didSelectedQuicklyAtIndex1:(NSInteger)index
{
    //if(![tmodel1.status isEqual: @"3"])
    /*
    self.title=@"";
    self.hidesBottomBarWhenPushed=YES;
    HomeWebController *discountVC = [[HomeWebController alloc] init];
    QuicklyModel * model=[_kstzArray objectAtIndex:index];
    
    discountVC.urlStr=model.link_url;
    
    discountVC.returnmain=@"5"; //页返回
    [self.navigationController pushViewController:discountVC animated:YES];
    self.title=@"首页";
    self.hidesBottomBarWhenPushed=NO;
    */
      QuicklyModel * model=[_kstzArray objectAtIndex:index];
    ProgrameNewDetailController * vc=[[ProgrameNewDetailController alloc] init];
    vc.loan_id=model.loanid;
      [self.navigationController pushViewController:vc animated:YES];
         [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.tabBarController.tabBar setHidden:TRUE];
}
//快速投资
-(void)didSelectedQuicklyAtIndex:(NSInteger)index
{
    if(!theAppDelegate.IsLogin)
    {
        [self OnLogin];
        return;
    }
    QuicklyModel * model=[_kstzArray objectAtIndex:index];
      RushPurchaseController * vc=[[RushPurchaseController alloc] init];
      vc.vistorType=@"1";
    vc.loan_id=model.loanid;
     self.tabBarController.tabBar.hidden=YES;
      [self.navigationController pushViewController:vc animated:YES];
      [self.navigationController setNavigationBarHidden:NO animated:NO];
    //self.title=@"";
   // self.hidesBottomBarWhenPushed=YES;
   // HomeWebController *discountVC = [[HomeWebController alloc] init];
    // QuicklyModel * model=[_kstzArray objectAtIndex:index];
    
   // discountVC.urlStr=model.bt_link_url;
    
   // discountVC.returnmain=@"5"; //页返回
   // [self.navigationController pushViewController:discountVC animated:YES];
  // self.title=@"首页";
  //  self.hidesBottomBarWhenPushed=NO;
}
//快速投资 头部
-(void)OnTapClickView:(UIGestureRecognizer*)Tap
{
    
 //   UIView * view=Tap.view;
}
//滚动视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 100 && offsetY > 0) {
        //53, 171, 245
        self.navView.navLabel.text=@"土土金服";
        self.navView.backgroundColor = [UIColor colorWithRed:53/255.0 green:171/255.0 blue:245/255.0 alpha:offsetY / 100.0];
    }else if(offsetY > 100){
        self.navView.backgroundColor = [UIColor colorWithRed:53/255.0 green:171/255.0 blue:245/255.0 alpha:1.0];
        self.navView.navLabel.text=@"土土金服";
    }else{
        self.navView.backgroundColor = [UIColor clearColor];
        self.navView.navLabel.text=@"";
    }
    
    if (scrollView.tag == 131420) {
        MJRefreshBackNormalFooter *footView = (MJRefreshBackNormalFooter *)_tableView.mj_footer;
        footView.stateLabel.frame = CGRectMake(scrollView.contentOffset.x, footView.stateLabel.frame.origin.y, footView.stateLabel.frame.size.width, footView.stateLabel.frame.size.height);
        footView.arrowView.center = CGPointMake(footView.stateLabel.center.x - 100, footView.arrowView.center.y);
        //   footView.loadingView.center = CGPointMake(footView.stateLabel.center.x - 100, footView.arrowView.center.y);
        MJRefreshNormalHeader *headView = (MJRefreshNormalHeader *)_tableView.mj_header;
        headView.stateLabel.frame = CGRectMake(scrollView.contentOffset.x, headView.stateLabel.frame.origin.y, headView.stateLabel.frame.size.width, headView.stateLabel.frame.size.height);
        headView.arrowView.center = CGPointMake(headView.stateLabel.center.x - 100, headView.arrowView.center.y);
        //  headView.loadingView.center = CGPointMake(headView.stateLabel.center.x - 100, headView.arrowView.center.y);
        headView.lastUpdatedTimeLabel.center = CGPointMake(headView.stateLabel.center.x, headView.lastUpdatedTimeLabel.center.y);
    }
    //  NSLog(@"%f",scrollView.contentOffset.y);
}
// 公告
-(void)didSelectedNewsDynamicsAtIndex:(NSInteger)index
{
    //daibanArrayURL
    NewsDynamicsModel * model=[daibanArrayURL objectAtIndex:index];
    self.title=@"";
    self.hidesBottomBarWhenPushed=YES;
    HomeWebController *discountVC = [[HomeWebController alloc] init];
    
   
        discountVC.urlStr=model.link_url;
    
    discountVC.returnmain=@"5"; //页返回
    [self.navigationController pushViewController:discountVC animated:YES];
    self.title=@"首页";
    self.hidesBottomBarWhenPushed=NO;
}
/**表格内部委托事件出触发**/

/**网络访问数据操作**/
/**
 **/

/**首页广告录播图**/
-(void) getAdvertData{
   
    NSString *urlStr = @"";
    NSString * user_token=@"";
    NSString * sign=@"";
    if(theAppDelegate.IsLogin)
    {
        user_token=theAppDelegate.user_token;
        NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[theAppDelegate.user_token] forKeys:@[@"user_token"] ];
        sign=[HttpSignCreate GetSignStr:dict_data];
    }
    urlStr = [NSString stringWithFormat:getAdvert,oyApiUrl,user_token,sign];
    NSData * data=  [ggHttpFounction  synHttpGet:urlStr];
    if([ggHttpFounction getJsonIsOk:data])
    {
        [_albumListArray removeAllObjects];
        [_albumImgurlArray removeAllObjects];
        NSArray *arrayList=  [ggHttpFounction getJsonData:data];
        for(int k=0;k<[arrayList count];k++)
        {
            NSDictionary * dir =  [arrayList  objectAtIndex:k];
            BannerModel * model=[[BannerModel alloc] init];
            model.pic_url=[dir objectForKey:@"pic_url"]; //[dir objectForKey:@"title"];
            //   model.title=[dir objectForKey:@"title"];
            model.link_url=[dir objectForKey:@"link_url"];
            //   model.nrid=[NSString  stringWithFormat:@"%@", [dir objectForKey:@"id"]];
            [_albumListArray addObject: model];
            [_albumImgurlArray addObject: model.pic_url];
            
        }
          [self GetNoviceLoanInfo];
    }
    else
    {
        /*
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""   message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
         */
            [self GetNoviceLoanInfo];
    }
    
    /*
    [PPNetworkHelper GET:urlStr parameters:nil success:^(id responseObject) {
        //请求成功
       // NSDictionary *dic = [responseObject objectForKey:@"resultData"];
        NSString * resultStatus= [responseObject objectForKey:@"resultStatus"];
        [_albumListArray removeAllObjects];
        [_albumImgurlArray removeAllObjects];
        if([resultStatus isEqual:@"0"])
        {
                 NSArray * array=[responseObject objectForKey:@"resultData"];
            for(int k=0;k<[array count];k++)
            {
                NSDictionary * dir =  [array  objectAtIndex:k];
                BannerModel * model=[[BannerModel alloc] init];
                model.pic_url=[NSString stringWithFormat:@"%@%@",oyApiUrl,[dir objectForKey:@"pic_url"]]; //[dir objectForKey:@"title"];
                //   model.title=[dir objectForKey:@"title"];
                model.link_url=[dir objectForKey:@"link_url"];
                //   model.nrid=[NSString  stringWithFormat:@"%@", [dir objectForKey:@"id"]];
                [_albumListArray addObject: model];
                [_albumImgurlArray addObject: model.pic_url];
                
            }
            
        }
        else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[ReturnCode getSysCMsg:resultStatus]   message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        [self GetNoviceLoanInfo];
        //[PPNetworkCache setHttpCache:responseObject URL:urlStr parameters:nil];
    } failure:^(NSError *error) {
        //请求失败
        NSLog(@"Error: %@", error);
      
    }];
    */
}

-(void) GetNoviceLoanInfo{
    NSString *urlStr = @"";
    urlStr = [NSString stringWithFormat:noviceLoanInfo,oyApiUrl];
    
    NSData * data=  [ggHttpFounction  synHttpGet:urlStr];
    if([ggHttpFounction getJsonIsOk:data])
    {
         [tArray removeAllObjects];
        NSDictionary * dic= [ggHttpFounction getJsonData1:data];
        ImmediateModel * model=[[ImmediateModel alloc] init];
        if([[dic objectForKey:@"additional_status"]  isEqual:@"1"])
        {
            additionalstatus=1;
        model.additional_status=[dic objectForKey:@"additional_status"];
        model.link_url=[dic objectForKey:@"link_url"];
         model.loanid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
         model.bt_link_url=[dic objectForKey:@"bt_link_url"];
        model.activity_url_img=@"";
        model.apr=[dic objectForKey:@"apr"];
        model.additional_apr=[dic objectForKey:@"additional_apr"];
        model.period=[dic objectForKey:@"period"];
        model.tender_amount_min=[dic objectForKey:@"tender_amount_min"];
        }
        else  if([[dic objectForKey:@"additional_status"]  isEqual:@"0"])

        {
                additionalstatus=0;
            model.additional_status=@"0";
            model.link_url=@"";
            
            model.activity_url_img=@"";
            model.apr=@"10.00";
            model.additional_apr=@"1";
            model.period=@"10";
            model.tender_amount_min=@"10";
        }
        [tArray addObject: model];
         [self GetInterfaceData];
    }
    else
    {
         /*
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""  message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
          */
         [self GetInterfaceData];
        
    }
    
    /*
    [PPNetworkHelper GET:urlStr parameters:nil success:^(id responseObject) {
        //请求成功
        NSDictionary *dic = [responseObject objectForKey:@"resultData"];
        NSString * resultStatus= [responseObject objectForKey:@"resultStatus"];
        [tArray removeAllObjects];
        if([resultStatus isEqual:@"0"])
        {
            NSDictionary * dic=[responseObject objectForKey:@"resultData"];
            ImmediateModel * model=[[ImmediateModel alloc] init];
      
            model.additional_status=[dic objectForKey:@"additional_status"];
            model.link_url=[dic objectForKey:@"link_url"];
            
            model.activity_url_img=[dic objectForKey:@"activity_url_img"];
            model.apr=[dic objectForKey:@"apr"];
             model.apr=[dic objectForKey:@"additional_apr"];
            model.apr=[dic objectForKey:@"period"];
            model.apr=[dic objectForKey:@"tender_amount_min"];
           [tArray addObject: model];
            
            
        }
        else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[ReturnCode getSysCMsg:resultStatus]   message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        [self GetInterfaceData];
        //[PPNetworkCache setHttpCache:responseObject URL:urlStr parameters:nil];
    } failure:^(NSError *error) {
        //请求失败
        [self GetInterfaceData];
    }];
    */
}


-(void) GetInterfaceData{
    NSString *urlStr = @"";
    urlStr = [NSString stringWithFormat:getInterface,oyApiUrl];
    NSData * data=  [ggHttpFounction  synHttpGet:urlStr];
    if([ggHttpFounction getJsonIsOk:data])
    {
        [_lijiTouZiArray removeAllObjects];
        NSDictionary * dic= [ggHttpFounction getJsonData1:data];
        HotQueueModel * model=[[HotQueueModel alloc] init];
        //trans_num
        model.trans_num=[dic objectForKey:@"trans_num"];
        NSDictionary * dleft=[dic objectForKey:@"index_left_ad"];
        
        model.left_pic_url=[dleft objectForKey:@"pic_url"];
        model.left_link_url=[dleft objectForKey:@"link_url"];
        NSDictionary * dright=[dic objectForKey:@"index_right_ad"];
        model.right_pic_url=[dright objectForKey:@"pic_url"];
        model.right_link_url=[dright objectForKey:@"link_url"];
        
        model.guarantee_txt=[dic objectForKey:@"guarantee_txt"];
        //guarantee_txt
        CGFloat ww=[model.guarantee_txt length]*13;
        
        UILabel * lilu= [[UILabel alloc] initWithFrame:CGRectMake((screen_width-ww)/2, 7,ww,12)];
        lilu.textAlignment=NSTextAlignmentCenter;
        lilu.textColor=RGB(103,103,103);
        lilu.font=CHINESE_SYSTEM(12);
        lilu.text=model.guarantee_txt;
        [footerView addSubview:lilu];
        UIImageView *typeimgsrc= [[UIImageView alloc] initWithFrame:CGRectMake((screen_width-ww)/2-18, 5,18, 18)];
        [typeimgsrc setImage:[UIImage imageNamed:@"y.png"]];
        [footerView addSubview:typeimgsrc];
        
        [_lijiTouZiArray addObject: model];
        [self GetArticlesNoticeData];
    }
    else
    {
        /*
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""  message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
         */
      [self GetArticlesNoticeData];
        
    }
    /*
    //HotQueueModel
    [PPNetworkHelper GET:urlStr parameters:nil success:^(id responseObject) {
        //请求成功
        NSDictionary *dic = [responseObject objectForKey:@"resultData"];
        NSString * resultStatus= [responseObject objectForKey:@"resultStatus"];
        [_lijiTouZiArray removeAllObjects];
        if([resultStatus isEqual:@"0"])
        {
            NSDictionary * dic=[responseObject objectForKey:@"resultData"];
            HotQueueModel * model=[[HotQueueModel alloc] init];
            //trans_num
            model.trans_num=[dic objectForKey:@"trans_num"];
            NSDictionary * dleft=[dic objectForKey:@"index_left_ad"];
          
            model.left_pic_url=[dleft objectForKey:@"pic_url"];
            model.left_link_url=[dleft objectForKey:@"link_url"];
          NSDictionary * dright=[dic objectForKey:@"index_right_ad"];
            model.right_pic_url=[dright objectForKey:@"pic_url"];
            model.right_link_url=[dright objectForKey:@"link_url"];
            
              model.guarantee_txt=[dic objectForKey:@"guarantee_txt"];
            //guarantee_txt
            
            [_lijiTouZiArray addObject: model];
              [self GetArticlesNoticeData];
            
        }
        else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[ReturnCode getSysCMsg:resultStatus]   message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
              [self GetArticlesNoticeData];
        //[PPNetworkCache setHttpCache:responseObject URL:urlStr parameters:nil];
    } failure:^(NSError *error) {
        //请求失败
       // [self GetArticlesNoticeData];
    }];
    */
}



-(void) GetArticlesNoticeData{
    NSString *urlStr = @"";
  NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[@"6"] forKeys:@[@"top"] ];
    NSString *sign=[HttpSignCreate GetSignStr:dict_data];
    urlStr = [NSString stringWithFormat:getArticlesNotice,oyApiUrl,@"6",sign];
    
    NSData * data=  [ggHttpFounction  synHttpGet:urlStr];
    if([ggHttpFounction getJsonIsOk:data])
    {
        [daibanArrayURL removeAllObjects];
        NSArray * dir= [ggHttpFounction getJsonData:data];
        for(int k=0;k<dir.count;k++)
        {
            NewsDynamicsModel * model=[[NewsDynamicsModel alloc] init];
            NSDictionary * dic=[dir objectAtIndex:k];
            model.title=[dic objectForKey:@"title"];
            model.link_url=[dic objectForKey:@"link_url"];
            [daibanArrayURL addObject: model];
        }
        [self LoanTopListData];
    }
    else
    {
        /*
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""  message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
         */
        //[self GetArticlesNoticeData];
        
    }
    
   //  NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[@"我是测试1号",@"my test 2 num",@"我是测试3号",@"我是测试4号",@"我是测试5号"] forKeys:@[@"testkey1",@"Testkey2",@"aestkey3",@"iestkey4",@"ieqweqy5"] ];
    //HotQueueModel]
    /*
    [PPNetworkHelper GET:urlStr parameters:nil success:^(id responseObject) {
        //请求成功
      //  NSDictionary *dic = [responseObject objectForKey:@"resultData"];
        NSString * resultStatus= [responseObject objectForKey:@"resultStatus"];
     
        if([resultStatus isEqual:@"0"])
        {
           NSArray * dir=[responseObject objectForKey:@"resultData"];
            //trans_num
           [daibanArrayURL removeAllObjects];
            for(int k=0;k<dir.count;k++)
            {
             NewsDynamicsModel * model=[[NewsDynamicsModel alloc] init];
              NSDictionary * dic=[dir objectAtIndex:k];
              model.title=[dic objectForKey:@"title"];
              model.link_url=[dic objectForKey:@"link_url"];
             //guarantee_txt
             [daibanArrayURL addObject: model];
            }
            [self LoanTopListData];
            
        }
        else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[ReturnCode getSysCMsg:resultStatus]   message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        //[PPNetworkCache setHttpCache:responseObject URL:urlStr parameters:nil];
    } failure:^(NSError *error) {
        //请求失败
           [self LoanTopListData];
        
    }];
    */
}

-(void) LoanTopListData{
    NSString *urlStr = @"";
    NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[@"3"] forKeys:@[@"top"] ];
    NSString *sign=[HttpSignCreate GetSignStr:dict_data];
    urlStr = [NSString stringWithFormat:loanTopList,oyApiUrl,@"3",sign];
    
    NSData * data=  [ggHttpFounction  synHttpGet:urlStr];
    if([ggHttpFounction getJsonIsOk:data])
    {
        [_kstzArray removeAllObjects];
        NSArray * dir= [ggHttpFounction getJsonData:data];
        for(int k=0;k<[dir count];k++)
        {
            NSDictionary * dic=[dir objectAtIndex:k];
            QuicklyModel * model=[[QuicklyModel alloc] init];
            model.nrid=[NSString stringWithFormat:@"%d",k];
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
            model.link_url=[dic objectForKey:@"link_url"];
             model.open_up_date=[dic objectForKey:@"open_up_date"];
                model.open_up_status=[NSString stringWithFormat:@"%@",[dic objectForKey:@"open_up_status"]];
            model.bt_link_url=[dic objectForKey:@"bt_link_url"];
            model.activity_img_width=[NSString stringWithFormat:@"%@",[dic objectForKey:@"activity_img_width"]];
            model.activity_url_img_height=[NSString stringWithFormat:@"%@",[dic objectForKey:@"activity_url_img_height"]];
            [_kstzArray addObject: model];
        }
        if(!isExeute)
        {
         isExeute=TRUE;
          [self initTableView];
        }
        else {
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
     
    }
    else
    {
        /*
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""  message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
         */
        
    }
    /*
    //HotQueueModel
    [PPNetworkHelper GET:urlStr parameters:nil success:^(id responseObject) {
        //请求成功
     //   NSDictionary *dic = [responseObject objectForKey:@"resultData"];
        NSString * resultStatus= [responseObject objectForKey:@"resultStatus"];
        [_kstzArray removeAllObjects];
        if([resultStatus isEqual:@"0"])
        {
            NSArray * dir=[responseObject objectForKey:@"resultData"];
            for(int k=0;k<[dir count];k++)
            {
                NSDictionary * dic=[dir objectAtIndex:k];
            QuicklyModel * model=[[QuicklyModel alloc] init];
            model.nrid=[NSString stringWithFormat:@"%d",k];
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
            model.link_url=[dic objectForKey:@"link_url"];
            [_kstzArray addObject: model];
            }
                [self setUpTableView];
            
        }
        else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[ReturnCode getSysCMsg:resultStatus]   message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        //[PPNetworkCache setHttpCache:responseObject URL:urlStr parameters:nil];
    } failure:^(NSError *error) {
        //请求失败
        
    }];
    */
}


/**网络访问数据操作**/


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

-(void)didAutoLoginSelect:(NSString *)username pswd:(NSString *)pswd isvalid:(Boolean)isvalid
{
    if(isvalid)
    {
        [self getYUancheng];
    }
}
/**默认登录操作**/
-(void) getYUancheng{
    //Api/Users/GetUsetInfo?user_token={user_token}&sign={sign}
    NSString *user_name=theAppDelegate.user_name;
    NSString *user_token=theAppDelegate.user_token;
    NSString *urlStr = @"";
    
    user_name=[HttpSignCreate encodeString:user_name];
    NSDictionary *dict_data=[[NSDictionary alloc] initWithObjects:@[user_name,user_token] forKeys:@[@"user_name",@"user_token"]];
    NSMutableArray * paixu1=[[NSMutableArray alloc] init];
    [paixu1 addObject:@"user_name"];
    [paixu1 addObject:@"user_token"];
    NSString *sign=[HttpSignCreate GetSignStr:dict_data paixu:paixu1];
    urlStr = [NSString stringWithFormat:login2,oyUrlAddress,user_name,user_token,sign];
    [self loadPage1:urlStr];
    
    
}

//加载网页
- (void)loadPage1: (NSString *) urlstr {
    
    iWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 0,0)];
    
    iWebView.delegate=self;
    //伸缩内容适应屏幕尺寸
    iWebView.scalesPageToFit=YES;
    [iWebView setUserInteractionEnabled:YES];
  //  [[NSURLCache sharedURLCache] removeAllCachedResponses];//清除缓存
    
    NSURL *url = [[NSURL alloc] initWithString:urlstr];
    //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSMutableURLRequest *request ;
    request = [NSMutableURLRequest requestWithURL:url];
    
    //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSMutableString *cookies = [NSMutableString string];
    NSArray *tmp = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie * cookie in tmp) {
        [cookies appendFormat:@"%@=%@;",cookie.name,cookie.value];
    }
    [request setHTTPShouldHandleCookies:YES];
    // 注入Cookie
    [request setValue:cookies forHTTPHeaderField:@"Cookie"];

    [iWebView loadRequest:request];
    iWebView.scrollView.bounces = NO;
    [self.view addSubview:iWebView];
    //  [iWebView isHidden:TRUE];
    
}

/**
 *WebView加载完毕的时候调用（请求完毕）
 */
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (_noticBlock) {
        _noticBlock(YES);
    }
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
//遮罩页



/* 广告 宣传弹出界面

*/


//遮罩页
-(void)initAdvertMaskView
{
    if(_maskView==nil)
    {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
        //    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+40, screen_width, 0)];
        _maskView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //   [self.view addSubview:_maskView];
        _maskView.hidden = NO;
        //添加手势
        CGFloat  ddw=242;
        CGFloat  ddh=266;
        advertView = [[OpenAdvertView alloc] initWithFrame:CGRectMake((screen_width-ddw)/2, (screen_height-ddh)/2, ddw, ddh) ];
        advertView.delegate = self;
        [_maskView addSubview:advertView];
        [self.view addSubview:_maskView];
    }
    else
    {
        _maskView.hidden = NO;
    }
}

//遮罩页
-(void)initVersionMaskView
{
    if(_maskView1==nil)
    {
        _maskView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
        //    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+40, screen_width, 0)];
        _maskView1.backgroundColor = RGBA(0, 0, 0, 0.5);
        //   [self.view addSubview:_maskView];
        _maskView1.hidden = NO;
        [_maskView1.layer setCornerRadius:10];
        versionView = [[UpdateVersion alloc] initWithFrame:CGRectMake(50, (screen_height-300)/2, screen_width-100, 300) ];
        versionView.delegate = self;
        [_maskView1 addSubview:versionView];
        [self.view addSubview:_maskView1];
    }
    else
    {
        _maskView1.hidden = NO;
    }
}



-(void)didOpenAdvertView:(NSInteger)type
{
   if(type==2)
   {
       _maskView.hidden = YES;
   
   }
   else if(type==1)
   {
       [self OnLogin];
    _maskView.hidden = YES;
   }
}
//版本控制
-(void)didOpenVersionView:(NSInteger)type
{
    if(type==1)
    {
        NSString  *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",@"1241881881"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    else if(type==2)
    {
         _maskView1.hidden = YES;
    }
    
}

/**默认登录操作**/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

//修改tabbar高度
/*
- (void)viewWillLayoutSubviews {
    if(theAppDelegate.IS_IPhoneX)
    {
       
        
        CGRect tabFrame = self.tabBarController.tabBar.frame;
        tabFrame.size.height = 76;
        tabFrame.origin.y = screen_height - 57;
        self.tabBarController.tabBar.frame = tabFrame;
    }
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
