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
        _backScroll.bounces = YES;
        
    }
    return _backScroll;
}
-(void)getRequest
{
    [self loadSubViews];
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
    
    UILabel *stateLabel = [[UILabel alloc]initWithFrame:RECT(screen_width - kSizeFrom750(300), title.top, kSizeFrom750(270), title.height)];
    stateLabel.textAlignment = NSTextAlignmentRight;
    stateLabel.textColor = COLOR_DarkBlue;
    stateLabel.text = @"已回收";
    stateLabel.font = SYSTEMSIZE(28);
    [topView addSubview:stateLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:RECT(0, title.bottom +kSizeFrom750(25) - kLineHeight, screen_width, kLineHeight)];
    line.backgroundColor = separaterColor;
    [topView addSubview:line];
    
    CGFloat labelHeight = kSizeFrom750(80);
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
    
    UIView *middleView = [[UIView alloc]initWithFrame:RECT(0, topView.bottom+kLabelHeight, screen_width, labelHeight*2)];
    middleView.backgroundColor = COLOR_White;
    [self.backScroll addSubview:middleView];
    
    UILabel *transferTitle = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, 0, kSizeFrom750(350), labelHeight)];
    transferTitle.textColor = RGB_153;
    transferTitle.font = SYSTEMSIZE(30);
    transferTitle.text = @"转让价格（元）：";
    [middleView addSubview:transferTitle];
    
    UILabel *transferContent = [[UILabel alloc]initWithFrame:RECT(screen_width/2, transferTitle.top, screen_width/2 - kOriginLeft, transferTitle.height)];
    transferContent.textColor = RGB_51;
    transferContent.textAlignment = NSTextAlignmentRight;
    transferContent.font = SYSTEMSIZE(28);
    transferContent.text = @"100元";
    [middleView addSubview:transferContent];
    
    UILabel *incomeTitle = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, transferTitle.bottom, kSizeFrom750(350), labelHeight)];
    incomeTitle.textColor = RGB_153;
    incomeTitle.font = SYSTEMSIZE(30);
    incomeTitle.text = @"预计盈利（元）：";
    [middleView addSubview:incomeTitle];
    
    UILabel *incomeContent = [[UILabel alloc]initWithFrame:RECT(screen_width/2, incomeTitle.top, screen_width/2 - kOriginLeft, incomeTitle.height)];
    incomeContent.textColor = RGB_51;
    incomeContent.textAlignment = NSTextAlignmentRight;
    incomeContent.font = SYSTEMSIZE(28);
    incomeContent.text = @"100";
    [middleView addSubview:incomeContent];
    
    UIButton *agreementBtn = [[UIButton alloc]initWithFrame:RECT(screen_width - kSizeFrom750(280), middleView.bottom+kSizeFrom750(20), kSizeFrom750(270), kSizeFrom750(40))];
    agreementBtn.adjustsImageWhenHighlighted = NO;
    NSString *agreeStr = @"查看《债权转让协议》";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:agreeStr];
    [attr addAttributes:@{NSFontAttributeName:SYSTEMSIZE(26),NSForegroundColorAttributeName:RGB_166} range:NSMakeRange(0, agreeStr.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:COLOR_DarkBlue range:[agreeStr rangeOfString:@"《债权转让协议》"]];
    [agreementBtn setAttributedTitle:attr forState:UIControlStateNormal];
    [agreementBtn addTarget:self action:@selector(agreementBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backScroll addSubview:agreementBtn];
    
    UIView *bottomView = InitObject(UIView);
    bottomView.backgroundColor = COLOR_White;
    [self.backScroll addSubview:bottomView];
    
    UILabel *subTitle = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, kSizeFrom750(35), kSizeFrom750(300), kSizeFrom750(40))];
    [bottomView addSubview:subTitle];
    subTitle.text = @"还款信息";
    subTitle.font = SYSTEMSIZE(32);
    subTitle.textColor = RGB_51;
    
    UILabel *subContent = [[UILabel alloc]initWithFrame:RECT(screen_width - kSizeFrom750(300), title.top, kSizeFrom750(270), title.height)];
    subContent.textAlignment = NSTextAlignmentRight;
    subContent.textColor = RGB_153;
    subContent.text = @"第1/1期";
    subContent.font = SYSTEMSIZE(28);
    [bottomView addSubview:subContent];
    
    UIView *line1 = [[UIView alloc]initWithFrame:RECT(0, subTitle.bottom +kSizeFrom750(25)-kLineHeight, screen_width, kLineHeight)];
    line1.backgroundColor = separaterColor;
    [bottomView addSubview:line1];
    
    
    for (int i=0; i<5; i++) {
        UILabel *titleL = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, line1.bottom+labelHeight*i, kSizeFrom750(350), labelHeight)];
        titleL.textColor = RGB_153;
        titleL.font = SYSTEMSIZE(30);
        titleL.text = @"还款情况：";
        [bottomView addSubview:titleL];
        
        UILabel *contentL = [[UILabel alloc]initWithFrame:RECT(screen_width/2,titleL.top, screen_width/2 - kOriginLeft, titleL.height)];
        contentL.textColor = RGB_51;
        contentL.textAlignment = NSTextAlignmentRight;
        contentL.font = SYSTEMSIZE(28);
        contentL.text = @"未还款";
        [bottomView addSubview:contentL];
        
        if (i==4) {
            bottomView.frame = RECT(0, agreementBtn.bottom+kSizeFrom750(20), screen_width, contentL.bottom);
            self.backScroll.contentSize = CGSizeMake(screen_width, bottomView.bottom);
        }
    }
    
}
-(void)agreementBtnClick:(UIButton *)sender
{
    
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
