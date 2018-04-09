//
//  DetailTop.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DetailTop.h"
#import "OneDetailModel.h"
@interface DetailTop ()
{
    UILabel * _shouyi;
    UILabel * xmzonger;
    UILabel  * xmqixian;
    UIProgressView *processView;
    NSTimer * myTimer;
    UILabel * jindu;
    
    UILabel * syktje;
    UILabel *  yuan ;
    CGFloat jinduv;
    LoanBase * model;
}
@end

@implementation DetailTop

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame data:(LoanBase *) data{
    self = [super initWithFrame:frame];
    if (self) {
        model=data;
        [self initView];
    }
    return self;
}
-(void)initView
{
    [self firstView];
    [self initBottom];
}

-(void)firstView
{
    LoanInfo * info=model.loan_info;
    UIView * uv=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 134)];
    uv.backgroundColor= RGB(6, 159, 241);
//    uv.backgroundColor= navigationBarColor;

    _shouyi= [[UILabel alloc] initWithFrame:CGRectMake(40, 32,140,24)];
    _shouyi.text=[[NSString stringWithFormat:@"%@",info.apr] stringByAppendingString:@"%"];
    _shouyi.textAlignment=NSTextAlignmentLeft;
    NSInteger index=[ _shouyi.text rangeOfString:@"%"].location;
    NSInteger len=[ _shouyi.text  length];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString: _shouyi.text];
    [textColor addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:24] range:NSMakeRange(0, index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,255,255) range:NSMakeRange(0, index)];
    [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(12) range:NSMakeRange(index,len-index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,255,255)  range:NSMakeRange(index, len-index)];
    [_shouyi setAttributedText:textColor];
    [uv addSubview:_shouyi];
    
    UIView * line=[[UIView alloc] initWithFrame:CGRectMake(screen_width/2-40, 30, 0.8, 50)];
    line.backgroundColor=RGB(141,200,255);
    [uv addSubview:line];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 60,106, 14)];
    lab1.font = CHINESE_SYSTEM(14);
    lab1.textAlignment=NSTextAlignmentLeft;
    lab1.textColor=RGB(141,200,255);
    lab1.text=@"预期利率";
    [uv addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-12, 36,106, 14)];
    lab2.font = CHINESE_SYSTEM(14);
    lab2.textAlignment=NSTextAlignmentLeft;
    lab2.textColor=RGB(141,200,255);
    lab2.text=@"项目期限";
    [uv addSubview:lab2];
    
    //
    
    xmqixian = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2+50, 36,60, 15)];
    xmqixian.font = CHINESE_SYSTEM(15);
    xmqixian.textAlignment=NSTextAlignmentLeft;
    xmqixian.textColor=RGB(255,255,255);
    xmqixian.text=info.period_name;
    [uv addSubview:xmqixian];
    
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-12, 60,106, 14)];
    lab3.font = CHINESE_SYSTEM(14);
    lab3.textAlignment=NSTextAlignmentLeft;
    lab3.textColor=RGB(141,200,255);
    lab3.text=@"项目总额";
    [uv addSubview:lab3];
    
    xmzonger = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2+50, 60,screen_width/2-50, 15)];
    xmzonger.font = CHINESE_SYSTEM(15);
    xmzonger.textAlignment=NSTextAlignmentLeft;
    xmzonger.textColor=RGB(255,255,255);
    xmzonger.text=[NSString stringWithFormat:@"%@元",[self hanleNums:info.amount]];
     index=[xmzonger.text rangeOfString:@"元"].location-1;
     len=[ xmzonger.text  length];
    NSMutableAttributedString *textColor1 = [[NSMutableAttributedString alloc]initWithString: xmzonger.text];
    [textColor1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:15] range:NSMakeRange(0, index)];
    [textColor1 addAttribute:NSForegroundColorAttributeName value:RGB(255,255,255) range:NSMakeRange(0, index)];
    [textColor1 addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(15) range:NSMakeRange(len-1, 1)];
    [textColor1 addAttribute:NSForegroundColorAttributeName value:RGB(111,187,255) range:NSMakeRange(len-1, 1)];
    [xmzonger setAttributedText:textColor1];
    [uv addSubview:xmzonger];
    
    jindu = [[UILabel alloc] initWithFrame:CGRectMake(screen_width-70, 112,70, 12)];
    jindu.font = CHINESE_SYSTEM(12);
    jindu.textAlignment=NSTextAlignmentLeft;
    jindu.textColor=RGB(179,254,246);
    jindu.text=@"已售0%";
    [uv addSubview:jindu];
    //
    processView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    processView.frame = CGRectMake(0, 132,screen_width,6);
    [processView setProgressTintColor:RGB(44,214,249)];
    [processView setTrackTintColor:RGB(32,149,244)];
    [processView setProgress:0.0];
    NSString *   numbers=[info.progress stringByReplacingOccurrencesOfString:@".00" withString:@""];
    jinduv=[numbers floatValue]/100;
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                               target:self
                                             selector:@selector(download)
                                             userInfo:nil
                                              repeats:YES];
    //添加该控件到视图View中
    [uv addSubview:processView];
    
    //
    
    [self addSubview:uv];
    
    
    
}

-(void) initBottom
{
    LoanInfo * info=model.loan_info;
    UIView * bottom=[[UIView alloc] initWithFrame:CGRectMake(0, 134, screen_width, 42)];
    bottom.backgroundColor= RGB(37,142,233);
    syktje = [[UILabel alloc] initWithFrame:CGRectMake(10, 15,screen_width/2+100,14)];
    syktje.font =  CHINESE_SYSTEM(14);
    syktje.textColor =  RGB(111,187,255);
    syktje.text=[NSString stringWithFormat:@"剩余可投%@元",info.left_amount];
    syktje.textAlignment=NSTextAlignmentLeft;
    NSInteger index=[syktje.text rangeOfString:@"投"].location+1;
    NSInteger len=[ syktje.text  length];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString: syktje.text];
    [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(14) range:NSMakeRange(0, index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(111,187,255) range:NSMakeRange(0, index)];
    [textColor addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:14]  range:NSMakeRange(index,len-index-1)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,255,255) range:NSMakeRange(index, len-index-1)];
    [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(14) range:NSMakeRange(len-1, 1)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(111,187,255) range:NSMakeRange(len-1, 1)];
    [syktje setAttributedText:textColor];
    [bottom addSubview:syktje];
    

    
    yuan= [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2, 15,screen_width/2-10,14)];
    yuan.font =  CHINESE_SYSTEM(14);
    yuan.textColor =  RGB(141,200,255);
    yuan.text=[NSString stringWithFormat:@"已经有%@位投资人",info.tender_count];
    yuan.textAlignment=NSTextAlignmentRight;
    
     index=[ yuan.text rangeOfString:@"有"].location+1;
     len=[ yuan.text  length];
      NSInteger lw=[ yuan.text rangeOfString:@"位"].location;
    NSInteger ww=lw-index;
  
    NSMutableAttributedString *textColor1= [[NSMutableAttributedString alloc]initWithString: yuan.text];
    [textColor1 addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(14) range:NSMakeRange(0, index)];
    [textColor1 addAttribute:NSForegroundColorAttributeName value:RGB(111,187,255) range:NSMakeRange(0, index)];
    [textColor1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:14]  range:NSMakeRange(index,ww)];
    [textColor1 addAttribute:NSForegroundColorAttributeName value:RGB(255,255,255) range:NSMakeRange(index, ww)];
    [textColor1 addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(14) range:NSMakeRange(lw, len-lw)];
    [textColor1 addAttribute:NSForegroundColorAttributeName value:RGB(111,187,255) range:NSMakeRange(lw, len-lw)];
    [yuan setAttributedText:textColor1];
    [bottom addSubview:yuan];
    
    bottom.tag=2;
    bottom.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBack:)];
    [bottom addGestureRecognizer:tap];
    
    [bottom addSubview:yuan];
    [self addSubview:bottom];
    
    
}
-(void)OnTapBack:(UIView *)sender{
    
   // [self.delegate didMyMiddleAtIndex:sender.tag];
}


-(void)setModel:(OneDetailModel *)model
{
    
    _shouyi.text=model.nianhuasy;
    NSInteger index=[ _shouyi.text rangeOfString:@"%"].location;
    NSInteger len=[ _shouyi.text  length];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString: _shouyi.text];
    [textColor addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:36] range:NSMakeRange(0, index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,255,255) range:NSMakeRange(0, index)];
    [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(12) range:NSMakeRange(index,len-index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,255,255)  range:NSMakeRange(index, len-index)];
    [_shouyi setAttributedText:textColor];
    
    jindu.frame=CGRectMake(0, 124, 50, 12);
    jinduv=[model.xmjindu floatValue];
    [processView setProgress:0.0];
    [processView setProgressTintColor:RGB(44,214,249)];
    // 定时器方法：在一个特定的时间间隔后向某对象发送消息
    // target 为发送消息给哪个对象
    // timeinterval 间隔时间
    // selector 要调用的方法名
    // userinfo 给消息发送的参数
    // repeats 是否重复
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                               target:self
                                             selector:@selector(download)
                                             userInfo:nil
                                              repeats:YES];
    
    xmzonger.text=[NSString stringWithFormat:@"%@元",[self countNumAndChangeformat:model.xmzonger]];
    
    syktje.text=[NSString stringWithFormat:@"%@.00",[self countNumAndChangeformat:@"56998"]];
    yuan.frame =CGRectMake(66+([syktje.text length]-1)*9, 19,16,12);
    
}

- (void)download
{
    if(jinduv==0||jinduv<0.01)
    {
          CGFloat xx=processView.progress*screen_width-50;
         jindu.frame=CGRectMake(xx+60, 112,70, 12);
        jindu.text=[[NSString stringWithFormat:@"已售%.2f",processView.progress*100] stringByAppendingString:@"%"];
        CGFloat rr=44+processView.progress*176;
        CGFloat  gg=214+processView.progress*39;
        [processView setProgressTintColor:RGB(rr,gg,252)];
        [myTimer invalidate];
    }
    else{
    processView.progress += 0.01; // 设定步进长度
    jindu.text=[[NSString stringWithFormat:@"已售%.2f",processView.progress*100] stringByAppendingString:@"%"];
    CGFloat xx=processView.progress*screen_width-50;
    if(processView.progress>0.05)
    jindu.frame=CGRectMake(xx, 112,70, 12);
    else
    jindu.frame=CGRectMake(xx+60, 112,70, 12);
    CGFloat rr=44+processView.progress*176;
    CGFloat  gg=214+processView.progress*39;
    [processView setProgressTintColor:RGB(rr,gg,252)];
    if (processView.progress >= jinduv) {// 如果进度条到头了
        // 终止定时器
        if(jinduv==1.0f)
           jindu.frame=CGRectMake(screen_width-70, 112,70, 12);
        [myTimer invalidate];
        if(jinduv!=1)
        jindu.text=[[NSString stringWithFormat:@"已售%.2f",jinduv*100] stringByAppendingString:@"%"];
        else
         jindu.text=[[NSString stringWithFormat:@"已售%.1f",jinduv*100] stringByAppendingString:@"%"];
    }
    }
}


-(NSString *)countNumAndChangeformat:(NSString *)num{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSString *)hanleNums:(NSString *)numbers{
     numbers=[numbers stringByReplacingOccurrencesOfString:@".00" withString:@""];
    NSString *str = [numbers substringWithRange:NSMakeRange(numbers.length%3, numbers.length-numbers.length%3)];
    NSString *strs = [numbers substringWithRange:NSMakeRange(0, numbers.length%3)];
    for (int  i =0; i < str.length; i =i+3) {
        NSString *sss = [str substringWithRange:NSMakeRange(i, 3)];
        strs = [strs stringByAppendingString:[NSString stringWithFormat:@",%@",sss]];
    }
    if ([[strs substringWithRange:NSMakeRange(0, 1)] isEqualToString:@","]) {
        strs = [strs substringWithRange:NSMakeRange(1, strs.length-1)];
    }
    strs = [strs stringByAppendingString:@".00"];
    return strs;
}

@end
