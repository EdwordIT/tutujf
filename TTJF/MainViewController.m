//
//  MainViewController.m
//    改版的B版效果 是参照国美在线头部搜索 C 版 是 我主良缘
//
//  Created by 占碧光 on 2017/2/26.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "MainViewController.h"
#import "HttpSignCreate.h"
#import "HomeBanner.h"
#import "ImmediateCell.h"//新手专享
#import "QuicklyCell.h"//快速投资
#import "PlatformDataCell.h"//信息公告
#import "GuideRegisterCell.h"//引导新用户注册
#import "ClubeCell.h"//社区
#import "OpenAdvertView.h"//启动显示的广告页
#import "HomeWebController.h"
#import "AutoLoginView.h"
#import "RushPurchaseController.h"
#import "ProgrameDetailController.h"
#import "RegisterViewController.h"//注册页面
#import "TotalTradesView.h"//总成交金额
#import "CustomerServiceView.h"//客户服务
#import "AdverAlertView.h"//广告浮层
#import "HomepageModel.h"
#import <UIButton+WebCache.h>
#import "SystemConfigModel.h"
#import "CountDownManager.h"

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,UIWebViewDelegate,BannerDelegate,ImmediateDelegate,OpenShowAdvertDelegate,UIAlertViewDelegate>
{
    UIWebView *iWebView;
    NSMutableArray * daibanArrayURL;
    UIView *footerView ;
    NSMutableArray *clubDataArray;

}
Strong BaseUITableView *tableView;
Strong TotalTradesView *tradesView;//交易总金额视图
Strong CustomerServiceView *serviceView;//客服热线
Strong AdverAlertView *adAlertView;//广告浮层
Strong UIButton *serviceBtn;//客服按钮
Strong UIButton *messageBtn;//消息按钮
Strong HomepageModel *homePageModel;//数据源
Strong SystemConfigModel *configModel;//
Strong UIView *functionTopView;//功能按钮
@end


@implementation MainViewController
#pragma mark --buttonClick
-(void)serviceBtnClick:(UIButton *)sender{
    
    [self.serviceView setHidden:NO];
}
-(void)messageBtnClick:(UIButton *)sender{
    //消息按钮点击
    [self goWebViewWithUrl:self.homePageModel.unread_msg_link];
}
//显示升级弹框
-(void)showUpdate
{
    
    NSString *updateVersion = self.configModel.ios_version;
    if((!IsEmptyStr(updateVersion))&&(![updateVersion isEqualToString:currentVersion]))
    {
        NSString  *downloadStr = self.configModel.ios_downurl;
        NSInteger isForced = [self.configModel.ios_forceup integerValue];//是否强制升级
        
        if (isForced==1) {//强制更新，只有一个按钮
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"土土金服有新内容更新" delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"土土金服有新内容更新" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"cancel Action");
            }];
            [alertController addAction:cancelAction];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"OK Action");
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadStr]];
                
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
   
}

//点击进入appStore更新
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString  *downloadStr = self.configModel.ios_downurl;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadStr]];
}
//跳转到webView
-(void)goWebViewWithUrl:(NSString *)url
{
    HomeWebController *web = [[HomeWebController alloc]init];
    web.urlStr = url;
    [self.navigationController pushViewController:web animated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([self.configModel.ios_forceup integerValue]==1){
        [self showUpdate];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.alpha = 0;
    [self.backBtn setHidden:YES];
    self.titleString = @"土土金服";
    clubDataArray = InitObject(NSMutableArray);

    [self registerUserAgent];
    /**自定登录*/
    //如果已经存储了token值，则自动登录更新token
    if ([CommonUtils isLogin]) {
        AutoLoginView *loginView = InitObject(AutoLoginView);
        [self.view addSubview:loginView];
        [loginView autoLogin];
    }else{
        
    }
    [self initSubViews];
    
    [self checkNotification];
    //注入是否登录更新首页内容通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHomePageInfo) name:Noti_LoginChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadConfig) name:Noti_GetSystemConfig object:nil];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
}
-(void)dealloc{
    [[CountDownManager manager] cancel];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_LoginChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_GetSystemConfig object:nil];

}
-(void)registerUserAgent
{
    
    WKWebView *  wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
    // 获取默认User-Agent
    [wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        NSString *oldAgent = result;
        NSString *typeString = [NSString stringWithFormat:WEB_UserAgent,kVersion_Coding];;
        if ([oldAgent rangeOfString:typeString].location!=NSNotFound) {
            return ;
        }
        // 给User-Agent添加额外的信息
        NSString *newAgent = [NSString stringWithFormat:@"%@;%@", oldAgent, typeString];
        // 设置global User-Agent
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    }];
    [self.view addSubview:wkWebView];
}
//app通过点击通知打开app，此处校验通知内容，做出相应的跳转
-(void)checkNotification{
    if (self.userInfo) {
        NSDictionary *aps = [self.userInfo objectForKey:@"aps"];
        if (aps!=nil) {
            NSString *category = [aps objectForKey:@"category"];
            if(!IsEmptyStr(category)){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self goWebViewWithUrl:category];
                });
            }
        }
        
    }
}
//初始化主界面
-(void)initSubViews{
    
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kSizeFrom750(135))];
    self.tableView = [[BaseUITableView alloc] initWithFrame:CGRectMake(0, -1, screen_width, screen_height - kTabbarHeight+1) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = separaterColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    // 设置表格尾部
    [self.tableView setTableFooterView:footerView];
    [self.view addSubview:self.tableView];

    __weak typeof(self) weakSelf = self;
    self.tableView.ly_emptyView = [EmptyView noDataRefreshBlock:^{
        [weakSelf getHomePageInfo];
    }];
    self.tableView.mj_header =  [TTJFRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf  getHomePageInfo];
    }];
    [self getHomePageInfo];
    
    [self.view bringSubviewToFront:self.titleView];
    
}
//自定义视图
-(void)initCustomView
{
    //累计成交总额
    self.tradesView = [[TotalTradesView alloc]initWithFrame: RECT(kSizeFrom750(50), kSizeFrom750(342), screen_width - kSizeFrom750(100), kSizeFrom750(290))];
    [CommonUtils setShadowCornerRadiusToView:self.tradesView];
    self.tradesView.hidden = YES;
    [self.tableView addSubview:self.tradesView];
    
    self.functionTopView = [[UIView alloc]initWithFrame:RECT(0, 0, screen_width, kNavHight)];
    [self.view addSubview:self.functionTopView];
    
     [self.view bringSubviewToFront:self.titleView];
     [self.view bringSubviewToFront:self.functionTopView];
    //客服按钮
    self.serviceBtn = [[UIButton alloc]initWithFrame:RECT(0,kStatusBarHeight+((kNavHight - kStatusBarHeight) - kSizeFrom750(46))/2, kSizeFrom750(114), kSizeFrom750(46))];
    [self.serviceBtn addTarget:self action:@selector(serviceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.serviceBtn setImage:IMAGEBYENAME(@"service_sel") forState:UIControlStateNormal];
    self.serviceBtn.adjustsImageWhenHighlighted = NO;
    [self.functionTopView addSubview:self.serviceBtn];
    
    //消息按钮
    self.messageBtn = [[UIButton alloc]initWithFrame:RECT(screen_width - kSizeFrom750(60), self.serviceBtn.top, kSizeFrom750(46), kSizeFrom750(46))];
    self.messageBtn.centerY = self.serviceBtn.centerY;
    [self.messageBtn addTarget:self action:@selector(messageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.messageBtn setImage:IMAGEBYENAME(@"message_noPoint") forState:UIControlStateNormal];
    self.messageBtn.adjustsImageWhenHighlighted = NO;
    [self.functionTopView addSubview:self.messageBtn];
    //客服页面
    self.serviceView = [[CustomerServiceView alloc]initWithFrame:kScreen_Bounds];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.serviceView];
    [self.serviceView setHidden:YES];
    WEAK_SELF;
    self.serviceView.serviceBlock = ^(NSInteger tag) {
        
        [weakSelf.serviceView setHidden:YES];
        //
        if (tag==1) {
            //拨打客服电话
            NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",IsEmptyStr(weakSelf.configModel.cust_serv_tel)?@"400-000-9899":weakSelf.configModel.cust_serv_tel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }else{
            //跳转到常见问题界面
            [weakSelf goWebViewWithUrl:weakSelf.configModel.com_problem_link];
        }
    };
    
    self.adAlertView  = [[AdverAlertView alloc]initWithFrame:RECT(screen_width - kSizeFrom750(180), kSizeFrom750(1000), kSizeFrom750(150), kSizeFrom750(150))];
    [self.view addSubview:self.adAlertView];
    self.adAlertView.adAlertBlock = ^{
        //跳转广告页面
        [weakSelf goWebViewWithUrl:weakSelf.homePageModel.activity_ad_info.link_url];
        
    };
    [self.adAlertView setHidden:YES];
}

#pragma mark --数据加载
//获取主页数据
-(void)getHomePageInfo
{
    NSString *user_token = [CommonUtils getToken];
    NSString *version = @"20";
    NSString *device_id = [CommonUtils getDeviceToken];
    
    NSArray *keys = @[@"version",@"device_id",kToken];
    NSArray *values = @[version,device_id,user_token];
    
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getHomePageInfoUrl keysArray:keys valuesArray:values refresh:self.tableView success:^(NSDictionary *successDic) {
        if (!self.tradesView) {
            [self initCustomView];
        }
        [[CountDownManager manager] start];
        self.homePageModel = [HomepageModel yy_modelWithJSON:successDic];
        [self.tradesView setHidden:NO];
        [self ->clubDataArray removeAllObjects];
        if (self.homePageModel.notice_items!=nil) {
            [self ->clubDataArray addObjectsFromArray:self.homePageModel.notice_items];
        }
        if (self.homePageModel.lcgh_items!=nil) {
            [self ->clubDataArray addObjectsFromArray:self.homePageModel.lcgh_items];
        }

        [self reloadCustomData];//刷新自定义内容
        [self.tableView reloadData];
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
//刷新自定义控件内容
-(void)reloadCustomData{
    if (self.configModel) {
        //service客服页面
        [self.serviceView reloadInfoWithModel:self.configModel];
    }
    self.tradesView.top = kSizeFrom750(342);
    //总金额
    [self.tradesView loadInfoWithModel:self.homePageModel];
    
    [footerView removeAllSubViews];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:RECT(0, kSizeFrom750(20), screen_width, kSizeFrom750(40))];
    [btn setTitle:self.homePageModel.guarantee_txt forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    [btn.titleLabel setFont:SYSTEMSIZE(25)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -kSizeFrom750(10))];
    [btn setImage:IMAGEBYENAME(@"icons_safe") forState:UIControlStateNormal];
    [btn setTitleColor:RGB_153 forState:UIControlStateNormal];
    [footerView addSubview:btn];
    
    UILabel *remindLabel = InitObject(UILabel);
    remindLabel.frame = RECT(0, btn.bottom+kSizeFrom750(20), screen_width, kSizeFrom750(20));
    remindLabel.textAlignment = NSTextAlignmentCenter;
    remindLabel.textColor=RGB(204, 204, 204);
    remindLabel.font = SYSTEMSIZE(20);
    remindLabel.text = [NSString stringWithFormat:@"%@%@%@",@"—— ",self.homePageModel.guarantee_sub_txt,@" ——"];
    [footerView addSubview:remindLabel];
    
    if ([self.homePageModel.unread_msg_num integerValue]>0) {
        [self.messageBtn setImage:IMAGEBYENAME(@"message_point") forState:UIControlStateNormal];

    }else{
        [self.messageBtn setImage:IMAGEBYENAME(@"message_noPoint") forState:UIControlStateNormal];
    }
    
    if (!IsEmptyStr(self.homePageModel.activity_ad_info.status)) {
        if ([self.homePageModel.activity_ad_info.status integerValue]==1) {
            [self.adAlertView setHidden:NO];
            
            self.adAlertView.frame = RECT(screen_width - [self.homePageModel.activity_ad_info.img_width floatValue] - kSizeFrom750(30), screen_height - [self.homePageModel.activity_ad_info.img_height floatValue] - kTabbarHeight - kSizeFrom750(30), [self.homePageModel.activity_ad_info.img_width floatValue], [self.homePageModel.activity_ad_info.img_height floatValue]);
            [self.adAlertView.iconImage sd_setImageWithURL:[NSURL URLWithString:self.homePageModel.activity_ad_info.images_url] forState:UIControlStateNormal];
        }else
            [self.adAlertView setHidden:YES];
    }else{
        [self.adAlertView setHidden:YES];
    }
}
//刷新SystemConfig接口相关内容
-(void)reloadConfig
{
    NSDictionary *configDic = [CommonUtils getCacheDataWithKey:Cache_SystemConfig];
    if (configDic!=nil) {
        self.configModel = [SystemConfigModel yy_modelWithJSON:configDic];
    }
    /**版本更新判断**/
    [self showUpdate];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section ==0 ){//banner
        return self.homePageModel?2:0;
    }
    else if (section ==1 ){//快速投资
        return self.homePageModel.loan_items.count;
    }
    else if (section ==2 ){//土土社区+平台数据和信息披露
        return clubDataArray.count+(self.homePageModel?1:0);
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
            if(indexPath.row==0)
                return kSizeFrom750(380);//banner高度
            else if(indexPath.row==1){ //新手专享或者注册通知
                if (![CommonUtils isLogin]) {
                    return kSizeFrom750(650);//引导注册
                }else{
                    if ([self.homePageModel.novice_loan_data.additional_status integerValue]==0){
                        return kSizeFrom750(280);//用户已经登录，但是新手专享无数据
                    }else
                    return kSizeFrom750(650);//用户已经登录，并且有新手标
                }
        }
    }else if(indexPath.section == 1){//快速投资
        return kSizeFrom750(258);
    }else if (indexPath.section == 2){
        if (indexPath.row==0) {
            return kSizeFrom750(140);
        }else
        return kSizeFrom750(185);//土土咨询
    }
    else{
        return 0;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    if (section == 2) {//社区
        return kSizeFrom750(88);
    }
    else{
        return 0.01;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section==0) {
        return kSizeFrom750(30);
    }
   else if (section==1) {
       if (self.homePageModel.loan_items.count == 0) {//如果没有快速投资
           return 0;
       }
        return kSizeFrom750(30);
    }
    //社区不需要tablefooter
   else if (section==2) {
        return 0;
    }
    else
        return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.homePageModel) {
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        header.backgroundColor = COLOR_Background;
        return header;
    }
    if (section==2) {
        UIView *clubTitle = [[UIView alloc]initWithFrame:RECT(0, 0, screen_width, kSizeFrom750(88))];
        clubTitle.backgroundColor = [UIColor whiteColor];
        CALayer *layer = [CALayer layer];
        layer.frame = RECT(0, kSizeFrom750(88) - 0.5, screen_width, 0.5);
        [layer setBackgroundColor:[RGB_166 CGColor]];
        layer.opacity = 0.3;
        [clubTitle.layer addSublayer:layer];
        
        UIButton *title = [[UIButton alloc]initWithFrame:RECT(kSizeFrom750(30), 0, kSizeFrom750(180), kSizeFrom750(40))];
        title.centerY = clubTitle.centerY;
        [title setImage:IMAGEBYENAME(@"home_club") forState:UIControlStateNormal];
        title.userInteractionEnabled = NO;
        [title setTitle:@"土土社区" forState:UIControlStateNormal];
        [title.titleLabel setFont:SYSTEMBOLDSIZE(25)];
        [title setTitleColor:RGB_51 forState:UIControlStateNormal];
        [title setTitleEdgeInsets:UIEdgeInsetsMake(0, -kSizeFrom750(20), 0, 0)];
        [title setImageEdgeInsets:UIEdgeInsetsMake(0, -(title.width-title.imageView.width - title.titleLabel.width), 0, 0)];
        [clubTitle addSubview:title];
        return clubTitle;
        
    }else {
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        header.backgroundColor = COLOR_Background;
        return header;
        return nil;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    footer.backgroundColor = COLOR_Background;
    if (section==0) {
        return footer;
    }
    else if (section==1) {
        if (self.homePageModel.loan_items.count == 0) {//如果没有快速投资
            return footer;
        }
        return footer;
    }
    //社区不需要tablefooter
    else if (section==2) {
        return nil;
    }
    else
        return nil;
//    return footer;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        //banner
        if(indexPath.row == 0)
        {
            static NSString *cellIndentifier = @"HomeBanner";
            HomeBanner *bannerCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if(bannerCell==nil){
                bannerCell =  [[HomeBanner alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
            }
            NSMutableArray *imageArr = InitObject(NSMutableArray);
            for (int i=0; i<self.homePageModel.advert_items.count; i++) {
                BannerModel *banner = [self.homePageModel.advert_items objectAtIndex:i];
                [imageArr addObject:banner.pic_url];
                if (i==self.homePageModel.advert_items.count-1) {
                    [bannerCell setModelArray:imageArr];
                }
            }
            bannerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            bannerCell.delegate=self;
            return bannerCell;
            
        }else{
            if (![CommonUtils isLogin]) {
                //注册提示
                return  [self registerRegisterTableView:tableView indexPath:indexPath];
            }else{
                //新手专享
                static NSString *cellIndentifier = @"ImmediateCell";
                ImmediateCell *cell = [[ImmediateCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
                cell.delegate=self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                BOOL isHaveData = [self.homePageModel.novice_loan_data.additional_status integerValue]==1?YES:NO;
                [cell hiddenSubViews:isHaveData];
                [cell setImmediateModel:self.homePageModel.novice_loan_data];
                return cell;
            }
        }
        
        
    }//快速投资
    else if (indexPath.section == 1){
        
        NSString *cellIndentifier = @"QuicklyCell";
        QuicklyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if(cell == nil)
        {
            cell = [[QuicklyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
        }
        
        [cell.sepView removeFromSuperview];//清除间隔符
        WEAK_SELF;
        QuicklyModel * tmodel1=[self.homePageModel.loan_items objectAtIndex:indexPath.row];
        [cell setQuicklyModel:tmodel1];
        cell.investBlock = ^{
            [weakSelf investWithModel:tmodel1];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    //土土社区
    else if(indexPath.section ==2){
        
        if (indexPath.row==clubDataArray.count) {
            return [self registerPlatTableView:tableView indexPath:indexPath];//平台数据
        }else
            return  [self registerClubTableView:tableView indexPath:indexPath];//社区内容
    }else{
    }
    return nil;
}



#pragma mark --customCell
//社区
-(ClubeCell *)registerClubTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"ClubeCell";
    ClubeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[ClubeCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
        NoticeModel *model = [clubDataArray objectAtIndex:indexPath.row];
        [cell loadInfoWithModel:model];
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//注册提示
-(GuideRegisterCell *)registerRegisterTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"GuideRegisterCell";
    GuideRegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[GuideRegisterCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    [cell.registerBtn setTitle:self.homePageModel.reg_button_txt forState:UIControlStateNormal];
    cell.registerBlock = ^{
        RegisterViewController *reg = InitObject(RegisterViewController);
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:reg];
        reg.isRootVC = YES;
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//信息披露
-(PlatformDataCell *)registerPlatTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"PlatformDataCell";
    PlatformDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell==nil) {
        cell = [[PlatformDataCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    //平台数据点击
    WEAK_SELF;
    cell.platBlock = ^{
        [weakSelf goWebViewWithUrl:weakSelf.homePageModel.platformModel.left_link_url];
    };
    //信息披露
    cell.infoBlock = ^{
         [weakSelf goWebViewWithUrl:weakSelf.homePageModel.platformModel.right_link_url];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setBanndrNum
{
    [self.tradesView countTradeNum];
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //关闭选中效果
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        [self  didSelectedQuicklyAtIndex1:indexPath.row];
    }else if(indexPath.section==2)//土土社区
    {
        [self didSelectedClubAtIndexPath:indexPath.row];
    }
    
}

/**表格内部委托事件出触发**/

//轮播图事件
-(void)didSelectedBannerAtIndex:(NSInteger)index
{
    BannerModel * model=[self.homePageModel.advert_items objectAtIndex:index];
    
    [self goWebViewWithUrl:model.link_url];
}
//立即投资（新手标）
-(void)didSelectedImmediateAtIndex:(NSInteger)index
{
    if(![CommonUtils isLogin])
    {
        [self goLoginVC];
        return;
    }
    ImmediateModel * model = self.homePageModel.novice_loan_data;
    RushPurchaseController * vc=[[RushPurchaseController alloc] init];
    vc.loan_id=model.loan_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//抢购（首页其他标的）
-(void)investWithModel:(QuicklyModel *)model
{
    if(![CommonUtils isLogin])
    {
        [self goLoginVC];
        return;
    }
    RushPurchaseController * vc=[[RushPurchaseController alloc] init];
    vc.loan_id=model.loan_id;
    [self.navigationController pushViewController:vc animated:YES];
  
}
//首页投资列表点击
-(void)didSelectedQuicklyAtIndex1:(NSInteger)index
{
    QuicklyModel * model=[self.homePageModel.loan_items objectAtIndex:index];
    ProgrameDetailController * vc=[[ProgrameDetailController alloc] init];
    LoanBase *base = InitObject(LoanBase);
    LoanInfo *info = InitObject(LoanInfo);
    
    info.apr = model.apr_val;
    info.progress = model.progress;
    info.period = model.period;
    info.amount = model.amount;
    info.name = model.name;
    info.status_name = model.status_name;
    info.tender_amount_min = @"";
    base.repay_type_name = model.repay_type_name;
    base.loan_info = info;
    vc.baseModel = base;
    vc.loan_id = model.loan_id;
    [self.navigationController pushViewController:vc animated:YES];
}
//社区事件点击
-(void)didSelectedClubAtIndexPath:(NSInteger)index{
    NoticeModel *model = [clubDataArray objectAtIndex:index];
    [self  goWebViewWithUrl:model.link_url];
}
//滚动视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView!=self.tableView) {
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y - scrollView.top;
//    self.tradesView.top = kSizeFrom750(342) - offsetY;//交易view
    if (offsetY <= kNavHight && offsetY > 0) {
        self.titleView.alpha = offsetY/kNavHight;
    }else if(offsetY > kNavHight){
        self.titleView.alpha = 1.0f;
    }else{
        self.titleView.alpha = 0;
    }

    CGFloat halfNav = kNavHight/2.0f;
    if(offsetY<=0){//下拉刷新时候
        [self.serviceBtn setImage:IMAGEBYENAME(@"service_sel") forState:UIControlStateNormal];
        self.serviceBtn.alpha = 1;
    }
   else if (offsetY<=halfNav&&offsetY>0) {
       [self.serviceBtn setImage:IMAGEBYENAME(@"service_sel") forState:UIControlStateNormal];
        self.serviceBtn.alpha = 1-offsetY/halfNav;
    }else if(offsetY>halfNav&&offsetY<=kNavHight){
        [self.serviceBtn setImage:IMAGEBYENAME(@"service_unsel") forState:UIControlStateNormal];
        self.serviceBtn.alpha = (offsetY-halfNav)/halfNav;
    }else{
        [self.serviceBtn setImage:IMAGEBYENAME(@"service_unsel") forState:UIControlStateNormal];
        self.serviceBtn.alpha = 1;
    }
    
    //客服按钮
    if (offsetY<=0) {
        self.functionTopView.top = - offsetY;
    }else{
        self.functionTopView.top = 0;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}




@end
