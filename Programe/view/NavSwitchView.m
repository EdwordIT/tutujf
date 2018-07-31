//
//  NavSwitchView.m
//  TTJF
//
//  Created by wbzhan on 2018/4/26.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "NavSwitchView.h"
#define titleSpace 1
@interface NavSwitchView()
Strong UIView *backView;
@end
@implementation NavSwitchView
{
    NSArray *nameArray;
}

-(instancetype)initWithFrame:(CGRect)frame Array:(NSArray <NSString *>*)titleArray{
 
    nameArray = titleArray;
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        self.selectIndex = 0;
    }
    return self;
}
-(void)initSubViews
{
    
    CGFloat btnW = 69;
    CGFloat btnH = 24;//按钮高度
    CGFloat viewBottomH = 9;//view距离navigationbar底部距离
    CGFloat cornerRadius = 5;
    self.backView = InitObject(UIView);
    self.backView.backgroundColor = COLOR_White;
    self.backView.frame = RECT((screen_width - btnW*nameArray.count+titleSpace*2)/2, self.height - btnH -titleSpace*2 -viewBottomH,btnW*nameArray.count+titleSpace*2, btnH+titleSpace*2);
    self.backView.layer.cornerRadius = cornerRadius;
    self.backView.layer.masksToBounds = YES;
    [self addSubview:self.backView];
    for (int i=0; i<nameArray.count; i++) {
        UIButton *btn = InitObject(UIButton);
        btn.frame = RECT(titleSpace+btnW*i, titleSpace, btnW, btnH);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:nameArray[i] forState:UIControlStateNormal];
        btn.tag = i;
        [self.backView addSubview:btn];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        
        UIBezierPath *fieldPath;
        if(i==0)
        {
            fieldPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(cornerRadius , cornerRadius)];
            CAShapeLayer *fieldLayer = [[CAShapeLayer alloc] init];
            fieldLayer.frame = btn.bounds;
            fieldLayer.path = fieldPath.CGPath;
            btn.layer.mask = fieldLayer;
        }
        if (i==nameArray.count-1) {
            fieldPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius , cornerRadius)];
            CAShapeLayer *fieldLayer = [[CAShapeLayer alloc] init];
            fieldLayer.frame = btn.bounds;
            fieldLayer.path = fieldPath.CGPath;
            btn.layer.mask = fieldLayer;
        }
        
    }
}
-(void)btnClick:(UIButton *)sender{
  
    [self reloadSelect:sender.tag];
}
//刷新数据
-(void)reloadSelect:(NSInteger)index{
    for (UIButton *btn in self.backView.subviews) {
        if (btn.tag==index) {
            [btn setTitleColor:navigationBarColor forState:UIControlStateNormal];//选中状态
            btn.backgroundColor = [UIColor clearColor];
        }else{
            [btn setTitleColor:COLOR_White forState:UIControlStateNormal];//未选中状态
            btn.backgroundColor = navigationBarColor;
        }
    }
    if (self.switchBlock) {
        self.switchBlock(index);//点击事件响应
    }
    
}
-(void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    [self reloadSelect:selectIndex];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
