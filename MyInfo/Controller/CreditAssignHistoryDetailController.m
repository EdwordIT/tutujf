//
//  CreditAssignHistoryDetailController.m
//  TTJF
//
//  Created by wbzhan on 2018/5/16.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "CreditAssignHistoryDetailController.h"

@interface CreditAssignHistoryDetailController ()
Strong UIScrollView *backScroll;
@end

@implementation CreditAssignHistoryDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"购买详情";
    [self.view addSubview:self.backScroll];
    
    [self getRequest];
    // Do any additional setup after loading the view.
}
-(UIScrollView *)backScroll{
    if (!_backScroll) {
        _backScroll = [[UIScrollView alloc]initWithFrame:RECT(0, kNavHight, screen_width, kViewHeight)];
        
    }
    return _backScroll;
}
-(void)getRequest
{
    [self loadSubViews];
}
-(void)loadSubViews
{
    UIView *topView = [[UIView alloc]initWithFrame:RECT(0, 0, screen_width, kOriginLeft)];
    topView.backgroundColor = COLOR_White;
    [self.backScroll addSubview:topView];
    
    
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
