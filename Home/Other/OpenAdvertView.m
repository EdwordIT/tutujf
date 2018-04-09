//
//  OpenAdvertView.m
//  TTJF
//
//  Created by 占碧光 on 2017/4/17.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "OpenAdvertView.h"

@implementation OpenAdvertView
{
    UIImageView * imageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        CGFloat  ddw=242;
        CGFloat  ddh=266;
        if(IS_IPhone6plus)
        {
            ddw=270;
            ddh=300;
        }
         imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, ddw, ddh)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"showregedit"]];
        imageView.tag = 1;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [imageView addGestureRecognizer:tap];
        [imageView setUserInteractionEnabled:YES];
        
        [self addSubview:imageView];
        
       UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
         if(IS_IPhone6plus)
          btn1.frame = CGRectMake(40,200, 192, 33);
             else
        btn1.frame = CGRectMake(25,172, 192, 33);
        
        [btn1 setTitle:@"立即开通" forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn1 addTarget:self action:@selector(OnSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setBackgroundColor:RGB(0,160,240)];
        [btn1.layer setCornerRadius:16]; //设置矩形四个圆角半径
        btn1.tag=1;
        [self addSubview:btn1];
        
        UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        if(IS_IPhone6plus)
            btn2.frame = CGRectMake(40, 247,192, 33);
        else
        btn2.frame = CGRectMake(25, 214,192, 33);
        [btn2 setTitle:@"暂不开通" forState:UIControlStateNormal];
        [btn2 setTitleColor:RGB(0,160,240) forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont systemFontOfSize:12];
        btn2.titleLabel.textColor=RGB(0,160,240);
        [btn2 addTarget:self action:@selector(OnSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 setBackgroundColor:RGB(255,255,255)];
        [btn2.layer setBorderWidth:1.0];
        [btn2.layer setBorderColor:[RGB(0,160,240) CGColor]];
        [btn2.layer setCornerRadius:16]; //设置矩形四个圆角半径
           btn2.tag=2;
        [self addSubview:btn2];
     
    }
    
    return self;
}

-(void) setDataBind:(MyAccountModel *) userinfo
{
}

-(void)handleTap:(id)sender{
    [self.delegate didOpenAdvertView:0];
}

-(void) OnSaveBtn:(UIButton *)sender
{
    //  [self delegate:OpenShowViewDelegate]
    [self.delegate didOpenAdvertView:sender.tag];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
