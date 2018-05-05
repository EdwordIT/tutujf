//
//  TreasureMiddleCell.m
//  DingXinDai
//
//  Created by 占碧光 on 2016/12/8.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import "TreasureMiddleCell.h"
#import "DiscoverMenuModel.h"
@implementation TreasureMiddleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
      
    }
    return self;
}
-(void)menuClick:(UITapGestureRecognizer *)ges{
    
    if ([self.delegate respondsToSelector:@selector(didTreasureMiddleIndex:)]) {
        [self.delegate didTreasureMiddleIndex:ges.view.tag];
    }
}



-(void) setDataBind:(NSMutableArray *) data
{
    [self.contentView removeAllSubViews];
    CGFloat menuWidth = screen_width/3;
    CGFloat menuHeight = kSizeFrom750(192);
    CGFloat lineWidth = kLineHeight;
    for (int i=0; i<data.count; i++) {
        
        DiscoverMenuModel * model=[data objectAtIndex:i];

        UIView *menuView = InitObject(UIView);
        menuView.frame = RECT((i%3)*menuWidth, (i/3)*menuHeight, menuWidth, menuHeight);
        menuView.tag = i;
        [self.contentView addSubview:menuView];
        
        //最右边儿元素不加
        if (i%3!=2) {
            CALayer *rightLayer = [CALayer layer];
            rightLayer.frame = RECT(menuView.width - lineWidth, 0, lineWidth, menuHeight);
            rightLayer.backgroundColor = [separaterColor CGColor];
            [menuView.layer addSublayer:rightLayer];
        }
       //最下排元素不加
        if ((data.count - (i/3)*3)/3!=0) {
            CALayer *bottomLayer = [CALayer layer];
            bottomLayer.frame = RECT(0, menuHeight-1, menuWidth, lineWidth);
            bottomLayer.backgroundColor = [separaterColor CGColor];
            [menuView.layer addSublayer:bottomLayer];
        }
        
        UIImageView *iconImage = InitObject(UIImageView);
        iconImage.frame = RECT(0, kSizeFrom750(25), kSizeFrom750(90), kSizeFrom750(90));
        iconImage.centerX = menuWidth/2;
        [menuView addSubview:iconImage];
        [iconImage setImageWithString:model.pic_url];
        
        
        UILabel  * lab1=[[UILabel alloc] initWithFrame:CGRectMake(0, iconImage.bottom+kSizeFrom750(20),menuWidth, kSizeFrom750(30))];
        lab1.font = SYSTEMSIZE(24);
        lab1.textColor=RGB_102;
        lab1.textAlignment=NSTextAlignmentCenter;
        lab1.text=model.title;
        [menuView addSubview:lab1];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuClick:)];
        menuView.userInteractionEnabled = YES;
        [menuView addGestureRecognizer:ges];
    }
    
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
