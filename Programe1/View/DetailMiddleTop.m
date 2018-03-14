//
//  DetailMiddleTop.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/15.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DetailMiddleTop.h"
@interface DetailMiddleTop ()
{
    UILabel * xmmc;
   
}
@end

@implementation DetailMiddleTop

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
     CGFloat w1=(screen_width-64*2-54*3-20)/4;
    UIImageView * img1=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 54, 18)];
    [img1 setImage:[UIImage imageNamed:@"xm_xxcb"]];
    [self addSubview:img1];
    
    UIImageView * img2=[[UIImageView alloc] initWithFrame:CGRectMake(54+10+w1, 10, 54, 18)];
    [img2 setImage:[UIImage imageNamed:@"xm_mdba"]];
    [self addSubview:img2];
    
    UIImageView * img3=[[UIImageView alloc] initWithFrame:CGRectMake(54*2+10+w1*2, 10, 54, 18)];
    [img3 setImage:[UIImage imageNamed:@"xm_swdy"]];
    [self addSubview:img3];
    
    UIImageView * img4=[[UIImageView alloc] initWithFrame:CGRectMake(54*3+10+w1*3, 10, 64, 18)];
     [img4 setImage:[UIImage imageNamed:@"xm_cgsba"]];
    [self addSubview:img4];
    
    UIImageView * img5=[[UIImageView alloc] initWithFrame:CGRectMake(54*3+10+w1*4+64, 10, 64, 18)];
     [img5 setImage:[UIImage imageNamed:@"xm_stjyd"]];
    [self addSubview:img5];
    
    UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(10, 50, 100, 14)];
    lab.text=@"项目名称";
    lab.textAlignment=NSTextAlignmentLeft;
    lab.font=CHINESE_SYSTEM(14);
    lab.textColor=RGB(170,170, 170);
    [self addSubview:lab];
    
    xmmc=[[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-115, 50, screen_width/2+100, 14)];
    xmmc.text=@"丰田1712213213（温州总部）";
    xmmc.textAlignment=NSTextAlignmentRight;
    xmmc.font=CHINESE_SYSTEM(14);
    xmmc.textColor=RGB(80,80, 80);
    UIView * line1=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.8, screen_width, 0.5)];
    line1.backgroundColor=lineBg;
    [self addSubview:line1];
    [self addSubview:xmmc];
}

-(void)setXMMC:(NSString *)mc
{
    xmmc.text=mc;
}

@end
