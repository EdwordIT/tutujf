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
    UILabel * jindu;
    UIProgressView *processView;
     float jinduv;
    Boolean isfinish;
    UILabel * lab5;
    UIImageView  * imghk;
    UIButton* btn1;

    NSInteger secondsCountDown;//倒计时总时长
    NSTimer *countDownTimer;
    UILabel * kaiqian;
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

    self.title= [[UILabel alloc] initWithFrame:CGRectMake(15, 20,screen_width-55, 15)];
    self.title.font = CHINESE_SYSTEM(15);
    self.title.textColor=RGB(51,51,51);
    self.title.text=@"宝马0214-02（温州总部）";
    self.title.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview: self.title];


    self.yuqiinh= [[UILabel alloc] initWithFrame:CGRectMake(10, 51,70,20)];
    self.yuqiinh.text=@"8.23%";
    self.yuqiinh.textAlignment=NSTextAlignmentCenter;
    NSInteger index=[  self.yuqiinh.text rangeOfString:@"%"].location;
    NSInteger len=[  self.yuqiinh.text  length];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:  self.yuqiinh.text];
    [textColor addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:20] range:NSMakeRange(0, index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,48,19) range:NSMakeRange(0, index)];
    [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(13) range:NSMakeRange(index,len-index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,48,19)  range:NSMakeRange(index, len-index)];
    [ self.yuqiinh setAttributedText:textColor];
    [self.contentView addSubview: self.yuqiinh];
    
    
    
    UILabel * lab2= [[UILabel alloc] initWithFrame:CGRectMake(10, 75,70, 12)];
    lab2.font = CHINESE_SYSTEM(12);
    lab2.textColor=RGB(153,153,153);
    lab2.textAlignment=NSTextAlignmentCenter;
    lab2.text=@"年化收益率";
    //   [lab2 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [self.contentView addSubview:lab2];
    
    self.yuqisj= [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-25, 55,50, 15)];
    self.yuqisj.font = CHINESE_SYSTEM(15);
    self.yuqisj.textColor=RGB(51,51,51);
    self.yuqisj.text=@"2个月";
    self.yuqisj.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.yuqisj];
    //
    UILabel * lab3= [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-25, 75,50, 12)];
  lab3.font = CHINESE_SYSTEM(12);
    lab3.textColor=RGB(153,153,153);
    lab3.text=@"理财期限";
    //[lab3 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    lab3.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:lab3];
    
    lab5= [[UILabel alloc] initWithFrame:CGRectMake(screen_width-135, 98,120, 12)];
    lab5.font = CHINESE_SYSTEM(12);
    lab5.text=@"到期还本利息";
    lab5.textAlignment= NSTextAlignmentRight;
    [self.contentView addSubview:lab5];
    
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(screen_width-81,50, 66, 28);
    //  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref =navigationBarColor.CGColor;
    
    [btn1.layer setBorderColor:colorref];//边框颜色
    
    //[btn1 setImage:[UIImage imageNamed:@"gogo.png"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(button_event:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag=1;
    [btn1 setTitle:@"抢购" forState:UIControlStateNormal];//button title
    [btn1.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [btn1 setTitleColor:RGB(255,255,255) forState:UIControlStateNormal];//title color
    
    btn1.backgroundColor=RGB(255,46,18);
    [btn1.layer setCornerRadius:14]; //设置矩形四个圆角半径
    [btn1.layer setBorderWidth:0.0]; //边框宽度
    [self.contentView addSubview:btn1];
    
    imghk= [[UIImageView alloc] initWithFrame:CGRectMake(screen_width*3/4-10, 10,74, 74)];
    [ imghk setImage:[UIImage imageNamed:@"huankuanz"]];
    [self.contentView addSubview:imghk];//huankuanz
    
    if(isfinish)
    {
        [btn1 setHidden:FALSE];
     [imghk setHidden:TRUE];
    lab5.textColor=RGB(51,51,51);
    
    }
    else{
        lab5.textColor=RGB(183,183,183);
        [imghk setHidden:FALSE];
          [btn1 setHidden:TRUE];
        
    }
   
    jindu = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2+12, 98,80, 12)];
    jindu.font = CHINESE_SYSTEM(12);
    jindu.textAlignment=NSTextAlignmentLeft;
    jindu.textColor=RGB(158,158,158);
    jindu.text=@"进度 70%";
    [self.contentView addSubview:jindu];
    
    processView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    processView.frame = CGRectMake(15, 105,screen_width/2-15, 6);
    [processView setProgressTintColor:RGB(48,156,246)];
    [processView setTrackTintColor:RGB(231,231,231)];
    
    jinduv=0.7;
    
    if(IS_IPHONE5)
    {
          jindu.frame =CGRectMake(screen_width/2-18, 98,80, 12);
            processView.frame = CGRectMake(15, 105,screen_width/2-45, 6);
    }
 
    //添加该控件到视图View中
    [self.contentView addSubview:processView];
    
    UIView * bottom=[[UIView alloc] initWithFrame:CGRectMake(0, 125, screen_width, 10)];
    bottom.backgroundColor= separaterColor;
      [self.contentView addSubview:bottom];
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
        [processView setHidden:FALSE];
        [kaiqian setHidden:TRUE];
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
    if (processView.progress >= jinduv) {// 如果进度条到头了
        // 终止定时器
        [myTimer invalidate];
          return  ;
    }
  
      
    processView.progress += 0.04; // 设定步进长度
    //jindu.text=[[NSString stringWithFormat:@"进度:%.0f",processView.progress*100] stringByAppendingString:@"%"];
  // CGFloat xx=processView.progress*(screen_width/2)-50;
    //jindu.frame=CGRectMake(xx, 124, 50, 12);
   // CGFloat rr=44+processView.progress*176;
    CGFloat  gg=83+processView.progress*78;
    [processView setProgressTintColor:RGB(0,gg,239)];
    
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
    {
        isfinish=YES;
    }
    else
    {   isfinish=NO;}
    jinduv=[model.progress intValue]/100;
   secondsCountDown = [self getDifferenceByDate:model.open_up_date];//倒计时秒数(48小时换算成的秒数,项目中需要从服务器获取)
    if(isfinish)
    {
           lab5.textColor=RGB(153,153,153);
           self.yuqiinh.textColor=RGB(153,153,153);
         self.yuqisj.textColor=RGB(153,153,153);
            self.title.textColor=RGB(153,153,153);
           jindu.textColor=RGB(158,158,158);
        [imghk setHidden:FALSE];
        [btn1 setHidden:TRUE];
       
         [processView setProgress:1.0];
            [processView setProgressTintColor:RGB(211,211,211)];
       
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
        self.yuqiinh.textColor=RGB(255,48,19);
            self.yuqisj.textColor=RGB(51,51,51);
            self.title.textColor=RGB(51,51,51);
         jindu.textColor=RGB(51,51,51);
        [btn1 setHidden:FALSE];
        [imghk setHidden:TRUE];
        if(![model.open_up_status isEqual:@"-1"])
        {
        [processView setProgress:0.0];
        [processView setProgressTintColor:RGB(48,156,246)];
        jinduv=[model.progress floatValue]/100;
       
         myTimer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                                   target:self
                                                 selector:@selector(download)
                                                 userInfo:nil
                                                  repeats:YES];
        }
        else
        {
            if(secondsCountDown>0)
            [processView setHidden:TRUE];
            else
            {
                [processView setProgress:0.0];
                [processView setProgressTintColor:RGB(48,156,246)];
                jinduv=[model.progress floatValue]/100;
                
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
     self.yuqisj.text=[NSString stringWithFormat:@"%@",model.period];
    jindu.text= [[NSString stringWithFormat:@"进度%@",model.progress] stringByAppendingString:@"%"];
    CGFloat f=[model.additional_apr floatValue];
    if(f==0)
    {
         self.yuqiinh.textAlignment=NSTextAlignmentCenter;
         self.yuqiinh.frame=CGRectMake(10, 51,70,20);
        NSString * temp=model.apr;
        temp=[temp stringByAppendingString:@"%"];
         self.yuqiinh.text=temp;
        NSInteger index=[ self.yuqiinh.text rangeOfString:@"%"].location;
        NSInteger len=[ self.yuqiinh.text  length];
        NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString: self.yuqiinh.text];
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
        [self.yuqiinh setAttributedText:textColor];
    }
    else
    {
        NSString * ff=[NSString stringWithFormat:@"%.2f",f];
        NSString * temp=model.apr;
        temp=[temp stringByAppendingString:@"%"];
        temp=[temp stringByAppendingString:@"+"];
        temp=[temp stringByAppendingString:ff];
        temp=[temp stringByAppendingString:@"%"];
        self.yuqiinh.text=temp;
        self.yuqiinh.frame=CGRectMake(10, 51,180,20);
        self.yuqiinh.textAlignment=NSTextAlignmentLeft;
        NSInteger index=[ self.yuqiinh.text rangeOfString:@"+"].location;
        NSInteger index1=[ff rangeOfString:@"."].location;
        NSInteger len=[ self.yuqiinh.text  length];
        NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString: self.yuqiinh.text];
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
        
        [self.yuqiinh setAttributedText:textColor];
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
           [processView setHidden:TRUE];
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
    if(kaiqian==nil)
    {
    kaiqian=[[UILabel alloc] initWithFrame:CGRectMake(15, 100, 90, 12)];
    kaiqian.font = CHINESE_SYSTEM(12);
    kaiqian.textAlignment=NSTextAlignmentLeft;
    kaiqian.textColor=RGB(102,102,102);
    kaiqian.text=@"距离开抢还剩";
    [self.contentView addSubview:kaiqian];
    }
    if( self.timeView==nil)
    self.timeView = [[UIView alloc] initWithFrame:CGRectMake(100, 94, 90, 20)];
     
    hourshow=[self getTimeShowView:str_hour index:0];
    minutehow=[self getTimeShowView:str_minute index:1];
    secrodhow=[self getTimeShowView:str_second index:2];
     if(hour>100)
     {
      self.timeView.frame=CGRectMake(90, 94, 105, 20);
         
         hourshow.frame=CGRectMake(0, 0, 37, 20);
          minutehow.frame=CGRectMake(46, 0, 22, 20);
           secrodhow.frame=CGRectMake(77, 0, 22, 20);
    }
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
