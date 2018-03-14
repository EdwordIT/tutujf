//
//  DetailInvest.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DetailInvest.h"
#import "Tender.h"

@implementation DetailInvest

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
        self.backgroundColor=[UIColor whiteColor];
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    
    
    
    
    
}
-(void) setModel:(LoanBase *) model
{
    UILabel * content=[[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-200, 80, 400, 15)];
    TenderModel * dic= model.tender_list;
    if(![dic.not_lktenlist_title isEqual:@""])
    {
       content.textAlignment=NSTextAlignmentCenter;
       content.textColor=RGB(83,83,83);
       content.font=CHINESE_SYSTEM(15);
       content.text=dic.not_lktenlist_title;
       [self addSubview:content];
    }
    else{
        NSArray * dataAry;
        dataAry=dic.items;
        self.backgroundColor=[UIColor whiteColor];
        if(dataAry!=nil)
        {
            for(int k=0;k<dataAry.count;k++)
            {
                //Hone_Column_Rapidinvestment_
                Tender * ten=[dataAry objectAtIndex:k];
                UILabel * left1=[[UILabel alloc] initWithFrame:CGRectMake(15, 25+75*k, screen_width-40, 13)];
                
                left1.textColor=RGB(31,31,31);
                left1.textAlignment=NSTextAlignmentLeft;
                left1.text=ten.member_name;
                left1.font=CHINESE_SYSTEM(13);
                [self addSubview:left1];
                
                
                UILabel * left2=[[UILabel alloc] initWithFrame:CGRectMake(15, 50+75*k, screen_width-40, 13)];
                
                left2.textColor=RGB(146,146,146);
                left2.textAlignment=NSTextAlignmentLeft;
                left2.text=ten.add_time;
                left2.font=CHINESE_SYSTEM(13);
                [self addSubview:left2];
                
                UILabel * content=[[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-100, 33+75*k, screen_width/2+85, 15)];
                
                content.textAlignment=NSTextAlignmentRight;
                content.textColor=RGB(255,32,32);
                content.font=[UIFont fontWithName:@"Helvetica" size:18];
                content.text=ten.amount;
                
                [self addSubview:content];
                
                UIView *  line1=[[UIView alloc] initWithFrame:CGRectMake(15, 75*(k+1), screen_width-30, 0.5)];
                line1.backgroundColor=lineBg;
                [self addSubview:line1];
                
                
            }
            
        }
    }
//
}

@end
