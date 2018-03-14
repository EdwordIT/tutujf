//
//  OneDetailBottomCellCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/4/11.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "OneDetailBottomCellCell.h"

@implementation OneDetailBottomCellCell
{
    UILabel *  lab0 ;
    UILabel *  lab1 ;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier left:(NSString *) left  right:(NSString*) right{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        lab0 = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 78,14)];
        lab0.font = CHINESE_SYSTEM(14);
        lab0.textColor =  RGB(183,183,183);
        lab0.text=left;
        [self addSubview:lab0];
        
         lab1 = [[UILabel alloc] initWithFrame:CGRectMake(92, 20, screen_width/2,14)];
        lab1.font = CHINESE_SYSTEM(14);
        lab1.textColor =  RGB(100,100,100);
        lab1.text=right;
        [self addSubview:lab1];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 55,screen_width , 0.5)];
        lineView.backgroundColor =lineBg;
        [self addSubview:lineView];
    }
    return self;
}
/*
 -(void) OnMenuBtn:(UIButton *) sender
 {
 NSInteger tag=sender.tag-1;
 [self.delegate didMenu1AtIndex:tag];
 }
 */

-(void)setDefaultValue:(NSString *) left  title:(NSString*) right
{
    lab0.text=left;
    lab1.text=right;
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
