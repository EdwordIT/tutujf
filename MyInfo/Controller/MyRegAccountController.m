//
//  MyRegAccountController.m
//  TTJF
//
//  Created by wbzhan on 2018/6/7.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyRegAccountController.h"
#import "MyRegAccountModel.h"
#import "GradientButton.h"
@interface MyRegAccountController ()
Strong GradientButton *topView;//
Strong UILabel *titleL;//
Strong UILabel *amountTitle;//总金额
Strong UILabel *amountL;//
Strong UILabel *remainLabel;//可用余额
Strong UILabel *freezeLabel;//冻结金额
Strong UILabel *usernameLabel;//账号名
Strong MyRegAccountModel *baseModel;//
@end

@implementation MyRegAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"我的托管账户";
    
    [self getRequest];
    // Do any additional setup after loading the view.
}
-(void)getRequest
{
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getMyRegAccountUrl keysArray:@[kToken] valuesArray:@[[CommonUtils getToken]] refresh:nil success:^(NSDictionary *successDic) {
        self.baseModel = [MyRegAccountModel yy_modelWithJSON:successDic];
        [self loadSubViews];
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
-(void)loadSubViews{
    [self.view addSubview:self.topView];
    [self.topView setGradientColors:@[COLOR_DarkBlue,COLOR_LightBlue]];
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
        _topView = [[GradientButton alloc]initWithFrame:RECT(0, kNavHight, screen_width, kSizeFrom750(300))];
        _topView.userInteractionEnabled = NO;
    }
    return _topView;
}
-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, kOriginLeft, kContentWidth, kLabelHeight)];
        _titleL.textColor = COLOR_White;
        _titleL.font = SYSTEMSIZE(26);
        _titleL.text = [NSString stringWithFormat:@"%@：%@",self.baseModel.trust_account_info.trust_account_txt,self.baseModel.trust_account_info.trust_account];
    }
    return _titleL;
}
-(UILabel *)amountTitle{
    if (!_amountTitle) {
        _amountTitle = [[UILabel alloc]initWithFrame:RECT(self.titleL.left, self.titleL.bottom+kSizeFrom750(40), kContentWidth, kLabelHeight)];
        _amountTitle.textColor = COLOR_White;
        _amountTitle.font = SYSTEMSIZE(26);
        _amountTitle.textAlignment = NSTextAlignmentCenter;
        _amountTitle.text = self.baseModel.trust_account_info.balance_txt;
    }
    return _amountTitle;
}
-(UILabel *)amountL{
    if (!_amountL) {
        _amountL = [[UILabel alloc]initWithFrame:RECT(self.amountTitle.left, self.amountTitle.bottom+kSizeFrom750(20), kContentWidth, kSizeFrom750(50))];
        _amountL.textColor = COLOR_White;
        _amountL.textAlignment = NSTextAlignmentCenter;
        _amountL.font = NUMBER_FONT_BOLD(50);
        _amountL.text = [CommonUtils getHanleNums: self.baseModel.trust_account_info.balance];

    }
    return _amountL;
} 
//可用余额
-(UILabel *)remainLabel{
    if (!_remainLabel) {
        _remainLabel = [[UILabel alloc]initWithFrame:RECT(0, self.amountL.bottom+kSizeFrom750(40), screen_width/2, kLabelHeight)];
        _remainLabel.textColor = COLOR_White;
        _remainLabel.textAlignment = NSTextAlignmentCenter;
        _remainLabel.font = NUMBER_FONT(28);
        _remainLabel.text = [NSString stringWithFormat:@"%@%@",self.baseModel.trust_account_info.availableamount_txt,self.baseModel.trust_account_info.availableamount];

    }
    return _remainLabel;
}
//冻结金额
-(UILabel *)freezeLabel{
    if (!_freezeLabel) {
        _freezeLabel = [[UILabel alloc]initWithFrame:RECT(screen_width/2, self.remainLabel.top, screen_width/2, kLabelHeight)];
        _freezeLabel.textColor = COLOR_White;
        _freezeLabel.textAlignment = NSTextAlignmentCenter;
        _freezeLabel.font = NUMBER_FONT(28);
        _freezeLabel.text = [NSString stringWithFormat:@"%@%@",self.baseModel.trust_account_info.freezeamount_txt,self.baseModel.trust_account_info.freezeamount];
    }
    return _freezeLabel;
}
-(UILabel *)usernameLabel{
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc]initWithFrame:RECT(0, self.topView.bottom, screen_width, kSizeFrom750(60))];
        _usernameLabel.textColor = COLOR_White;
        _usernameLabel.backgroundColor =  RGB(237, 137, 52);
        _usernameLabel.textAlignment = NSTextAlignmentCenter;
        _usernameLabel.font = NUMBER_FONT(28);
        _usernameLabel.text = [NSString stringWithFormat:@"%@：%@",self.baseModel.trust_account_info.trust_usename_txt,self.baseModel.trust_account_info.trust_usename];

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
