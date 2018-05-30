//
//  CreditAssignController.m
//  TTJF
//
//  Created by wbzhan on 2018/5/16.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "TransferListController.h"
#import "NavSwitchView.h"
#import "CreditAssignHistoryDetailController.h"
#import "FDSlideBar.h"
#import "ScrollerContentView.h"
#import "MyTransferController.h"

@interface TransferListController ()<ScrollerContentViewDataSource>

Strong ScrollerContentView *transferContentView;//转让记录
Strong ScrollerContentView *buyContentView;//购买记录
Assign NSInteger selectedIndex;//被选中状态
Assign BOOL isBuy;//购买记录
Strong NavSwitchView *switchView;//标题切换
Strong FDSlideBar *slideBar;//滑动选择bar
Strong NSMutableArray *titleArr;//slideBar数据源
@end

@implementation TransferListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedIndex = 0;
    [self.view addSubview:self.switchView];
    [self.switchView addSubview:self.backBtn];
    [self.backBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSizeFrom750(20));
        make.width.mas_equalTo(kSizeFrom750(50));
        make.height.mas_equalTo(kSizeFrom750(88));
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.view addSubview:self.slideBar];
    [self.view addSubview:self.transferContentView];
    [self.view addSubview:self.buyContentView];

//    [SVProgressHUD show];
    
//    [self loadRequestAtIndex:0];
    
    // Do any additional setup after loading the view.
}
#pragma mark lazyLoading
-(NavSwitchView *)switchView{
    if (!_switchView) {
        _switchView = [[NavSwitchView alloc]initWithFrame:RECT(0, 0, screen_width, kNavHight) Array:@[@"债权转让",@"债权购买"]];
        WEAK_SELF;
        _switchView.switchBlock = ^(NSInteger tag) {
            if (tag==0) {
                    weakSelf.slideBar.itemsTitle = @[@"全部",@"可转让",@"转让中",@"已转让"];
                    weakSelf.isBuy = NO;
                    weakSelf.transferContentView.hidden = NO;
                    weakSelf.buyContentView.hidden = YES;

                   
            }else{
                 weakSelf.slideBar.itemsTitle =@[@"全部",@"回款中",@"已回款"];
                weakSelf.isBuy = YES;
                weakSelf.transferContentView.hidden = YES;
                weakSelf.buyContentView.hidden = NO;
            }
        };
    }
    return _switchView;
}
#pragma mark -- 设置Slider
- (ScrollerContentView *)transferContentView {
    if (!_transferContentView) {
        
        _transferContentView = [[ScrollerContentView alloc] init];
        _transferContentView.frame = RECT(0, self.slideBar.bottom, screen_width, screen_height - self.slideBar.bottom);
        _transferContentView.dataSource = self;
        __weak typeof(self) weakSelf = self;
        [_transferContentView slideContentViewScrollFinished:^(NSUInteger index) {
            [weakSelf.slideBar selectSlideBarItemAtIndex:index];
        }];
    }
    return _transferContentView;
}
- (ScrollerContentView *)buyContentView {
    if (!_buyContentView) {
        
        _buyContentView = [[ScrollerContentView alloc] init];
        _buyContentView.frame = RECT(0, self.slideBar.bottom, screen_width, screen_height - self.slideBar.bottom);
        _buyContentView.dataSource = self;
        _buyContentView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        [_buyContentView slideContentViewScrollFinished:^(NSUInteger index) {
            [weakSelf.slideBar selectSlideBarItemAtIndex:index];
        }];
    }
    return _buyContentView;
}
- (FDSlideBar *)slideBar {
    if (!_slideBar) {
        __weak typeof(self) weakSelf = self;
        _slideBar = [[FDSlideBar alloc] initWithFrame:RECT(0, kNavHight, screen_width, kTitleHeight)];
        _slideBar.itemsTitle = @[@"全部",@"可转让",@"转让中",@"已转让"];
        [_slideBar slideBarItemSelectedCallback:^(NSUInteger idx) {
            if (weakSelf.isBuy) {
                 [weakSelf.buyContentView scrollSlideContentViewToIndex:idx];
            }else
                [weakSelf.transferContentView scrollSlideContentViewToIndex:idx];
        }];
    }
    return _slideBar;
}

#pragma mark -- ScrollerContentViewDataSource
- (UIViewController *)slideContentView:(ScrollerContentView *)contentView viewControllerForIndex:(NSUInteger)index {
    //显示内容的控制器
    MyTransferController *contentVC = [[MyTransferController alloc] init];
    contentVC.selectedIndex = self.selectedIndex;
    contentVC.isBuy = self.isBuy;
    return contentVC;
}

- (NSInteger)numOfContentView:(ScrollerContentView *)contentView {
    return self.slideBar.itemsTitle.count;
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
