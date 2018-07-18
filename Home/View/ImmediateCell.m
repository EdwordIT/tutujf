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
    lab1.textColor=RGB_102;
    NSAttributedString *attr = [CommonUtils diffierentFontWithString:@"新手专享 为您特供" rang:NSMakeRange(0, 4) font:SYSTEMBOLDSIZE(32) color:COLOR_Red spacingBeforeValue:0 lineSpace:0];
    lab1.attributedText=attr;
    lab1.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:lab1];
    
    rightimg=[[UIImageView alloc] initWithFrame:CGRectMake(screen_width - kSizeFrom750(160)- kSizeFrom750(75), leftImage.top, leftImage.width, leftImage.height)];
    [rightimg setImage:[UIImage imageNamed:@"wings_right"]];
    [self.contentView addSubview:rightimg];
    
    _incomeLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, lab1.bottom+kSizeFrom750(40),kSizeFrom750(200),kSizeFrom750(55))];
    _incomeLabel.centerX = lab1.centerX;
    _incomeLabel.textAlignment=NSTextAlignmentCenter;
    _incomeLabel.font = NUMBER_FONT_BOLD(60);
    _incomeLabel.textColor = COLOR_Red;
    [self.contentView addSubview:_incomeLabel];
    
     self.minPointLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, _incomeLabel.bottom+kSizeFrom750(40),screen_width/2, kSizeFrom750(25))];
     self.minPointLabel.font = NUMBER_FONT_BOLD(26);
    self.minPointLabel.textColor=RGB(54,54,54);
     self.minPointLabel.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview: self.minPointLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.minPointLabel.right, self.minPointLabel.top, 1, self.minPointLabel.height)];
    lineView.backgroundColor = RGB_166;
    [self.contentView addSubview:lineView];
    
    //投资时间
    self.timeLabel= [[UILabel alloc] initWithFrame:CGRectMake((screen_width-30)/2, self.minPointLabel.top,self.minPointLabel.width, self.minPointLabel.height)];
    self.timeLabel.font = NUMBER_FONT_BOLD(26);
    self.timeLabel.textColor=RGB(54,54,54);
    self.timeLabel.textAlignment=NSTextAlignmentCenter;
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

-(void)setImmediateModel:(ImmediateModel *)model {
     if([model.additional_status isEqual:@"0"])
         return ;
     self.incomeLabel.text=model.apr_val;
    NSString *minPoint =[[model.tender_amount_min_txt stringByAppendingString:@" "] stringByAppendingString:model.tender_amount_min_val];
    [self.minPointLabel setAttributedText:[CommonUtils diffierentFontWithString:minPoint rang:NSMakeRange(0, 4) font:SYSTEMSIZE(26) color:RGB_166 spacingBeforeValue:0 lineSpace:0]];
    [self.timeLabel setAttributedText:[CommonUtils diffierentFontWithString:[[model.period_txt stringByAppendingString:@" "] stringByAppendingString:model.period] rang:NSMakeRange(0, 4) font:SYSTEMSIZE(26) color:RGB_166 spacingBeforeValue:0 lineSpace:0]];
    [self.incomeLabel setAttributedText:[CommonUtils diffierentFontWithString:model.apr_val rang:NSMakeRange(model.apr_val.length - 4, 4) font:SYSTEMBOLDSIZE(30) color:COLOR_Red spacingBeforeValue:0 lineSpace:0]];

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
