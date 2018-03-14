//
//  WalletMenu2Cell.m
//  DingXinDai
//
//  Created by 占碧光 on 16/6/26.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import "WalletMenu2Cell.h"

@implementation WalletMenu2Cell



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imgsrc:(NSString *) imgsrc  title:(NSString*) title imgsrcright:(NSString *) imgsrcright{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imagev1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 18,18)];
        [imagev1 setImage:[UIImage imageNamed:imgsrc]];
        [self addSubview:imagev1];
        
        UILabel *  lab1 = [[UILabel alloc] initWithFrame:CGRectMake(48, 20, screen_width/2,15)];
        lab1.font = CHINESE_SYSTEM(15);
        lab1.textColor =  RGB(53,53,53);
        lab1.text=title;
        [self addSubview:lab1];
        
        UIImageView *imagev2 = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width-57, 23, 25,9)];
        [imagev2 setImage:[UIImage imageNamed:imgsrcright]];
        [self addSubview:imagev2];
        
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 54,screen_width-15 , 0.5)];
        self.lineView.backgroundColor =lineBg;
        [self addSubview:self.lineView];
        
        
        
        
    }
    return self;
}

/*

-(void) OnMenuBtn:(UIButton *) sender
{
    NSInteger tag=sender.tag-1;
    [self.delegate didMenu2AtIndex:tag];
}

*/
-(void)setDefaultValue:(NSString *) imgsrc  title:(NSString*) title imageright:(NSString*) imageright
{
    self.title=title;
    self.imgsrc=imgsrc;
    self.imgsrcright=imageright;
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
