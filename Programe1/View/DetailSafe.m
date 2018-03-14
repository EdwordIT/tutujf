//
//  DetailSafe.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DetailSafe.h"
#import "SecurityModel.h"



@interface DetailSafe ()
{
    NSMutableArray * dataAry;
  
    
}
@end


@implementation DetailSafe

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
    dataAry=model.security_audit;
    self.backgroundColor=[UIColor whiteColor];
    if(dataAry!=nil)
    {
        for(int k=0;k<dataAry.count;k++)
        {
            //Hone_Column_Rapidinvestment_
            
            UIImageView *typeimgsrc= [[UIImageView alloc] initWithFrame:CGRectMake(13, 20,3, 15)];
            [typeimgsrc setImage:[UIImage imageNamed:@"Hone_Column_Rapidinvestment_"]];
            [self addSubview:typeimgsrc];
            SecurityModel * security=[dataAry objectAtIndex:k];
            UILabel * title=[[UILabel alloc] initWithFrame:CGRectMake(20, 18, screen_width-40, 13)];
            if(k==0)
            {
                title.frame=CGRectMake(22, 21, screen_width-40, 13);
            }
             else if(k==1)
             {
                 title.frame=CGRectMake(22, 139.5, screen_width-40, 13);
                 typeimgsrc.frame=CGRectMake(13, 138,3, 15);
             }
            else if(k==2)
            {
                title.frame=CGRectMake(22, 301, screen_width-40, 13);
                   typeimgsrc.frame=CGRectMake(13, 301,3, 15);
            }
             title.textColor=RGB(83,83,83);
            title.textAlignment=NSTextAlignmentLeft;
            title.text=security.title;
            title.font=CHINESE_SYSTEM(13);
            [self addSubview:title];
            
            UILabel * content=[[UILabel alloc] initWithFrame:CGRectMake(20, 20, screen_width-35, 200)];
            if(k==0)
            {
                content.frame=CGRectMake(20, -20, screen_width-35, 200);
            }
           else  if(k==1)
            {
                content.frame=CGRectMake(20, 120, screen_width-35, 200);
            }
            else if(k==2)
            {
                content.frame=CGRectMake(20, 282, screen_width-35, 200);
            }
            content.textAlignment=NSTextAlignmentLeft;
            content.textColor=RGB(83,83,83);
            content.font=CHINESE_SYSTEM(13);
            content.numberOfLines=0;
     
            content=[self setData:security.contents titleLabel:content ];
            [self addSubview:content];
            
   
        }
    
    }
}

-(UILabel *) setData:(NSString *)title titleLabel:(UILabel *) titleLabel
{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:4*2.25];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
    
    titleLabel.attributedText = attributedString;
    return titleLabel;
}


@end
