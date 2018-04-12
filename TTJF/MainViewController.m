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
#import "BannerModel.h"
#import "ImmediateCell.h"
#import "QuicklyCell.h"//快速投资
#import "PlatformDataCell.h"//信息公告
#import "GuideRegisterCell.h"//引导新用户注册
#import "ClubeCell.h"//社区
#import "OpenAdvertView.h"
#import "HomeWebController.h"
#import "HttpUrlAddress.h"
#import "ggHttpFounction.h"
#import "AutoLoginView.h"
#import "RushPurchaseController.h"
#import "ProgrameNewDetailController.h"
#import "TTJFRefreshStateHeader.h"
#import "RegisterViewController.h"//注册页面
#import "TotalTradesView.h"//总成交金额
#import "CustomerServiceView.h"//客户服务
#import "AdverAlertView.h"//广告浮层
#import "HomepageModel.h"
#import <UIButton+WebCache.h>
#import "SystemConfigModel.h"

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,UIWebViewDelegate,BannerDelegate,ImmediateDelegate,OpenShowAdvertDelegate,UIAlertViewDelegate>
{
    UIWebView *iWebView;
    NSMutableArray * daibanArrayURL;
    OpenAdvertView *advertView;
    UIView *footerView ;
    Boolean isExeute;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.alpha = 0;
    [self.backBtn setHidden:YES];
    self.titleString = @"土土金服";
    clubDataArray = InitObject(NSMutableArray);
    isExeute=FALSE;
   
    /**自定登录*/
    //如果已经存储了token值，则自动登录更新token
    if ([CommonUtils isLogin]) {
        [self.view addSubview:[AutoLoginView defaultView]];
        [[AutoLoginView defaultView] autoLogin];
    }else{
        
    }
    [self initSubViews];
    //注入是否登录更新首页内容通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHomePageInfo) name:Noti_LoginChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadConfig) name:Noti_GetSystemConfig object:nil];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_LoginChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_GetSystemConfig object:nil];

}
//初始化主界面
-(void)initSubViews{
    
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kSizeFrom750(135))];
    self.tableView = [[BaseUITableView alloc] initWithFrame:CGRectMake(0, -kStatusBarHeight, screen_width, screen_height+kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = separaterColor;
    // 设置表格尾部
    [self.tableView setTableFooterView:footerView];
    [self.tableView setSeparatorColor:separaterColor];
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

    [self initCustomView];
    
}
//自定义视图
-(void)initCustomView
{
    //累计成交总额
    self.tradesView = [[TotalTradesView alloc]initWithFrame: RECT(kSizeFrom750(50), kSizeFrom750(342), screen_width - kSizeFrom750(100), kSizeFrom750(290))];
    [CommonUtils setShadowCornerRadiusToView:self.tradesView];
    self.tradesView.hidden = YES;
    [self.tableView addSubview:self.tradesView];
    
    //客服按钮
    self.serviceBtn = [[UIButton alloc]initWithFrame:RECT(0, kNavHight - kSizeFrom750(66), kSizeFrom750(114), kSizeFrom750(46))];
    [self.serviceBtn addTarget:self action:@selector(serviceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.serviceBtn setImage:IMAGEBYENAME(@"service_unsel") forState:UIControlStateNormal];
    [self.serviceBtn setImage:IMAGEBYENAME(@"service_sel") forState:UIControlStateSelected];
    self.serviceBtn.adjustsImageWhenHighlighted = NO;
    self.serviceBtn.selected = YES;//默认处于加黑状态
    [self.view addSubview:self.serviceBtn];
    
    //消息按钮
    self.messageBtn = [[UIButton alloc]initWithFrame:RECT(screen_width - kSizeFrom750(60), self.serviceBtn.top, kSizeFrom750(50), kSizeFrom750(46))];
    self.messageBtn.centerY = self.serviceBtn.centerY;
    [self.messageBtn addTarget:self action:@selector(messageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.messageBtn setImage:IMAGEBYENAME(@"message_noPoint") forState:UIControlStateNormal];
    [self.messageBtn setImage:IMAGEBYENAME(@"message_Point") forState:UIControlStateSelected];
    self.messageBtn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:self.messageBtn];
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
    
    [[HttpCommunication sharedInstance] getSignRequestWithPath:getHomePageInfoUrl keysArray:keys valuesArray:values refresh:self.tableView success:^(NSDictionary *successDic) {
        self.homePageModel = [HomepageModel yy_modelWithJSON:successDic];
        [self.tradesView setHidden:NO];
        [clubDataArray removeAllObjects];
        if (self.homePageModel.notice_items!=nil) {
            [clubDataArray addObjectsFromArray:self.homePageModel.notice_items];
        }
        if (self.homePageModel.lcgh_items!=nil) {
            [clubDataArray addObjectsFromArray:self.homePageModel.lcgh_items];
        }
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
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
    //总金额
    [self.tradesView loadInfoWithModel:self.homePageModel];
    
    [footerView removeAllSubViews];
    
    CGFloat ww=[self.homePageModel.guarantee_txt length]*SYSTEMSIZE(25).lineHeight;
    UILabel * title= [[UILabel alloc] initWithFrame:CGRectMake((screen_width-ww)/2, kSizeFrom750(30),ww,kSizeFrom750(30))];
    title.textAlignment=NSTextAlignmentCenter;
    title.textColor=RGB_153;
    title.font=SYSTEMSIZE(25);
    title.text=self.homePageModel.guarantee_txt;
    [footerView addSubview:title];
    UIImageView *typeimgsrc= [[UIImageView alloc] initWithFrame:CGRectMake((screen_width-ww)/2-kSizeFrom750(50), 5,kSizeFrom750(36), kSizeFrom750(40))];
    typeimgsrc.centerY = title.centerY;
    [typeimgsrc setImage:[UIImage imageNamed:@"y.png"]];
    [footerView addSubview:typeimgsrc];
    
    UILabel *remindLabel = InitObject(UILabel);
    remindLabel.frame = RECT(0, title.bottom+kSizeFrom750(20), screen_width, kSizeFrom750(20));
    remindLabel.textAlignment = NSTextAlignmentCenter;
    remindLabel.textColor=RGB(204, 204, 204);
    remindLabel.font = SYSTEMSIZE(20);
    remindLabel.text = [NSString stringWithFormat:@"%@%@%@",@"—— ",self.homePageModel.guarantee_sub_txt,@" ——"];
    [footerView addSubview:remindLabel];
    
    if ([self.homePageModel.unread_msg_num integerValue]>0) {
        self.messageBtn.selected = YES;
    }else{
        self.messageBtn.selected = NO;
    }
    
    if (!IsEmptyStr(self.homePageModel.activity_ad_info.status)) {
        if ([self.homePageModel.activity_ad_info.status integerValue]==1) {
            [self.adAlertView setHidden:NO];
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
    if( [CommonUtils isUpdate])
    {
        [self showUpdate];
    }
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section ==0 ){//banner
        return 2;
    }
    else if (section ==1 ){//快速投资
        return self.homePageModel.loan_items.count;
    }
    else if (section ==2 ){//土土社区+平台数据和信息披露
        return clubDataArray.count+1;
    }
    
    return 1;
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
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //社区不需要footer
    if (section==2) {
        return 0;
    }else
        return kSizeFrom750(30);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
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
        return nil;
        
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section!=2) {
        return [UIView new];
    }else{
        return nil;
    }
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
            return [self registerPlatTableView:tableView indexPath:indexPath];
        }else
            return  [self registerClubTableView:tableView indexPath:indexPath];
        
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
    
    if ([model.link_url rangeOfString:[urlCheckAddress stringByAppendingString:@"/wap/loan/loantender"]].location != NSNotFound)
    {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
        return;
    }
    else{
        [self goWebViewWithUrl:model.link_url];
    }
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
    vc.vistorType=@"1";
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
    vc.vistorType=@"1";
    vc.loan_id=model.loan_id;
    [self.navigationController pushViewController:vc animated:YES];
  
}
//首页投资列表点击
-(void)didSelectedQuicklyAtIndex1:(NSInteger)index
{
    QuicklyModel * model=[self.homePageModel.loan_items objectAtIndex:index];
    ProgrameNewDetailController * vc=[[ProgrameNewDetailController alloc] init];
    vc.loan_id=model.loan_id;
    [self.navigationController pushViewController:vc animated:YES];
}
//社区事件点击
-(void)didSelectedClubAtIndexPath:(NSInteger)index{
    NoticeModel *model = [clubDataArray objectAtIndex:index];
    [self  goWebViewWithUrl:model.link_url];
}
//滚动视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= kNavHight && offsetY > 0) {
        self.titleView.alpha = offsetY/kNavHight;
    }else if(offsetY > kNavHight){
        self.titleView.alpha = 1.0f;
    }else{
        self.titleView.alpha = 0;
    }

    CGFloat halfNav = kNavHight/2.0f;
    if(offsetY<=0){
        self.serviceBtn.selected = YES;
        self.serviceBtn.alpha = 1;
    }
   else if (offsetY<=halfNav&&offsetY>0) {
        self.serviceBtn.selected = YES;
        self.serviceBtn.alpha = 1-offsetY/halfNav;
    }else if(offsetY>halfNav&&offsetY<=kNavHight){
        self.serviceBtn.selected = NO;
        self.serviceBtn.alpha = (offsetY-halfNav)/halfNav;
    }else{
        self.serviceBtn.selected = NO;
        self.serviceBtn.alpha = 1;
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
