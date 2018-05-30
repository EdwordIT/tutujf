//
//  TransferSellDetailController.m
//  TTJF
//
//  Created by wbzhan on 2018/5/30.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "TransferSellDetailController.h"
#import "GradientButton.h"
@interface TransferSellDetailController ()<UITextFieldDelegate>
Strong UIScrollView *backScroll;
Strong UITextField *percentageTextField;//转让折扣
Strong GradientButton *transferBtn;
Strong UILabel *transferLabel;//转让价格
Strong UILabel *remindLabel;//温馨提示
Strong UIButton *qBtn1;//
Strong UIButton *qBtn2;//
Strong UIButton *qBtn3;//
@end

@implementation TransferSellDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"债权详情";
    [self getRequest];
    // Do any additional setup after loading the view.
}
-(UIScrollView *)backScroll{
    if (!_backScroll) {
        _backScroll = [[UIScrollView alloc]initWithFrame:RECT(0, kNavHight, screen_width, kViewHeight)];
        _backScroll.bounces = YES;
        
    }
    return _backScroll;
}
-(void)getRequest
{
    NSArray *keys = @[@"tender_id",kToken];
    NSArray *values = @[self.tender_id,[CommonUtils getToken]];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:myTransferBuyDetailUrl keysArray:keys valuesArray:values refresh:nil success:^(NSDictionary *successDic) {
        
    } failure:^(NSDictionary *errorDic) {
        
    }];
    [self loadSubViews];
}
#pragma mark --lazyLoading
-(UIButton *)qBtn1{
    if (!_qBtn1) {
        _qBtn1 = InitObject(UIButton);
        [_qBtn1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _qBtn1.tag = 0;
    }
    return _qBtn1;
}
-(UIButton *)qBtn2{
    if (!_qBtn2) {
        _qBtn2 = InitObject(UIButton);
        [_qBtn2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _qBtn2.tag = 1;
    }
    return _qBtn2;
}
-(UIButton *)qBtn3{
    if (!_qBtn3) {
        _qBtn3 = InitObject(UIButton);
        [_qBtn3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _qBtn3.tag = 2;
    }
    return _qBtn3;
}
-(void)loadSubViews
{
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = COLOR_White;
    [self.backScroll addSubview:topView];

    UILabel *title = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, kSizeFrom750(35), kSizeFrom750(300), kSizeFrom750(40))];
    [topView addSubview:title];
    title.text = @"债权转让3月标的";
    title.font = SYSTEMSIZE(32);
    title.textColor = RGB_51;
    
    UIView *line = [[UIView alloc]initWithFrame:RECT(0, title.bottom +kSizeFrom750(25) - kLineHeight, screen_width, kLineHeight)];
    line.backgroundColor = separaterColor;
    [topView addSubview:line];
    
    CGFloat labelHeight = kSizeFrom750(60);
    for (int i=0; i<3; i++) {
        UILabel *titleL = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, line.bottom+labelHeight*i, kSizeFrom750(350), labelHeight)];
        titleL.textColor = RGB_153;
        titleL.font = SYSTEMSIZE(30);
        titleL.text = @"债权价值：";
        [topView addSubview:titleL];
        
        UILabel *contentL = [[UILabel alloc]initWithFrame:RECT(screen_width/2,titleL.top, screen_width/2 - kOriginLeft, titleL.height)];
        contentL.textColor = RGB_51;
        contentL.textAlignment = NSTextAlignmentRight;
        contentL.font = SYSTEMSIZE(28);
        contentL.text = @"100元";
        [topView addSubview:contentL];
        
        if (i==2) {
            topView.frame = RECT(0, 0, screen_width, contentL.bottom);
        }
    }
    
    UIView *middleView = [[UIView alloc]initWithFrame:RECT(0, topView.bottom+kLabelHeight, screen_width, labelHeight)];
    middleView.backgroundColor = COLOR_White;
    [self.backScroll addSubview:middleView];
    
    UILabel *transferTitle = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, 0, kSizeFrom750(350), labelHeight)];
    transferTitle.textColor = RGB_153;
    transferTitle.font = SYSTEMSIZE(30);
    transferTitle.text = @"转让折扣（元）：";
    [middleView addSubview:transferTitle];
    
    //转让折扣
    self.percentageTextField = [[UITextField alloc]initWithFrame:CGRectMake(transferTitle.right, transferTitle.top, screen_width - transferTitle.right - kOriginLeft, kSizeFrom750(50))];
     self.percentageTextField.centerY = transferTitle.centerY;
     self.percentageTextField.delegate = self;
     self.percentageTextField.keyboardType = UIKeyboardTypeNumberPad;//纯数字;
     self.percentageTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//内容垂直居中
     self.percentageTextField.placeholder = @"95% ~ 105%";
     self.percentageTextField.font =SYSTEMSIZE(26);
     self.percentageTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [ self.percentageTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [middleView addSubview: self.percentageTextField];
    
    self.transferLabel = [[UILabel alloc] init];
    self.transferLabel.font = SYSTEMSIZE(26);
    self.transferLabel.textColor =  RGB_166;
    NSString *expect = @"承接价格：￥0.0";
    NSMutableAttributedString *attr1 = [CommonUtils diffierentFontWithString:expect rang:[expect rangeOfString:@"￥0.0"] font:NUMBER_FONT(30) color:COLOR_DarkBlue spacingBeforeValue:0 lineSpace:0];
    [self.transferLabel setAttributedText:attr1];
    [self.backScroll addSubview:self.transferLabel];
    
    
    [self.transferLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.height.mas_equalTo(kSizeFrom750(40));
        make.top.mas_equalTo(middleView.mas_bottom).offset(kSizeFrom750(30));
    }];
    
    
    self.transferBtn = InitObject(GradientButton);
     self.transferBtn.frame = CGRectMake(kOriginLeft,self.transferLabel.bottom+kSizeFrom750(80), kContentWidth, kSizeFrom750(90));
    [ self.transferBtn setTitle:@"立即转让" forState:UIControlStateNormal];
     self.transferBtn.titleLabel.font = SYSTEMSIZE(32);
    [ self.transferBtn addTarget:self action:@selector(transferBtnClick:) forControlEvents:UIControlEventTouchUpInside];
     self.transferBtn.layer.cornerRadius =  self.transferBtn.height/2;
     self.transferBtn.layer.masksToBounds =YES;
    [ self.transferBtn setGradientColors:@[COLOR_DarkBlue,COLOR_LightBlue]];
    [ self.transferBtn setUntouchedColor:COLOR_Btn_Unsel];
     self.transferBtn.enabled = NO;
    [self.backScroll addSubview: self.transferBtn];
    
    self.remindLabel = [[UILabel alloc]init];
    self.remindLabel.font = SYSTEMSIZE(28);
    self.remindLabel.textColor = RGB_153;
    [self.backScroll addSubview:self.remindLabel];
    
    [self.backScroll addSubview:self.qBtn3];
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.top.mas_equalTo(self.transferBtn.mas_bottom).offset(kSizeFrom750(30));
        make.width.mas_equalTo(kContentWidth);
    }];
    
//    [self.qBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(kSizeFrom750(60));
//        make.centerY.mas_equalTo(self.amountTitle);
//        make.left.mas_equalTo(self.amountTitle.mas_right);
//    }];
//    [self.qBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(kSizeFrom750(60));
//        make.centerY.mas_equalTo(self.principalTitle);
//        make.left.mas_equalTo(self.principalTitle.mas_right);
//    }];
    [self.qBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kSizeFrom750(60));
        make.centerY.mas_equalTo(self.transferLabel);
        make.left.mas_equalTo(self.transferLabel.mas_right);
    }];
}
#pragma mark --textField Delegate
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSString *    str = [self.percentageTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(str.length >0)
    {
        if(![CommonUtils isNumber:str])
        {
             self.transferBtn.enabled = NO;
            
        }
        else  if([CommonUtils isNumber:str])
        {
            NSInteger num=[str intValue];
            if(num>=95&&num<=105)
            {
                 self.transferBtn.enabled = YES;
//                [self getInterest];
            }
            else
            {
                 self.transferBtn.enabled = NO;
            }
        }
        
    }
    else{
        
    }
}
-(BOOL)checkNum{
    NSString *    str = [self.percentageTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([CommonUtils isNumber:str]) {
            return YES;
    }
    return NO;
}
//转让按钮点击
-(void)transferBtnClick:(UIButton *)sender
{
    
}
-(void)buttonClick:(UIButton *)sender{
    
    
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
