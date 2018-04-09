//
//  AccountInfoController.m
//  TTJF
//
//  Created by 占碧光 on 2017/10/30.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "AccountInfoController.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "HttpSignCreate.h"
#import "ggHttpFounction.h"
#import "HttpUrlAddress.h"
#import "AccountModel.h"
#import "HomeWebController.h"
#import "AccountRealname.h"
#import "AccountPhone.h"
#import "SVProgressHUD.h"
#import "TTJFRefreshStateHeader.h"
#import "LoginViewController.h"
#import "ChangePasswordViewController.h"
@interface AccountInfoController ()<UITableViewDataSource, UITableViewDelegate,UIWebViewDelegate>
{
    Boolean isFirstExe;
    AccountModel * account;
    AccountRealname   *realname;
    AccountPhone   *phone;
    UIWebView * iWebView;
    NSString * ishaveOpen;
}
@end

@implementation AccountInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstExe=FALSE;
    ishaveOpen=@"0";
    if([CommonUtils isLogin])
    {
        self.titleString = @"账户详情";
        [self GetMyUserDatas];
        isFirstExe=TRUE;
        [self initTableView];
        
    }
    else
        [self initTableView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    if ( self.navigationController.navigationBarHidden == YES )
    {
        [self.view setBounds:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    else
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if((![CommonUtils isLogin])&&[ishaveOpen isEqual:@"0"])
    {
        realname.card_id=@"";
        realname.realname=@"";
        realname.name=@"";
          account=[[AccountModel alloc] init];
           phone=[[AccountPhone alloc] init];
        [self initTableView];
        ishaveOpen=@"1";
        [self OnLogin];
    }
    else if((![CommonUtils isLogin])&&[ishaveOpen isEqual:@"1"])
    {
         [self.navigationController popViewControllerAnimated:YES];
    }
    else if([CommonUtils isVerifyRealName])
    {
        [TTJFUserDefault setBool:NO key:isCertificationed];
        [self GetMyUserDatas];
        [self initTableView];
    }
}

//初始化主界面
-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHight, screen_width, kViewHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor=RGB(235,235,235);
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
            if([CommonUtils isLogin])
            {
                if(!isFirstExe)
                {
                    isFirstExe=TRUE;
                    [weakSelf GetMyUserDatas];
                }
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        });
    });
    
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section ==0 ){
        //return _hotQueueData.count+1;
        return 2;
    }
    else if (section ==1 ){
        return 1;
    }
    else if (section ==2 ){
        return 1;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        {
           
          return 55;
          
            
        }
    }else if(indexPath.section == 1){
        
        return 55;
        
    }
    else{
        return 45;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    else if (section == 1) {
        return 15;
    } else if (section == 2) {
        return 15;
    }
    else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    else if (section == 1) {
        return 0.01;
    } else if (section == 2) {
        return 0.01;
    }
    else{
        return 0.1;
    }
}




-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    headerView.backgroundColor =RGB(235,235,235);
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    footerView.backgroundColor = RGB(235,235,235);
    
    
    //    footerView.backgroundColor = [UIColor yellowColor];
    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if(indexPath.row == 0)
        {
            static NSString *cellIndentifier = @"MineTopCell1";
            UITableViewCell *cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.backgroundColor=[UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *  left = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, screen_width/2,15)];
            left.font = CHINESE_SYSTEM(15);
            left.textColor =  RGB(38,38,38);
            left.text=@"实名认证";
            [cell addSubview:left];
            
            NSString * temp=realname.realname;
            temp=[temp stringByAppendingString:@"  "];
            temp=[temp stringByAppendingString:realname.card_id];
            
            
            UILabel *  right = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-50, 20, screen_width/2+35,12)];
            right.font = CHINESE_SYSTEM(12);
            right.textColor =  RGB(165,165,165);
            right.textAlignment=NSTextAlignmentRight;
            if([realname.card_id isEqual:@""])
            {
                right.frame=CGRectMake(screen_width/2-70, 20, screen_width/2+35,12);
                temp=@"您未实名认证，请认证";
            }
            right.text=temp;
            [cell addSubview:right];
            
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 54,screen_width-30 , kLineHeight)];
            lineView.backgroundColor = lineBg;
            [cell addSubview:lineView];
            
            if([realname.card_id isEqual:@""])
               {
                   UIImageView * img0=[[UIImageView alloc] initWithFrame:CGRectMake(screen_width-22, 20, 7, 14)];
                   [img0 setImage:[UIImage imageNamed:@"rightArrow.png"]];
                   [cell addSubview:img0];
               }
            
            return cell;
            
        }
        else  if(indexPath.row == 1)
        {
            static NSString *cellIndentifier = @"MIneMiddleCell1";
            UITableViewCell *cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.backgroundColor=[UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *  left = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, screen_width/2,15)];
            left.font = CHINESE_SYSTEM(15);
            left.textColor =  RGB(38,38,38);
            left.text=@"手机绑定";
            [cell addSubview:left];
            
            UILabel *  right = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-50, 20, screen_width/2+35,12)];
            right.font = CHINESE_SYSTEM(12);
            right.textColor =  RGB(165,165,165);
            right.textAlignment=NSTextAlignmentRight;
            right.text=phone.phone_num;
            [cell addSubview:right];
            if([phone.phone_num isEqual:@""])
            {
                UIImageView * img0=[[UIImageView alloc] initWithFrame:CGRectMake(screen_width-22, 20, 7, 14)];
                [img0 setImage:[UIImage imageNamed:@"rightArrow.png"]];
                [cell addSubview:img0];
            }
            
            return cell;
        }
    }
    else if (indexPath.section == 1) {
        if(indexPath.row == 0)
        {
            static NSString *cellIndentifier = @"MineMenuCell12";
            
            UITableViewCell *cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.backgroundColor=[UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *  left = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, screen_width/2,15)];
            left.font = CHINESE_SYSTEM(15);
            left.textColor =  RGB(38,38,38);
            left.text=@"修改密码";
            [cell addSubview:left];
            
            UIImageView * img0=[[UIImageView alloc] initWithFrame:CGRectMake(screen_width-22, 20, 7, 14)];
            [img0 setImage:[UIImage imageNamed:@"rightArrow.png"]];
            [cell addSubview:img0];
            return cell;
        }
    }
    else if (indexPath.section == 2) {
        if(indexPath.row == 0)
        {
            static NSString *cellIndentifier = @"MineMenuCell2";
            
            UITableViewCell *cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.backgroundColor=[UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *  left = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-60, 15, 120,15)];
            left.font = CHINESE_SYSTEM(15);
            left.textColor = navigationBarColor;
            left.textAlignment=NSTextAlignmentCenter;
            left.text=@"退出登录";
            [cell addSubview:left];
            
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
   
    if (indexPath.section == 0) {
        if(indexPath.row == 0)
        {
            if([realname.card_id isEqual:@""]&&![realname.url isEqual:@""])
            {
                [TTJFUserDefault setBool:YES key:isCertificationed];
                self.hidesBottomBarWhenPushed=YES;
                HomeWebController *discountVC = [[HomeWebController alloc] init];
                discountVC.urlStr=realname.url;
                discountVC.returnmain=@"3"; //页返回
                [self.navigationController pushViewController:discountVC animated:YES];
                self.hidesBottomBarWhenPushed=NO;
            }
        }
        else if(indexPath.row == 1)
        {
            if([phone.phone_num isEqual:@""]&&![phone.url isEqual:@""])
            {
                self.hidesBottomBarWhenPushed=YES;
                HomeWebController *discountVC = [[HomeWebController alloc] init];
                discountVC.urlStr=phone.url;
                discountVC.returnmain=@"3"; //页返回
                [self.navigationController pushViewController:discountVC animated:YES];
                self.hidesBottomBarWhenPushed=NO;
            }
        }
    }
     if (indexPath.section == 1) {
         ChangePasswordViewController *change = InitObject(ChangePasswordViewController);
         [self.navigationController pushViewController:change animated:YES];
     }
    if (indexPath.section == 2) {
        [SVProgressHUD showWithStatus:@"正在退出登录..."];
        [self exit];
    }
}
- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

-(void) GetMyUserDatas{
    NSString *urlStr = @"";
    NSMutableDictionary *dict_data=[[NSMutableDictionary alloc] initWithObjects:@[[CommonUtils getToken]] forKeys:@[kToken] ];
    NSString *sign=[HttpSignCreate GetSignStr:dict_data];
    
    urlStr = [NSString stringWithFormat:getMyAccountData,oyApiUrl,[CommonUtils getToken],sign];
    NSData * data=  [ggHttpFounction  synHttpGet:urlStr];
    if([ggHttpFounction getJsonIsOk:data])
    {
        NSDictionary * dir= [ggHttpFounction getJsonData1:data];
        account=[[AccountModel alloc] init];
        isFirstExe=FALSE;
        NSDictionary * d2=[dir objectForKey:@"is_realname"];
        realname=[[AccountRealname alloc] init];
         realname.name=[d2 objectForKey:@"name"];
         realname.realname=[d2 objectForKey:@"realname"];
         realname.card_id=[d2 objectForKey:@"card_id"];
         realname.url=[d2 objectForKey:@"url"];
        
          NSDictionary * d1=[dir objectForKey:@"is_phone"];
         phone=[[AccountPhone alloc] init];
          phone.name=[d1 objectForKey:@"name"];
          phone.phone_num=[d1 objectForKey:@"phone_num"];
          phone.url=[d1 objectForKey:@"url"];
        account.update_pwd_link=[dir objectForKey:@"update_pwd_link"];
        account.user_name=[dir objectForKey:@"user_name"];
        account.exit_link=[dir objectForKey:@"exit_link"];
        
        [self.tableView reloadData];
    }
    else
    {
        
        
    }
}

-(void) exit{
    [self loadPage1:account.exit_link];
}

//加载网页
- (void)loadPage1: (NSString *) urlstr {
    
    iWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 0,0)];
    
    iWebView.delegate=self;
    //伸缩内容适应屏幕尺寸
    iWebView.scalesPageToFit=YES;
    [iWebView setUserInteractionEnabled:YES];
       [self cleanCaches];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];//清除缓存  
    NSURL *url = [[NSURL alloc] initWithString:urlstr];
    //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSMutableURLRequest *request ;
    request = [NSMutableURLRequest requestWithURL:url];
    
    //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    /*
    NSMutableString *cookies = [NSMutableString string];
    NSArray *tmp = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie * cookie in tmp) {
        [cookies appendFormat:@"%@=%@;",cookie.name,cookie.value];
    }
    [request setHTTPShouldHandleCookies:YES];
    // 注入Cookie
    [request setValue:cookies forHTTPHeaderField:@"Cookie"];
     */
    
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
    
    
    [self exitLoginStatus];
    [SVProgressHUD showSuccessWithStatus:@"退出登录成功"];
    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_LoginChanged object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{

    NSString *  currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    currentURL=[currentURL stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
   
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) OnLogin{
    [self goLoginVC];
}
/**
 *  清理缓存
 */
// 根据路径删除文件  删除cookies文件

- (void)cleanCaches{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
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
