//
//  MyRedEnvelopeController.m
//  TTJF
//
//  Created by wbzhan on 2018/5/16.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyRedEnvelopeController.h"
#import "MyRedEnvelopeCell.h"
#import "FDSlideBar.h"
#import "ScrollerContentView.h"
#import "RedEnvelopeContentController.h"
@interface MyRedEnvelopeController ()<ScrollerContentViewDataSource>
Strong FDSlideBar *slideBar;//滑动选择bar
Strong ScrollerContentView *contentView;//内容页面
Strong NSMutableArray *titleArr;//slideBar数据源
Assign NSInteger selectedIndex;//被选中状态
Strong UIView *headerView;
Strong UIButton *remindBtn;
Assign BOOL isused;
Assign BOOL isoverdued;
@end

@implementation MyRedEnvelopeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"红包列表";
    
    self.selectedIndex = 0;

    [self.view addSubview:self.slideBar];
    
    [self.view addSubview:self.headerView];
    
    [self.headerView addSubview:self.remindBtn];
    
    [self.view addSubview:self.contentView];
    
    // Do any additional setup after loading the view.
}
#pragma mark lazyLoading
#pragma mark -- 设置Slider
- (ScrollerContentView *)contentView {
    if (!_contentView) {
        
        _contentView = [[ScrollerContentView alloc] init];
        _contentView.frame = RECT(0, self.headerView.bottom, screen_width, screen_height - self.headerView.bottom);
        _contentView.dataSource = self;
        __weak typeof(self) weakSelf = self;
        [_contentView slideContentViewScrollFinished:^(NSUInteger index) {
            self.selectedIndex = index;
            [weakSelf.slideBar selectSlideBarItemAtIndex:index];
        }];
    }
    return _contentView;
}
- (FDSlideBar *)slideBar {
    if (!_slideBar) {
        __weak typeof(self) weakSelf = self;
        _slideBar = [[FDSlideBar alloc] initWithFrame:RECT(0, kNavHight, screen_width, kTitleHeight)];
        _slideBar.itemsTitle = @[@"未使用",@"已使用",@"已过期"];
        [_slideBar slideBarItemSelectedCallback:^(NSUInteger idx) {
            weakSelf.selectedIndex = idx;
            [weakSelf.contentView scrollSlideContentViewToIndex:idx];
           
        }];
    }
    return _slideBar;
}
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:RECT(0, self.slideBar.bottom, screen_width, kSizeFrom750(120))];
    }
    return _headerView;
    
}
-(UIButton *)remindBtn{
    if (!_remindBtn) {
        _remindBtn = [[UIButton alloc]initWithFrame:RECT(kSizeFrom750(30), kSizeFrom750(30), kSizeFrom750(690), kSizeFrom750(60))];
        [_remindBtn setImage:IMAGEBYENAME(@"remind_blue") forState:UIControlStateNormal];
        _remindBtn.userInteractionEnabled = NO;
        _remindBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_remindBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, kSizeFrom750(20), 0, 0)];
        [_remindBtn setImageEdgeInsets:UIEdgeInsetsMake(-kSizeFrom750(30), 0, 0, 0)];
        [_remindBtn setTitleColor:RGB_153 forState:UIControlStateNormal];
        [_remindBtn.titleLabel setFont:SYSTEMSIZE(25)];
        [_remindBtn setTitle:@"投资成功后红包进入待激活状态，平台审核通过后将发放到账号余额。" forState:UIControlStateNormal];
    }
    return _remindBtn;
}
#pragma mark -- ScrollerContentViewDataSource
- (UIViewController *)slideContentView:(ScrollerContentView *)contentView viewControllerForIndex:(NSUInteger)index {
    //显示内容的控制器
    RedEnvelopeContentController *contentVC = [[RedEnvelopeContentController alloc] init];
    contentVC.selectedIndex = index;
    WEAK_SELF;
    contentVC.remindBlock = ^(NSString *remindTxt) {
         [weakSelf.remindBtn setTitle:remindTxt forState:UIControlStateNormal];
    };
    return contentVC;
}

- (NSInteger)numOfContentView:(ScrollerContentView *)contentView {
   
    return 3;
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
