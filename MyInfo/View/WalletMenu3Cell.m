//
//  WalletMenu3Cell.m
//  DingXinDai
//
//  Created by 占碧光 on 16/7/6.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import "WalletMenu3Cell.h"
#import "UIImageView+WebCache.h"


@implementation WalletMenu3Cell
{
    UIImageView *imagev1;
    UILabel *  lab1;
    UILabel *  lab2 ;
    UIImageView *imagev2 ;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imgsrc:(NSString *) imgsrc  title:(NSString*) title right:(NSString *)right {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSRange range;
        range = [right rangeOfString:@".png"];
        NSRange range1;
        range1 = [right rangeOfString:@"http"];
        if (range.location != NSNotFound||range1.location != NSNotFound) {
        //    NSLog(@"found at location = %d, length = %d",range.location,range.length);
            
            imagev1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, 20,20)];
            [imagev1 setImage:[UIImage imageNamed:imgsrc]];
            [self addSubview:imagev1];
            
             lab1 = [[UILabel alloc] initWithFrame:CGRectMake(45, 28, screen_width/2,12)];
            lab1.font = CHINESE_SYSTEM(14);
            lab1.textColor =  [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
            lab1.text=title;
            [self addSubview:lab1];
            
            imagev2 = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width-75, 10, 45,45)];
            if(range1.location != NSNotFound)
            [imagev2 sd_setImageWithURL:[NSURL URLWithString:right] placeholderImage:[UIImage imageNamed:@"qd_zhzx.png"]];
             else
             [imagev2 setImage:[UIImage imageNamed:right]];
            imagev2.layer.cornerRadius =22.5f;
        
            [self addSubview:imagev2];
            
            
            
        }else{
         //   NSLog(@"Not Found");
         imagev1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20,20)];
            [imagev1 setImage:[UIImage imageNamed:imgsrc]];
            [self addSubview:imagev1];
            
           lab1 = [[UILabel alloc] initWithFrame:CGRectMake(45, 19, screen_width/2,12)];
            lab1.font = CHINESE_SYSTEM(14);
            lab1.textColor =  [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
            lab1.text=title;
            [self addSubview:lab1];
            
             lab2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width-165, 18, 130,12)];
            lab2.font = CHINESE_SYSTEM(12);
            lab2.textColor =  [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
            lab2.textAlignment=NSTextAlignmentRight;
            lab2.text=right;
            [self addSubview:lab2];
        }
        
      
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 49,screen_width-30 , 0.5)];
        self.lineView.backgroundColor = lineBg;
        [self addSubview:self.lineView];
    }
    return self;
}

-(void)setDefaultValue:(NSString *) imgsrc  title:(NSString*) title right:(NSString *)right
{
    NSRange range;
    range = [right rangeOfString:@".png"];
    NSRange range1;
    range1 = [right rangeOfString:@"http"];
    if (range.location != NSNotFound||range1.location != NSNotFound) {
        
        lab1.text=title;
        [imagev1 setImage:[UIImage imageNamed:imgsrc]];
        if(range1.location != NSNotFound)
            [imagev2 sd_setImageWithURL:[NSURL URLWithString:right] placeholderImage:[UIImage imageNamed:@"qd_zhzx.png"]];
        else
            [imagev2 setImage:[UIImage imageNamed:right]];
    }
    
    else
    {
        lab1.text=title;
        [imagev1 setImage:[UIImage imageNamed:imgsrc]];
        lab2.text=right;
    
    }
   
}


@end
