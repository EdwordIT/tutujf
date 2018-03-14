//
//  DetailRepay.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/20.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DetailRepay.h"
#import "RepayModel.h"


@interface DetailRepay ()
{
    NSMutableArray * dataAry;
    
    UIView * line1;
}
@end

@implementation DetailRepay

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
        self.backgroundColor=lineBg;
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
}

-(void) setModel:(LoanBase *) model
{
    dataAry=model.repay_plan;
    self.backgroundColor=[UIColor whiteColor];
    if(dataAry!=nil)
    {
        for(int k=0;k<dataAry.count;k++)
        {
            //Hone_Column_Rapidinvestment_
            RepayModel * repay=[dataAry objectAtIndex:k];
            UILabel * left1=[[UILabel alloc] initWithFrame:CGRectMake(15, 25+75*k, screen_width-40, 13)];
          
            left1.textColor=RGB(31,31,31);
            left1.textAlignment=NSTextAlignmentLeft;
            left1.text=repay.type_name;
            left1.font=CHINESE_SYSTEM(13);
            [self addSubview:left1];
            
            
            UILabel * left2=[[UILabel alloc] initWithFrame:CGRectMake(15, 50+75*k, screen_width-40, 13)];
            
            left2.textColor=RGB(146,146,146);
            left2.textAlignment=NSTextAlignmentLeft;
            left2.text=[NSString stringWithFormat:@"预期还款时间：%@",repay.repay_date];
            left2.font=CHINESE_SYSTEM(13);
            [self addSubview:left2];
            
            UILabel * content=[[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-100, 33+75*k, screen_width/2+85, 15)];
            
            content.textAlignment=NSTextAlignmentRight;
            content.textColor=RGB(255,32,32);
            content.font=[UIFont fontWithName:@"Helvetica" size:18];
            content.text=repay.total;
           
            [self addSubview:content];
            
            line1=[[UIView alloc] initWithFrame:CGRectMake(15, 75*(k+1), screen_width-30, 0.5)];
            line1.backgroundColor=lineBg;
            [self addSubview:line1];
            
            
        }
        
    }
}

- (NSString *)hanleNums:(NSString *)numbers{
    // numbers=[numbers stringByReplacingOccurrencesOfString:@".00" withString:@""];
    NSString *str = [numbers substringWithRange:NSMakeRange(numbers.length%3, numbers.length-numbers.length%3)];
    NSString *strs = [numbers substringWithRange:NSMakeRange(0, numbers.length%3)];
    for (int  i =0; i < str.length; i =i+3) {
        NSString *sss = [str substringWithRange:NSMakeRange(i, 3)];
        strs = [strs stringByAppendingString:[NSString stringWithFormat:@",%@",sss]];
    }
    if ([[strs substringWithRange:NSMakeRange(0, 1)] isEqualToString:@","]) {
        strs = [strs substringWithRange:NSMakeRange(1, strs.length-1)];
    }
    strs = [strs stringByAppendingString:@".00"];
    return strs;
}
@end
