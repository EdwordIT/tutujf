//
//  ChangeToolBar.m
//  ThemisSurvey
//
//  Created by Gao on 15/10/6.
//  Copyright (c) 2015年 Themis Credit Mangement. All rights reserved.
//


//#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//底线线宽
#define LineWidth 0.5
//底线颜色
#define GrayLine RGB(212,212,212)
//按钮默认颜色
#define GRAY_COLOR_16 RGB(102,102,102)
//按钮选中颜色
#define BLUE_COLOR_16 RGB(0,160,240)

#import "HorizontalMenu.h"
#import "UIViewExt.h"
#import "Utility.h"

@interface RemoveBtnHighlighted : UIButton

@end
@implementation RemoveBtnHighlighted
- (void)setHighlighted:(BOOL)highlighted{}
@end




@interface HorizontalMenu()
{
    RemoveBtnHighlighted *_tmpBtn;
    UIView *_selectLine;
}
@end

@implementation HorizontalMenu

- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles
{
    if (self = [super initWithFrame:frame]) {
        [self creatTopToolBar:titles];
    }
    return self;
}

/**
 *  创建顶部排序工具条
 */
- (void)creatTopToolBar:(NSArray *)titles
{
    
    //背景view
    CGFloat backViewW = screen_width;
    CGFloat backViewX = 0;
    CGFloat backViewH = 44;
    CGFloat backViewY = 0;
    UIView *backView = [[UIView alloc] init];
    backView.alpha = 0.9;
    backView.frame = CGRectMake(backViewX, backViewY, backViewW, backViewH);
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];

    //底部灰色的线
    CGFloat lineW = backViewW;
    CGFloat lineH = LineWidth;
    CGFloat lineX = 0;
    CGFloat lineY = backViewH - lineH;
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(lineX, lineY, lineW, lineH);
    line.backgroundColor = GrayLine;
    [backView addSubview:line];
    
    //两个按钮
    CGFloat buttonW = screen_width / titles.count;
    CGFloat buttonH = 35;
    CGFloat buttonY = (backViewH - buttonH) / 2.0;
    
    for (int i = 0; i < titles.count; i++) {
        
        CGFloat buttonX = i * buttonW;
        RemoveBtnHighlighted *button = [RemoveBtnHighlighted buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:CHINESE_SYSTEM(15)];
        [button setTitleColor:GRAY_COLOR_16 forState:UIControlStateNormal];
        [button setTitleColor:BLUE_COLOR_16 forState:UIControlStateSelected];
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        if (button.tag == 0) {
            button.selected = YES;
            //记录选中的按钮
            _tmpBtn = button;
            _button = _tmpBtn;
        }
        
        
        [backView addSubview:button];
    }
    
    CGSize size = [Utility sizeWithText:_tmpBtn.titleLabel.text font:_tmpBtn.titleLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    //选中线
    CGFloat selectLineW = size.width;
    CGFloat selectLineH = 2.5;
    CGFloat selectLineX = (_tmpBtn.width - selectLineW) / 2;
    CGFloat selectLineY = line.top - selectLineH + 0.5;
    _selectLine = [[UIView alloc] init];
    _selectLine.backgroundColor = BLUE_COLOR_16;
    _selectLine.frame = CGRectMake(selectLineX-20, selectLineY, selectLineW+40, selectLineH);
    [backView addSubview:_selectLine];

}


#pragma mark - 分栏按钮点击事件
/**
 *  距离最近/收入最高
 */
- (void)btnAction:(RemoveBtnHighlighted *)button
{
    //设置按钮不能重复点击
    if (button == _tmpBtn) {
        return;
    }
    
    
    //切换_selectLine的位置
    [UIView animateWithDuration:.35 animations:^{
        self->_selectLine.center = CGPointMake(button.center.x, button.bottom+3);
        
    }];
    
    //保证同时只有一个按钮被选中
    [self selectButton:button];
    
    if ([_delegate respondsToSelector:@selector(clieckButton:)]) {
        [_delegate clieckButton:button];
    }
}
/**
 *  保证同时只有一个按钮被选中
 */
- (void)selectButton:(RemoveBtnHighlighted *)button
{
    //保证同时只有一个按钮被选中
    if (_tmpBtn == nil){
        button.selected = YES;
        _tmpBtn = button;
    }
    else if (_tmpBtn !=nil && _tmpBtn == button){
        button.selected = YES;
        
    }
    else if (_tmpBtn!= button && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        button.selected = YES;
        _tmpBtn = button;
    }
}
@end
