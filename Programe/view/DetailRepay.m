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
    NSArray * dataAry;
    
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
        self.backgroundColor=RGB_233;
    }
    return self;
}

-(void) setModel:(LoanBase *) model
{
    dataAry=model.repay_plan.items;
    self.backgroundColor=[UIColor whiteColor];
    if(dataAry!=nil)
    {
        for(int k=0;k<dataAry.count;k++)
        {
            //Hone_Column_Rapidinvestment_
            RepayDetailModel * repay=[dataAry objectAtIndex:k];
            UILabel * left1=[[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, kSizeFrom750(50)+kSizeFrom750(150)*k, screen_width-kOriginLeft*2, kSizeFrom750(30))];
            left1.textColor=RGB(31,31,31);
            left1.text=repay.type_name;
            left1.font=SYSTEMSIZE(26);
            [self addSubview:left1];
            
            
            UILabel * left2=[[UILabel alloc] initWithFrame:CGRectMake(left1.left, left1.bottom+kSizeFrom750(20), left1.width, kSizeFrom750(30))];
            left2.textColor=RGB(146,146,146);
            left2.text=[NSString stringWithFormat:@"预期还款时间：%@",repay.repay_date];
            left2.font=SYSTEMSIZE(26);
            [self addSubview:left2];
            
            UILabel * content=[[UILabel alloc] initWithFrame:CGRectMake(screen_width/2, kSizeFrom750(55), screen_width/2-kOriginLeft, kSizeFrom750(40))];
            content.textAlignment=NSTextAlignmentRight;
            content.textColor=RGB(255,32,32);
            content.font=NUMBER_FONT(36);
            content.text=[CommonUtils getHanleNums:repay.total];
            [self addSubview:content];
            
            line1=[[UIView alloc] initWithFrame:CGRectMake(left1.left, kSizeFrom750(150)*(k+1)-kLineHeight, left1.width, kLineHeight)];
            line1.backgroundColor=RGB_233;
            [self addSubview:line1];
            
            
        }
        
    }
}

@end
