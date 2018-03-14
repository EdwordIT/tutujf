//
//  MIneMidddleCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/10/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "MIneMiddleCell.h"

@implementation MIneMiddleCell
{
    UIImageView * img11;
    UILabel * menuL12;
    UILabel * menuL13;
    
    UIImageView * img21;
    UILabel * menuL22;
    UILabel * menuL23;
    
    UIImageView * img31;
    UILabel * menuL32;
    UILabel * menuL33;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=RGB(240,240,240);
        UIView * uv1=[[UIView alloc] initWithFrame:CGRectMake(15, 20, 108, 109)];
         if(IS_IPHONE5)
        {
            uv1.frame=CGRectMake(15, 20, 85, 85);
        }
        else  if(IS_IPhone6plus)
        {
             uv1.frame=CGRectMake(15, 20, 118, 118);
        }
            
        uv1.layer.shadowRadius=5;
        uv1.backgroundColor=[UIColor whiteColor];
        img11=[[UIImageView alloc] initWithFrame:CGRectMake(32, 13, 42, 42)];
        if(IS_IPHONE5)
        {
            img11.frame=CGRectMake(26.5, 6, 32, 32);
        }
        [uv1.layer setCornerRadius:8];
        [uv1 addSubview:img11];
          if(IS_IPhone6plus)
          menuL12=[[UILabel alloc] initWithFrame:CGRectMake(0, 62, 118, 12)];
        else
        menuL12=[[UILabel alloc] initWithFrame:CGRectMake(0, 62, 108, 12)];
        if(IS_IPHONE5)
        {
            menuL12.frame=CGRectMake(0, 44, 85, 12);
        }
        menuL12.font=CHINESE_SYSTEM(14);
        menuL12.textColor=RGB(38,38,38);
        menuL12.textAlignment=NSTextAlignmentCenter;
         [uv1 addSubview:menuL12];
         if(IS_IPhone6plus)
         {
              img11.frame=CGRectMake(37, 13, 42, 42);
       menuL13=[[UILabel alloc] initWithFrame:CGRectMake(0, 84, 118, 12)];
         }
        else
        menuL13=[[UILabel alloc] initWithFrame:CGRectMake(0, 84, 108, 12)];
        if(IS_IPHONE5)
        {
            menuL13.frame=CGRectMake(0, 62, 85, 12);
        }
        menuL13.font=CHINESE_SYSTEM(12);
        menuL13.textColor=RGB(138,138,138);
        menuL13.textAlignment=NSTextAlignmentCenter;
        [uv1 addSubview:menuL13];
        
        uv1.tag=1;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImage:)];
        [uv1 addGestureRecognizer:tap1];
        
        [self.contentView addSubview:uv1];
        
        
        UIView * uv2=[[UIView alloc] initWithFrame:CGRectMake(133.5, 20, 108, 109)];
        if(IS_IPhone6plus)
        {
            uv2.frame=CGRectMake(133.5+15, 20, 118, 118);
        }
        else if(IS_IPHONE5)
        {
            uv2.frame=CGRectMake(117.5, 20, 85, 85);
        }
        uv2.layer.shadowRadius=5;
        uv2.backgroundColor=[UIColor whiteColor];
        img21=[[UIImageView alloc] initWithFrame:CGRectMake(32, 13, 42, 42)];
        if(IS_IPHONE5)
        {
            img21.frame=CGRectMake(26.5, 6, 32, 32);
        }
           [uv2 addSubview:img21];
        if(IS_IPhone6plus)
           menuL22=[[UILabel alloc] initWithFrame:CGRectMake(0, 62, 118, 12)];
        else
        menuL22=[[UILabel alloc] initWithFrame:CGRectMake(0, 62, 108, 12)];
        if(IS_IPHONE5)
        {
            menuL22.frame=CGRectMake(0, 44, 85, 12);
        }
        menuL22.font=CHINESE_SYSTEM(14);
        menuL22.textColor=RGB(38,38,38);
        menuL22.textAlignment=NSTextAlignmentCenter;
        [uv2 addSubview:menuL22];
        
        if(IS_IPhone6plus)
        {
              img21.frame=CGRectMake(37, 13, 42, 42);
         menuL23=[[UILabel alloc] initWithFrame:CGRectMake(0, 84, 118, 12)];
        }
        else
        menuL23=[[UILabel alloc] initWithFrame:CGRectMake(0, 84, 108, 12)];
        if(IS_IPHONE5)
        {
            menuL23.frame=CGRectMake(0, 62, 85, 12);
        }
        menuL23.font=CHINESE_SYSTEM(12);
        menuL23.textColor=RGB(138,138,138);
        menuL23.textAlignment=NSTextAlignmentCenter;
        [uv2 addSubview:menuL23];
        [uv2.layer setCornerRadius:8];
         uv2.tag=2;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImage:)];
        [uv2 addGestureRecognizer:tap2];
        
        [self.contentView addSubview:uv2];
        
        
       UIView * uv3=[[UIView alloc] initWithFrame:CGRectMake(252, 20, 108, 109)];
        if(IS_IPhone6plus)
        {
              uv3.frame=CGRectMake(252+29, 20, 118, 118);
        }
        else if(IS_IPHONE5)
        {
             uv3.frame=CGRectMake(220, 20, 85, 85);
        }
        uv3.layer.shadowRadius=5;
       [uv3.layer setCornerRadius:8];
        uv3.backgroundColor=[UIColor whiteColor];
       img31=[[UIImageView alloc] initWithFrame:CGRectMake(32, 13, 42, 42)];
        if(IS_IPHONE5)
        {
              img31.frame=CGRectMake(26.5, 6, 32, 32);
        }
       [uv3 addSubview:img31];
        if(IS_IPhone6plus)
        {
          img31.frame=CGRectMake(37, 13, 42, 42);
           menuL32=[[UILabel alloc] initWithFrame:CGRectMake(0, 62, 118, 12)];
        }
            else
        menuL32=[[UILabel alloc] initWithFrame:CGRectMake(0, 62, 108, 12)];
        if(IS_IPHONE5)
        {
            menuL32.frame=CGRectMake(0, 44, 85, 12);
        }
        menuL32.font=CHINESE_SYSTEM(14);
        menuL32.textColor=RGB(38,38,38);
        menuL32.textAlignment=NSTextAlignmentCenter;
        [uv3 addSubview:menuL32];
        if(IS_IPhone6plus)
         menuL33=[[UILabel alloc] initWithFrame:CGRectMake(0, 84, 118, 12)];
        else
        menuL33=[[UILabel alloc] initWithFrame:CGRectMake(0, 84, 108, 12)];
        if(IS_IPHONE5)
        {
            menuL33.frame=CGRectMake(0, 62, 85, 12);
        }
        menuL33.font=CHINESE_SYSTEM(12);
        menuL33.textColor=RGB(138,138,138);
        menuL33.textAlignment=NSTextAlignmentCenter;
        [uv3 addSubview:menuL33];
        
             uv3.tag=3;
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImage:)];
        [uv3 addGestureRecognizer:tap3];
        
         [self.contentView addSubview:uv3];
        
    }
    return self;
}

-(void)OnTapImage:(UITapGestureRecognizer *)sender{
    
    
    [self.delegate didopMIneMiddleAtIndex:sender.view.tag];
}

-(void) setModelData:(NSArray *) ary1 ary2:(NSArray *)ary2 ary3:(NSArray *)ary3
{
    [img11 setImage:[UIImage imageNamed:ary1[0]]];
    [img21 setImage:[UIImage imageNamed:ary1[1]]];
    [img31 setImage:[UIImage imageNamed:ary1[2]]];
    
    menuL12.text=ary2[0];
    menuL22.text=ary2[1];
    menuL32.text=ary2[2];
    
    menuL13.text=ary3[0];
    menuL23.text=ary3[1];
    menuL33.text=ary3[2];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code108
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
