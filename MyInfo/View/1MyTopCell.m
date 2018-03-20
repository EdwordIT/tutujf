//
//  1MyTopCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/3/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "1MyTopCell.h"
#import "AppDelegate.h"

@implementation _MyTopCell
{
    UIButton  * selectbg2;
     UILabel *title;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=RGB(48,156,246);
        UIImageView *imagev1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 25,25)];
        [imagev1 setImage:[UIImage imageNamed:@"Me_iceo_Setup"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImage:)];
        imagev1.tag=0;
        [imagev1 addGestureRecognizer:tap];
        imagev1.userInteractionEnabled = YES;
        [self addSubview:imagev1];
        
        UIImageView *imagev2 = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width-40, 30, 25,25)];
        [imagev2 setImage:[UIImage imageNamed:@"Me_iceo_news"]];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImage:)];
           imagev2.tag=0;
        [imagev2 addGestureRecognizer:tap1];
        imagev2.userInteractionEnabled = YES;
        [self addSubview:imagev2];
        
        selectbg2=  [UIButton buttonWithType:UIButtonTypeCustom];
        selectbg2.frame=CGRectMake(screen_width/2-100,66, 200, 72);
        selectbg2.backgroundColor=[UIColor clearColor];
        selectbg2.tag=3;
        [selectbg2 addTarget:self action:@selector(OnTapBack:) forControlEvents:UIControlEventTouchUpInside];//
        [self addSubview:selectbg2];
        if(![CommonUtils isLogin])
        {
            UIImageView *imagev3 = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/2-27, 52, 54,54)];
            [imagev3 setImage:[UIImage imageNamed:@"ttlogintp"]];
            
            [self addSubview:imagev3];
            
            UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            loginButton.frame = CGRectMake(85, 120, screen_width -170, 45);
            [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
            loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
            loginButton.tag=3;
            [loginButton addTarget:self action:@selector(OnTapBack:) forControlEvents:UIControlEventTouchUpInside];
            [loginButton setBackgroundColor:RGB(62,177,250)];
            [loginButton.layer setCornerRadius:22.5]; //设置矩形四个圆角半径
            [self addSubview:loginButton];
        }
        else
        {
        
        UILabel *  lab1 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-50, 66,100,14)];
        lab1.font =  CHINESE_SYSTEM(14);
        lab1.textColor =  [UIColor whiteColor];
        lab1.text=@"我的资产(元)";
        lab1.textAlignment=NSTextAlignmentCenter;
        [self addSubview:lab1];
            title= [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-100, 102,200,35)];
            title.font =  CHINESE_SYSTEM(35);
            title.textColor =  [UIColor whiteColor];
            title.text=@"0.00";
            title.textAlignment=NSTextAlignmentCenter;
            [self addSubview:title];
        }
        //ttlogintp
        
        
       
       
        //inputrow
    }
    return self;
}
/*
 
 -(void) OnMenuBtn:(UIButton *) sender
 {
 NSInteger tag=sender.tag-1;
 [self.delegate didMenu2AtIndex:tag];
 }
 
 */

-(void)OnTapImage:(UITapGestureRecognizer *)sender{
  
 
    [self.delegate didMyTopAtIndex:sender.view.tag];
}

-(void)OnTapBack:(UIButton *)sender{

    [self.delegate didMyTopAtIndex:sender.tag];
}




-(void)setDefaultValue: (NSString*) str
{
    title.text=str;
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
