//
//  DetailMiddleMenu.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/15.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DetailMiddleMenu.h"
@interface DetailMiddleMenu ()
{
    UILabel * contentLab;
    UILabel * title;
    UIView * line1;
}
@end

@implementation DetailMiddleMenu

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
    
    title=[[UILabel alloc] initWithFrame:CGRectMake(10, (self.frame.size.height-14)/2, 100, 14)];
    title.text=@"项目名称";
    title.textAlignment=NSTextAlignmentLeft;
    title.font=CHINESE_SYSTEM(14);
    title.textColor=RGB(170,170, 170);
    [self addSubview:title];
    
    contentLab=[[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-115, (self.frame.size.height-14)/2, screen_width/2+100, 14)];
    contentLab.text=@"丰田1712213213（温州总部）";
    contentLab.textAlignment=NSTextAlignmentRight;
    contentLab.font=CHINESE_SYSTEM(14);
    contentLab.textColor=RGB(80,80, 80);
    [self addSubview:contentLab];
    
    line1=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.8, screen_width, 0.5)];
    line1.backgroundColor=lineBg;
    [self addSubview:line1];
}

-(void)setMenu:(NSString *)t1 content:(NSString *)c1
{
    title.text=t1;
    contentLab.text=c1;
    if([title isEqual:@"结束时间"])
    {
        [line1 setHidden:TRUE];
    }
}

@end
