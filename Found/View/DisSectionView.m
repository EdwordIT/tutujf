//
//  DisSectionView.m
//  TTJF
//
//  Created by wbzhan on 2018/7/31.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "DisSectionView.h"
@implementation DisSectionView
-(instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
-(void)loadSectionWithArray:(NSArray  *)data
{
    [self removeAllSubViews];
    CGFloat menuWidth = screen_width/3;
    CGFloat menuHeight = kSizeFrom750(192);
    CGFloat lineWidth = kLineHeight;
    if (!data) {
        NSArray *arr = @[@"关于土土",@"行业资讯",@"风控合作",@"运营报告",@"意见反馈",@"帮助中心"];
        NSMutableArray *mArr = InitObject(NSMutableArray);
        for (int i=0; i<arr.count; i++) {
            DiscoverMenuModel * model;
            model.title = arr[i];
            [mArr addObject:model];
        }
        data = mArr;
    }
    for (int i=0; i<data.count; i++) {
        
        DiscoverMenuModel * model=[data objectAtIndex:i];
        
        UIView *menuView = InitObject(UIView);
        menuView.frame = RECT((i%3)*menuWidth, (i/3)*menuHeight, menuWidth, menuHeight);
        menuView.tag = i;
        [self addSubview:menuView];
        
        //最右边儿元素不加
        if (i%3!=2) {
            CALayer *rightLayer = [CALayer layer];
            rightLayer.frame = RECT(menuView.width - lineWidth, 0, lineWidth, menuHeight);
            rightLayer.backgroundColor = [separaterColor CGColor];
            [menuView.layer addSublayer:rightLayer];
        }
        //最下排元素不加
        if (i/3!=1) {
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
-(void)menuClick:(UITapGestureRecognizer *)ges{
    
    if ([self.delegate respondsToSelector:@selector(didTapSectionButton:)]) {
        [self.delegate didTapSectionButton:ges.view.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
