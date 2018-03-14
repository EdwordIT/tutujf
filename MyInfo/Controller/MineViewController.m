//
//  MineViewController.m
//  TTJF
//
//  Created by 占碧光 on 2017/3/10.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "MineViewController.h"
#import "MJRefresh.h"
#import "DMLoginViewController.h"
//#import "NavView.h"
//#import "PPNetworkHelper.h"
#import "HttpSignCreate.h"
#import "AppDelegate.h"
#import "WinChageType.h"
#import "DMLoginViewController.h"

#import "TopScrollShow.h"
#import "MineTopCell.h"
#import "MIneMiddleCell.h"
#import "MineMenuCell.h"

#import "HttpSignCreate.h"
#import "HttpUrlAddress.h"
#import "ggHttpFounction.h"
#import "OpenAdvertView.h"
#import "HomeWebController.h"
#import "TopScrollMode.h"
#import "UserInfo.h"
#import "BtMyUser.h"
#import "AccountInfoController.h"
#import "LoginViewController.h"

@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,MineNavDelegate,MineMenuDelegate,MIneMiddleDelegate,MineTopDelegate,
OpenShowAdvertDelegate>
{
    NSArray *array1;// 第一个 cell 行
    
    NSArray *array2;/***第二个cell 行*/
    
      NSArray *array30;/****  */
    NSArray *array3;/****  */
    NSArray *array4;/**<  第三个cell */
    NSArray *array5; //
    
    NSArray *array6;/****  */
    NSArray *array7;/**< 第四个 cell */
    NSArray *array8; //
    
    NSString * zongjiner;//
    
      NSString * keyingjiner;//
    CGFloat  navxL;
    CGFloat  navyL;
    CGFloat  navwL;
    CGFloat  navhL;
    
    CGFloat  navxR;
    CGFloat  navyR;
    CGFloat  navwR;
    CGFloat  navhR;
    UIView *_maskView;
    OpenAdvertView *advertView;
    TopScrollMode * scrollmodel;
    UserInfo * userinfo;
    BtMyUser * myuser;
    Boolean isFirstExe;
    Boolean isTuanGuan;
    MineTopCell *topcell;
    NSMutableArray * bt_user_url;
}



@property (nonatomic ,strong) TopScrollShow *navView; //导航栏视图

@end



@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    bt_user_url=[[NSMutableArray alloc] init];
    [self initData];
    isFirstExe=FALSE;;
    isTuanGuan=FALSE;
    if(theAppDelegate.IsLogin)
      [self initTableView];
    else
    [self initTableView];
    keyingjiner=@"";
    zongjiner=@"";
  
  
    [self setDataNav];

    // Do any additional setup after loading the view.
}
//
-(void) showRegTuanGuan
{
    isTuanGuan=TRUE;
    NSString  * temp =[NSString stringWithFormat:@"%@",userinfo.is_trust_reg] ;
    if([temp isEqual:@"0"])  //显示托管
    {
         [self initAdvertMaskView];
        [advertView setDataBind:userinfo];
    }
    
}
//头部数据
-(void) setDataNav
{
    self.navView = [[TopScrollShow alloc] initWithFrame:CGRectMake(0, 0, screen_height, 90)];
    self.navView .delegate=self;
    //[self.navView setHidden:TRUE];
    [self.view addSubview:self.navView ];
    navxR= self.navView.rightView.frame.origin.x;
    navyR= self.navView.rightView.frame.origin.y;
    navwR= self.navView.rightView.frame.size.width;
    navhR= self.navView.rightView.frame.size.height;
    
    navxL= self.navView.backimg.frame.origin.x;
    navyL= self.navView.backimg.frame.origin.y;
    navwL= self.navView.backimg.frame.size.width;
    navhL= self.navView.backimg.frame.size.height;
}

//GetMyUserDatas
//视图出现时操作
- (void)viewWillAppear:(BOOL)animated {
     [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    if(theAppDelegate.IsWebRegdit)//web 注册自动登录
    {
        theAppDelegate.IsWebRegdit=FALSE;
        if(theAppDelegate.IsLogin)
        {
            if(!isFirstExe)
            {
                isFirstExe=TRUE;
                [self GetMyByWebUserDatas];
            }
            else if(userinfo!=nil)
            {
                self.navView.leftName.text=theAppDelegate.user_name;
            }
        }
    }
    else
    {
      if(theAppDelegate.IsLogin)
      {
        if(!isFirstExe)
        {
            isFirstExe=TRUE;
            [self GetMyUserDatas];
        }
        else if(userinfo!=nil)
        {
           self.navView.leftName.text=theAppDelegate.user_name;
         }
      }
    }
    

}

//导航返回刷新
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:TRUE];
    if(theAppDelegate.xbindex!=-1)
    {
        if(theAppDelegate.xbindex!=2)
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:theAppDelegate.xbindex];
        theAppDelegate.xbindex=-1;
    }
    if(!theAppDelegate.IsLogin)
    {
        self.navView.leftName.text=@"******";
        if(userinfo!=nil)
        {
            userinfo.total_amount=@"0.0";
            userinfo.to_interest_award=@"0.0";
            userinfo.balance_amount=@"0.00";
            if(topcell!=nil)
            [topcell setModelData:userinfo];
             if(self.navView!=nil)
           [self.navView.infolimg setHidden:TRUE];
        }
    }
    else if(userinfo!=nil)
    {
        self.navView.leftName.text=theAppDelegate.user_name;
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

    array1 = [[NSArray alloc] init];
    array2= [[NSArray alloc] init];
    
    array30= [NSArray arrayWithObjects: @"user03.png",@"user04.png",@"user05.png",nil];
    array3= [NSArray arrayWithObjects: @"我的投资",@"我的红包",@"资金记录",nil];
    array4= [NSArray arrayWithObjects: @"了解投资进度",@"各种红包福利",@"查看资金流向",nil];
    
//Me_iceo_transfer  Me_iceo_Invitation  Me_iceo_help Me_iceo_Loan
    array6= [NSArray arrayWithObjects: [oyUrlAddress stringByAppendingString:@"/wapassets/trust/images/news/mylogo01.png"],[oyUrlAddress stringByAppendingString:@"/wapassets/trust/images/news/mylogo02.png"],[oyUrlAddress stringByAppendingString:@"/wapassets/trust/images/news/mylogo04.png"],[oyUrlAddress stringByAppendingString:@"/wapassets/trust/images/news/mylogo03.png"],nil];
    array7= [NSArray arrayWithObjects: @"我的邀请",@"我的借款",@"托管账户",@"银行卡管理",nil];
    array8=  [NSArray arrayWithObjects: @"",@"",@"",@"",nil];
    
}
/**表格数据操作**/
//初始化主界面
-(void)initTableView{
    if(kDevice_Is_iPhoneX)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
            self.tabBarController.tabBar.subviews[0].subviews[1].hidden = YES;
        }
        self.tabBarController.tabBar.backgroundColor=RGB(240,240,240);
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, screen_width, screen_height-50) style:UITableViewStyleGrouped];
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

        
    }
    else
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, screen_width, screen_height+20) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor=RGB(240,240,240);
   //   self.tableView.backgroundColor=RGB(21,140,241);
    // 设置表格尾部
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    // [self.tableView setSeparatorColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.01]];
    [self.tableView setSeparatorColor:separaterColor];
    
    [self.view addSubview:self.tableView];
    
    [self setUpTableView];
    
    
}

//界面表格刷新
-(void)setUpTableView{
   
   __weak typeof(self) weakSelf = self;
    TTJFRefreshStateHeader *header = [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
      
    }];
    self.tableView.mj_header = header;
    // 马上进入刷新状态
    [header beginRefreshing];

}

//重复刷新
-(void)refreshData{
      __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        // [self getHttpDatta:@"839" top:@"5"];
        // [self getDaiBang];
        dispatch_async(dispatch_get_main_queue(), ^{
            //update UI
            if(theAppDelegate.IsLogin)
            {
                if(!isFirstExe)
                {
                  isFirstExe=TRUE;
                  [weakSelf GetMyUserDatas];
                }
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            else
            {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            }
        });
    });
    
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section ==0 ){
        //return _hotQueueData.count+1;
        return 2;
    }
    else if (section ==1 ){
        return 1;
    }

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        {
            
            if(indexPath.row==0)
                return 316;
            else
            {
                if(IS_IPHONE5)
                    return 120;
                      if(IS_IPhone6plus)
                        return 150;
                    else
                    {
                return 140;
                    }
            }
            
        }
    }else if(indexPath.section == 1){
        if([bt_user_url count]>0)
        return [bt_user_url count]*54;
        else
         return [array7 count]*54;
        
    }
    else{
        return 56;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    else if (section == 1) {
        return 0.01;
    } else if (section == 2) {
        return 0.1;
    }
    else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    else if (section == 1) {
        return 15;
    } else if (section == 2) {
        return 0.01;
    }
    else{
        return 0.1;
    }
}




-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    headerView.backgroundColor =RGB(240,240,240);
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    footerView.backgroundColor = RGB(240,240,240);
    
    
    //    footerView.backgroundColor = [UIColor yellowColor];
    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if(indexPath.row == 0)
        {
            static NSString *cellIndentifier = @"MineTopCell";
           
            topcell =  [[MineTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            topcell.accessoryType = UITableViewCellAccessoryNone;
            topcell.selectionStyle=UITableViewCellSelectionStyleNone;
            topcell.delegate=self;
           
             if(userinfo!=nil)
            [topcell setModelData:userinfo];
            return topcell;
            
        }
        else  if(indexPath.row == 1)
        {
            static NSString *cellIndentifier = @"MIneMiddleCell";
            MIneMiddleCell *cell =  [[MIneMiddleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.delegate=self;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell setModelData:array30 ary2:array3 ary3:array4];
            return cell;
        }
    }
    else if (indexPath.section == 1) {
        if(indexPath.row == 0)
        {
        static NSString *cellIndentifier = @"MineMenuCell";
          
        MineMenuCell *cell =  [[MineMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.delegate=self;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(bt_user_url!=nil&&[bt_user_url count]>0)
        [cell setMenuData:array7 ayr2:array6];
         else  if(!theAppDelegate.IsLogin)
         [cell setMenuData:array7 ayr2:array6];
        return cell;
        }
    }
   
        return nil;
}
/**在viewWillAppear方法中加入：
 [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];**/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //消除cell选择痕迹
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.1f];
    if([CommonUtils isLogin])
    {
        
    }
    else
    {
        [self OnLogin];
    }
  
    
    //[self JumpLogin];
}
- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

/**网络访问数据操作**/


-(void) OnLogin{
    LoginViewController *next = InitObject(LoginViewController);
    [self presentViewController:next animated:YES completion:nil];
//    //创建动画
//    CATransition * transition = [CATransition animation];
//    //设置动画类型（这个是字符串，可以搜索一些更好看的类型）
//    transition.type = @"moveOut";
//    //动画出现类型
//    transition.subtype = @"fromCenter";
//    //动画时间
//    transition.duration = 0.2;
//    //移除当前window的layer层的动画
//    [self.view.window.layer removeAllAnimations];
//    //将定制好的动画添加到当前控制器window的layer层
//    [self.view.window.layer addAnimation:transition forKey:nil];
////    DMLoginViewController *next=[[DMLoginViewController alloc]init];
//    LoginViewController *next = InitObject(LoginViewController);
//
//    //把当前控制器作为背景
//    self.definesPresentationContext = YES;
//    [self presentViewController:next animated:YES completion:nil];
//    // [self presentViewController:searchVC animated:YES completion:NULL];
//    //   [self.navigationController pushViewController:next animated:YES];
}

/**表格数据操作**/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**xia**/
-(void)didNavViewDAtIndex:(NSInteger)index;\
{
    if(theAppDelegate.IsLogin)
    {
        
    }
    else
    {
        [self OnLogin];
    }
}




-(void)didMyTopAtIndex:(NSInteger)index
{
   if(theAppDelegate.IsLogin)
   {
     
   }
    else
    {
        [self OnLogin];
    }
}

-(void)didMineMenuAtIndex:(NSInteger)index
{
    if(theAppDelegate.IsLogin)
    {
        NSString * url=[bt_user_url objectAtIndex:index-1];
        self.hidesBottomBarWhenPushed=YES;
        HomeWebController *discountVC = [[HomeWebController alloc] init];
        discountVC.urlStr=url;
        discountVC.returnmain=@"3"; //页返回
        [self.navigationController pushViewController:discountVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
        
     
    }
    else
    {
        [self OnLogin];
    }
}

-(void)didMyBottomAtIndex:(NSInteger)index
{
    if(theAppDelegate.IsLogin)
    {
        
    }
    else
    {
        [self OnLogin];
    }
}
-(void)didopMineAtIndex:(NSInteger)index
{
    if(theAppDelegate.IsLogin)
    {
        if(index==1)
        {
            /*
            self.hidesBottomBarWhenPushed=YES;
            HomeWebController *discountVC = [[HomeWebController alloc] init];
              discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/member/myaccountdata",oyUrlAddress];
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
            */
                self.hidesBottomBarWhenPushed=YES;
            AccountInfoController * account=[[AccountInfoController alloc] init];
           [self.navigationController pushViewController:account animated:YES];
             self.hidesBottomBarWhenPushed=NO;
        }
        else if(index==2)
        {
             self.hidesBottomBarWhenPushed=YES;
            HomeWebController *discountVC = [[HomeWebController alloc] init];
              discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/message/list",oyUrlAddress];
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
             self.hidesBottomBarWhenPushed=NO;
        }
        else if(index==3)
        {
            self.hidesBottomBarWhenPushed=YES;
            HomeWebController *discountVC = [[HomeWebController alloc] init];
             discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/member/account",oyUrlAddress];
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
        
        else if(index==4)
        {
            self.hidesBottomBarWhenPushed=YES;
            HomeWebController *discountVC = [[HomeWebController alloc] init];
             discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/member/accounttwo",oyUrlAddress];
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
        else if(index==5)
        {
            NSString  * temp =[NSString stringWithFormat:@"%@",userinfo.is_trust_reg] ;
            if([temp isEqual:@"0"])  //显示托管
            {
                self.hidesBottomBarWhenPushed=YES;
                HomeWebController *discountVC = [[HomeWebController alloc] init];
                discountVC.urlStr=[NSString stringWithFormat:@"%@/%@",oyUrlAddress,userinfo.trust_reg_link];
                discountVC.returnmain=@"3"; //页返回
                [self.navigationController pushViewController:discountVC animated:YES];
                self.hidesBottomBarWhenPushed=NO;
            }
            else
            {
            self.hidesBottomBarWhenPushed=YES;
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/member/recharge",oyUrlAddress];
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
            }
        }
        else if(index==6)
        {
             NSString  * temp =[NSString stringWithFormat:@"%@",userinfo.is_trust_reg] ;
            if([temp isEqual:@"0"])  //显示托管
        {
            self.hidesBottomBarWhenPushed=YES;
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr=[NSString stringWithFormat:@"%@/%@",oyUrlAddress,userinfo.trust_reg_link];
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            else
            {
            self.hidesBottomBarWhenPushed=YES;
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/member/cash",oyUrlAddress];
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
            }
        }
        else if(index==7)
        {
            /*
            self.hidesBottomBarWhenPushed=YES;
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr=@"http://www.tutujf.com/wap/member/accounttwo";
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
             */
        }
    }
    else
    {
        [self OnLogin];
    }
}
-(void)didTopScrollAtIndex:(NSInteger)index
{
    if(theAppDelegate.IsLogin)
    {
        if(index==1)
        {
            self.hidesBottomBarWhenPushed=YES;
            AccountInfoController * account=[[AccountInfoController alloc] init];
            [self.navigationController pushViewController:account animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
       else if(index==2)
        {
             self.hidesBottomBarWhenPushed=YES;
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/message/list",oyUrlAddress];
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
         
        }
       else if(index==3)
       {
           self.hidesBottomBarWhenPushed=YES;
           HomeWebController *discountVC = [[HomeWebController alloc] init];
           discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/member/myaccountdata",oyUrlAddress];
           discountVC.returnmain=@"3"; //页返回
           [self.navigationController pushViewController:discountVC animated:YES];
           self.hidesBottomBarWhenPushed=NO;
           
       }
        //
    }
    else
    {
        [self OnLogin];
    }
    
}

-(void)didopMIneMiddleAtIndex:(NSInteger)index
{
    if(theAppDelegate.IsLogin)
    {
        if(index==1)
        {
        self.hidesBottomBarWhenPushed=YES;
        HomeWebController *discountVC = [[HomeWebController alloc] init];
        discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/member/mytender",oyUrlAddress];
        discountVC.returnmain=@"3"; //页返回
        [self.navigationController pushViewController:discountVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
        }
       else if(index==2)
        {
            self.hidesBottomBarWhenPushed=YES;
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/member/bounty",oyUrlAddress];
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
       else if(index==3)
        {
            self.hidesBottomBarWhenPushed=YES;
            HomeWebController *discountVC = [[HomeWebController alloc] init];
            discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/account/accountLog",oyUrlAddress];
            discountVC.returnmain=@"3"; //页返回
            [self.navigationController pushViewController:discountVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
    }
    else
    {
        [self OnLogin];
    }
}
/****/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat  yh=10;
    if(bt_user_url!=nil)
    {
        if([bt_user_url count]<5)
            yh=30;
        else
        yh=([bt_user_url count]-4)*54;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y+20;
    if(kDevice_Is_iPhoneX)
        offsetY=scrollView.contentOffset.y;
    if (offsetY <=1) {
        self.navView.rightView.frame=CGRectMake(navxR,navyR,navwR,navhR);
        [self.navView.rightView.layer setCornerRadius:navwR/2];
        self.navView.backimg.frame=CGRectMake(navxL,navyL,navwL,navhL);
        [self.navView.backimg.layer setCornerRadius:navwL/2];
        self.navView.leftName.frame=CGRectMake(navxL+60,navyL+19,200,15);
         self.navView.leftName.font=CHINESE_SYSTEM(15);
         self.navView.infolimg.frame=CGRectMake(20, 6, 10,10);
           [self.navView.infolimg.layer setCornerRadius:5];
        self.navView.leftBtn.frame=CGRectMake(4,4,42,42);
       [self.navView.leftBtn.layer setCornerRadius:21];
        
      self.navView.image1.frame=CGRectMake(10, 11, 20, 20);
        
    }
    else if (offsetY>1&&offsetY <yh) {
        
        CGFloat ff=offsetY+10;
        CGFloat L1=10-10*(yh-ff)/yh;
        CGFloat Ly=15-15*(yh-ff)/yh;
        CGFloat R1=5-5*(yh-ff)/yh;
        CGFloat R3=10-10*(yh-ff)/yh;
        CGFloat Ry=13-13*(yh-ff)/yh;
        CGFloat nbxL=7-7*(yh-ff)/yh;
        CGFloat nbxR=2-2*(yh-ff)/yh;
        CGFloat fontH=22-22*(yh-ff)/yh;
        
        self.navView.rightView.frame=CGRectMake(navxR-nbxR,navyR-Ry,navwR-R3,navwR-R3);
        self.navView.backimg.frame=CGRectMake(navxL+nbxL,navyL-Ly,navwL-L1,navwL-L1);
        [self.navView.backimg.layer setCornerRadius:(navwL-L1)/2];
        [self.navView.rightView.layer setCornerRadius:(navwR-R3)/2];
        self.navView.frame=CGRectMake(0, 0, screen_height,90);
        self.navView.backgroundColor=[UIColor clearColor];
        self.navView.leftName.frame=CGRectMake(navxL+60-nbxR,navyL+19-fontH,200,12);
        self.navView.leftBtn.frame=CGRectMake(4,4,navwL-L1-6,navwL-L1-6);

        [self.navView.leftBtn.layer setCornerRadius:(navwL-L1-4)/2];
        self.navView.image1.frame=CGRectMake(10-nbxR, 11-nbxR, 16, 16);
    }else{
        self.navView.frame=CGRectMake(0, 0, screen_height,64);
        self.navView.backgroundColor=navigationBarColor;
        self.navView.rightView.frame=CGRectMake(navxR-2,navyR-13,navwR-10,navhR-10);
        self.navView.backimg.frame=CGRectMake(navxL+7,navyL-16,navwL-10,navhL-10);
        [self.navView.backimg.layer setCornerRadius:(navwL-10)/2];
       [self.navView.rightView.layer setCornerRadius:(navwR-10)/2];
       // self.navView.leftBtn.frame=CGRectMake(20,20,navwL-6,navhL-6);
        [self.navView.leftBtn.layer setCornerRadius:(navwL-10)/2];
        self.navView.leftName.frame=CGRectMake(navxL+58,navyL-3,200,12);
        self.navView.leftName.font=CHINESE_SYSTEM(12);
          self.navView.leftBtn.frame=CGRectMake(4,4,32,32);
         [self.navView.leftBtn.layer setCornerRadius:16];
        
         self.navView.infolimg.frame=CGRectMake(15, 5, 8,8);
            [self.navView.infolimg.layer setCornerRadius:4];
          self.navView.image1.frame=CGRectMake(8, 8.5, 14, 14);
        
    }
   
    // self.view.backgroundColor=RGB(21,140,241);
    // NSLog(@"dy%f",offsetY); RGB(53, 171, 245)
}

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
        if(IS_IPhone6plus)
        {
            ddw=270;
            ddh=300;
            advertView = [[OpenAdvertView alloc] initWithFrame:CGRectMake((screen_width-ddw)/2, (screen_height-ddh)/2, ddw, ddh) ];
        }
        else
        advertView = [[OpenAdvertView alloc] initWithFrame:CGRectMake((screen_width-ddw)/2, (screen_height-ddh)/2, ddw, ddh) ];
        advertView.delegate = self;
        //UserInfo
        [_maskView addSubview:advertView];
        [self.view addSubview:_maskView];
    }
    else
    {
        _maskView.hidden = NO;
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
       // [self OnLogin];
        _maskView.hidden = YES;
        self.hidesBottomBarWhenPushed=YES;
        HomeWebController *discountVC = [[HomeWebController alloc] init];
        discountVC.urlStr=[NSString stringWithFormat:@"%@/%@",oyUrlAddress,userinfo.trust_reg_link];
        discountVC.returnmain=@"3"; //页返回
        [self.navigationController pushViewController:discountVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }
}




-(void) GetMyUserDatas{
  __weak typeof(self) weakSelf = self;
    NSString *urlStr = @"";
    NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[theAppDelegate.user_token] forKeys:@[@"user_token"] ];
    NSString *sign=[HttpSignCreate GetSignStr:dict_data];
    urlStr = [NSString stringWithFormat:getMyUserData,oyApiUrl,theAppDelegate.user_token,sign];
    NSData * data=  [ggHttpFounction  synHttpGet:urlStr];
    if([ggHttpFounction getJsonIsOk:data])
    {
           NSDictionary * dir= [ggHttpFounction getJsonData1:data];
        scrollmodel=[[TopScrollMode alloc] init];
        myuser=[[BtMyUser alloc] init];
        userinfo=[[UserInfo alloc] init];
        
        userinfo.balance_amount=[dir objectForKey:@"balance_amount"];
        userinfo.cash_url=[dir objectForKey:@"cash_url"];
        userinfo.is_trust_reg=[NSString stringWithFormat:@"%@",[dir objectForKey:@"is_trust_reg"]];
        userinfo.message=[NSString stringWithFormat:@"%@",[dir objectForKey:@"message"]];
        userinfo.recharge_url=[NSString stringWithFormat:@"%@",[dir objectForKey:@"recharge_url"]];
        userinfo.to_interest_award=[NSString stringWithFormat:@"%@",[dir objectForKey:@"to_interest_award"]];
        userinfo.total_amount=[NSString stringWithFormat:@"%@",[dir objectForKey:@"total_amount"]];
        userinfo.trust_reg_link=[NSString stringWithFormat:@"%@",[dir objectForKey:@"trust_reg_link"]];
        userinfo.trust_reg_log=[NSString stringWithFormat:@"%@",[dir objectForKey:@"trust_reg_log"]];
        userinfo.trust_reg_sub_title=[NSString stringWithFormat:@"%@",[dir objectForKey:@"trust_reg_sub_title"]];
         userinfo.trust_reg_title=[NSString stringWithFormat:@"%@",[dir objectForKey:@"trust_reg_title"]];
        userinfo.user_name=[dir objectForKey:@"user_name"];
        userinfo.to_interest_award=[dir objectForKey:@"to_interest_award"];
         userinfo.total_amount=[dir objectForKey:@"total_amount"];
        
        
        //user_name
        NSDictionary * bt_my_capital_log=[dir objectForKey:@"bt_my_capital_log"];
        NSDictionary * bt_my_investment=[dir objectForKey:@"bt_my_investment"];
        NSDictionary * bt_my_red=[dir objectForKey:@"bt_my_red"];
       NSArray *  bt_user_content=[dir objectForKey:@"bt_user_content"];
        NSMutableArray * bt_user_title=[[NSMutableArray alloc] init];
        NSMutableArray * bt_user_logo=[[NSMutableArray alloc] init];
        bt_user_url=[[NSMutableArray alloc] init];
        for(int k=0;k<[bt_user_content count];k++)
        {
          [bt_user_url addObject:[bt_user_content[k] objectForKey:@"link_url"]] ;
          [bt_user_title addObject:[bt_user_content[k] objectForKey:@"title"]] ;
          [bt_user_logo addObject:[bt_user_content[k] objectForKey:@"logo_url"]] ;
        }
        array7 =[bt_user_title copy];
        array6 =[bt_user_logo copy];
      
        array3= [NSArray arrayWithObjects:[bt_my_investment objectForKey:@"title"],[bt_my_red objectForKey:@"title"],[bt_my_capital_log objectForKey:@"title"],nil];
        array4= [NSArray arrayWithObjects: [bt_my_investment objectForKey:@"sub_title"],[bt_my_red objectForKey:@"sub_title"],[bt_my_capital_log objectForKey:@"sub_title"],nil];
        array2=[NSArray arrayWithObjects:[bt_my_investment objectForKey:@"link_url"],[bt_my_red objectForKey:@"link_url"],[bt_my_capital_log objectForKey:@"link_url"],nil];
        
        if(! [userinfo.message isEqual:@"0"])
        {
            if(weakSelf.navView.infolimg==nil)
            {
            weakSelf.navView.infolimg=[[UIView alloc] initWithFrame:CGRectMake(20, 6, 10,10)];
            [weakSelf.navView.infolimg.layer setCornerRadius:5];
            weakSelf.navView.infolimg.backgroundColor=RGB(252,18,18);
            [weakSelf.navView.rightView addSubview:self.navView.infolimg];
            }
            else
                 {
                     [weakSelf.navView.infolimg setHidden:FALSE];
                 }
        }
        else
         {
             weakSelf.navView.ishaveinfo=@"0";
               if(weakSelf.navView.infolimg!=nil)
            [weakSelf.navView.infolimg setHidden:TRUE];
         }
        //
        theAppDelegate.user_name=userinfo.user_name;
        weakSelf.navView.leftName.text=userinfo.user_name;
        
        array1=[NSArray arrayWithObjects:[[bt_user_content objectAtIndex:0] objectForKey:@"link_url"],[[bt_user_content objectAtIndex:1] objectForKey:@"link_url"],[[bt_user_content objectAtIndex:2] objectForKey:@"link_url"],nil];
        
         array8=[NSArray arrayWithObjects:[[bt_user_content objectAtIndex:0] objectForKey:@"title"],[[bt_user_content objectAtIndex:1] objectForKey:@"title"],[[bt_user_content objectAtIndex:2] objectForKey:@"title"],nil];
        
           isFirstExe=FALSE;
        
           [weakSelf.tableView reloadData];
      
              [weakSelf showRegTuanGuan];
  
       
    }
    else
    {
       
        
    }

}
-(void) GetMyByWebUserDatas
{
    __weak typeof(self) weakSelf = self;
    NSString *urlStr = @"";
    NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[theAppDelegate.user_token] forKeys:@[@"user_token"] ];
    NSString *sign=[HttpSignCreate GetSignStr:dict_data];
    urlStr = [NSString stringWithFormat:getMyUserData,oyApiUrl,theAppDelegate.user_token,sign];
    NSData * data=  [ggHttpFounction  synHttpGet:urlStr];
    if([ggHttpFounction getJsonIsOk:data])
    {
        NSDictionary * dir= [ggHttpFounction getJsonData1:data];
        scrollmodel=[[TopScrollMode alloc] init];
        myuser=[[BtMyUser alloc] init];
        userinfo=[[UserInfo alloc] init];
        
        userinfo.balance_amount=[dir objectForKey:@"balance_amount"];
        userinfo.cash_url=[dir objectForKey:@"cash_url"];
        userinfo.is_trust_reg=[NSString stringWithFormat:@"%@",[dir objectForKey:@"is_trust_reg"]];
        userinfo.message=[NSString stringWithFormat:@"%@",[dir objectForKey:@"message"]];
        userinfo.recharge_url=[NSString stringWithFormat:@"%@",[dir objectForKey:@"recharge_url"]];
        userinfo.to_interest_award=[NSString stringWithFormat:@"%@",[dir objectForKey:@"to_interest_award"]];
        userinfo.total_amount=[NSString stringWithFormat:@"%@",[dir objectForKey:@"total_amount"]];
        userinfo.trust_reg_link=[NSString stringWithFormat:@"%@",[dir objectForKey:@"trust_reg_link"]];
        userinfo.trust_reg_log=[NSString stringWithFormat:@"%@",[dir objectForKey:@"trust_reg_log"]];
        userinfo.trust_reg_sub_title=[NSString stringWithFormat:@"%@",[dir objectForKey:@"trust_reg_sub_title"]];
        userinfo.trust_reg_title=[NSString stringWithFormat:@"%@",[dir objectForKey:@"trust_reg_title"]];
        userinfo.user_name=[dir objectForKey:@"user_name"];
        userinfo.to_interest_award=[dir objectForKey:@"to_interest_award"];
        userinfo.total_amount=[dir objectForKey:@"total_amount"];
        
        
        //user_name
        NSDictionary * bt_my_capital_log=[dir objectForKey:@"bt_my_capital_log"];
        NSDictionary * bt_my_investment=[dir objectForKey:@"bt_my_investment"];
        NSDictionary * bt_my_red=[dir objectForKey:@"bt_my_red"];
        NSArray *  bt_user_content=[dir objectForKey:@"bt_user_content"];
        NSMutableArray * bt_user_title=[[NSMutableArray alloc] init];
        NSMutableArray * bt_user_logo=[[NSMutableArray alloc] init];
        bt_user_url=[[NSMutableArray alloc] init];
        for(int k=0;k<[bt_user_content count];k++)
        {
            [bt_user_url addObject:[bt_user_content[k] objectForKey:@"link_url"]] ;
            [bt_user_title addObject:[bt_user_content[k] objectForKey:@"title"]] ;
            [bt_user_logo addObject:[bt_user_content[k] objectForKey:@"logo_url"]] ;
        }
        array7 =[bt_user_title copy];
        array6 =[bt_user_logo copy];
        
        array3= [NSArray arrayWithObjects:[bt_my_investment objectForKey:@"title"],[bt_my_red objectForKey:@"title"],[bt_my_capital_log objectForKey:@"title"],nil];
        array4= [NSArray arrayWithObjects: [bt_my_investment objectForKey:@"sub_title"],[bt_my_red objectForKey:@"sub_title"],[bt_my_capital_log objectForKey:@"sub_title"],nil];
        array2=[NSArray arrayWithObjects:[bt_my_investment objectForKey:@"link_url"],[bt_my_red objectForKey:@"link_url"],[bt_my_capital_log objectForKey:@"link_url"],nil];
        
        if(! [userinfo.message isEqual:@"0"])
        {
            if(weakSelf.navView.infolimg==nil)
            {
                weakSelf.navView.infolimg=[[UIView alloc] initWithFrame:CGRectMake(20, 6, 10,10)];
                [weakSelf.navView.infolimg.layer setCornerRadius:5];
                weakSelf.navView.infolimg.backgroundColor=RGB(252,18,18);
                [weakSelf.navView.rightView addSubview:self.navView.infolimg];
            }
            else
            {
                [weakSelf.navView.infolimg setHidden:FALSE];
            }
        }
        else
        {
            weakSelf.navView.ishaveinfo=@"0";
            if(weakSelf.navView.infolimg!=nil)
                [weakSelf.navView.infolimg setHidden:TRUE];
        }
        //
        theAppDelegate.user_name=userinfo.user_name;
        NSString * temp=[[dir objectForKey:@"expiration_date"] substringWithRange:NSMakeRange(0,10)];
        theAppDelegate.expirationdate=temp;
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setObject:temp forKey:@"LoginTime"];
        [userDef setObject:theAppDelegate.user_name forKey:@"LoginAccount"];
    //    [userDef setObject:password forKey:@"LoginPassword"];
        [userDef synchronize];
        
        weakSelf.navView.leftName.text=userinfo.user_name;
        
        array1=[NSArray arrayWithObjects:[[bt_user_content objectAtIndex:0] objectForKey:@"link_url"],[[bt_user_content objectAtIndex:1] objectForKey:@"link_url"],[[bt_user_content objectAtIndex:2] objectForKey:@"link_url"],nil];
        
        array8=[NSArray arrayWithObjects:[[bt_user_content objectAtIndex:0] objectForKey:@"title"],[[bt_user_content objectAtIndex:1] objectForKey:@"title"],[[bt_user_content objectAtIndex:2] objectForKey:@"title"],nil];
        
        isFirstExe=FALSE;
        
        [weakSelf.tableView reloadData];
        
        [weakSelf showRegTuanGuan];
        
        
    }
    else
    {
        
        
    }
}


- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

//getMyUserData


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



@end
