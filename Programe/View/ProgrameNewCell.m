//
//  ProgrameNewCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/3/22.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "ProgrameNewCell.h"

@implementation ProgrameNewCell
{
    UIProgressView *processView;
    NSTimer * myTimer;
    
    UILabel * ysj;
    UILabel * yhx;
    UILabel * lilu;
    UILabel * shijian;
    UILabel *  jindu;
    UILabel * xianmumc;
    UIImageView  *_topLeftImg;
    float jinduv;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor=separaterColor;
    UIView * bgv=[[UIView alloc] init];
    bgv.frame=CGRectMake(0, 10, screen_width, 132);
    bgv.backgroundColor=[UIColor whiteColor];
    _topLeftImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 65, 15)];
    
    [_topLeftImg setImage:[UIImage imageNamed:@"Projectlist_tab_Novicespecial_"]];
    [bgv addSubview:_topLeftImg];
    
    xianmumc = [[UILabel alloc] initWithFrame:CGRectMake(85, 16,screen_width-85, 12)];
    xianmumc.font = CHINESE_SYSTEM(12);
    xianmumc.textAlignment=NSTextAlignmentLeft;
    xianmumc.textColor=RGB(51,51,51);
    xianmumc.text=@"宝马520质押贷款";
    [bgv addSubview:xianmumc];
    
    
    lilu= [[UILabel alloc] initWithFrame:CGRectMake(15, 49,140,30)];
    lilu.text=@"7.23%";
    lilu.textAlignment=NSTextAlignmentLeft;
    NSInteger index=[ lilu.text rangeOfString:@"%"].location;
    NSInteger len=[ lilu.text  length];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString: lilu.text];
    [textColor addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:30] range:NSMakeRange(0, index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,136,19) range:NSMakeRange(0, index)];
    [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(15) range:NSMakeRange(index,len-index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,136,19)  range:NSMakeRange(index, len-index)];
    [lilu setAttributedText:textColor];
    [bgv addSubview:lilu];
    
    
    shijian = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-30, 58,60, 15)];
    shijian.font = CHINESE_SYSTEM(15);
    shijian.textAlignment=NSTextAlignmentCenter;
    shijian.textColor=RGB(51,51,51);
    shijian.text=@"3天";
    [bgv addSubview:shijian];
    
    
    yhx = [[UILabel alloc] initWithFrame:CGRectMake(15, 105,150, 12)];
    yhx.font = CHINESE_SYSTEM(12);
    yhx.textAlignment=NSTextAlignmentLeft;
    yhx.textColor=RGB(158,158,158);
    yhx.text=@"月还息到期还本";
    [bgv addSubview:yhx];
    
    
    jindu = [[UILabel alloc] initWithFrame:CGRectMake(screen_width-60, 85,60, 12)];
    jindu.font = CHINESE_SYSTEM(12);
    jindu.textAlignment=NSTextAlignmentLeft;
    jindu.textColor=RGB(158,158,158);
    jindu.text=@"70%";
    [bgv addSubview:jindu];
    
    
    ysj = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-60, 105,120, 12)];
    ysj.font = CHINESE_SYSTEM(12);
    ysj.textAlignment=NSTextAlignmentCenter;
    ysj.textColor=RGB(158,158,158);
    ysj.text=@"剩余22,238元";
    NSInteger index1=[ysj.text rangeOfString:@"余"].location+1;
    NSInteger len1=[ysj.text  length];
    NSMutableAttributedString *textColor1 = [[NSMutableAttributedString alloc]initWithString: ysj.text];
    
    [textColor1 addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(12) range:NSMakeRange(0,index1)];
    [textColor1 addAttribute:NSForegroundColorAttributeName value:RGB(153,153,153)  range:NSMakeRange(0, index1)];
    [textColor1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:13] range:NSMakeRange(index1, 6)];
    [textColor1 addAttribute:NSForegroundColorAttributeName value:RGB(51,51,51) range:NSMakeRange(index1, 6)];
    
    [textColor1 addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(12) range:NSMakeRange(len1-1,1)];
    [textColor1 addAttribute:NSForegroundColorAttributeName value:RGB(51,51,51)  range:NSMakeRange(len1-1, 1)];
    [ysj setAttributedText:textColor1];
    [bgv addSubview:ysj];
    
    processView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    processView.frame = CGRectMake(15, 90,screen_width-85, 2);
    [processView setProgressTintColor:RGB(48,156,246)];
    [processView setTrackTintColor:RGB(210,219,210)];

    jinduv=0.7;
         [processView setProgress:0.0];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                               target:self
                                             selector:@selector(download)
                                             userInfo:nil
                                              repeats:YES];
    //添加该控件到视图View中
    [bgv addSubview:processView];
    [self addSubview:bgv];
    return self;
}

- (void)download
{
    processView.progress += 0.1; // 设定步进长度
      jindu.text=[[NSString stringWithFormat:@"%.0f",processView.progress*100] stringByAppendingString:@"%"];
    if (processView.progress >= jinduv) {// 如果进度条到头了
        // 终止定时器
        [myTimer invalidate];
    }
}
-(void)setProgrameNewModel:(ProgrameNewModel *)model
{

     jinduv=[model.jindu floatValue];
    // 定时器方法：在一个特定的时间间隔后向某对象发送消息
    // target 为发送消息给哪个对象
    // timeinterval 间隔时间
    // selector 要调用的方法名
    // userinfo 给消息发送的参数
    // repeats 是否重复
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                               target:self
                                             selector:@selector(download)
                                             userInfo:nil
                                              repeats:YES];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)hanleNums:(NSString *)numbers{
    NSString *str = [numbers substringWithRange:NSMakeRange(numbers.length%3, numbers.length-numbers.length%3)];
    NSString *strs = [numbers substringWithRange:NSMakeRange(0, numbers.length%3)];
    for (int  i =0; i < str.length; i =i+3) {
        NSString *sss = [str substringWithRange:NSMakeRange(i, 3)];
        strs = [strs stringByAppendingString:[NSString stringWithFormat:@",%@",sss]];
    }
    if ([[strs substringWithRange:NSMakeRange(0, 1)] isEqualToString:@","]) {
        strs = [strs substringWithRange:NSMakeRange(1, strs.length-1)];
    }
    
    return strs;
}

@end
