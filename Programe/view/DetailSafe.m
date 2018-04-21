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
    NSArray * dataAry;
  
    
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
        self.backgroundColor=RGB_233;

    }
    return self;
}

-(CGFloat) setModel:(LoanBase *) model
{
    dataAry=model.security_audit;
    self.backgroundColor=[UIColor whiteColor];
    if(dataAry!=nil)
    {
        CGFloat originBottom = kSizeFrom750(40);
        CGFloat originSpace = kSizeFrom750(10);
        for(int k=0;k<dataAry.count;k++)
        {
           
            UIImageView *typeimgsrc= [[UIImageView alloc] initWithFrame:CGRectMake(kSizeFrom750(30), originBottom,kSizeFrom750(6), kSizeFrom750(24))];
            [typeimgsrc setImage:[UIImage imageNamed:@"pro_title_left"]];
            [self addSubview:typeimgsrc];
            
            SecurityModel * security=[dataAry objectAtIndex:k];
            UILabel * title=[[UILabel alloc] initWithFrame:CGRectMake(typeimgsrc.right+originSpace, originBottom-kSizeFrom750(6), screen_width-kSizeFrom750(70), kSizeFrom750(30))];
            title.centerY = typeimgsrc.centerY;
            title.textColor=RGB(83,83,83);
            title.text=security.title;
            title.font=SYSTEMSIZE(26);
            [self addSubview:title];
            
            UILabel * content=[[UILabel alloc] init];
            CGFloat contentHeight = [CommonUtils getSpaceLabelHeight:security.contents withFont:SYSTEMSIZE(28) withWidth:title.width lineSpace:kSizeFrom750(10)];
            content.frame = CGRectMake(title.left, title.bottom+kSizeFrom750(20), title.width, contentHeight);
            content.textColor=RGB(83,83,83);
            content.font=SYSTEMSIZE(28);
            content.numberOfLines=0;
            [self setData:security.contents titleLabel:content];
            [self addSubview:content];
            
            originBottom = content.bottom+originSpace*2;
            
            if (k==dataAry.count-1) {
                //总高度
                self.height = originBottom;
                self.backgroundColor = [UIColor whiteColor];
                return  originBottom+originSpace*2;
                
            }
            
   
        }
    
    }
    return 100;
}

-(void)setData:(NSString *)title titleLabel:(UILabel *) titleLabel
{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:kSizeFrom750(10)];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
    
    titleLabel.attributedText = attributedString;
}


@end
