//
//  1MyMiddleCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/3/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "1MyMiddleCell.h"

@implementation _MyMiddleCell
{
  UIButton  * selectbg1;
    UIButton  * selectbg2;;
    UILabel *jiner;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=RGB(41,134,222);
        
        selectbg1=  [UIButton buttonWithType:UIButtonTypeCustom];
        selectbg1.frame=CGRectMake(0,0, 100, 45);
        selectbg1.backgroundColor=[UIColor clearColor];
        selectbg1.tag=0;
        [selectbg1 addTarget:self action:@selector(OnTapBack:) forControlEvents:UIControlEventTouchUpInside];//
        [self addSubview:selectbg1];
        
        
        UILabel *  lab1 = [[UILabel alloc] initWithFrame:CGRectMake(14, 16,50,12)];
        lab1.font =  CHINESE_SYSTEM(12);
        lab1.textColor =RGB(128,200,255);
        lab1.text=@"可用余额";
        lab1.textAlignment=NSTextAlignmentLeft;
        [self addSubview:lab1];
        
        
        jiner= [[UILabel alloc] initWithFrame:CGRectMake(66, 16,100,13)];//13
        jiner.font =  CHINESE_SYSTEM(13);
        jiner.textColor =  [UIColor whiteColor];
        jiner.text=@"45450.00";
        jiner.textAlignment=NSTextAlignmentLeft;
        [self addSubview:jiner];
        
        selectbg2=  [UIButton buttonWithType:UIButtonTypeCustom];
        selectbg2.frame=CGRectMake(screen_width-88,0, 88, 45);
       selectbg2.backgroundColor=[UIColor clearColor];
        selectbg2.tag=1;
        [selectbg2 addTarget:self action:@selector(OnTapBack:) forControlEvents:UIControlEventTouchUpInside];//
        [self addSubview:selectbg2];
        
        UILabel *  lab2 = [[UILabel alloc] initWithFrame:CGRectMake(66+([jiner.text length]-1)*9, 16,16,12)];
        lab2.font =  CHINESE_SYSTEM(12);
        lab2.textColor =RGB(128,200,255);
        lab2.text=@"元";
        lab2.textAlignment=NSTextAlignmentLeft;
        [self addSubview:lab2];
        
        UILabel *  lab3 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width-88, 16,60,12)];
        lab3.font =  CHINESE_SYSTEM(12);
        lab3.textColor =[UIColor whiteColor];
        lab3.text=@"充值/提现";
        lab3.textAlignment=NSTextAlignmentRight;
        [self addSubview:lab3];
        
        UIImageView *imagev2 = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width-21, 18, 5,9)];
        [imagev2 setImage:[UIImage imageNamed:@"Me_iceo_WithdrawalsReturn"]];
        [self addSubview:imagev2];
        
        
        //inputrow
        
        
        
        
    }
    return self;
}

-(void)setDefaultValue: (NSString*) title
{
      jiner.text=title;
}

-(void)OnTapBack:(UIButton *)sender{
    
    [self.delegate didMyMiddleAtIndex:sender.tag];
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
