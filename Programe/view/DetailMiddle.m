//
//  DetailMiddle.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DetailMiddle.h"
#import "DetailMiddleMenu.h"
#import "LoanInfo.h"
#import "DetailMiddleTop.h"

@interface DetailMiddle ()
{
    DetailMiddleTop * mtop;
    NSInteger secondsCountDown;//倒计时总时长
    NSTimer *countDownTimer;
    UILabel * kaiqian;
    DetailMiddleMenu  * m1;
    DetailMiddleMenu  * m2;
    DetailMiddleMenu  * m3;
    DetailMiddleMenu  * m4;
    DetailMiddleMenu  * m5;
    NSString * countDownTime;
//    LoanBase * model;
    
}
@end

@implementation DetailMiddle


- (instancetype)init;
{
    self = [super init];
    if (self) {
        self.backgroundColor=RGB_233;
        secondsCountDown = 0;

        [self initSubViews];
    }
    return self;
}

-(void)loadInfoWithModel:(LoanBase *)programModel{
    
    LoanInfo * info=programModel.loan_info;
    
    [mtop setproName:info.name];//项目名称
    
    [m1 setMenu:@"最低投标金额" content:[NSString stringWithFormat:@"%@元",info.tender_amount_min]];

    [m2 setMenu:@"还款方式" content:programModel.repay_type_name];
    
    [m3 setMenu:@"项目状态" content:info.status_name];
    
    secondsCountDown = [CommonUtils getDifferenceByDate:info.overdue_time_date];//倒计时秒数(48小时换算成的秒数,项目中需要从服务器获取)
    if (secondsCountDown>0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification:) name:Noti_CountDown object:nil];
    }
    if ([programModel.loan_info.open_up_status isEqualToString:@"-1"]) {//可购买，显示购买倒计时，此处项目持续时间不可添加
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kSizeFrom750(520));
        }];
        [m4 setMenu:@"结束时间" content:[CommonUtils getCountDownTime:secondsCountDown]];
    }else{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kSizeFrom750(430));
        }];
         [m4 setHidden:TRUE];
    }
    [self layoutIfNeeded];//刷新UI控件frame
}
//债权转让
-(void)loadCreditInfoWithModel:(LoanBase *)programModel{
    
    
    LoanInfo * info=programModel.loan_info;
    
    [mtop setproName:info.name];//项目名称
    
    [m1 setMenu:@"待收本金" content:[NSString stringWithFormat:@"%@元",[CommonUtils getHanleNums:programModel.transfer_ret.wait_principal]]];
    
    [m2 setMenu:@"待收利息" content:[NSString stringWithFormat:@"%@元", [CommonUtils getHanleNums:programModel.transfer_ret.wait_interest]]];

    [m3 setMenu:@"还款方式" content:programModel.repay_type_name];
    
    [m4 setMenu:@"还款状态" content:info.status_name];
    
    [m5 setHidden:NO];
    
    [m5 setMenu:@"还款期限" content:programModel.transfer_ret.next_repay_time];
    
    [self layoutIfNeeded];//刷新UI控件frame
}

- (void)initSubViews{
    
    
    mtop=[[DetailMiddleTop alloc] initWithFrame:CGRectMake(0, 0, screen_width, kSizeFrom750(160))];
    [self addSubview:mtop];
     m1=[[DetailMiddleMenu alloc] initWithFrame:CGRectMake(0,mtop.bottom, screen_width, kSizeFrom750(90))];
    [self addSubview:m1];
     m2=[[DetailMiddleMenu alloc] initWithFrame:CGRectMake(0, m1.bottom, screen_width, kSizeFrom750(90))];
    [self addSubview:m2];
     m3=[[DetailMiddleMenu alloc] initWithFrame:CGRectMake(0, m2.bottom, screen_width, kSizeFrom750(90))];
    [self addSubview:m3];
     m4=[[DetailMiddleMenu alloc] initWithFrame:CGRectMake(0, m3.bottom, screen_width, kSizeFrom750(90))];
    [self addSubview:m4];
    m5=[[DetailMiddleMenu alloc] initWithFrame:CGRectMake(0, m4.bottom, screen_width, kSizeFrom750(90))];
    [m5 setHidden:YES];
    [self addSubview:m5];
  
}
//一秒获取一次心跳
-(void)countDownNotification:(NSNotification *)noti
{
    secondsCountDown--;
    if(secondsCountDown<=0){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_CountDown object:nil];//移除通知监听
        [[NSNotificationCenter defaultCenter] postNotificationName:Noti_CountDownFinished object:nil];//
    }
    [m4 setMenu:@"结束时间" content:[CommonUtils getCountDownTime:secondsCountDown]];
}





@end
