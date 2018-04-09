//
//  OneDetailTopCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/4/11.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "OneDetailTopCell.h"


@implementation OneDetailTopCell
{

    UILabel * _shouyi;
    UILabel * xmzonger;
    UILabel  * xmqixian;
    UIProgressView *processView;
    NSTimer * myTimer;
     UILabel * jindu;
    
    UILabel * syktje;
    UILabel *  yuan ;
    float jinduv;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self initView];
    
    
    return self;
}

-(void)initView
{
    [self firstView];
     [self initBottom];
}

-(void)firstView
{
  
    
    UIView * uv=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 140)];
    uv.backgroundColor= RGB(6, 159, 241);
    
    _shouyi= [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-106, 32,140,36)];
    _shouyi.text=@"7.23%";
    _shouyi.textAlignment=NSTextAlignmentLeft;
    NSInteger index=[ _shouyi.text rangeOfString:@"%"].location;
    NSInteger len=[ _shouyi.text  length];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString: _shouyi.text];
    [textColor addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:36] range:NSMakeRange(0, index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,255,255) range:NSMakeRange(0, index)];
    [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(12) range:NSMakeRange(index,len-index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,255,255)  range:NSMakeRange(index, len-index)];
    [_shouyi setAttributedText:textColor];
    [uv addSubview:_shouyi];
    
     UIView * line=[[UIView alloc] initWithFrame:CGRectMake(screen_width/2, 44, 0.8, 40)];
      line.backgroundColor=RGB(141,200,255);
     [uv addSubview:line];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-106, 70,106, 12)];
    lab1.font = CHINESE_SYSTEM(12);
    lab1.textAlignment=NSTextAlignmentLeft;
    lab1.textColor=RGB(141,200,255);
    lab1.text=@"预期年化收益";
    [uv addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2+16, 45,60, 12)];
    lab2.font = CHINESE_SYSTEM(12);
    lab2.textAlignment=NSTextAlignmentLeft;
    lab2.textColor=RGB(141,200,255);
    lab2.text=@"项目期限";
    [uv addSubview:lab2];
    
    //
    
    xmqixian = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2+80, 45,60, 15)];
    xmqixian.font = CHINESE_SYSTEM(15);
    xmqixian.textAlignment=NSTextAlignmentLeft;
    xmqixian.textColor=RGB(255,255,255);
    xmqixian.text=@"3个月";
    [uv addSubview:xmqixian];
    
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2+16, 70,106, 12)];
    lab3.font = CHINESE_SYSTEM(12);
    lab3.textAlignment=NSTextAlignmentLeft;
    lab3.textColor=RGB(141,200,255);
    lab3.text=@"项目总额";
    [uv addSubview:lab3];
    
    xmzonger = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2+80, 70,90, 12)];
    xmzonger.font = CHINESE_SYSTEM(12);
    xmzonger.textAlignment=NSTextAlignmentLeft;
    xmzonger.textColor=RGB(141,200,255);
    xmzonger.text=@"3,000,0000元";
    [uv addSubview:xmzonger];
    
    UIView *  backBg1 = [[UIView alloc] initWithFrame:CGRectMake(15, 0,screen_width-30, 84)];
    backBg1.backgroundColor =[UIColor clearColor];
    backBg1.tag=2;
      backBg1.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBack:)];
    [uv addGestureRecognizer:tap1];
    
    
    jindu = [[UILabel alloc] initWithFrame:CGRectMake(0, 124,50, 12)];
    jindu.font = CHINESE_SYSTEM(12);
    jindu.textAlignment=NSTextAlignmentLeft;
    jindu.textColor=RGB(193,255,240);
    jindu.text=@"已售0%";
    [uv addSubview:jindu];
    //
    processView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    processView.frame = CGRectMake(0, 138,screen_width, 2);
    [processView setProgressTintColor:RGB(44,214,249)];
    [processView setTrackTintColor:RGB(32,149,244)];
    [processView setProgress:0.0];
    jinduv=0.6;
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
      UIView * bottom=[[UIView alloc] initWithFrame:CGRectMake(0, 140, screen_width, 50)];
    bottom.backgroundColor= RGB(37,142,233);
    UILabel *  lab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 19,60,12)];
    lab1.font =  CHINESE_SYSTEM(12);
    lab1.textColor =  RGB(141,200,255);
    lab1.text=@"剩余可投";
    lab1.textAlignment=NSTextAlignmentLeft;
    [bottom addSubview:lab1];
    
    
    syktje= [[UILabel alloc] initWithFrame:CGRectMake(5, 19,200,13)];
    syktje.font =  CHINESE_SYSTEM(13);
    syktje.textColor =  [UIColor whiteColor];
    syktje.text=@"569,998.00";
    syktje.textAlignment=NSTextAlignmentCenter;
    [bottom addSubview:syktje];
    
    yuan = [[UILabel alloc] initWithFrame:CGRectMake(66+([syktje.text length]-1)*9, 19,16,12)];
    yuan.font =  CHINESE_SYSTEM(12);
    yuan.textColor =RGB(128,200,255);
    yuan.text=@"元";
    yuan.textAlignment=NSTextAlignmentLeft;
    
    UILabel *  lab2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width-75, 19,70,12)];
    lab2.font =  CHINESE_SYSTEM(12);
    lab2.textColor =  RGB(141,200,255);
    lab2.text=@"300元起投";
    lab2.textAlignment=NSTextAlignmentLeft;
    [bottom addSubview:lab2];
    
    bottom.tag=2;
    bottom.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBack:)];
    [bottom addGestureRecognizer:tap];
    
    [bottom addSubview:yuan];
     [self addSubview:bottom];
    
  
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

-(void)OnTapBack:(id)sender{
  UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    
    [self.delegate didSelectedDetailAtIndex:singleTap.view.tag];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)download
{
    processView.progress += 0.01; // 设定步进长度
    jindu.text=[[NSString stringWithFormat:@"已售%.0f",processView.progress*100] stringByAppendingString:@"%"];
    CGFloat xx=processView.progress*screen_width-50;
    jindu.frame=CGRectMake(xx, 124, 50, 12);
    CGFloat rr=44+processView.progress*176;
    CGFloat  gg=214+processView.progress*39;
     [processView setProgressTintColor:RGB(rr,gg,252)];
    if (processView.progress >= jinduv) {// 如果进度条到头了
        // 终止定时器
        [myTimer invalidate];
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
@end
