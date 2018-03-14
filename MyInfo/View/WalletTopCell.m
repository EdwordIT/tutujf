//
//  WalletTopCell.m
//  DingXinDai
//
//  Created by 占碧光 on 16/6/26.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import "WalletTopCell.h"

@implementation WalletTopCell
{
    UILabel *  lab7;
    UILabel *  lab2;
    UILabel *  lab4;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UIButton* btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3.frame = CGRectMake(0, 71, screen_width/4+1, 80);
       [btn3 setImage:[UIImage imageNamed:@"gogo.png"] forState:UIControlStateNormal];
          [btn3 setImage:[UIImage imageNamed:@"gogo1"] forState:UIControlStateHighlighted];
        [btn3 addTarget:self action:@selector(OnMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn3.tag=3;
        [btn3.layer setBorderColor:[UIColor clearColor].CGColor];//边框颜色
            [btn3.layer setBorderWidth:0]; //边框宽度
         btn3.backgroundColor=[UIColor whiteColor];
        [self addSubview:btn3];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/8-14, 15, 28, 28)];
        imageView2.image = [UIImage imageNamed:@"hongbao"];
        [btn3 addSubview:imageView2];
        
       lab4 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/8-30, 47, 60,14)];
        lab4.font = CHINESE_SYSTEM(14);
          lab4.textAlignment=NSTextAlignmentCenter;
        lab4.textColor =  RGB(51,51,51);
        lab4.text=@"红包";
        [btn3 addSubview:lab4];
        
        
        UIButton* btn4= [UIButton buttonWithType:UIButtonTypeCustom];
        btn4.frame = CGRectMake(screen_width/4, 71, screen_width/4+1, 80);
        [btn4 setImage:[UIImage imageNamed:@"gogo.png"] forState:UIControlStateNormal];
        [btn4 setImage:[UIImage imageNamed:@"gogo1"] forState:UIControlStateHighlighted];
        
        [btn4 addTarget:self action:@selector(OnMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn4.tag=5;
        
        [btn4.layer setBorderColor:[UIColor clearColor].CGColor];//边框颜色
         [btn4.layer setBorderWidth:0]; //边框宽度
         btn4.backgroundColor=[UIColor whiteColor];
        [self addSubview:btn4];

        
        UIImageView *imageView3= [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/8-14, 15, 28, 28)];
        imageView3.image = [UIImage imageNamed:@"tiyanjin"];
        [btn4 addSubview:imageView3];
        
        UILabel *  lab5 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/8-30, 47, 60,14)];
        lab5.font = CHINESE_SYSTEM(14);
        lab5.textAlignment=NSTextAlignmentCenter;
        lab5.textColor = RGB(51,51,51);
        lab5.text=@"体验金";
        [btn4 addSubview:lab5];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0,40,0.5,24)];
        lineView1.backgroundColor = RGB(238,238,238);
        [btn4 addSubview:lineView1];

        /****/
        UIButton* btn7= [UIButton buttonWithType:UIButtonTypeCustom];
        btn7.frame = CGRectMake(screen_width*2/4, 71, screen_width/4, 80);
        [btn7 setImage:[UIImage imageNamed:@"gogo.png"] forState:UIControlStateNormal];
        [btn7 setImage:[UIImage imageNamed:@"gogo1"] forState:UIControlStateHighlighted];
        [btn7 addTarget:self action:@selector(OnMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn7.tag=8;
        
        [btn7.layer setBorderColor:[UIColor clearColor].CGColor];//边框颜色
        [btn7.layer setBorderWidth:0]; //边框宽度
        btn7.backgroundColor=[UIColor whiteColor];
        [self addSubview:btn7];
        
        UIImageView *imageView5= [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/8-9, 15, 28, 28)];
        imageView5.image = [UIImage imageNamed:@"daijinquan"];
        [btn7 addSubview:imageView5];
        
        UILabel *  lab8 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/8-24, 47, 60,14)];
        lab8.font = CHINESE_SYSTEM(14);
        lab8.textAlignment=NSTextAlignmentCenter;
        lab8.textColor = RGB(51,51,51);
        lab8.text=@"代金券";
        [btn7 addSubview:lab8];
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0,40,0.5, 26)];
        lineView2.backgroundColor = RGB(238,238,238);
        [btn7 addSubview:lineView2];
        

        /****/
        UIButton* btn5= [UIButton buttonWithType:UIButtonTypeCustom];
        btn5.frame = CGRectMake(screen_width*3/4, 71, screen_width/4, 80);
        [btn5 setImage:[UIImage imageNamed:@"gogo.png"] forState:UIControlStateNormal];
        [btn5 setImage:[UIImage imageNamed:@"gogo1"] forState:UIControlStateHighlighted];
        [btn5 addTarget:self action:@selector(OnMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn5.tag=4;
        
        [btn5.layer setBorderColor:[UIColor clearColor].CGColor];//边框颜色
        [btn5.layer setBorderWidth:0]; //边框宽度
        btn5.backgroundColor=[UIColor whiteColor];
        [self addSubview:btn5];
        
        UIImageView *imageView4= [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/8-9, 15, 28, 28)];
        imageView4.image = [UIImage imageNamed:@"dingxinbi"];
        [btn5 addSubview:imageView4];
        
        UILabel *  lab6 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/8-24, 47, 60,14)];
        lab6.font = CHINESE_SYSTEM(14);
        lab6.textAlignment=NSTextAlignmentCenter;
        lab6.textColor = RGB(51,51,51);
        lab6.text=@"鼎信币";
        [btn5 addSubview:lab6];
        
        UIView *lineView5 = [[UIView alloc] initWithFrame:CGRectMake(0,40,0.5, 26)];
        lineView5.backgroundColor = RGB(238,238,238);
        [btn5 addSubview:lineView5];
 
        UIView *topbg= [[UIView alloc] initWithFrame:CGRectMake( 0,0,screen_width, 72)];
        topbg.backgroundColor=RGB(255,255,255);
        lab2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 27, 150,28)];
        lab2.font = [UIFont fontWithName:@"Helvetica" size:28];
        lab2.textAlignment=NSTextAlignmentLeft;
        lab2.textColor = RGB(51,51,51);
        lab2.text=@"0.00";
        [topbg addSubview:lab2];
        
        
        UILabel *  lab3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 150,15)];
        lab3.font =  CHINESE_SYSTEM(15);
        lab3.textAlignment=NSTextAlignmentLeft;
        lab3.textColor = RGB(153,153,153);
        lab3.text=@"可用余额";
        [topbg addSubview:lab3];
        
        UIButton* btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn0.frame = CGRectMake(15, 5, 150,32);
        btn0.backgroundColor=[UIColor clearColor];
        [btn0 addTarget:self action:@selector(OnMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn0.tag=9;
        //  btn1.backgroundColor=[UIColor whiteColor];
        [topbg addSubview:btn0];
        
        
        UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(screen_width-158, 20, 64, 31);
        [btn1 setImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(OnMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn1.tag=1;
        //  btn1.backgroundColor=[UIColor whiteColor];
        [topbg addSubview:btn1];
        
        
        
        UIButton* btn2= [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(screen_width-80, 20, 64, 31);
        [btn2 setImage:[UIImage imageNamed:@"tixian"] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(OnMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn2.tag=2;
        //btn2.backgroundColor=[UIColor whiteColor];
        [topbg addSubview:btn2];
        
        UIView *lineView0 = [[UIView alloc] initWithFrame:CGRectMake( 15,70,screen_width-30, 0.5)];
        lineView0.backgroundColor =lineBg;
        [topbg addSubview:lineView0];
        
        [self addSubview:topbg];
          
        /*
         
         UILabel *  lb3 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width-48, 15, 24, 12)];
         lb3.font = [UIFont systemFontOfSize:12];
         lb3.textColor =  [UIColor grayColor];
         lb3.text=@"时间";
         [self addSubview:lb3];
         */
        
        
    }
    return self;
}

-(void) setDxb:(NSString *)str  kyye:(NSString *)kyye
{
    lab2.text=kyye;
    //lab7.text=str;
  
}


-(void) setHongbao:(NSString *)str
{
    
    if(![str isEqual:@""]&&[str length]>2&&![str isEqual:@"红包(0)"])
    {
        NSMutableAttributedString *textColor1 = [[NSMutableAttributedString alloc]initWithString:str];
        
        [textColor1 addAttribute:NSForegroundColorAttributeName value:RGB(51,51,78) range:NSMakeRange(0, 2)];
        
        [textColor1 addAttribute:NSForegroundColorAttributeName value:RGB(254,85,78) range:NSMakeRange(2,[str length]-2)];
        
        
        [lab4 setAttributedText:textColor1];
    }
    else
    {
        lab4.font = CHINESE_SYSTEM(14);
        lab4.textAlignment=NSTextAlignmentCenter;
        lab4.textColor =  RGB(51,51,51);
       lab4.text=@"红包";
    }
    
}
-(void) OnMenuBtn:(UIButton *) sender
{
    NSInteger tag=sender.tag-1;
    [self.delegate didopWalletAtIndex:tag];
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
