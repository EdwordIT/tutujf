//
//  TransferSellDetailController.m
//  TTJF
//
//  Created by wbzhan on 2018/5/30.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "TransferSellDetailController.h"
#import "GradientButton.h"
#import "MyTransferDetailModel.h"
@interface TransferSellDetailController ()<UITextFieldDelegate>
Strong UIScrollView *backScroll;
Strong UITextField *percentageTextField;//转让折扣
Strong GradientButton *transferBtn;
Strong UILabel *transferLabel;//转让价格
Strong UILabel *remindLabel;//温馨提示
Strong MyTransferDetailModel *model;
Strong UIButton *qBtn3;
@end

@implementation TransferSellDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"债权详情";
    [self.view addSubview:self.backScroll];
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
    [[HttpCommunication sharedInstance] postSignRequestWithPath:myTransferInfoUrl keysArray:keys valuesArray:values refresh:nil success:^(NSDictionary *successDic) {
        
        self.model = [MyTransferDetailModel yy_modelWithJSON:successDic];
        
        [self loadSubViews];
        
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
#pragma mark --lazyLoading

-(UIButton *)qBtn3{
    if (!_qBtn3) {
        _qBtn3 = InitObject(UIButton);
        [_qBtn3 setImage:IMAGEBYENAME(@"transfer_record_question") forState:UIControlStateNormal];
        _qBtn3.adjustsImageWhenHighlighted = NO;
        [_qBtn3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _qBtn3.tag = 5;
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
    title.text = self.model.loan_name;
    title.font = SYSTEMSIZE(32);
    title.textColor = RGB_51;
    
    UIView *line = [[UIView alloc]initWithFrame:RECT(0, title.bottom +kSizeFrom750(25) - kLineHeight, screen_width, kLineHeight)];
    line.backgroundColor = separaterColor;
    [topView addSubview:line];
    
    CGFloat labelHeight = kSizeFrom750(80);
    for (int i=0; i<self.model.transfer.count; i++) {
        ContentInfoModel *infoModel = [self.model.transfer objectAtIndex:i];
        UILabel *titleL = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, line.bottom+labelHeight*i, kSizeFrom750(150), labelHeight)];
        titleL.textColor = RGB_153;
        titleL.font = SYSTEMSIZE(30);
        titleL.text = infoModel.title;
        [topView addSubview:titleL];
        
        UILabel *contentL = [[UILabel alloc]init];
        contentL.textColor = RGB_51;
        contentL.font = SYSTEMSIZE(28);
        contentL.text = infoModel.content;
        [topView addSubview:contentL];
        
        [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleL.mas_right);
            make.height.centerY.mas_equalTo(titleL);
        }];
        
        if (!IsEmptyStr(infoModel.notes)) {
            UIButton *qbtn = [[UIButton alloc]init];
            [qbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            qbtn.tag = i;
            [qbtn setImage:IMAGEBYENAME(@"transfer_record_question") forState:UIControlStateNormal];
            qbtn.adjustsImageWhenHighlighted = NO;
            [topView addSubview:qbtn];
            [qbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(kSizeFrom750(60));
                make.centerY.mas_equalTo(contentL);
                make.left.mas_equalTo(contentL.mas_right);
            }];
        }
       
        if (i==self.model.transfer.count-1) {
            [topView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(screen_width);
                make.left.top.mas_equalTo(0);
                make.bottom.mas_equalTo(contentL.mas_bottom);
            }];

        }
    }
    
    UIView *middleView = [[UIView alloc]init];
    middleView.backgroundColor = COLOR_White;
    [self.backScroll addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(topView.mas_bottom).offset(kOriginLeft);
        make.width.mas_equalTo(screen_width);
        make.height.mas_equalTo(labelHeight);
    }];
    
    UILabel *transferTitle = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, 0, kSizeFrom750(150), labelHeight)];
    transferTitle.textColor = RGB_153;
    transferTitle.font = SYSTEMSIZE(28);
    transferTitle.text = self.model.coefficient_config.title;
    [middleView addSubview:transferTitle];
    
    //转让折扣
    self.percentageTextField = [[UITextField alloc]initWithFrame:CGRectMake(transferTitle.right, transferTitle.top, screen_width - transferTitle.right - kOriginLeft, kSizeFrom750(50))];
     self.percentageTextField.centerY = transferTitle.centerY;
     self.percentageTextField.delegate = self;
     self.percentageTextField.keyboardType = UIKeyboardTypeNumberPad;//纯数字;
     self.percentageTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//内容垂直居中
     self.percentageTextField.placeholder =[NSString stringWithFormat:@"%@%@ ~ %@%@",self.model.coefficient_config.coefficient_min,@"%",self.model.coefficient_config.coefficient_max,@"%"];
     self.percentageTextField.font =NUMBER_FONT(30);
     self.percentageTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [ self.percentageTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [middleView addSubview: self.percentageTextField];
    
    self.transferLabel = [[UILabel alloc] init];
    self.transferLabel.font = SYSTEMSIZE(26);
    self.transferLabel.textColor =  RGB_166;
    NSString *expect = [NSString stringWithFormat:@"%@ ￥0.0",self.model.transfer_amount.title];
    NSMutableAttributedString *attr1 = [CommonUtils diffierentFontWithString:expect rang:[expect rangeOfString:@"￥0.0"] font:NUMBER_FONT(30) color:COLOR_DarkBlue spacingBeforeValue:0 lineSpace:0];
    [self.transferLabel setAttributedText:attr1];
    [self.backScroll addSubview:self.transferLabel];
    
    
    [self.transferLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.height.mas_equalTo(kSizeFrom750(40));
        make.top.mas_equalTo(middleView.mas_bottom).offset(kSizeFrom750(30));
    }];
    
    
    self.transferBtn = InitObject(GradientButton);
    [ self.transferBtn setTitle:self.model.bt_name forState:UIControlStateNormal];
     self.transferBtn.titleLabel.font = SYSTEMSIZE(32);
    [ self.transferBtn addTarget:self action:@selector(transferBtnClick:) forControlEvents:UIControlEventTouchUpInside];
     self.transferBtn.layer.cornerRadius =  self.transferBtn.height/2;
     self.transferBtn.layer.masksToBounds =YES;
    [ self.transferBtn setGradientColors:@[COLOR_DarkBlue,COLOR_LightBlue]];
    [ self.transferBtn setUntouchedColor:COLOR_Btn_Unsel];
     self.transferBtn.enabled = NO;
    [self.backScroll addSubview: self.transferBtn];
    
    [self.transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kContentWidth);
        make.height.mas_equalTo(kSizeFrom750(90));
        make.left.mas_equalTo(kOriginLeft);
        make.top.mas_equalTo(self.transferLabel.mas_bottom).offset(labelHeight);
    }];
    
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
    
  
    [self.qBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kSizeFrom750(60));
        make.centerY.mas_equalTo(self.transferLabel);
        make.left.mas_equalTo(self.transferLabel.mas_right);
    }];
}
#pragma mark --textField Delegate
-(void)textFieldDidChange :(UITextField *)theTextField{
    if ([self.model.bt_state isEqualToString:@"-1"]) {//不可操作
        return;
    }
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
            if(num>=[self.model.coefficient_config.coefficient_min floatValue]&&num<=[self.model.coefficient_config.coefficient_max floatValue])
            {
                NSString *expect = [NSString stringWithFormat:@"￥%.2f",[self.model.transfer_amount.content floatValue]*0.01*num];
                NSString *expectText = [NSString stringWithFormat:@"%@ %@",self.model.transfer_amount.title,expect];
                NSMutableAttributedString *attr1 = [CommonUtils diffierentFontWithString:expectText rang:[expectText rangeOfString:expect] font:NUMBER_FONT(30) color:COLOR_DarkBlue spacingBeforeValue:0 lineSpace:0];
                [self.transferLabel setAttributedText:attr1];
                 self.transferBtn.enabled = YES;
            }
            else
            {
                 self.transferBtn.enabled = NO;
                NSString *expect = [NSString stringWithFormat:@"%@ ￥0.0",self.model.transfer_amount.title];
                NSMutableAttributedString *attr1 = [CommonUtils diffierentFontWithString:expect rang:[expect rangeOfString:@"￥0.0"] font:NUMBER_FONT(30) color:COLOR_DarkBlue spacingBeforeValue:0 lineSpace:0];
                [self.transferLabel setAttributedText:attr1];
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
    if (sender.tag==5) {
        [CommonUtils showAlerWithTitle:@"温馨提示" withMsg:self.model.transfer_amount.notes];

    }else{
    ContentInfoModel *infoModel = [self.model.transfer objectAtIndex:sender.tag];
    [CommonUtils showAlerWithTitle:@"温馨提示" withMsg:infoModel.notes];
    }
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
