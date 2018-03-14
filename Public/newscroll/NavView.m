//
//  NavView.m
//  CLBigTest
//
//  Created by Rain on 16/9/2.
//  Copyright © 2016年 Rain. All rights reserved.
//

#import "NavView.h"
#import "UIImageView+WebCache.h"

@implementation NavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    
    self.backgroundColor = [UIColor clearColor];
  //  _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, screen_width,64)];
   // [_imageView setImage:[UIImage imageNamed:@"qdqrtopbg"]];
    

    _personalimg= [[UIImageView alloc] init];
    
    [_personalimg setImage:[UIImage imageNamed:@"Me_iceo_Set up"]];
    _personalimg.frame=CGRectMake(15, 27, 24, 24);
    _personalimg.layer.cornerRadius = 15;
    _personalimg.clipsToBounds = YES;
    [_personalimg.layer setBorderColor:RGB(240,240,240).CGColor];//边框颜色
    [_personalimg.layer setBorderWidth:0]; //边框宽度
    _personalimg.userInteractionEnabled=TRUE;
    
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBack:)];
    [_personalimg addGestureRecognizer:tap2];
    _personalimg.tag=1;

    [self addSubview:_personalimg];
 
    
    _mobilenum=[[UILabel alloc]initWithFrame:CGRectMake(50, 32, 200, 18)];
    _mobilenum.textColor=[UIColor whiteColor];
    _mobilenum.text=@"未登录";
    _mobilenum.font =CHINESE_SYSTEM(16);
    [self addSubview:_mobilenum];

    UIView * bg2=[[UIView alloc] initWithFrame:CGRectMake(screen_width-36, 30, 24, 24)];
    bg2.backgroundColor=[UIColor clearColor];
    
    _infolimg= [[UIImageView alloc] init];
    [_infolimg setImage:[UIImage imageNamed:@"Me_iceo_news"]];
    _infolimg.frame=CGRectMake(0, 0, 24, 24);
    _infolimg.clipsToBounds = YES;
    
      [bg2 addSubview:_infolimg];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBack:)];
    [bg2 addGestureRecognizer:tap1];
    bg2.tag=2;
    bg2.userInteractionEnabled = YES;
    [self addSubview:bg2];
    
    
  //  [_personalimg sd_setImageWithURL:@"" placeholderImage:[UIImage imageNamed:@"morentx"]];
 
    
   
}

-(void)OnTapBack:(UITapGestureRecognizer *)sender{
   
    [self.delegate didNavViewDAtIndex:sender.view.tag];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
