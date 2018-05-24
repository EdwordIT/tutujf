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

@interface DetailMiddle ()
{
    UIImageView * topImage;
    NSInteger secondsCountDown;//倒计时总时长
    NSTimer *countDownTimer;
    UILabel * kaiqian;
    NSMutableArray *menuArray;
    DetailMiddleMenu  * endTimeMenu;
    NSString * countDownTime;
//    LoanBase * model;
    
}
@end

@implementation DetailMiddle


- (instancetype)init;
{
    self = [super init];
    if (self) {
        menuArray = InitObject(NSMutableArray);
        self.backgroundColor = COLOR_White;
        secondsCountDown = 0;
        [self initSubViews];
    }
    return self;
}
//项目详情
-(void)loadInfoWithModel:(LoanBase *)programModel{
    
    LoanInfo * info=programModel.loan_info;
    
    [topImage setImageWithString:info.select_type_img];

    NSArray *nameArray = @[@"项目名称",@"最低投标金额",@"还款方式",@"项目状态"];
    NSArray *valueArray = @[info.name,[NSString stringWithFormat:@"%@元",info.tender_amount_min],programModel.repay_type_name,info.status_name];
    for (int i=0; i<nameArray.count; i++) {
        DetailMiddleMenu *menu = [menuArray objectAtIndex:i];
        [menu setMenu:nameArray[i] content:valueArray[i]];
    }
    
    endTimeMenu = [menuArray objectAtIndex:nameArray.count];
    secondsCountDown = [CommonUtils getDifferenceByDate:info.overdue_time_date];//倒计时秒数(48小时换算成的秒数,项目中需要从服务器获取)
    if (secondsCountDown>0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification:) name:Noti_CountDown object:nil];
    }
    if ([programModel.loan_info.open_up_status isEqualToString:@"-1"]) {//可购买，显示购买倒计时，此处项目持续时间不可添加
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kSizeFrom750(520));
        }];
        [endTimeMenu setHidden:NO];
        [endTimeMenu setMenu:@"结束时间" content:[CommonUtils getCountDownTime:secondsCountDown]];
    }else{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kSizeFrom750(430));
        }];
         [endTimeMenu setHidden:YES];
    }
    [self layoutIfNeeded];//刷新UI控件frame
}
//债权转让
-(void)loadCreditInfoWithModel:(LoanBase *)programModel{
    
    [topImage setImageWithString:programModel.loan_info.select_type_img];

    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[DetailMiddleMenu class]]) {
            [view removeFromSuperview];
        }
    }
    for (int i=0; i<programModel.loan_info.introduce.count; i++) {
        IntroduceModel *model = [programModel.loan_info.introduce objectAtIndex:i];
        DetailMiddleMenu *menu = [[DetailMiddleMenu alloc] initWithFrame:CGRectMake(0,kSizeFrom750(70)+kSizeFrom750(90)*i, screen_width, kSizeFrom750(90))];
        [menu loadInfoWithModel:model];
        [self addSubview:menu];
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kSizeFrom750(70)+programModel.loan_info.introduce.count*kSizeFrom750(90));
    }];
    [self layoutIfNeeded];//刷新UI控件frame
}

- (void)initSubViews{
    
    topImage = [[UIImageView alloc]initWithFrame:RECT(kOriginLeft, kSizeFrom750(20), kContentWidth, kSizeFrom750(36))];
    
    [self addSubview:topImage];
   
    
    for (int i=0; i<5; i++) {
        DetailMiddleMenu *menu = [[DetailMiddleMenu alloc] initWithFrame:CGRectMake(0,kSizeFrom750(70)+kSizeFrom750(90)*i, screen_width, kSizeFrom750(90))];
        if (i==4) {
            [menu setHidden:YES];
        }
        [self addSubview:menu];
        
        [menuArray addObject:menu];
    }
  
}
//一秒获取一次心跳
-(void)countDownNotification:(NSNotification *)noti
{
    secondsCountDown--;
    if(secondsCountDown<=0){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_CountDown object:nil];//移除通知监听
        [[NSNotificationCenter defaultCenter] postNotificationName:Noti_CountDownFinished object:nil];//
    }
    [endTimeMenu setMenu:@"结束时间" content:[CommonUtils getCountDownTime:secondsCountDown]];
}





@end
