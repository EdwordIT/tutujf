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

Assign BOOL isused;
Assign BOOL isoverdued;
@end

@implementation MyRedEnvelopeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"红包列表";
    
    self.selectedIndex = 0;

    [self.view addSubview:self.slideBar];
    
    [self.view addSubview:self.contentView];
    
    // Do any additional setup after loading the view.
}
#pragma mark lazyLoading
#pragma mark -- 设置Slider
- (ScrollerContentView *)contentView {
    if (!_contentView) {
        
        _contentView = [[ScrollerContentView alloc] init];
        _contentView.frame = RECT(0, self.slideBar.bottom, screen_width, screen_height - self.slideBar.bottom);
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

#pragma mark -- ScrollerContentViewDataSource
- (UIViewController *)slideContentView:(ScrollerContentView *)contentView viewControllerForIndex:(NSUInteger)index {
    //显示内容的控制器
    RedEnvelopeContentController *contentVC = [[RedEnvelopeContentController alloc] init];
    contentVC.selectedIndex = index;
    
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
