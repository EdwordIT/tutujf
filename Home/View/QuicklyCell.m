//
//  QuicklyCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/3/12.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "QuicklyCell.h"
#import "CustomProgressView.h"
#import "CountDownManager.h"
@interface QuicklyCell()
Strong CustomProgressView *progressView;
Strong UILabel *hourLabel;//时分秒
Strong UILabel *minuteLabel;
Strong UILabel *secondLabel;
Strong QuicklyModel *cellModel;
Strong NSDate *nowDate;//现在的时间
@end
@implementation QuicklyCell
{
    NSTimer * myTimer;
    UILabel * proTextLabel;
     float progressNum;
    Boolean isfinish;
    UILabel * lab5;
    UIImageView  * proStateImage;
    UIButton* buyBtn;
    UILabel * startLabel;
    NSInteger secondsCountDown;
    
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    isfinish=FALSE;
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification:) name:Noti_CountDown object:nil];
        secondsCountDown = 0;
        [self initViews];
    }
    return self;
}

-(void)initViews {
    
    self.title= [[UILabel alloc] init];
    self.title.font = SYSTEMSIZE(30);
    self.title.textColor=RGB_51;
    self.title.text=@"宝马0214-02（温州总部）";
    self.title.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview: self.title];
    
    self.typeimgsrc= [[UIImageView alloc] init];
    self.typeimgsrc.centerY = self.title.centerY;
    [ self.typeimgsrc setImage:[UIImage imageNamed:@"gqzq.png"]];
    [self.contentView addSubview:self.typeimgsrc];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kOriginLeft);
        make.top.mas_equalTo(kSizeFrom750(30));
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    
    [self.typeimgsrc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.title.mas_right).offset(kSizeFrom750(30));
        make.width.mas_equalTo(kSizeFrom750(116));
        make.height.mas_equalTo(kSizeFrom750(38));
        make.centerY.mas_equalTo(self.title);
    }];
    
    self.percentLabel= [[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, kSizeFrom750(100),kSizeFrom750(150),kSizeFrom750(32))];
    self.percentLabel.text=@"8.23%";
    [self.percentLabel setFont:NUMBER_FONT(30)];
    self.percentLabel.textColor = COLOR_Red;
    [self.contentView addSubview: self.percentLabel];
    
    
    
    UILabel * lab2= [[UILabel alloc] initWithFrame:CGRectMake(self.percentLabel.left, self.percentLabel.bottom+kSizeFrom750(15),kSizeFrom750(140), kSizeFrom750(25))];
    lab2.font = SYSTEMSIZE(24);
    lab2.textColor=RGB_183;
    lab2.text=@"预期利率";
    [self.contentView addSubview:lab2];
    
    self.timeLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, self.percentLabel.top,self.percentLabel.width, self.percentLabel.height)];
    self.timeLabel.centerX = screen_width/2;
    self.timeLabel.font = SYSTEMSIZE(24);
    self.timeLabel.textColor=RGB_51;
    self.timeLabel.text=@"2个月";
    self.timeLabel.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.timeLabel];
    //
    UILabel * lab3= [[UILabel alloc] initWithFrame:CGRectMake(0, lab2.top,lab2.width, lab2.height)];
    lab3.centerX = self.timeLabel.centerX;
    lab3.font = SYSTEMSIZE(24);
    lab3.textColor=RGB_183;
    lab3.text=@"理财期限";
    lab3.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:lab3];
    
    
    lab5= [[UILabel alloc] initWithFrame:CGRectMake(screen_width-kSizeFrom750(300), kSizeFrom750(200),kSizeFrom750(252), kSizeFrom750(25))];
    lab5.font = SYSTEMSIZE(24);
    lab5.text=@"到期还本利息";
    lab5.textAlignment= NSTextAlignmentRight;
    [self.contentView addSubview:lab5];
    
    buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(screen_width-kSizeFrom750(216),kSizeFrom750(100), kSizeFrom750(168), kSizeFrom750(60));
    [buyBtn addTarget:self action:@selector(button_event:) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.tag=1;
    buyBtn.adjustsImageWhenHighlighted = NO;
    [buyBtn setTitle:@"抢购" forState:UIControlStateNormal];//button title
    [buyBtn.titleLabel setFont:SYSTEMSIZE(30)];
    [buyBtn setTitleColor:RGB(255,255,255) forState:UIControlStateNormal];//title color
    buyBtn.backgroundColor=COLOR_Btn_Unsel;
    buyBtn.layer.masksToBounds = YES;
    [buyBtn.layer setCornerRadius:kSizeFrom750(60)/2]; //设置矩形四个圆角半径
    [self.contentView addSubview:buyBtn];
    
    //还款中
    proStateImage= [[UIImageView alloc] initWithFrame:CGRectMake(screen_width - kSizeFrom750(180), kSizeFrom750(20),kSizeFrom750(148), kSizeFrom750(148))];
    [ proStateImage setImage:IMAGEBYENAME(@"program_payback")];
    [proStateImage setHidden:YES];
    [self.contentView addSubview:proStateImage];//huankuanz
    
    if(isfinish)
    {
        [buyBtn setHidden:FALSE];
        [proStateImage setHidden:TRUE];
        lab5.textColor=RGB_51;
        
    }
    else{
        lab5.textColor=RGB_183;
        [proStateImage setHidden:FALSE];
        [buyBtn setHidden:TRUE];
        
    }
    
    proTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSizeFrom750(350), kSizeFrom750(200),kSizeFrom750(150), kSizeFrom750(25))];
    proTextLabel.font = SYSTEMSIZE(24);
    proTextLabel.textAlignment=NSTextAlignmentLeft;
    proTextLabel.textColor=RGB(158,158,158);
    proTextLabel.text=@"进度 70%";
    [self.contentView addSubview:proTextLabel];
    
    self.progressView = [[CustomProgressView alloc]initWithFrame:CGRectMake(kSizeFrom750(30), 0,kSizeFrom750(300), kSizeFrom750(6))];
    self.progressView.centerY = proTextLabel.centerY;
    [self.progressView setProgressColor:navigationBarColor];
    [self.progressView setDefaultColor:RGB(231,231,231)];
    progressNum=0.7;
    [self.contentView addSubview:self.progressView];
    
    //倒计时
    self.timeView = [[UIView alloc]initWithFrame:RECT(kSizeFrom750(30), 0, kSizeFrom750(360), kSizeFrom750(50))];
    [self.timeView setHidden:YES];//默认隐藏倒计时
    [self.contentView addSubview:self.timeView];
    
    startLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, proTextLabel.top, kSizeFrom750(150), kSizeFrom750(25))];
    startLabel.font = SYSTEMSIZE(24);
    startLabel.textColor=RGB(102,102,102);
    startLabel.text=@"距离开抢还剩";
    [self.timeView addSubview:startLabel];
    
    [self.timeView addSubview:self.hourLabel];
    UILabel * t1=[[UILabel alloc] initWithFrame:CGRectMake(self.hourLabel.right, self.hourLabel.top, kSizeFrom750(15), self.hourLabel.height)];
    t1.font = SYSTEMSIZE(24);
    t1.textAlignment=NSTextAlignmentCenter;
    t1.textColor=COLOR_Red;
    t1.text=@":";
    [self.timeView addSubview:t1];
    [self.timeView addSubview:self.minuteLabel];
    UILabel * t2=[[UILabel alloc] initWithFrame:CGRectMake(self.minuteLabel.right, self.minuteLabel.top, kSizeFrom750(15), self.hourLabel.height)];
    t2.font = SYSTEMSIZE(24);
    t2.textAlignment=NSTextAlignmentCenter;
    t2.textColor=COLOR_Red;
    t2.text=@":";
    [self.timeView addSubview:t2];
    [self.timeView addSubview:self.secondLabel];
    
    self.sepView = [[UIView alloc]initWithFrame:RECT(0, kSizeFrom750(258), screen_width, kSizeFrom750(20))];
    self.sepView.backgroundColor = separaterColor;
    [self.contentView addSubview:self.sepView];
    
}
#pragma mark --loadUI
-(UILabel *)hourLabel{
    if (!_hourLabel) {
        _hourLabel= InitObject(UILabel);
        _hourLabel.frame = RECT(startLabel.right+kSizeFrom750(15), 0, kSizeFrom750(45), kSizeFrom750(42));
        _hourLabel.centerY = startLabel.centerY;
        _hourLabel.font = SYSTEMSIZE(22);
        _hourLabel.backgroundColor = COLOR_Red;
        _hourLabel.layer.cornerRadius = kSizeFrom750(8);
        _hourLabel.layer.masksToBounds = YES;
        _hourLabel.textAlignment=NSTextAlignmentCenter;
        _hourLabel.textColor=RGB(255,255,255);
    }
    return _hourLabel;
}
-(UILabel *)minuteLabel{
    if (!_minuteLabel) {
        _minuteLabel= InitObject(UILabel);
        _minuteLabel.frame = RECT(_hourLabel.right+kSizeFrom750(15), _hourLabel.top, _hourLabel.width, _hourLabel.height);
        _minuteLabel.font = SYSTEMSIZE(22);
        _minuteLabel.backgroundColor = COLOR_Red;
        _minuteLabel.layer.cornerRadius = kSizeFrom750(8);
        _minuteLabel.layer.masksToBounds = YES;

        _minuteLabel.textAlignment=NSTextAlignmentCenter;
        _minuteLabel.textColor=RGB(255,255,255);
    }
    return _minuteLabel;
}
-(UILabel *)secondLabel{
    if (!_secondLabel) {
        _secondLabel= InitObject(UILabel);
        _secondLabel.frame = RECT(_minuteLabel.right+kSizeFrom750(15), _hourLabel.top, _hourLabel.width, _hourLabel.height);
        _secondLabel.font = SYSTEMSIZE(22);
        _secondLabel.backgroundColor = COLOR_Red;
        _secondLabel.layer.cornerRadius = kSizeFrom750(8);
        _secondLabel.layer.masksToBounds = YES;
        _secondLabel.textAlignment=NSTextAlignmentCenter;
        _secondLabel.textColor=RGB(255,255,255);
    }
    return _secondLabel;
}
#pragma mark --notification
//倒计时通知事件接收
-(void)countDownNotification:(NSNotification *)noti{
    
    secondsCountDown--;
    if (secondsCountDown<=0||([self.cellModel.open_up_status rangeOfString:@"-1"].location!=NSNotFound)) {
        return;//如果开始就不存在倒计时，则不走下边儿判断
    }
    if (secondsCountDown >0&&self.timeView.hidden == NO) {
        
        NSInteger hour=(secondsCountDown-(secondsCountDown%HOUR))/HOUR;
        NSString *str_hour = [NSString stringWithFormat:@"%02ld",hour];
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%HOUR)/MINUTE];
        NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%MINUTE];
        self.hourLabel.text = str_hour;
        self.minuteLabel.text = str_minute;
        self.secondLabel.text = str_second;
    }else
    {
        self.cellModel.open_up_status = @"-1";
        self.cellModel.status = @"3";
        buyBtn.backgroundColor=COLOR_Red;
        [self.progressView setHidden:NO];
        self.progressView.progress = 0;
        [proTextLabel setHidden:NO];
        [self.timeView  setHidden:YES];
    }
    
}

- (NSInteger)getDifferenceByDate:(NSString *)creat_time {
    self.nowDate = [NSDate date]; // 当前时间(同一个model只计算一次，防止count和time倒计时重复计算)
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
    NSDate *creat = [formatter dateFromString:creat_time]; // 传入的时间
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *compas = [calendar components:unit fromDate:self.nowDate toDate:creat options:0];

    NSInteger day= [compas day];
    if(day<0)
        return 0;
    NSInteger sss= [compas second]+compas.hour*HOUR+[compas minute]*MINUTE+day*DAY;
    if(sss<0)
        return 0;
    return sss;
}

- (void)download
{
    if (self.progressView.progress >= progressNum) {// 如果进度条到头了
        // 终止定时器
        [myTimer invalidate];
          return  ;
    }
  
      
    self.progressView.progress += 0.04; // 设定步进长度
    [self.progressView setProgressColor:navigationBarColor];
    
}



-(void)button_event:(UIButton*) sender
{
    if ([self.cellModel.status isEqualToString:@"3"]&&[self.cellModel.open_up_status isEqualToString:@"-1"]) {
        self.investBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setQuicklyModel:(QuicklyModel *)quickModel
{
    [buyBtn setTitle:quickModel.status_name forState:UIControlStateNormal];
    self.cellModel = quickModel;

    progressNum=[self.cellModel.progress intValue]/100;
    secondsCountDown = [self getDifferenceByDate:self.cellModel.open_up_date];//倒计时秒数(48小时换算成的秒数,项目中需要从服务器获取)
    int status = [self.cellModel.status intValue];
    if( status== 4||status ==6||status==7)//如果已经满标，三种状态
    {
        lab5.textColor=RGB_183;
        self.percentLabel.textColor=RGB_183;
        self.timeLabel.textColor=RGB_183;
        self.title.textColor=RGB_183;
        proTextLabel.textColor=RGB_158;
        [proStateImage setHidden:NO];
        [buyBtn setHidden:YES];
        [self.timeView setHidden:YES];
        [self.progressView setHidden:NO];
        [proTextLabel setHidden:NO];
        
        [self.progressView setProgress:1.0];
        [self.progressView setProgressColor:RGB(211,211,211)];
        
        if([self.cellModel.status isEqual:@"4"])//满标待审
        {
            [proStateImage setImage:IMAGEBYENAME(@"program_full")];
        }
        else if([self.cellModel.status isEqual:@"7"])//已还完
        {
            [proStateImage setImage:IMAGEBYENAME(@"program_repayed")];
        }
        else if([self.cellModel.status isEqual:@"6"])//还款中
        {
            [proStateImage setImage:IMAGEBYENAME(@"program_payback")];
        }
    }
    else//未满标，则可能可购买，或者可能在倒计时
    {
        lab5.textColor=RGB_51;
        self.percentLabel.textColor=RGB(255,48,19);
        self.timeLabel.textColor=RGB_51;
        self.title.textColor=RGB_51;
        proTextLabel.textColor=RGB_51;
        [buyBtn setHidden:NO];
        [proStateImage setHidden:YES];
        
        //进度条和倒计时的显示判断
        if([self.cellModel.open_up_status isEqual:@"-1"])//如果还可购买，则显示进度条
        {
            buyBtn.backgroundColor=COLOR_Red;
            [self.timeView setHidden:YES];
            [self.progressView setHidden:NO];
            [proTextLabel setHidden:NO];
            
            [self.progressView setProgress:0.0];
            [self.progressView setProgressColor:RGB(48,156,246)];
            progressNum=[self.cellModel.progress floatValue]/100;
            
            myTimer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                                       target:self
                                                     selector:@selector(download)
                                                     userInfo:nil
                                                      repeats:YES];
        }
        else
        {
            [buyBtn setBackgroundColor:COLOR_Btn_Unsel];//抢购按钮置灰色,显示倒计时
            [self.timeView setHidden:NO];
            [self.progressView setHidden:YES];
            [proTextLabel setHidden:YES];
            //设置倒计时显示的时间
            NSInteger hour=(secondsCountDown-(secondsCountDown%HOUR))/HOUR;
            NSString *str_hour = [NSString stringWithFormat:@"%02ld",hour];//时
            NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%HOUR)/MINUTE];//分
            NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%MINUTE];//秒
            self.hourLabel.text = str_hour;
            self.minuteLabel.text = str_minute;
            self.secondLabel.text = str_second;
        }
    }
    
    self.title.text=self.cellModel.name;
  
    if (!IsEmptyStr(self.cellModel.activity_url_img)) {
        self.typeimgsrc.width = [self.cellModel.activity_img_width floatValue];
        self.typeimgsrc.height = [self.cellModel.activity_url_img_height floatValue];
        self.typeimgsrc.centerY = self.title.centerY;
        [self.typeimgsrc mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([self.cellModel.activity_img_width floatValue]);
            make.height.mas_equalTo([self.cellModel.activity_url_img_height floatValue]);
        }];
        [self.typeimgsrc setImageWithString:self.cellModel.activity_url_img];
    }else{
        [self.typeimgsrc setImageWithString:@""];
    }
    self.timeLabel.text=[NSString stringWithFormat:@"%@",self.cellModel.period];
    proTextLabel.text= [[NSString stringWithFormat:@"进度%@",self.cellModel.progress] stringByAppendingString:@"%"];
    self.percentLabel.text = self.cellModel.apr_val;
    
    lab5.text=[NSString stringWithFormat:@"%@",self.cellModel.repay_type_name];
   
    
}

@end
