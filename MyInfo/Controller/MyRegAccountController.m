//
//  MyRegAccountController.m
//  TTJF
//
//  Created by wbzhan on 2018/6/7.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyRegAccountController.h"

@interface MyRegAccountController ()
Strong UIView *topView;//
Strong UILabel *titleL;//
Strong UILabel *amountTitle;//总金额
Strong UILabel *amountL;//
Strong UILabel *remainLabel;//可用余额
Strong UILabel *freezeLabel;//冻结金额
Strong UILabel *usernameLabel;//账号名
@end

@implementation MyRegAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"我的托管账户";
    
    [self loadSubViews];
    // Do any additional setup after loading the view.
}
-(void)loadSubViews{
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.titleL];
    [self.topView addSubview:self.amountTitle];
    [self.topView addSubview: self.amountL];
    [self.topView addSubview:self.remainLabel];
    UIView *lineV = [[UIView alloc]initWithFrame:RECT(self.remainLabel.right, self.remainLabel.top, 1, self.remainLabel.height)];
    lineV.backgroundColor = COLOR_White;
    [self.topView addSubview:lineV];
    [self.topView addSubview:self.freezeLabel];
    [self.view addSubview:self.usernameLabel];
}
-(UIView *)topView{
    if(!_topView)
    {
        _topView = [[UIView alloc]initWithFrame:RECT(0, kNavHight, screen_width, kSizeFrom750(250))];
        _topView.backgroundColor = COLOR_DarkBlue;
    }
    return _topView;
}
-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, kOriginLeft, kContentWidth, kLabelHeight)];
        _titleL.textColor = COLOR_White;
        _titleL.font = SYSTEMSIZE(26);
    }
    return _titleL;
}
-(UILabel *)amountTitle{
    if (!_amountTitle) {
        _amountTitle = [[UILabel alloc]initWithFrame:RECT(self.titleL.left, self.titleLabel.bottom+kOriginLeft, kContentWidth, kLabelHeight)];
        _amountTitle.textColor = COLOR_White;
        _amountTitle.font = SYSTEMSIZE(26);
    }
    return _amountTitle;
}
-(UILabel *)amountL{
    if (!_amountL) {
        _amountL = [[UILabel alloc]initWithFrame:RECT(self.amountTitle.left, self.amountTitle.bottom+kSizeFrom750(20), kContentWidth, kSizeFrom750(40))];
        _amountL.textColor = COLOR_White;
        _amountL.font = NUMBER_FONT_BOLD(35);
    }
    return _amountL;
} 
//可用余额
-(UILabel *)remainLabel{
    if (!_remainLabel) {
        _remainLabel = [[UILabel alloc]initWithFrame:RECT(0, self.amountL.bottom+kSizeFrom750(50), screen_width/2, kLabelHeight)];
        _remainLabel.textColor = COLOR_White;
        _remainLabel.textAlignment = NSTextAlignmentCenter;
        _remainLabel.font = NUMBER_FONT_BOLD(35);
    }
    return _remainLabel;
}
//冻结金额
-(UILabel *)freezeLabel{
    if (!_freezeLabel) {
        _freezeLabel = [[UILabel alloc]initWithFrame:RECT(screen_width/2, self.remainLabel.top, screen_width/2, kLabelHeight)];
        _freezeLabel.textColor = COLOR_White;
        _freezeLabel.textAlignment = NSTextAlignmentCenter;
        _freezeLabel.font = NUMBER_FONT_BOLD(35);
    }
    return _freezeLabel;
}
-(UILabel *)usernameLabel{
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc]initWithFrame:RECT(0, self.topView.bottom, screen_width, kSizeFrom750(40))];
        _usernameLabel.textColor = COLOR_White;
        _usernameLabel.textAlignment = NSTextAlignmentCenter;
        _usernameLabel.font = NUMBER_FONT(28);
    }
    return _usernameLabel;
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
