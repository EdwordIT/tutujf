//
//  BaseViewController.m
//  TTJF
//
//  Created by 占碧光 on 2017/3/13.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import <Masonry.h>
@interface BaseViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation BaseViewController
//+ (UIViewController *)appRootViewController {
//    UIViewController *appRootVC = [(AppDelegate *)[UIApplication sharedApplication].delegate currentNav];
//    if ([appRootVC isKindOfClass:[UINavigationController class]]) {
//        UINavigationController *topVC = (UINavigationController *)appRootVC;
//        return topVC.topViewController;
//    } else {
//        UIViewController *topVC = appRootVC;
//        while (topVC.presentedViewController) {
//            topVC = topVC.presentedViewController;
//        }
//        return topVC;
//    }
//}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
//
//    // 设置导航控制器的代理为self
//    self.navigationController.delegate = self;
    //设置默认背景颜色
//    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavBar];
    
    [self makeConstraints];
    
    if (self.titleString) {
        self.titleLabel.text = self.titleString;
    }
    
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
    if(kDevice_Is_iPhoneX){
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kStatusBarHeight+20);
            make.width.mas_equalTo(screen_width);
            make.height.mas_equalTo(kNavHight - kStatusBarHeight - 20);
            make.centerX.equalTo(self.view);
        }];
    }
    else{
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kStatusBarHeight);
            make.width.mas_equalTo(screen_width);
            make.height.mas_equalTo(kNavHight - kStatusBarHeight);
            make.centerX.equalTo(self.view);
        }];
    }
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
        _titleLabel.textColor = RGBCOLOR(255, 255, 255);
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
//        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(kSizeFrom750(88 - 44) / 2, kSizeFrom750(88 - 44) / 2, kSizeFrom750(88 - 44) / 2, kSizeFrom750(88 - 44) / 2)];
//        [_backBtn setTitleEdgeInsets:UIEdgeInsetsMake(kSizeFrom750(88 - 30) / 2, 0, kSizeFrom750(88 - 30) / 2, 0)];
        
    }
    return _backBtn;
}
-(UIButton *)rightBtn
{
    if (!_rightBtn) {
        //右边按钮默认隐藏
        _rightBtn = InitObject(UIButton);
        [_rightBtn.titleLabel setFont:CHINESE_SYSTEM(kSizeFrom750(30))];
        [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(kSizeFrom750(88 - 44) / 2, kSizeFrom750(88 - 44) / 2, kSizeFrom750(88 - 44) / 2, kSizeFrom750(88 - 44) / 2)];
        [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(kSizeFrom750(88 - 30) / 2, 0, kSizeFrom750(88 - 30) / 2, 0)];
        [_rightBtn setHidden:YES];
        
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

-(void)backPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UINavigationControllerDelegate
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
        if (self.navigationController.viewControllers.count == 1) {
            [self setCustomTabBarHidden:NO];
        } else {
            [self setCustomTabBarHidden:YES];
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
- (void)setCustomTabBarHidden:(BOOL)hidden {
    self.tabBarController.tabBar.hidden = hidden;
    
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
