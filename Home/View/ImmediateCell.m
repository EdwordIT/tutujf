//
//  ImmediateCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/3/12.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "ImmediateCell.h"


@implementation ImmediateCell
{
    UIImageView * rightimg;
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=separaterColor;
        [self initViews];
    }
    return self;
}

-(void)initViews {
    UIView * bgv=[[UIView alloc] initWithFrame:CGRectMake(10, 0, screen_width-20, 190)];
    bgv.backgroundColor=RGB(255, 255, 255);
  //  bgv.layer.shadowColor=[UIColor grayColor].CGColor;
  //  bgv.layer.shadowOffset=CGSizeMake(1,1);
   // bgv.layer.shadowOpacity=0.5;
   // bgv.layer.shadowRadius=2;
    
    UILabel * lab1= [[UILabel alloc] initWithFrame:CGRectMake((screen_width-30)/2-80, 21,100, 15)];
    lab1.font = CHINESE_SYSTEM(15);
    lab1.textColor=RGB(102,102,102);
    lab1.text=@"新手体验标";
    lab1.textAlignment=NSTextAlignmentCenter;
    [bgv addSubview:lab1];
    
    rightimg=[[UIImageView alloc] initWithFrame:CGRectMake((screen_width-30)/2+20, 18, 58, 19)];
    [rightimg setImage:[UIImage imageNamed:@"xinshouzx"]];
    [bgv addSubview:rightimg];
    
    _shouyi= [[UILabel alloc] initWithFrame:CGRectMake((screen_width-30)/2-120, 58,240,36)];
    _shouyi.text=@"13.20%";
    _shouyi.textAlignment=NSTextAlignmentCenter;
    NSInteger index=[ _shouyi.text rangeOfString:@"."].location;
    NSInteger len=[ _shouyi.text  length];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString: _shouyi.text];
    [textColor addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:36] range:NSMakeRange(0, index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,46,19) range:NSMakeRange(0, index)];
    [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(14) range:NSMakeRange(index,len-index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,46,19)  range:NSMakeRange(index, len-index)];
    [_shouyi setAttributedText:textColor];
    [bgv addSubview:_shouyi];

    //xinshouzx
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(154, 21, 0.4f, 17)];
    lineView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.05];
    [self.contentView addSubview:lineView];
    
    UILabel * lab2= [[UILabel alloc] initWithFrame:CGRectMake(0, 108,(screen_width-30)/2-40, 12)];
    lab2.font = CHINESE_SYSTEM(12);
    lab2.textColor=RGB(184,184,184);
     lab2.textAlignment=NSTextAlignmentRight;
    lab2.text=@"最低投资金额";
    [bgv addSubview:lab2];
    
     self.shengyueje= [[UILabel alloc] initWithFrame:CGRectMake((screen_width-30)/2-35, 108,50, 12)];
     self.shengyueje.font = CHINESE_SYSTEM(12);
    self.shengyueje.textColor=RGB(54,54,54);
     self.shengyueje.textAlignment=NSTextAlignmentLeft;
     self.shengyueje.text=@"50.00元";
    [bgv addSubview: self.shengyueje];

    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake((screen_width-30)/2+18, 105, 0.4f, 17)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.05];
    [bgv  addSubview:lineView1];
    
    //
    UILabel * lab3= [[UILabel alloc] initWithFrame:CGRectMake((screen_width-30)/2+26, 108,100, 12)];
    lab3.font = CHINESE_SYSTEM(12);
    lab3.textColor=RGB(184,184,184);
    lab3.text=@"投资时间";
   lab3.textAlignment=NSTextAlignmentLeft;
    [bgv addSubview:lab3];
    
    
    self.xianmuqx= [[UILabel alloc] initWithFrame:CGRectMake((screen_width-30)/2+82, 108,50, 12)];
    self.xianmuqx.font = CHINESE_SYSTEM(12);
    self.xianmuqx.textColor=RGB(54,54,54);
    self.xianmuqx.text=@"2个月";
    self.xianmuqx.textAlignment=NSTextAlignmentLeft;
    [bgv addSubview:self.xianmuqx];
    
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake((screen_width-30)/2-100,140,200, 32);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = RGB(255,46,18).CGColor;
    
    [btn1.layer setBorderColor:colorref];//边框颜色
    
    //[btn1 setImage:[UIImage imageNamed:@"gogo.png"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(button_event:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag=1;
    [btn1 setTitle:@"新手抢购" forState:UIControlStateNormal];//button title
  //  [btn1 setFont:CHINESE_SYSTEM(13)];
     [btn1.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//title color
    
    btn1.backgroundColor=RGB(255, 46, 18);
    [btn1.layer setCornerRadius:16]; //设置矩形四个圆角半径
    [btn1.layer setBorderWidth:0.5]; //边框宽度
    [bgv addSubview:btn1];

    
    [self.contentView addSubview:bgv];

}

-(void)button_event:(UIButton*) sender
{
    [self.delegate didSelectedImmediateAtIndex:sender.tag];
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
  //  strs = [strs stringByAppendingString:@".00"];
    return strs;
}

-(void)setImmediateModel:(ImmediateModel *)model {
    //_hotQueue = hotQueue;
     if([model.additional_status isEqual:@"0"])
         return ;
     self.shouyi.text=[model.apr stringByAppendingString:@"%"];
    self.shengyueje.text=[model.tender_amount_min stringByAppendingString:@"元"];
    CGFloat f=[model.additional_apr floatValue];
     self.xianmuqx.text=model.period;
    if(f==0)
    {
  
    NSInteger index=[ _shouyi.text rangeOfString:@"."].location;
    NSInteger len=[ _shouyi.text  length];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString: _shouyi.text];
    [textColor addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:36] range:NSMakeRange(0, index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,46,19) range:NSMakeRange(0, index)];
    [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(14) range:NSMakeRange(index,len-index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,46,19)  range:NSMakeRange(index, len-index)];
    [_shouyi setAttributedText:textColor];
    }
    else
    {
      NSString * ff=[NSString stringWithFormat:@"%.2f",f];
        NSString * temp=model.apr;
        temp=[temp stringByAppendingString:@"%"];
       temp=[temp stringByAppendingString:@"+"];
     temp=[temp stringByAppendingString:ff];
       temp=[temp stringByAppendingString:@"%"];
          self.shouyi.text=temp;
        NSInteger index=[ _shouyi.text rangeOfString:@"+"].location;
           NSInteger index1=[ff rangeOfString:@"."].location;
        NSInteger len=[ _shouyi.text  length];
        NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString: _shouyi.text];
        [textColor addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:36] range:NSMakeRange(0, index-4)];
        [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,46,19) range:NSMakeRange(0, index-4)];
        [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(14) range:NSMakeRange(index-4,5)];
        [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,46,19)  range:NSMakeRange(index-4, 5)];
        [textColor addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:36] range:NSMakeRange(index+1, index1)];
        [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,46,19) range:NSMakeRange(index+1, index1)];
        [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(14) range:NSMakeRange(index+1+index1,len-(index+1+index1))];
        [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,46,19)  range:NSMakeRange(index+1+index1,len-(index+1+index1))];
        
        [_shouyi setAttributedText:textColor];
    }
   
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
