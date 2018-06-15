//
//  DetailInvest.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DetailInvest.h"

@implementation DetailInvest
{
    UIView *line1;
}
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
    }
    return self;
}

-(void) setModel:(LoanBase *) model
{
    TenderModel *tenderModel = model.tender_list;
    UILabel * content=[[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-200, 80, 400, 15)];
    if([tenderModel.is_show_tenlist isEqual:@"-1"])//如果不显示投资列表
    {
       content.textAlignment=NSTextAlignmentCenter;
       content.textColor=RGB(83,83,83);
       content.font=SYSTEMSIZE(30);
       content.text=tenderModel.not_lktenlist_title;
       [self addSubview:content];
    }
    else{
       
        self.backgroundColor=[UIColor whiteColor];
        if(tenderModel.items!=nil)
        {
            for(int k=0;k<tenderModel.items.count;k++)
            {
                //Hone_Column_Rapidinvestment_
                TenderDetailModel * tenDetail=[tenderModel.items objectAtIndex:k];
                UILabel * left1=[[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, kSizeFrom750(50)+kSizeFrom750(150)*k, screen_width-kOriginLeft*2, kSizeFrom750(30))];
                left1.textColor=RGB(31,31,31);
                left1.text=tenDetail.member_name;
                left1.font=SYSTEMSIZE(26);
                [self addSubview:left1];
                
                
                UILabel * left2=[[UILabel alloc] initWithFrame:CGRectMake(left1.left, left1.bottom+kSizeFrom750(20), left1.width, kSizeFrom750(30))];
                left2.textColor=RGB(146,146,146);
                left2.text= tenDetail.add_time;
                left2.font=NUMBER_FONT(26);
                [self addSubview:left2];
                
                UILabel * content=[[UILabel alloc] initWithFrame:CGRectMake(screen_width/2, kSizeFrom750(55)+kSizeFrom750(150)*k, screen_width/2-kOriginLeft, kSizeFrom750(40))];
                content.textAlignment=NSTextAlignmentRight;
                content.textColor=RGB(255,32,32);
                content.font=NUMBER_FONT(36);
                content.text=[CommonUtils getHanleNums:tenDetail.amount];
                [self addSubview:content];
                
                line1=[[UIView alloc] initWithFrame:CGRectMake(left1.left, kSizeFrom750(150)*(k+1) - kLineHeight, left1.width, kLineHeight)];
                line1.backgroundColor=RGB_233;
                [self addSubview:line1];
                
                
            }
            
        }
    }
//
}

@end
