//
//  DetailTop.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DetailTop.h"
#import "OneDetailModel.h"
#import "CustomProgressView.h"
@interface DetailTop ()
{
    NSTimer * myTimer;
}
Strong CustomProgressView *progressView;//进度条
Strong UILabel * rateLabel;//年化收益
Strong UILabel *lab2;
Strong UILabel *programLimitLabel;//项目期限
Strong UILabel *programTotalLabel;//项目总额
Strong UILabel *programRemainLabel;//剩余可投金额
Strong UILabel *progressLabel;//进度
Assign CGFloat progressNum;//进度
Strong UILabel *investLabel;//投资人
Strong UIView *progressTopView;//progressView覆盖层
Strong UILabel *lab3;//项目总额
Strong UIButton *questionBtn;//问题弹框
Strong UIButton *priceQuestionBtn;//承接价格弹框
Strong LoanBase *baseModel;
@end

@implementation DetailTop

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)questionBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
            {
                //债权价值
                [CommonUtils showAlerWithTitle:@"温馨提示" withMsg:self.baseModel.transfer_ret.amount_money_notes];

            }
            break;
        case 2:
        {
            //承接价格
            [CommonUtils showAlerWithTitle:@"温馨提示" withMsg:self.baseModel.transfer_ret.actual_amount_notes];

        }
            break;
            
        default:
            break;
    }
}
//债权转让内容
-(void)loadCreditInfoWithModel:(LoanBase *)infoModel{
    self.baseModel = infoModel;
    self.lab3.text=@"债权价值";
    self.lab2.text = infoModel.transfer_ret.expire_date_txt;
    //利率
    NSString *rate = [infoModel.loan_info.apr stringByAppendingString:@"%"];
    NSMutableAttributedString *attr = [CommonUtils diffierentFontWithString:rate  rang:NSMakeRange(rate.length-1, 1) font:NUMBER_FONT(28) color:COLOR_White spacingBeforeValue:0 lineSpace:0];
    [self.rateLabel setAttributedText:attr];
    //债权价值
    NSString *totalAmout = [NSString stringWithFormat:@"%@ 元",[CommonUtils getHanleNums:infoModel.transfer_ret.amount_money]];
    NSMutableAttributedString *attr1 = [CommonUtils diffierentFontWithString:totalAmout  rang:NSMakeRange(totalAmout.length-1, 1) font:SYSTEMSIZE(30) color:RGB(141,200,255) spacingBeforeValue:0 lineSpace:0];
    [self.programTotalLabel setAttributedText:attr1];
    //剩余期限
    if ([infoModel.transfer_ret.expire_date isEqualToString:@"-"]||IsEmptyStr(infoModel.transfer_ret.expire_date)) {
        self.programLimitLabel.text = infoModel.transfer_ret.expire_date;
    }else{
        NSString *attr = [NSString stringWithFormat:@"%@ 天",infoModel.transfer_ret.expire_date];
        [self.programLimitLabel setAttributedText:[CommonUtils diffierentFontWithString:attr rang:[attr rangeOfString:@"天"] font:SYSTEMSIZE(28) color:RGB(141,200,255) spacingBeforeValue:0 lineSpace:0]];
    }
    //承接价格
    NSString *remain = [NSString stringWithFormat:@"承接价格 %@ 元",[CommonUtils getHanleNums:infoModel.transfer_ret.actual_amount]];
    NSMutableAttributedString *attr2 = [CommonUtils diffierentFontWithString:remain  rang:[remain rangeOfString:[CommonUtils getHanleNums:infoModel.transfer_ret.actual_amount]] font:NUMBER_FONT(28) color:COLOR_White spacingBeforeValue:0 lineSpace:0];
    [self.programRemainLabel setAttributedText:attr2];
    
    self.investLabel.hidden = NO;
    self.questionBtn.hidden = NO;
    self.priceQuestionBtn.hidden = NO;
    self.progressLabel.hidden = YES;
    
//    NSString *period = [NSString stringWithFormat:@"转让期数：%@ 期",infoModel.transfer_ret.period];
//    NSString *totalPeriod = [NSString stringWithFormat:@"/共 %@ 期",infoModel.transfer_ret.total_period];
//    NSMutableAttributedString *attr3 = [CommonUtils diffierentFontWithString:period  rang:[period rangeOfString:infoModel.transfer_ret.period] font:NUMBER_FONT(28) color:COLOR_White spacingBeforeValue:0 lineSpace:0];
//    NSMutableAttributedString *attr4 = [CommonUtils diffierentFontWithString:totalPeriod  rang:[totalPeriod rangeOfString:infoModel.transfer_ret.total_period] font:NUMBER_FONT(28) color:COLOR_White spacingBeforeValue:0 lineSpace:0];
//    [attr3 appendAttributedString:attr4];
//    [self.investLabel setAttributedText:attr3];
//
}
-(void)loadInfoWithModel:(LoanInfo *)infoModel{
    //利率
    NSString *rate = [infoModel.apr stringByAppendingString:@"%"];
   NSMutableAttributedString *attr = [CommonUtils diffierentFontWithString:rate  rang:NSMakeRange(rate.length-1, 1) font:NUMBER_FONT(28) color:COLOR_White spacingBeforeValue:0 lineSpace:0];
    [self.rateLabel setAttributedText:attr];
    //总额
    NSString *totalAmout = [NSString stringWithFormat:@"%@元",[CommonUtils getHanleNums:infoModel.amount]];
    NSMutableAttributedString *attr1 = [CommonUtils diffierentFontWithString:totalAmout  rang:NSMakeRange(totalAmout.length-1, 1) font:SYSTEMSIZE(30) color:RGB(141,200,255) spacingBeforeValue:0 lineSpace:0];
    [self.programTotalLabel setAttributedText:attr1];
    //项目期限
    self.programLimitLabel.text=infoModel.period_name;
    
    self.progressNum=[[NSString stringWithFormat:@"%.4f",[infoModel.progress floatValue]/100] floatValue];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.005
                                               target:self
                                             selector:@selector(download)
                                             userInfo:nil
                                              repeats:YES];
    
    //剩余可投资金额
    NSString *remain = [NSString stringWithFormat:@"剩余可投 %@ 元",[CommonUtils getHanleNums:infoModel.left_amount]];
    NSMutableAttributedString *attr2 = [CommonUtils diffierentFontWithString:remain  rang:[remain rangeOfString:[CommonUtils getHanleNums:infoModel.left_amount]] font:NUMBER_FONT(28) color:COLOR_White spacingBeforeValue:0 lineSpace:0];
    [self.programRemainLabel setAttributedText:attr2];
    
//    //投资人数
//    NSString *invest = [NSString stringWithFormat:@"已经有%@位投资人",infoModel.tender_count];
//    NSMutableAttributedString *attr3 = [CommonUtils diffierentFontWithString:invest  rang:[invest rangeOfString:infoModel.tender_count] font:NUMBER_FONT(28) color:COLOR_White spacingBeforeValue:0 lineSpace:0];
//    [self.investLabel setAttributedText:attr3];


     
}

-(void)initSubView
{
    UIView * uv=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kSizeFrom750(220))];
    uv.backgroundColor= navigationBarColor;
    [self addSubview:uv];

    self.rateLabel= [[UILabel alloc] initWithFrame:CGRectMake(kSizeFrom750(100), kSizeFrom750(45),kSizeFrom750(280),kSizeFrom750(60))];
    self.rateLabel.font = NUMBER_FONT_BOLD(52);
    self.rateLabel.textColor = COLOR_White;
    [uv addSubview:self.rateLabel];
    
    UIView * line=[[UIView alloc] initWithFrame:CGRectMake(screen_width/2-kSizeFrom750(80), kSizeFrom750(60), kLineHeight, kSizeFrom750(100))];
    line.backgroundColor=RGB(141,200,255);
    [uv addSubview:line];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(self.rateLabel.left, self.rateLabel.bottom+kSizeFrom750(10),self.rateLabel.width, kSizeFrom750(30))];
    lab1.font = SYSTEMSIZE(28);
    lab1.textColor=RGB(141,200,255);
    lab1.text=@"预期利率";
    [uv addSubview:lab1];
    
    self.lab2 = [[UILabel alloc] initWithFrame:CGRectMake(line.right+kSizeFrom750(30), line.top+kSizeFrom750(10),kSizeFrom750(120), kSizeFrom750(30))];
    self.lab2.font = SYSTEMSIZE(28);
    self.lab2.textColor=RGB(141,200,255);
    self.lab2.text=@"项目期限";
    [uv addSubview:self.lab2];
    
    self.programLimitLabel = [[UILabel alloc] init];
    self.programLimitLabel.font = NUMBER_FONT(30);
    self.programLimitLabel.textColor=COLOR_White;
    [uv addSubview:self.programLimitLabel];
    [self.programLimitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lab2.mas_right).offset(kSizeFrom750(10));
        make.centerY.height.mas_equalTo(self.lab2);
    }];
    
    self.lab3 = [[UILabel alloc] initWithFrame:CGRectMake(self.lab2.left, self.lab2.bottom+kSizeFrom750(20),self.lab2.width, self.lab2.height)];
    self.lab3.font = SYSTEMSIZE(28);
    self.lab3.textAlignment=NSTextAlignmentLeft;
    self.lab3.textColor=RGB(141,200,255);
    self.lab3.text=@"项目总额";
    [uv addSubview:self.lab3];
    
    self.programTotalLabel = [[UILabel alloc] init];
    self.programTotalLabel.font = SYSTEMSIZE(28);
    self.programTotalLabel.textColor=RGB(255,255,255);
    
    [uv addSubview:self.programTotalLabel];
    
    [self.programTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.programLimitLabel.mas_left);
        make.top.mas_equalTo(self.lab3.mas_top);
        make.height.mas_equalTo(self.programLimitLabel.mas_height);
    }];
    
    
    self.questionBtn = [[UIButton alloc]init];
    [self.questionBtn setImage:IMAGEBYENAME(@"icons_question") forState:UIControlStateNormal];
    [self.questionBtn setHidden:YES];
    self.questionBtn.tag = 1;
    [self.questionBtn addTarget:self action:@selector(questionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [uv addSubview:self.questionBtn];
    
    [self.questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.programTotalLabel.mas_centerY);
        make.left.mas_equalTo(self.programTotalLabel.mas_right);
        make.width.height.mas_equalTo(kSizeFrom750(60));
    }];
    
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, uv.height - kSizeFrom750(45),kSizeFrom750(150), kSizeFrom750(25))];
    self.progressLabel.font = NUMBER_FONT(24);
    self.progressLabel.textColor=RGB(179,254,246);
    self.progressLabel.text=@"已售0%";
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    [uv addSubview:self.progressLabel];
    //
    self.progressView = [[CustomProgressView alloc]initWithFrame:CGRectMake(0, uv.height - kSizeFrom750(6),screen_width,kSizeFrom750(6))];
    [CommonUtils addGradientLayer:self.progressView startColor:RGB(41,213,253) endColor:RGB(190, 252, 248) withDirection:DirectionFromLeft];//设置渐变色
    self.progressView.progress = 0.0f;
    self.progressView.layer.cornerRadius = 0.01;
     self.progressView.tineView.layer.cornerRadius = 0.01;
    //添加该控件到视图View中
    [uv addSubview:self.progressView];

    
    self.progressTopView = [[UIView alloc]initWithFrame:RECT(0, self.progressView.top, self.progressView.width, self.progressView.height)];
    self.progressTopView.backgroundColor = navigationBarColor;
    [uv addSubview:self.progressTopView];
 
    UIView * bottom=[[UIView alloc] initWithFrame:CGRectMake(0, kSizeFrom750(220), screen_width, kSizeFrom750(80))];
    bottom.backgroundColor= RGB(37,142,233);
    [self addSubview:bottom];
    
    self.programRemainLabel = [[UILabel alloc] init];
    self.programRemainLabel.font =  SYSTEMSIZE(28);
    self.programRemainLabel.textColor =  RGB(111,187,255);
    [bottom addSubview:self.programRemainLabel];
    
    [self.programRemainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.top.mas_equalTo(kSizeFrom750(20));
        make.height.mas_equalTo(kSizeFrom750(40));
    }];
    
    self.priceQuestionBtn = [[UIButton alloc]init];
    [self.priceQuestionBtn setImage:IMAGEBYENAME(@"icons_question") forState:UIControlStateNormal];
    [self.priceQuestionBtn setHidden:YES];
    self.priceQuestionBtn.tag = 2;
    [self.priceQuestionBtn addTarget:self action:@selector(questionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:self.priceQuestionBtn];
    
    [self.priceQuestionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.programRemainLabel.mas_centerY);
        make.left.mas_equalTo(self.programRemainLabel.mas_right);
        make.width.height.mas_equalTo(kSizeFrom750(60));
    }];
    
//    self.investLabel= [[UILabel alloc] init];
//    self.investLabel.font =  SYSTEMSIZE(28);
//    self.investLabel.textColor =  RGB(141,200,255);
//    self.investLabel.textAlignment=NSTextAlignmentRight;
//    self.investLabel.hidden = YES;
//    [bottom addSubview:self.investLabel];
//    [self.investLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(bottom.mas_right).offset(-kOriginLeft);
//        make.height.centerY.mas_equalTo(self.programRemainLabel);
//    }];
    bottom.tag=2;
    

}
- (void)download
{
    if(self.progressNum==0||self.progressNum<0.0001)
    {
        NSString *progress = [[NSString stringWithFormat:@"%.2f",self.progressView.progress*100] stringByAppendingString:@"%"];
        NSString *proTxt = [@"已售" stringByAppendingString:progress];
        [self.progressLabel setAttributedText:[CommonUtils diffierentFontWithString:proTxt rang:[proTxt rangeOfString:progress] font:NUMBER_FONT(26) color:RGB(179,254,246) spacingBeforeValue:0 lineSpace:0]];
        self.progressLabel.left = kOriginLeft;
        [myTimer invalidate];
    }
    else{
        CGFloat endProgress = [[NSString stringWithFormat:@"%.4f",self.progressView.progress+0.005] floatValue];
        if (endProgress<=self.progressNum) {
            self.progressView.progress = endProgress;
        }else{
            
        }
        CGFloat proLeft = screen_width*self.progressView.progress;
        self.progressTopView.frame = RECT(proLeft, self.progressTopView.top, screen_width-proLeft, self.progressTopView.height);
        NSString *progress = [[NSString stringWithFormat:@"%.2f",self.progressView.progress*100] stringByAppendingString:@"%"];
        NSString *proTxt = [@"已售" stringByAppendingString:progress];
        [self.progressLabel setAttributedText:[CommonUtils diffierentFontWithString:proTxt rang:[proTxt rangeOfString:progress] font:NUMBER_FONT(26) color:RGB(179,254,246) spacingBeforeValue:0 lineSpace:0]];
        self.progressLabel.left = (screen_width - self.progressLabel.width)*self.progressView.progress;
        if (endProgress >= self.progressNum) {// 如果进度条到头了
            [myTimer invalidate];
            NSString *progress1 = [[NSString stringWithFormat:@"%.2f",self.progressNum*100] stringByAppendingString:@"%"];
            if ([progress isEqualToString:@"100.00%"]) {
                progress = @"100%";
            }
            NSString *proTxt1 = [@"已售" stringByAppendingString:progress];
            [self.progressLabel setAttributedText:[CommonUtils diffierentFontWithString:proTxt1 rang:[proTxt1 rangeOfString:progress1] font:NUMBER_FONT(26) color:RGB(179,254,246) spacingBeforeValue:0 lineSpace:0]];
            
        }
    }
}

@end
