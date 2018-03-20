//
//  QuicklyCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/3/12.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "QuicklyCell.h"

@implementation QuicklyCell
{
    NSTimer * myTimer;
    UILabel * proTextLabel;
    UIProgressView *progressView;
     float progressNum;
    Boolean isfinish;
    UILabel * lab5;
    UIImageView  * imghk;
    UIButton* btn1;

    NSInteger secondsCountDown;//倒计时总时长
    NSTimer *countDownTimer;
    UILabel * startLabel;
    UIView * hourshow;
    UIView * minutehow;
     UIView * secrodhow;
      UIView * dayhow;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    isfinish=FALSE;
   // self.backgroundColor=RGB(221,221,221);
    if (self) {
        [self initViews];
    }
    return self;
}

-(void)initViews {

    self.typeimgsrc= [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/2-90, 18, 58, 19)];
    [ self.typeimgsrc setImage:[UIImage imageNamed:@"gqzq.png"]];
    [self.contentView addSubview:self.typeimgsrc];

    
    self.title= [[UILabel alloc] initWithFrame:CGRectMake(kSizeFrom750(30), kSizeFrom750(30),screen_width-55, kSizeFrom750(30))];
    self.title.font = SYSTEMSIZE(30);
    self.title.textColor=RGB_51;
    self.title.text=@"宝马0214-02（温州总部）";
    self.title.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview: self.title];
    


    self.percentLabel= [[UILabel alloc] initWithFrame:CGRectMake(self.title.left, self.title.bottom+kSizeFrom750(44),kSizeFrom750(130),kSizeFrom750(32))];
    self.percentLabel.text=@"8.23%";
    self.percentLabel.textAlignment=NSTextAlignmentCenter;
    NSInteger index=[  self.percentLabel.text rangeOfString:@"%"].location;
    NSInteger len=[  self.percentLabel.text  length];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:  self.percentLabel.text];
    [textColor addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:20] range:NSMakeRange(0, index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,48,19) range:NSMakeRange(0, index)];
    [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(13) range:NSMakeRange(index,len-index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,48,19)  range:NSMakeRange(index, len-index)];
    [ self.percentLabel setAttributedText:textColor];
    [self.contentView addSubview: self.percentLabel];
    
    
    
    UILabel * lab2= [[UILabel alloc] initWithFrame:CGRectMake(self.percentLabel.left, self.percentLabel.bottom+kSizeFrom750(15),kSizeFrom750(140), kSizeFrom750(25))];
    lab2.font = SYSTEMSIZE(24);
    lab2.textColor=RGB_153;
    lab2.text=@"年化收益率";
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
    lab3.textColor=RGB_153;
    lab3.text=@"理财期限";
    //[lab3 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    lab3.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:lab3];
    
    
    lab5= [[UILabel alloc] initWithFrame:CGRectMake(screen_width-kSizeFrom750(300), kSizeFrom750(200),kSizeFrom750(252), kSizeFrom750(25))];
    lab5.font = SYSTEMSIZE(24);
    lab5.text=@"到期还本利息";
    lab5.textAlignment= NSTextAlignmentRight;
    [self.contentView addSubview:lab5];
    
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(screen_width-kSizeFrom750(216),kSizeFrom750(100), kSizeFrom750(168), kSizeFrom750(60));
    [btn1 addTarget:self action:@selector(button_event:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag=1;
    [btn1 setTitle:@"抢购" forState:UIControlStateNormal];//button title
    [btn1.titleLabel setFont:SYSTEMSIZE(30)];
    [btn1 setTitleColor:RGB(255,255,255) forState:UIControlStateNormal];//title color
    
    btn1.backgroundColor=RGB(255,46,18);
    btn1.layer.masksToBounds = YES;
    [btn1.layer setCornerRadius:kSizeFrom750(60)/2]; //设置矩形四个圆角半径
    [self.contentView addSubview:btn1];
    
    imghk= [[UIImageView alloc] initWithFrame:CGRectMake(screen_width - kSizeFrom750(180), kSizeFrom750(20),kSizeFrom750(148), kSizeFrom750(148))];
    [ imghk setImage:[UIImage imageNamed:@"huankuanz"]];
    [self.contentView addSubview:imghk];//huankuanz
    
    if(isfinish)
    {
        [btn1 setHidden:FALSE];
     [imghk setHidden:TRUE];
    lab5.textColor=RGB_51;
    
    }
    else{
        lab5.textColor=RGB(183,183,183);
        [imghk setHidden:FALSE];
          [btn1 setHidden:TRUE];
        
    }
   
    proTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSizeFrom750(350), kSizeFrom750(200),kSizeFrom750(150), kSizeFrom750(25))];
    proTextLabel.font = SYSTEMSIZE(24);
    proTextLabel.textAlignment=NSTextAlignmentLeft;
    proTextLabel.textColor=RGB(158,158,158);
    proTextLabel.text=@"进度 70%";
    [self.contentView addSubview:proTextLabel];
    
    progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.frame = CGRectMake(kSizeFrom750(30), 105,kSizeFrom750(300), kSizeFrom750(12));
    progressView.centerY = proTextLabel.centerY;
    [progressView setProgressTintColor:RGB(48,156,246)];
    [progressView setTrackTintColor:RGB(231,231,231)];
    progressNum=0.7;
    //添加该控件到视图View中
    [self.contentView addSubview:progressView];
    
    self.sepView = [[UIView alloc]initWithFrame:RECT(0, kSizeFrom750(258), screen_width, kSizeFrom750(20))];
    self.sepView.backgroundColor = separaterColor;
    [self.contentView addSubview:self.sepView];

}

-(UIView *) getTimeShowView:(NSString *) nr index:(NSInteger)index
{
    UIView * bg=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 22, 20)];
    if(index==1)
    {
        bg.frame=CGRectMake(31, 0, 22, 20);
    }
    if(index==2)
    {
        bg.frame=CGRectMake(62, 0, 22, 20);
    }
    bg.backgroundColor=RGB(255,46,19);
    [bg.layer setCornerRadius:2];
   
    UILabel * title=[[UILabel alloc] initWithFrame:CGRectMake(1, 5, bg.frame.size.width-2, 11)];
    title.font = CHINESE_SYSTEM(11);
    title.textAlignment=NSTextAlignmentCenter;
    title.textColor=RGB(255,255,255);
    title.text=nr;
    if(index==0)
    {
        NSInteger hour=[nr intValue];
        if(hour>100)
        {
            bg.frame=CGRectMake(1, 5,37, 11);
        }
    }
    [bg addSubview:title];
    return bg;
}

-(void) countDownAction{
    //倒计时-1
    secondsCountDown--;
   
    if(secondsCountDown<=0)
    {
        [countDownTimer invalidate];
        countDownTimer=nil;
        secondsCountDown=0;
        btn1.backgroundColor=RGB(255,46,18);
        [progressView setHidden:FALSE];
        [proTextLabel setHidden:NO];
        [startLabel setHidden:TRUE];
        [self.timeView  setHidden:TRUE];
    }
    NSInteger hour=(secondsCountDown-(secondsCountDown%3600))/3600;
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",hour];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];
   // NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    //修改倒计时标签现实内容
   
    for (UIView *subviews in [hourshow subviews]) {
        if ([subviews isKindOfClass:[UILabel class]]) {
         [subviews removeFromSuperview];
            
        }
    }
    UILabel * title=[[UILabel alloc] initWithFrame:CGRectMake(1, 4, 20, 11)];
    title.font = CHINESE_SYSTEM(11);
    if(hour>100)
        title.frame=CGRectMake(1, 4, 34, 11);
    title.textAlignment=NSTextAlignmentCenter;
    title.textColor=RGB(255,255,255);
    title.text=str_hour;
    [hourshow addSubview:title];
   
    
    for (UIView *subviews in [minutehow subviews]) {
        if ([subviews isKindOfClass:[UILabel class]]) {
          [subviews removeFromSuperview];
        }
    }
    UILabel * title1=[[UILabel alloc] initWithFrame:CGRectMake(1, 4, 20, 11)];
    title1.font = CHINESE_SYSTEM(11);
    title1.textAlignment=NSTextAlignmentCenter;
    title1.textColor=RGB(255,255,255);
    title1.text=str_minute;
    [minutehow addSubview:title1];
    
    for (UIView *subviews in [secrodhow subviews]) {
        if ([subviews isKindOfClass:[UILabel class]]) {
            [subviews removeFromSuperview];
        }
    }
    UILabel * title2=[[UILabel alloc] initWithFrame:CGRectMake(1, 4, 20, 11)];
    title2.font = CHINESE_SYSTEM(11);
    title2.textAlignment=NSTextAlignmentCenter;
    title2.textColor=RGB(255,255,255);
    title2.text=str_second;
    [secrodhow addSubview:title2];
     if(hour>100)
     {
         
     }
   // self.timeLabel.text=[NSString stringWithFormat:@"倒计时   %@",format_time];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    
}

- (NSInteger)getDifferenceByDate:(NSString *)creat_time {
    NSDate *nowDate = [NSDate date]; // 当前时间
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
    NSDate *creat = [formatter dateFromString:creat_time]; // 传入的时间
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *compas = [calendar components:unit fromDate:nowDate toDate:creat options:0];
    //NSLog(@"year=%zd  month=%zd  day=%zd hour=%zd  minute=%zd",compas.year,compas.month,compas.day,compas.hour,compas.minute);

    NSInteger day= [compas day];
    if(day<0)
        return 0;
    NSInteger sss= [compas second]+compas.hour*60*60+[compas minute]*60+day*24*60*60;
    if(sss<0)
        return 0;
    return sss;
}

- (void)download
{
    if (progressView.progress >= progressNum) {// 如果进度条到头了
        // 终止定时器
        [myTimer invalidate];
          return  ;
    }
  
      
    progressView.progress += 0.04; // 设定步进长度
    CGFloat  gg=83+progressView.progress*78;
    [progressView setProgressTintColor:RGB(0,gg,239)];
    
}



-(void)button_event:(UIButton*) sender
{
    if(secondsCountDown==0)
    [self.delegate didSelectedQuicklyAtIndex:sender.tag];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setQuicklyModel:(QuicklyModel *)model
{
    if(![model.status isEqual: @"3"])
        isfinish=YES;
    else
        isfinish=NO;
    progressNum=[model.progress intValue]/100;
    secondsCountDown = [self getDifferenceByDate:model.open_up_date];//倒计时秒数(48小时换算成的秒数,项目中需要从服务器获取)
    if(isfinish)
    {
        lab5.textColor=RGB(153,153,153);
        self.percentLabel.textColor=RGB(153,153,153);
        self.timeLabel.textColor=RGB(153,153,153);
        self.title.textColor=RGB(153,153,153);
        proTextLabel.textColor=RGB(158,158,158);
        [imghk setHidden:FALSE];
        [btn1 setHidden:TRUE];
        
        [progressView setProgress:1.0];
        [progressView setProgressTintColor:RGB(211,211,211)];
        
        if([model.status_name isEqual:@"满标待审"])
        {
            [imghk setImage:[UIImage imageNamed:@"aslo02.png"]];
        }
        else if([model.status_name isEqual:@"已还完"])
        {
            [imghk setImage:[UIImage imageNamed:@"aslo03.png"]];
        }
        else if([model.status_name isEqual:@"还款中"])
        {
            [imghk setImage:[UIImage imageNamed:@"huankuanz"]];
        }
    }
    else
    {
        lab5.textColor=RGB(51,51,51);
        self.percentLabel.textColor=RGB(255,48,19);
        self.timeLabel.textColor=RGB(51,51,51);
        self.title.textColor=RGB(51,51,51);
        proTextLabel.textColor=RGB(51,51,51);
        [btn1 setHidden:FALSE];
        [imghk setHidden:TRUE];
        if(![model.open_up_status isEqual:@"-1"])
        {
            [progressView setProgress:0.0];
            [progressView setProgressTintColor:RGB(48,156,246)];
            progressNum=[model.progress floatValue]/100;
            
            myTimer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                                       target:self
                                                     selector:@selector(download)
                                                     userInfo:nil
                                                      repeats:YES];
        }
        else
        {
            if(secondsCountDown>0){
                [progressView setHidden:TRUE];
                [proTextLabel setHidden:YES];
            }else{
                [progressView setProgress:0.0];
                [progressView setProgressTintColor:RGB(48,156,246)];
                progressNum=[model.progress floatValue]/100;
                
                myTimer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                                           target:self
                                                         selector:@selector(download)
                                                         userInfo:nil
                                                          repeats:YES];
            }
        }
    }
    
    btn1.tag=[model.nrid intValue];
    self.title.text=model.name;
    self.timeLabel.text=[NSString stringWithFormat:@"%@",model.period];
    proTextLabel.text= [[NSString stringWithFormat:@"进度%@",model.progress] stringByAppendingString:@"%"];
    CGFloat f=[model.additional_apr floatValue];
    if(f==0)
    {
        self.percentLabel.textAlignment=NSTextAlignmentCenter;
        self.percentLabel.frame=CGRectMake(10, 51,70,20);
        NSString * temp=model.apr;
        temp=[temp stringByAppendingString:@"%"];
        self.percentLabel.text=temp;
        NSInteger index=[ self.percentLabel.text rangeOfString:@"%"].location;
        NSInteger len=[ self.percentLabel.text  length];
        NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString: self.percentLabel.text];
        [textColor addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:20] range:NSMakeRange(0, index)];
        if(isfinish)
            [textColor addAttribute:NSForegroundColorAttributeName value:RGB(153,153,153) range:NSMakeRange(0, index)];
        else
            [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,46,19) range:NSMakeRange(0, index)];
        [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(12) range:NSMakeRange(index,len-index)];
        if(isfinish)
            [textColor addAttribute:NSForegroundColorAttributeName value:RGB(153,153,153)  range:NSMakeRange(index, len-index)];
        else
            [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,46,19)  range:NSMakeRange(index, len-index)];
        [self.percentLabel setAttributedText:textColor];
    }
    else
    {
        NSString * ff=[NSString stringWithFormat:@"%.2f",f];
        NSString * temp=model.apr;
        temp=[temp stringByAppendingString:@"%"];
        temp=[temp stringByAppendingString:@"+"];
        temp=[temp stringByAppendingString:ff];
        temp=[temp stringByAppendingString:@"%"];
        self.percentLabel.text=temp;
        self.percentLabel.frame=CGRectMake(10, 51,180,20);
        self.percentLabel.textAlignment=NSTextAlignmentLeft;
        NSInteger index=[ self.percentLabel.text rangeOfString:@"+"].location;
        NSInteger index1=[ff rangeOfString:@"."].location;
        NSInteger len=[ self.percentLabel.text  length];
        NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString: self.percentLabel.text];
        [textColor addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:20] range:NSMakeRange(0, index-4)];
        if(isfinish)
            [textColor addAttribute:NSForegroundColorAttributeName value:RGB(153,153,153) range:NSMakeRange(0, index-4)];
        else
            [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,46,19) range:NSMakeRange(0, index-4)];
        [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(12) range:NSMakeRange(index-4,5)];
        if(isfinish)
            [textColor addAttribute:NSForegroundColorAttributeName value:RGB(153,153,153)  range:NSMakeRange(index-4, 5)];
        else
            [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,46,19)  range:NSMakeRange(index-4, 5)];
        [textColor addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:20] range:NSMakeRange(index+1, index1)];
        if(isfinish)
            [textColor addAttribute:NSForegroundColorAttributeName value:RGB(153,153,153) range:NSMakeRange(index+1, index1)];
        else
            [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,46,19) range:NSMakeRange(index+1, index1)];
        [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(12) range:NSMakeRange(index+1+index1,len-(index+1+index1))];
        if(isfinish)
            [textColor addAttribute:NSForegroundColorAttributeName value:RGB(153,153,153)  range:NSMakeRange(index+1+index1,len-(index+1+index1))];
        else
            [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,46,19)  range:NSMakeRange(index+1+index1,len-(index+1+index1))];
        
        [self.percentLabel setAttributedText:textColor];
    }
    if([model.activity_url_img isEqual:@""])
        [self.typeimgsrc setHidden:TRUE];
    else
    {
        CGFloat hh=55;
        CGFloat ww=18;
        
        if([model.name length]>15)
        {
            if(![model.activity_img_width isEqual:@"0"])
            {
                ww=[model.activity_img_width  floatValue];
            }
            else
                ww=50;
            if(![model.activity_url_img_height isEqual:@"0"])
            {
                hh=[model.activity_url_img_height  floatValue];
            }
            else
                hh=15;
            CGFloat len=([model.name length]-15)*12;
            self.typeimgsrc.frame=CGRectMake(screen_width/2-25+len, 55,ww, hh);
        }
        else
        {
            if(![model.activity_img_width isEqual:@"0"])
            {
                ww=[model.activity_img_width  floatValue];
            }
            if(![model.activity_url_img_height isEqual:@"0"])
            {
                hh=[model.activity_url_img_height  floatValue];
            }
        }
        [self.typeimgsrc sd_setImageWithURL:[NSURL URLWithString:model.activity_url_img]];
        self.typeimgsrc.frame=CGRectMake([model.name length]*12+20, 17, ww, hh);
    }
    lab5.text=[NSString stringWithFormat:@"%@",model.repay_type_name];
    if(secondsCountDown>0)
    {
        btn1.backgroundColor=RGB(184,184,184);//抢购隐藏
        [progressView setHidden:TRUE];
        [proTextLabel setHidden:YES];
    }
    if( !isfinish&&secondsCountDown>0)
    {
        
        //设置倒计时显示的时间
        NSInteger hour=(secondsCountDown-(secondsCountDown%3600))/3600;
        NSString *str_hour = [NSString stringWithFormat:@"%02ld",hour];//时
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];//分
        NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];//秒
        NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
        NSLog(@"time:%@",format_time);
        if(startLabel==nil)
        {
            startLabel=[[UILabel alloc] initWithFrame:CGRectMake(kSizeFrom750(30), proTextLabel.top, kSizeFrom750(150), kSizeFrom750(25))];
            startLabel.font = SYSTEMSIZE(24);
            startLabel.textAlignment=NSTextAlignmentLeft;
            startLabel.textColor=RGB(102,102,102);
            startLabel.text=@"距离开抢还剩";
            [self.contentView addSubview:startLabel];
        }
        if( self.timeView==nil)
            self.timeView = [[UIView alloc] initWithFrame:CGRectMake(startLabel.right+kSizeFrom750(15), 94, kSizeFrom750(220), kSizeFrom750(40))];
        hourshow=[self getTimeShowView:str_hour index:0];
        minutehow=[self getTimeShowView:str_minute index:1];
        secrodhow=[self getTimeShowView:str_second index:2];
        if(hour>100)
        {
            //      self.timeView.frame=CGRectMake(90, 94, 105, 20);
            
            hourshow.frame=CGRectMake(0, 0, 37, 20);
            minutehow.frame=CGRectMake(46, 0, 22, 20);
            secrodhow.frame=CGRectMake(77, 0, 22, 20);
        }
        self.timeView.centerY = startLabel.centerY;
        UILabel * t1=[[UILabel alloc] initWithFrame:CGRectMake(22, 5, 9, 12)];
        t1.font = CHINESE_SYSTEM(12);
        t1.textAlignment=NSTextAlignmentCenter;
        t1.textColor=RGB(255,46,19);
        t1.text=@":";
        [self.timeView addSubview:t1];
        
        UILabel * t2=[[UILabel alloc] initWithFrame:CGRectMake(53, 5, 9, 12)];
        t2.font = CHINESE_SYSTEM(12);
        t2.textAlignment=NSTextAlignmentCenter;
        t2.textColor=RGB(255,46,19);
        t2.text=@":";
        if(hour>100)
        {
            t1.frame=CGRectMake(37, 5, 9, 12);
            t2.frame=CGRectMake(68, 5, 9, 12);
        }
        [self.timeView addSubview:t2];
        [self.timeView  addSubview:hourshow];
        [self.timeView  addSubview:minutehow];
        [self.timeView  addSubview:secrodhow];
        [self.contentView addSubview:self.timeView];
        if(countDownTimer==nil&&secondsCountDown>0)
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 countDownAction
    }
    
}

@end
