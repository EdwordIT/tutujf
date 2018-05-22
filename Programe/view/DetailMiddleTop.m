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
    UILabel * proName;
   
    UIImageView *topImage;
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

- (instancetype)init;
{
    self = [super init];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    
  
    topImage = [[UIImageView alloc]initWithFrame:RECT(kOriginLeft, kSizeFrom750(20), kContentWidth, kSizeFrom750(36))];
    [self addSubview:topImage];

    UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, kSizeFrom750(100), kSizeFrom750(200), kSizeFrom750(30))];
    lab.text=@"项目名称";
    lab.textAlignment=NSTextAlignmentLeft;
    lab.font=SYSTEMSIZE(28);
    lab.textColor=RGB(170,170, 170);
    [self addSubview:lab];
    
    proName=[[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-kSizeFrom750(230), lab.top, screen_width/2+kSizeFrom750(200), kSizeFrom750(30))];
    proName.text=@"丰田1712213213（温州总部）";
    proName.textAlignment=NSTextAlignmentRight;
    proName.font=SYSTEMSIZE(28);
    proName.textColor=RGB(80,80, 80);
    UIView * line1=[[UIView alloc] initWithFrame:CGRectMake(0, kSizeFrom750(160)-kLineHeight, screen_width, kLineHeight)];
    line1.backgroundColor=RGB_233;
    [self addSubview:line1];
    [self addSubview:proName];
}

-(void)setproName:(NSString *)mc image:(NSString *)imgUrl
{
    proName.text=mc;
    [topImage setImageWithString:imgUrl];
}

@end
