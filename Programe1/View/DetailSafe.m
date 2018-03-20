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

    }
    return self;
}

-(CGFloat) setModel:(LoanBase *) model
{
    dataAry=model.security_audit;
    self.backgroundColor=[UIColor whiteColor];
    if(dataAry!=nil)
    {
        CGFloat originBottom = 20;
        for(int k=0;k<dataAry.count;k++)
        {
           
            UIImageView *typeimgsrc= [[UIImageView alloc] initWithFrame:CGRectMake(13, originBottom,3, 15)];
            [typeimgsrc setImage:[UIImage imageNamed:@"Hone_Column_Rapidinvestment_"]];
            [self addSubview:typeimgsrc];
            SecurityModel * security=[dataAry objectAtIndex:k];
            UILabel * title=[[UILabel alloc] initWithFrame:CGRectMake(20, 1+originBottom, screen_width-40, 13)];
            title.textColor=RGB(83,83,83);
            title.textAlignment=NSTextAlignmentLeft;
            title.text=security.title;
            title.font=CHINESE_SYSTEM(13);
            [self addSubview:title];
            
            UILabel * content=[[UILabel alloc] init];
            CGFloat contentHeight = [CommonUtils getSpaceLabelHeight:security.contents withFont:CHINESE_SYSTEM(13) withWidth:screen_width-35 lineSpace:9];
            content.frame = CGRectMake(20, title.bottom+10, screen_width-35, contentHeight);
            content.textColor=RGB(83,83,83);
            content.font=CHINESE_SYSTEM(13);
            content.numberOfLines=0;
            [self setData:security.contents titleLabel:content];
            [self addSubview:content];
            
            originBottom = content.bottom+10;
            
            if (k==dataAry.count-1) {
                //总高度
                self.height = originBottom;
                self.backgroundColor = [UIColor whiteColor];
                return  originBottom+10;
                
            }
            
   
        }
    
    }
    return 100;
}

-(void)setData:(NSString *)title titleLabel:(UILabel *) titleLabel
{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:4*2.25];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
    
    titleLabel.attributedText = attributedString;
}


@end
