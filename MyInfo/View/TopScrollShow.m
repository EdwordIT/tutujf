//
//  TopScrollShow.m
//  TTJF
//
//  Created by 占碧光 on 2017/10/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "TopScrollShow.h"

@implementation TopScrollShow

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
        [self awakeFromNib];
    }
    return self;
}

-(void) awakeFromNib
{
    /*
    _backimg=[[UIView alloc] initWithFrame: CGRectMake(18, 20, 40, 40)];
    _backimg.backgroundColor=RGB(197,231,252);
    _backimg.userInteractionEnabled=YES;
    [_backimg.layer setCornerRadius:20];
    _leftBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(3, 3, 34, 34);
    [_leftBtn setImage:[UIImage imageNamed:@"user01.png"] forState:UIControlStateNormal];
    [_leftBtn setImage:[UIImage imageNamed:@"user01.png"] forState:UIControlStateHighlighted];
    [_leftBtn addTarget:self action:@selector(OnMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.tag=1;
    _leftBtn.layer.cornerRadius = 17;
    [_leftBtn.layer setBorderColor:[UIColor clearColor].CGColor];//边框颜色
    [_leftBtn.layer setBorderWidth:0]; //边框宽度
    _leftBtn.backgroundColor=[UIColor whiteColor];
    [_backimg addSubview:_leftBtn];
    [self addSubview:_backimg];
     */
    self.backgroundColor=[UIColor clearColor];
    _backimg=[[UIView alloc] initWithFrame: CGRectMake(15, 35, 50, 50)];
    _backimg.backgroundColor=RGB(197,231,252);
    _backimg.userInteractionEnabled=YES;
    [_backimg.layer setCornerRadius:25];
    _leftBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(4, 4, 42, 42);
    [_leftBtn setImage:[UIImage imageNamed:@"user01.png"] forState:UIControlStateNormal];
    [_leftBtn setImage:[UIImage imageNamed:@"user01.png"] forState:UIControlStateHighlighted];
    [_leftBtn addTarget:self action:@selector(OnMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.tag=1;
    [_leftBtn.layer setBorderColor:[UIColor clearColor].CGColor];//边框颜色
    [_leftBtn.layer setBorderWidth:0]; //边框宽度
    [_leftBtn.layer setCornerRadius:21];
    _leftBtn.backgroundColor=[UIColor whiteColor];
    [_backimg addSubview:_leftBtn];
    [self addSubview:_backimg];
    
    _leftName=[[UILabel alloc] initWithFrame:CGRectMake(75, 54, 200, 15)];
    _leftName.textAlignment=NSTextAlignmentLeft;
    //  _leftName.font=CHINESE_SYSTEM(13);
    _leftName.textColor=RGB(255,255,255);
    _leftName.text=@"******";
    _leftName.tag=3;
    _leftName.userInteractionEnabled=YES;
    [_leftName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImage:)];
    [_leftName addGestureRecognizer:tap1];
    [self addSubview:_leftName];
    /*
    _rightView=[[UIView alloc] initWithFrame:CGRectMake(screen_width-53, 22, 35, 35)];
    _rightView.layer.cornerRadius = 17.5;
    _rightView.layer.borderWidth = 1;
    _rightView.layer.backgroundColor = [UIColor clearColor].CGColor;
    _rightView.layer.borderColor = [UIColor whiteColor].CGColor;
    UIImageView * image1=[[UIImageView alloc] initWithFrame:CGRectMake(8.75, 9, 17.5, 17.5)];
    [image1 setImage:[UIImage imageNamed:@"user02.png"]];
    [_rightView addSubview:image1];
    
    _rightView.userInteractionEnabled=YES;
    _rightView.tag=2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImage:)];
    [_rightView addGestureRecognizer:tap];
    
    [self addSubview:_rightView];
    
    if([_ishaveinfo isEqual:@"1"])
    {
        _infolimg=[[UIView alloc] initWithFrame:CGRectMake(20, 5, 8,8)];
        _infolimg.layer.cornerRadius = 1.5;
        [_infolimg.layer setCornerRadius:4];
        _infolimg.backgroundColor=RGB(252,18,18);
        [_rightView addSubview:_infolimg];
    }
    */
    _rightView=[[UIView alloc] initWithFrame:CGRectMake(screen_width-55, 35, 40, 40)];
    _rightView.layer.cornerRadius = 20;
    _rightView.layer.borderWidth = 0.8;
    _rightView.layer.backgroundColor = [UIColor clearColor].CGColor;
    _rightView.layer.borderColor = [UIColor whiteColor].CGColor;
     _image1=[[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 20, 20)];
     [_image1 setImage:[UIImage imageNamed:@"user02.png"]];
    [_rightView addSubview:_image1];
    
    _rightView.userInteractionEnabled=YES;
    _rightView.tag=2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImage:)];
    [_rightView addGestureRecognizer:tap];
    
    [self addSubview:_rightView];
    
    if([_ishaveinfo isEqual:@"1"])
    {
        _infolimg=[[UIView alloc] initWithFrame:CGRectMake(20, 6, 10,10)];
        _infolimg.backgroundColor=RGB(252,18,18);
        [_infolimg.layer setCornerRadius:5];
        [_infolimg setHidden:FALSE];
        [_rightView addSubview:_infolimg];
    }

    
}

-(void)OnTapImage:(UITapGestureRecognizer *)sender{
    [self.delegate didTopScrollAtIndex:sender.view.tag];
}

-(void)OnMenuBtn:(UIButton *)sender
{
    [self.delegate didTopScrollAtIndex:sender.tag];
    
}

@end
