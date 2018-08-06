//
//  UIView+LineView.m
//  TTJF
//
//  Created by wbzhan on 2018/8/4.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "UIView+LineView.h"

@implementation UIView (LineView)
-(void)addLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = separaterColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.width.mas_equalTo(self);
        make.height.mas_equalTo(kLineHeight);
        
    }];
}
-(void)addCellSeparatorView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = separaterColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(kOriginLeft);
        make.right.mas_equalTo(-kOriginLeft);
        make.height.mas_equalTo(kLineHeight);
        
    }];
}
@end
