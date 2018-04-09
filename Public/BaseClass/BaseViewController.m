//
//  MineViewController.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/6.
//  Copyright © 2018年 wbzhan. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
@interface BaseViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation BaseViewController
+ (UIViewController *)appRootViewController {
    UIViewController *appRootVC = [(AppDelegate *)[UIApplication sharedApplication].delegate currentNav];
    if ([appRootVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *topVC = (UINavigationController *)appRootVC;
        return topVC.topViewController;
    } else {
        UIViewController *topVC = appRootVC;
        while (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }
        return topVC;
    }
}
#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //
    //设置默认背景颜色
    self.view.backgroundColor = RGB_246;
    
    [self initNavBar];
    
    [self makeConstraints];
    
    if (self.titleString) {
        self.titleLabel.text = self.titleString;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goLoginVC) name:Noti_AutoLogin object:nil];
    
}
#pragma mark --loadCustomTitleView
//masonary的layoutsubviews方法
-(void)makeConstraints
{
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(screen_width);
        make.height.mas_equalTo(kNavHight);
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight);
        make.width.mas_equalTo(screen_width);
        make.height.mas_equalTo(kNavHight - kStatusBarHeight);
        make.centerX.equalTo(self.view);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSizeFrom750(10));
        make.width.mas_equalTo(kSizeFrom750(88));
        make.height.mas_equalTo(kSizeFrom750(88));
        make.centerY.equalTo(self.titleLabel);
    }];
    //两个点属性连续书写会出现bug，代码崩溃，原因待查
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kSizeFrom750(10));
        make.width.mas_equalTo(kSizeFrom750(88));
        make.height.mas_equalTo(kSizeFrom750(88));
        make.centerY.equalTo(self.backBtn);
    }];
    
    [_newsMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_rightBtn.mas_top).mas_offset(kSizeFrom750(14));
        make.right.mas_equalTo(_rightBtn.mas_right).mas_offset(-kSizeFrom750(14));
        make.width.height.mas_equalTo(kSizeFrom750(14));
        
    }];
}
#pragma mark -- lazy
//- (UIImageView *)titleImageView {
//    if (!_titleImageView) {
//        _titleImageView = [[UIImageView alloc] init];
//        [_titleImageView setImage: IMAGEBYENAME(@"")];
//        _titleImageView.hidden = YES;
//    }
//    return _titleImageView;
//}
-(UIView *)titleView
{
    if (!_titleView) {
        _titleView = InitObject(UIView);
        //        _titleView.backgroundColor = navigationBarColor;
        _titleView.backgroundColor= RGB(6, 159, 241);//深蓝色
    }
    return _titleView;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = InitObject(UILabel);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = CHINESE_SYSTEM_BOLD(Title_Font);
        _titleLabel.textColor = RGB(255, 255, 255);
    }
    return _titleLabel;
}
-(void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    _titleLabel.text = _titleString;
}
-(UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = InitObject(UIButton);
        [_backBtn setImage:IMAGEBYENAME(@"nav_back") forState:UIControlStateNormal];
        _backBtn.adjustsImageWhenHighlighted = NO;

        
    }
    return _backBtn;
}
-(UIButton *)rightBtn
{
    if (!_rightBtn) {
        //右边按钮默认隐藏
        _rightBtn = InitObject(UIButton);
        [_rightBtn.titleLabel setFont:CHINESE_SYSTEM(kSizeFrom750(30))];
        [_rightBtn setHidden:YES];
        _rightBtn.adjustsImageWhenHighlighted = NO;
        
    }
    return _rightBtn;
}

//关于我的界面有新消息时候， 显示该图标
- (UIImageView *)newsMessage {
    if (!_newsMessage) {
        _newsMessage = [[UIImageView alloc] init];
        _newsMessage.backgroundColor = RGB(10, 224, 173);
        _newsMessage.layer.cornerRadius = kSizeFrom750(14 / 2);
        _newsMessage.layer.masksToBounds = YES;
        //默认隐藏
        _newsMessage.hidden = YES;
    }
    return _newsMessage;
}
//加载自定义导航栏
-(void)initNavBar
{
    [self.view addSubview:self.titleView];
    [self.titleView addSubview:self.backBtn];
    [self.titleView addSubview:self.titleLabel];
    [self.titleView addSubview:self.rightBtn];
    [self.titleView addSubview:self.newsMessage];
    //隐藏系统自带导航栏
    [self.navigationController.navigationBar setHidden:YES];
    [self.backBtn addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark --自定义按钮点击事件
-(void)backPressed:(UIButton *)sender
{
    if (self.isBackToRootVC) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
        [self.navigationController popViewControllerAnimated:YES];
}
-(void)goLoginVC{
    
    LoginViewController *loginVC = InitObject(LoginViewController);
    UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    
    [self presentViewController:loginNav animated:YES completion:^{
        
    }];
}
//退出登录状态
-(void)exitLoginStatus
{
    //清除token记录
    [TTJFUserDefault removeStrForKey:kToken];
    [TTJFUserDefault removeStrForKey:kPassword];
    [TTJFUserDefault removeStrForKey:kExpirationTime];
    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_LoginChanged object:nil];
}
#pragma mark - UINavigationControllerDelegate
-(void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    //主视图
    if (self.navigationController.viewControllers.count == 1) {
        [self hideHomeTabBar:NO];
    } else {
        [self hideHomeTabBar:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
}
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}
#pragma mark --
-(void)hideHomeTabBar:(BOOL)hidden
{
    UITabBar *tabbar = self.tabBarController.tabBar;
    if (tabbar==nil) {
        return;
    }
    if (hidden==YES&&tabbar.hidden==YES) {
        return;
    }
    if (hidden==NO&&tabbar.hidden==NO) {
        return;
    }
    if (!hidden) {
        tabbar.hidden=NO;
    }
    [UIView animateWithDuration:0.3 animations:^{
        if (hidden) {
            tabbar.frame = RECT(0, screen_height, screen_width, kTabbarHeight);
        }else{
            tabbar.frame = RECT(0, screen_height-kTabbarHeight, screen_width, kTabbarHeight);
        }
    } completion:^(BOOL finished) {
        [tabbar setHidden:hidden];
    }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_AutoLogin object:nil];
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
