//
//  HomeTabBarController.m
//  CloudSoundPlus
//
//  Created by renxlin on 2017/4/21.
//  Copyright © 2017年 hzlh. All rights reserved.
//

#import "HomeTabBarController.h"
#import "MBTabbarView.h"
#import "MainViewController.h"
#import "UINavigationController+MBNavigation.h"
#import "ProgrameListController.h"
#import "FoundController.h"
#import "MineViewController.h"
@interface HomeTabBarController ()<MBTabbarDelegate>
{
    BOOL isLocation;
}
//自定义标签栏
@property (nonatomic, strong)MBTabbarView  *customTabBar;

@property (nonatomic, strong) NSMutableArray  *tabNavigations;
@property (nonatomic, strong) NSMutableArray  *tabImages;
@property (nonatomic, strong) NSMutableArray  *tabSelectedImages;
@end

@implementation HomeTabBarController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init {
    self = [super init];
    if (self) {
        self.tabNavigations = [NSMutableArray new];
        self.tabImages = [NSMutableArray new];
        self.tabSelectedImages = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isLocation = NO;
    // Do any additional setup after loading the view.
    
    // TODO:根据接口动态配置Tab项：
    NSArray *allNavs = [self allNavs];
    
    NSArray *allButtionSelectImageNames = @[@"xuanzhong", @"xuanzhong", @"xuanzhong", @"xuanzhong"];
    NSArray *allButtionImageNames = @[@"new", @"nian", @"kuai", @"le"];
    NSArray *allTitles = @[@"首页", @"项目", @"发现", @"我的"];
    
    NSMutableArray *loadNavs = [NSMutableArray new];
    NSMutableArray *loadButtionImages = [NSMutableArray new];
    NSMutableArray *loadButtionSelectImages = [NSMutableArray new];
    NSMutableArray *loadTitles = [NSMutableArray new];
    
    NSInteger selectedIndex = 0;

    NSDictionary *meunObject = [CommonUtils getCacheDataWithKey:@"appMenu"];
    if (meunObject!=nil) {
        
    } else {
        // 加载默认项：
        isLocation = YES;
        [loadNavs addObjectsFromArray:allNavs];
        [loadButtionImages addObjectsFromArray:allButtionImageNames];
        [loadButtionSelectImages addObjectsFromArray:allButtionSelectImageNames];
        [loadTitles addObjectsFromArray:allTitles];
    }
    

    [self setViewControllers:loadNavs];
    self.tabBar.hidden = YES;
    
    self.customTabBar = [[MBTabbarView alloc] init];
    self.customTabBar.tag = HomeTabBar_Tag;
    _customTabBar.backgroundColor = RGB(255, 45, 18);
    self.customTabBar.delegate = self;
    self.customTabBar.frame = CGRectMake(0, screen_height - kTabbarHeight, screen_width, kTabbarHeight);
    [self.customTabBar createTabBarWithBackgroundImage:nil buttonsImageName:loadButtionImages buttonsSelectImageName:loadButtionSelectImages buttonsTitle:loadTitles isLocation:isLocation];
    [self.view addSubview:self.customTabBar];
    self.selectedIndex = selectedIndex;
    [self.customTabBar setSelectedIndex:self.selectedIndex];
    
}

#pragma mark - getter&setter
-(UINavigationController *)getTabBarItem:(NSInteger)tag
{
    switch (tag) {
        case 1:
        {
            //首页(V1.0.0)版本
            return [self getMain];
        }
            break;
        case 2:
        {
            //项目
            return [self getPrograme];
        }
            break;
        case 3:
        {
            //发现
            return [self getDiscover];
        }
            break;
        case 4:
        {
            //我的
            return [self getMine];
        }

        default:
            return nil;
            break;
    }
}
- (NSArray *)allNavs {
    //首页
    UINavigationController *homeNav = [self getMain];
    //项目
    UINavigationController *programeNav = [self getPrograme];
    //商城
    UINavigationController *disNav = [self getDiscover];
    //我的
    UINavigationController *myNav = [self getMine];

    return @[homeNav, programeNav, disNav, myNav];

}

#pragma mark -- 对应的控制器创建
//首页
- (UINavigationController *)getMain{
    MainViewController *homeVC = [[MainViewController alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNav.navigationBarHidden = YES;
    homeNav.tag = @"1";
    return homeNav;
}

//项目
- (UINavigationController *)getPrograme {
    ProgrameListController *programe = InitObject(ProgrameListController);
    UINavigationController *programeNav = [[UINavigationController alloc] initWithRootViewController:programe];
    programeNav.tag = @"2";
    return programeNav;
}
//发现
-(UINavigationController *)getDiscover{
    FoundController *dis = InitObject(FoundController);
    UINavigationController *disNav = [[UINavigationController alloc] initWithRootViewController:dis];
    disNav.tag = @"3";
    return disNav;
}
//我的
-(UINavigationController *)getMine{
    MineViewController *mine = InitObject(MineViewController);
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mine];
    mineNav.tag = @"4";
    return mineNav;
}

#pragma mark - LinkerTabBarViewDelegate
- (void)didSelectedItem:(NSInteger)index {
    //  点击一级菜单是更新我的消息，提示信息
    self.selectedIndex = index;
}
//动态隐藏底部标签栏
- (void)setCustomTabBarHidden:(BOOL)hidden{
    
    if (hidden==YES&&self.customTabBar.hidden==YES) {
        return;
    }
    if (hidden==NO&&self.customTabBar.hidden==NO) {
        return;
    }
    if (!hidden) {
        self.customTabBar.hidden=NO;
    }
    [UIView animateWithDuration:0.3 animations:^{
        if (hidden) {
            self.customTabBar.frame = RECT(0, screen_height, screen_width, kTabbarHeight);
        }else{
            self.customTabBar.frame = RECT(0, screen_height-kTabbarHeight, screen_width, kTabbarHeight);
        }
    } completion:^(BOOL finished) {
        [self.customTabBar setHidden:hidden];
    }];
}

#pragma mark - Private Mehtoes
// 设置给定类型的配置项是否显示新消息更新（即红点是否显示）
- (void)setNewMessage:(NSInteger)navType isHaveNew:(BOOL)haveNewMessage {
    NSArray *arr = [self allNavs];
    if (navType >= arr.count) {
        return;
    }
    
    for (UINavigationController *nav in self.viewControllers) {
        if ([nav.tag integerValue]== navType) {

            NSInteger index = [self.viewControllers indexOfObject:nav];
            [self.customTabBar setRedPointAtIndex:index isShow:haveNewMessage];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end







