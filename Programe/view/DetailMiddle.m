//
//  DetailMiddle.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DetailMiddle.h"
#import "DetailMiddleTop.h"
#import "DetailMiddleMenu.h"
#import "LoanInfo.h"


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
    NSString * countDownTime;
//    LoanBase * model;
    
}
@end

@implementation DetailMiddle


- (instancetype)init;
{
    self = [super init];
    if (self) {
        self.backgroundColor=lineBg;
        [self initSubViews];
    }
    return self;
}

-(void)loadInfoWithModel:(LoanBase *)programModel{
    
    LoanInfo * info=programModel.loan_info;
    
    [mtop setproName:info.name];//项目名称
    
    [m1 setMenu:@"最低投标金额" content:info.tender_amount_min];

    [m2 setMenu:@"还款方式" content:programModel.repay_type_name];
    
    [m3 setMenu:@"项目状态" content:info.status_name];
    
    secondsCountDown = [CommonUtils getDifferenceByDate:info.overdue_time_date];//倒计时秒数(48小时换算成的秒数,项目中需要从服务器获取)

    if (secondsCountDown>0) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kSizeFrom750(520));
        }];
        //设置倒计时显示的时间
        NSInteger hour=(secondsCountDown-(secondsCountDown%HOUR))/HOUR;
        NSInteger day=0;
        if(hour>24)
            day= (hour-(hour%24))/24;
        NSString *str_hour = [NSString stringWithFormat:@"%02ld",hour%24];//时
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%HOUR)/MINUTE];//分
        NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%MINUTE];//秒
        NSString *format_time =@"0天0时0分0秒";
        
        format_time = [NSString stringWithFormat:@"%ld天%@时%@分%@秒",day,str_hour,str_minute,str_second];
        if(countDownTimer==nil)
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 countDownAction
        [m4 setMenu:@"结束时间" content:format_time];
    }else{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kSizeFrom750(430));
        }];
         [m4 setHidden:TRUE];
    }
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
  
}
-(UIView *) getTimeShowView:(NSString *) nr index:(NSInteger)index
{
    UIView * bg=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    if(index==1)
    {
        bg.frame=CGRectMake(31, 0, 22, 22);
    }
    if(index==2)
    {
        bg.frame=CGRectMake(62, 0, 22, 22);
    }
    bg.backgroundColor=RGB(255,46,19);
    [bg.layer setCornerRadius:2];
    UILabel * title=[[UILabel alloc] initWithFrame:CGRectMake(1, 5, 20, 11)];
    title.font = SYSTEMSIZE(22);
    title.textAlignment=NSTextAlignmentCenter;
    title.textColor=RGB(255,255,255);
    title.text=nr;
    [bg addSubview:title];
    return bg;
}



-(void) countDownAction{
    //倒计时-1
    secondsCountDown--;
    if(secondsCountDown<=0){
        [countDownTimer invalidate];
        countDownTimer=nil;
    }
    NSInteger hour=secondsCountDown/HOUR;
    NSInteger day=(hour-(hour%24))/24;
    
    NSString *str_day = [NSString stringWithFormat:@"%0ld",day];
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",hour%24];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%HOUR)/MINUTE];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%MINUTE];
    // NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    //修改倒计时标签现实内容
    countDownTime=[NSString stringWithFormat:@"%@天%@时%@分%@秒",str_day,str_hour,str_minute, str_second];
    [m4 setMenu:@"结束时间" content:countDownTime];
   

}





@end
