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
    NSString * dsojisj;
    LoanBase * model;
    
}
@end

@implementation DetailMiddle

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=lineBg;
        [self awakeFromNib];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame data:(LoanBase *) data;
{
    self = [super initWithFrame:frame];
    if (self) {
        model=data;
        self.backgroundColor=lineBg;
        [self initSubViews];
    }
    return self;
}


- (void)initSubViews{
    
    LoanInfo * info=model.loan_info;
    mtop=[[DetailMiddleTop alloc] initWithFrame:CGRectMake(0, 0, screen_width, 80)];
    [self addSubview:mtop];
    [mtop setXMMC:info.name];
     m1=[[DetailMiddleMenu alloc] initWithFrame:CGRectMake(0,80, screen_width, 45)];
    [self addSubview:m1];
    [m1 setMenu:@"最低投标金额" content:info.tender_amount_min];
     m2=[[DetailMiddleMenu alloc] initWithFrame:CGRectMake(0, 125, screen_width, 45)];
    [self addSubview:m2];
    [m2 setMenu:@"还款方式" content:model.repay_type_name];
     m3=[[DetailMiddleMenu alloc] initWithFrame:CGRectMake(0, 170, screen_width, 45)];
    [self addSubview:m3];
    [m3 setMenu:@"项目状态" content:info.status_name];
    
     m4=[[DetailMiddleMenu alloc] initWithFrame:CGRectMake(0, 215, screen_width, 45)];
    [self addSubview:m4];
    secondsCountDown = [CommonUtils getDifferenceByDate:info.overdue_time_date];//倒计时秒数(48小时换算成的秒数,项目中需要从服务器获取)
    //设置倒计时显示的时间
    NSInteger hour=(secondsCountDown-(secondsCountDown%3600))/3600;
    NSInteger day=0;
    if(hour>24)
        day= (hour-(hour%24))/24;
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",hour%24];//时
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];//分
    NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];//秒
    NSString *format_time =@"0天0时0分0秒";
    if(secondsCountDown>0)
    format_time = [NSString stringWithFormat:@"%ld天%@时%@分%@秒",day,str_hour,str_minute,str_second];
    [m4 setMenu:@"结束时间" content:format_time];
    if(countDownTimer==nil&&secondsCountDown>0)
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 countDownAction
    else
    {
        [m4 setHidden:TRUE];
    }
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
    title.font = CHINESE_SYSTEM(11);
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
    NSInteger hour=secondsCountDown/3600;
    NSInteger day=(hour-(hour%24))/24;
    
    NSString *str_day = [NSString stringWithFormat:@"%0ld",day];
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",hour%24];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];
    // NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    //修改倒计时标签现实内容
    dsojisj=[NSString stringWithFormat:@"%@天%@时%@分%@秒",str_day,str_hour,str_minute, str_second];
    [m4 setMenu:@"结束时间" content:dsojisj];
   

}





@end
