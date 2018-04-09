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
        self.backgroundColor=[UIColor whiteColor];
        [self initViews];
    }
    return self;
}

-(void)initViews {

   UIImageView * leftImage=[[UIImageView alloc] initWithFrame:CGRectMake(kSizeFrom750(160), kSizeFrom750(290), kSizeFrom750(75), kSizeFrom750(25))];
    [leftImage setImage:[UIImage imageNamed:@"wings_left"]];
    [self.contentView addSubview:leftImage];
    
    
    UILabel * lab1=  [[UILabel alloc] initWithFrame:CGRectMake(leftImage.right, leftImage.top - kSizeFrom750(5),kSizeFrom750(280),kSizeFrom750(30))];
    lab1.font = SYSTEMBOLDSIZE(32);
    lab1.textColor=RGB(102,102,102);
    NSAttributedString *attr = [CommonUtils diffierentFontWithString:@"新手专享 为您特供" rang:NSMakeRange(0, 4) font:SYSTEMBOLDSIZE(32) color:COLOR_Red spacingBeforeValue:0 lineSpace:0];
    lab1.attributedText=attr;
    lab1.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:lab1];
    
    rightimg=[[UIImageView alloc] initWithFrame:CGRectMake(screen_width - kSizeFrom750(160)- kSizeFrom750(75), leftImage.top, leftImage.width, leftImage.height)];
    [rightimg setImage:[UIImage imageNamed:@"wings_right"]];
    [self.contentView addSubview:rightimg];
    
    _incomeLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, lab1.bottom+kSizeFrom750(40),kSizeFrom750(200),kSizeFrom750(55))];
    _incomeLabel.centerX = lab1.centerX;
    NSString *percentage = @"13.20%";
    _incomeLabel.textAlignment=NSTextAlignmentCenter;
    _incomeLabel.font = SYSTEMBOLDSIZE(60);
    _incomeLabel.textColor = COLOR_Red;
    [_incomeLabel setAttributedText:[CommonUtils diffierentFontWithString:@"13.20%" rang:NSMakeRange(percentage.length - 4, 4) font:SYSTEMSIZE(25) color:COLOR_Red spacingBeforeValue:0 lineSpace:0]];
    [self.contentView addSubview:_incomeLabel];
    
     self.minPointLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, _incomeLabel.bottom+kSizeFrom750(40),screen_width/2, kSizeFrom750(25))];
     self.minPointLabel.font = SYSTEMBOLDSIZE(24);
    self.minPointLabel.textColor=RGB(54,54,54);
     self.minPointLabel.textAlignment=NSTextAlignmentCenter;
    [self.minPointLabel setAttributedText:[CommonUtils diffierentFontWithString:@"起投金额 50.00元" rang:NSMakeRange(0, 4) font:SYSTEMSIZE(26) color:RGB_166 spacingBeforeValue:0 lineSpace:0]];
    [self.contentView addSubview: self.minPointLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.minPointLabel.right, self.minPointLabel.top, 1, self.minPointLabel.height)];
    lineView.backgroundColor = RGB_166;
    [self.contentView addSubview:lineView];
    
    //投资时间
    self.timeLabel= [[UILabel alloc] initWithFrame:CGRectMake((screen_width-30)/2, self.minPointLabel.top,self.minPointLabel.width, self.minPointLabel.height)];
    self.timeLabel.font = SYSTEMBOLDSIZE(24);
    self.timeLabel.textColor=RGB(54,54,54);
    self.timeLabel.textAlignment=NSTextAlignmentCenter;
    [self.timeLabel setAttributedText:[CommonUtils diffierentFontWithString:@"投资时间 1个月" rang:NSMakeRange(0, 4) font:SYSTEMSIZE(26) color:RGB_166 spacingBeforeValue:0 lineSpace:0]];
    [self.contentView addSubview:self.timeLabel];
    
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0,self.timeLabel.bottom+kSizeFrom750(35),kSizeFrom750(450), kSizeFrom750(72));
    btn1.centerX = self.incomeLabel.centerX;
    [btn1 addTarget:self action:@selector(button_event:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag=1;
    [btn1 setTitle:@"立即投资" forState:UIControlStateNormal];//button title
     [btn1.titleLabel setFont:SYSTEMSIZE(28)];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//title color
    btn1.backgroundColor=COLOR_Red;
    [btn1.layer setCornerRadius:btn1.height/2]; //设置矩形四个圆角半径

    [self.contentView addSubview:btn1];

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
     if([model.additional_status isEqual:@"0"])
         return ;
     self.incomeLabel.text=[model.apr stringByAppendingString:@"%"];
    NSString *minPoint =[@"起投金额 " stringByAppendingString:[model.tender_amount_min stringByAppendingString:@"元"]];
    [self.minPointLabel setAttributedText:[CommonUtils diffierentFontWithString:minPoint rang:NSMakeRange(0, 4) font:SYSTEMSIZE(26) color:RGB_166 spacingBeforeValue:0 lineSpace:0]];
    
    [self.timeLabel setAttributedText:[CommonUtils diffierentFontWithString:[@"投资时间 " stringByAppendingString:model.period] rang:NSMakeRange(0, 4) font:SYSTEMSIZE(26) color:RGB_166 spacingBeforeValue:0 lineSpace:0]];
    
    //新手年利率
    if ([model.apr floatValue]<=0) {
        return;
    }
    CGFloat add_apr=[model.additional_apr floatValue];//附加年利率
    CGFloat newhandApr = add_apr+[model.apr floatValue];
    NSString *incomeText = [[NSString stringWithFormat:@"%.2f",newhandApr] stringByAppendingString:@"%"];
    [self.incomeLabel setAttributedText:[CommonUtils diffierentFontWithString:incomeText rang:NSMakeRange(incomeText.length - 4, 4) font:SYSTEMBOLDSIZE(30) color:COLOR_Red spacingBeforeValue:0 lineSpace:0]];

}
-(void)hiddenSubViews:(BOOL)isHidden
{
    for (UIView *view in self.contentView.subviews) {
        [view setHidden:!isHidden];
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
