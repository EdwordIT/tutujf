//
//  1MyBottomCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/3/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "1MyBottomCell.h"

@implementation _MyBottomCell
{
   
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        [self addSubview:[self intiView:0 ]];
        [self addSubview:[self intiView:1 ]];
        [self addSubview:[self intiView:2 ]];
        [self addSubview:[self intiView:3 ]];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 75,screen_width , 0.5)];
        lineView.backgroundColor =lineBg;
        [self addSubview:lineView];
        
        
        
        UIView * lineView1 = [[UIView alloc] initWithFrame:CGRectMake(screen_width/2,0, 0.5,150)];
        lineView1.backgroundColor =lineBg;
        [self addSubview:lineView1];
        
        
    }
    return self;
}


-(UIButton *) intiView:(NSInteger) index
{
     UIButton  * selectbg1;
     selectbg1=  [UIButton buttonWithType:UIButtonTypeCustom];
    if(index==0)
        selectbg1.frame=CGRectMake(0, 0,screen_width/2 ,75);
    else if(index==1)
        selectbg1.frame=CGRectMake(screen_width/2, 0,screen_width/2 ,75);
    else if(index==2)
    selectbg1.frame=CGRectMake(0, 75,screen_width/2 ,75);
    else if(index==3)
      selectbg1.frame=CGRectMake(screen_width/2, 75,screen_width/2 ,75);
    
    [selectbg1 setImage:[UIImage imageNamed:@"rmbg12"] forState:UIControlStateNormal];
    [selectbg1 setImage:[UIImage imageNamed:@"rmbg13"] forState:UIControlStateHighlighted];
    selectbg1.tag=index;
    [selectbg1 addTarget:self action:@selector(OnTapBack:) forControlEvents:UIControlEventTouchUpInside];//
    

    
                  //WithFrame:CGRectMake(0, 0,screen_width/2 ,75)];
    UIImageView *imagev1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 18,18)];
    if(index==0)
    [imagev1 setImage:[UIImage imageNamed:@"Me_iceo_Record"]];
    else  if(index==1)
        [imagev1 setImage:[UIImage imageNamed:@"Me_iceo_Detailed"]];
    else  if(index==2)
        [imagev1 setImage:[UIImage imageNamed:@"Me_iceo_Automatic"]];
   else  if(index==3)
        [imagev1 setImage:[UIImage imageNamed:@"Me_iceo_Discount"]];
    [selectbg1 addSubview:imagev1];
    
    UILabel *  lab1 = [[UILabel alloc] initWithFrame:CGRectMake(48, 20, 100,15)];
    lab1.font = CHINESE_SYSTEM(15);
    lab1.textColor =  RGB(51,51,51);
    lab1.textAlignment=NSTextAlignmentLeft;
     if(index==0)
    lab1.text=@"投资记录";
    else if(index==1)
        lab1.text=@"待收明细";
    else if(index==2)
        lab1.text=@"自动投标";
    else if(index==3)
        lab1.text=@"红包优惠";
    [selectbg1 addSubview:lab1];
    
    UILabel *  lab2= [[UILabel alloc] initWithFrame:CGRectMake(48, 45,120,12)];
    lab2.font = CHINESE_SYSTEM(12);
    lab2.textColor =  RGB(153,153,153);
    lab2.textAlignment=NSTextAlignmentLeft;
    if(index==0)
        lab2.text=@"投标记录明细";
    else if(index==1)
        lab2.text=@"距下一回款日";
    else if(index==2)
        lab2.text=@"最高11%收益率";
    else if(index==3)
        lab2.text=@"红包优惠";
    [selectbg1 addSubview:lab2];
    return  selectbg1;
}

-(void)OnTapBack:(UIButton *)sender{
    
    [self.delegate didMyBottomAtIndex:sender.tag];
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
