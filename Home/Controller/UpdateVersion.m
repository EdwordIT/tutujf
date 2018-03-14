//
//  UpdateVersion.m
//  TTJF
//
//  Created by 占碧光 on 2017/11/24.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "UpdateVersion.h"

@implementation UpdateVersion

{
    UIImageView * imageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"updatev"]];
        imageView.tag = 1;
        [imageView.layer setCornerRadius:10];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [imageView addGestureRecognizer:tap];
        [imageView setUserInteractionEnabled:YES];
        
        self.title= [[UILabel alloc] initWithFrame:CGRectMake(20, 95,self.frame.size.width-40, 15)];
        self.title.font = CHINESE_SYSTEM(15);
        self.title.textColor=RGB(51,51,51);
        self.title.text=@"【新功能说明】";
        self.title.textAlignment=NSTextAlignmentLeft;
        [imageView addSubview: self.title];
        
        
        UILabel * lab1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 115,self.frame.size.width-40, 13)];
        lab1.font = CHINESE_SYSTEM(13);
        lab1.textColor=RGB(135,135,135);
        lab1.text=@"1、修改了App应用图标";
        lab1.textAlignment=NSTextAlignmentLeft;
        [imageView addSubview: lab1];
        
        UILabel * lab2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 133,self.frame.size.width-40, 13)];
        lab2.font = CHINESE_SYSTEM(13);
        lab2.textColor=RGB(135,135,135);
        lab2.text=@"";
        lab2.textAlignment=NSTextAlignmentLeft;
        [imageView addSubview: lab2];
        
        UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
       
        btn1.frame = CGRectMake(20,self.frame.size.height-48, (self.frame.size.width-40)/2-5, 33);
        
        [btn1 setTitle:@"立即升级" forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn1 addTarget:self action:@selector(OnSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setBackgroundColor:RGB(96,92,241)];
        [btn1.layer setCornerRadius:16]; //设置矩形四个圆角半径
        btn1.tag=1;
        [imageView addSubview:btn1];
        
        UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
       
        btn2.frame = CGRectMake(self.frame.size.width/2+5, self.frame.size.height-48, (self.frame.size.width-40)/2-5, 33);
        [btn2 setTitle:@"下次再说" forState:UIControlStateNormal];
        [btn2 setTitleColor:RGB(96,92,241) forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont systemFontOfSize:12];
        btn2.titleLabel.textColor=RGB(96,92,241);
        [btn2 addTarget:self action:@selector(OnSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 setBackgroundColor:RGB(255,255,255)];
        [btn2.layer setBorderWidth:1.0];
        [btn2.layer setBorderColor:[RGB(0,160,240) CGColor]];
        [btn2.layer setCornerRadius:16]; //设置矩形四个圆角半径
        btn2.tag=2;
        [imageView addSubview:btn2];
        
        [self addSubview:imageView];
    }
    return self;
}


-(void) setDataBind:(VersionInfo *) info
{
    //    [imageView sd_setImageWithURL:[NSURL URLWithString:userinfo.trust_reg_log] placeholderImage:[UIImage imageNamed:@"showregedit"]];
}

-(void)handleTap:(id)sender{
    [self.delegate didOpenVersionView:0];
}

-(void) OnSaveBtn:(UIButton *)sender
{
    //  [self delegate:OpenShowViewDelegate]
    [self.delegate didOpenVersionView:sender.tag];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 updatev
*/

@end
