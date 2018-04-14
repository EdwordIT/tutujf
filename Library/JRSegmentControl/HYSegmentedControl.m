//
//  HYSegmentedControl.m
//  CustomSegControlView
//
//  Created by sxzw on 14-6-12.
//  Copyright (c) 2014年 sxzw. All rights reserved.
//

#import "HYSegmentedControl.h"

#define HYSegmentedControl_Height 40.0
#define HYSegmentedControl_Width ([UIScreen mainScreen].bounds.size.width)
#define Min_Width_4_Button 70.0

#define Define_Tag_add 1000

#define UIColorFromRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface HYSegmentedControl()

@property (strong, nonatomic)UIScrollView *scrollView;
@property (strong, nonatomic)NSMutableArray *array4Btn;
@property (strong, nonatomic)UIView *bottomLineView;

@end

@implementation HYSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithOriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate
{
    CGRect rect4View = CGRectMake(.0f, y, HYSegmentedControl_Width, HYSegmentedControl_Height);
    if (self = [super initWithFrame:rect4View]) {
        
        self.backgroundColor = UIColorFromRGBValue(0xffffff);
        [self setUserInteractionEnabled:YES];
        
        self.delegate = delegate;
        
        //
        //  array4btn
        //
        _array4Btn = [[NSMutableArray alloc] initWithCapacity:[titles count]];
        
        //
        //  set button
        //
        CGFloat width4btn = rect4View.size.width/[titles count];
        if (width4btn < Min_Width_4_Button) {
            width4btn = Min_Width_4_Button;
        }
        //if(width4btn>Min_Width_4_Button)
        // width4btn = Min_Width_4_Button;
        CGFloat leftbtn=0;
        if([titles count]*width4btn<HYSegmentedControl_Width)
            leftbtn=(HYSegmentedControl_Width-[titles count]*width4btn)/2;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.backgroundColor = self.backgroundColor;
        self.scrollView.userInteractionEnabled = YES;
        self.scrollView.contentSize = CGSizeMake([titles count]*width4btn, HYSegmentedControl_Height);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        for (int i = 0; i<[titles count]; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*width4btn,0.0f, width4btn, HYSegmentedControl_Height);
            [btn setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitleColor:UIColorFromRGBValue(0xff0000) forState:UIControlStateSelected];
            [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = Define_Tag_add+i;
            [self.scrollView addSubview:btn];
            [_array4Btn addObject:btn];
            
            if (i == 0) {
                btn.selected = YES;
            }
        }
        
        //
        //  lineView
        //
      /*  CGFloat height4Line = HYSegmentedControl_Height/3.0f;
        CGFloat originY = (HYSegmentedControl_Height - height4Line)/2;
        for (int i = 1; i<[titles count]; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i*width4btn-1.0f, originY, 1.0f, height4Line)];
            lineView.backgroundColor = UIColorFromRGBValue(0xcccccc);
            [self.scrollView addSubview:lineView];
        }*/
        
        //
        //  bottom lineView
        //
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, HYSegmentedControl_Height-5, HYSegmentedControl_Width, 1.0f)];
        _bottomLineView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
        [self.scrollView addSubview:_bottomLineView];
        
        [self addSubview:self.scrollView];
    }
    return self;
}


- (id)initWithOriginLineY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate
{
     CGFloat hh=45;
    CGRect rect4View = CGRectMake(.0f, y, HYSegmentedControl_Width, hh);
    
    if (self = [super initWithFrame:rect4View]) {
        
        self.backgroundColor = UIColorFromRGBValue(0xffffff);
        [self setUserInteractionEnabled:YES];
        
        self.delegate = delegate;
        
        //
        //  array4btn
        //
        _array4Btn = [[NSMutableArray alloc] initWithCapacity:[titles count]];
        
        //
        //  set button
        //
        CGFloat width4btn = HYSegmentedControl_Width/[titles count];
        if (width4btn < Min_Width_4_Button) {
            width4btn = Min_Width_4_Button;
        }
       
        
        CGFloat leftbtn=0;
        if([titles count]*width4btn<HYSegmentedControl_Width)
            leftbtn=(HYSegmentedControl_Width-[titles count]*width4btn)/2;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.backgroundColor = self.backgroundColor;
        self.scrollView.userInteractionEnabled = YES;
        self.scrollView.contentSize = CGSizeMake([titles count]*width4btn, hh);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        for (int i = 0; i<[titles count]; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*width4btn,0.0f, width4btn, hh);
            [btn setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitleColor:UIColorFromRGBValue(0xff0000) forState:UIControlStateSelected];
            [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(segmentedControlChangeLine:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = Define_Tag_add+i;
            [self.scrollView addSubview:btn];
            [_array4Btn addObject:btn];
            
            if (i == 0) {
                btn.selected = YES;
            }
        }
        
        //
        //  lineView
        //
        /*
         CGFloat height4Line = HYSegmentedControl_Height/3.0f;
         CGFloat originY = (HYSegmentedControl_Height - height4Line)/2;
         for (int i = 1; i<[titles count]; i++) {
         UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i*width4btn-1.0f, originY, 1.0f, height4Line)];
         lineView.backgroundColor = RGB(254,85,78);
         [self.scrollView addSubview:lineView];
        
         }*/
        //
        //  bottom lineView
        //
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(15, hh-5, width4btn-30, 2.0f)];
        _bottomLineView.backgroundColor = RGB(254,85,78);
        [self.scrollView addSubview:_bottomLineView];
        
        [self addSubview:self.scrollView];
    }
    return self;
}


- (id)initWithOriginY:(CGFloat)y Titles:(NSArray *)titles Images:(NSArray *)imgs delegate:(id)delegate
{
    CGRect rect4View = CGRectMake(.0f, y, HYSegmentedControl_Width, HYSegmentedControl_Height);
    if (self = [super initWithFrame:rect4View]) {
        
        self.backgroundColor = UIColorFromRGBValue(0xffffff);
        [self setUserInteractionEnabled:YES];
        
        self.delegate = delegate;
        
        //
        //  array4btn
        //
        _array4Btn = [[NSMutableArray alloc] initWithCapacity:[imgs count]];
        
        //
        //  set button
        //
        CGFloat width4btn = rect4View.size.width/[imgs count];
        if (width4btn < Min_Width_4_Button) {
            width4btn = Min_Width_4_Button;
        }
        //if(width4btn>Min_Width_4_Button)
        // width4btn = Min_Width_4_Button;
        CGFloat leftbtn=0;
        if([imgs count]*width4btn<HYSegmentedControl_Width)
            leftbtn=(HYSegmentedControl_Width-[imgs count]*width4btn)/2;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.backgroundColor = self.backgroundColor;
        self.scrollView.userInteractionEnabled = YES;
        self.scrollView.contentSize = CGSizeMake([imgs count]*width4btn, HYSegmentedControl_Height);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        for (int i = 0; i<[imgs count]; i++) {
            
            UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(i*width4btn+35,8.0f, 45, 18)];
            [imagev setImage:[UIImage imageNamed:[imgs objectAtIndex:i]]];
               imagev.userInteractionEnabled = YES;
             imagev.tag = Define_Tag_add+i;
          //  UIImageView *img = [[UIImageView init] alloc];
          //  img.frame = CGRectMake(i*width4btn,0.0f, width4btn, HYSegmentedControl_Height);
             UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*width4btn+35,8.0f, 45, 18);
            btn.backgroundColor=[UIColor clearColor];
            [btn addTarget:self action:@selector(segmentedControlChangeImg:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = Define_Tag_add+i;
            
           // [btn addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventTouchUpInside];
           
            [self.scrollView addSubview:imagev];
            [self.scrollView addSubview:btn];
           // [_array4Btn addObject:img];
            
           // if (i == 0) {
           //     img.selected = YES;
           // }
        }
        
        //
        //  lineView
        //
        /*  CGFloat height4Line = HYSegmentedControl_Height/3.0f;
         CGFloat originY = (HYSegmentedControl_Height - height4Line)/2;
         for (int i = 1; i<[titles count]; i++) {
         UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i*width4btn-1.0f, originY, 1.0f, height4Line)];
         lineView.backgroundColor = UIColorFromRGBValue(0xcccccc);
         [self.scrollView addSubview:lineView];
         }*/
        
        //
        //  bottom lineView
        //
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, HYSegmentedControl_Height-5, HYSegmentedControl_Width, 1.0f)];
        _bottomLineView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
        [self.scrollView addSubview:_bottomLineView];
        
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void) segmentedControlChangeImg:(id)sender
{
      UIImageView *item=(UIImageView *)sender;

    if (self.delegate && [self.delegate respondsToSelector:@selector(hySegmentedControlSelectAtIndex:)]) {
        [self.delegate hySegmentedControlSelectAtIndex:item.tag - 1000];
    }

    
}

//
//  btn clicked
//
- (void)segmentedControlChange:(UIButton *)btn
{
    btn.selected = YES;
    for (UIButton *subBtn in self.array4Btn) {
        if (subBtn != btn) {
            subBtn.selected = NO;
        }
    }
    
    CGRect rect4boottomLine = self.bottomLineView.frame;
    rect4boottomLine.origin.x = btn.frame.origin.x+15 ;
    rect4boottomLine.size.width=btn.frame.size.width-30;
    
    CGPoint pt = CGPointZero;
    BOOL canScrolle = NO;
    if ((btn.tag - Define_Tag_add) >= 2 && [_array4Btn count] > 4 && [_array4Btn count] > (btn.tag - Define_Tag_add + 2)) {
        pt.x = btn.frame.origin.x - Min_Width_4_Button*1.5f;
        canScrolle = YES;
    }else if ([_array4Btn count] > 4 && (btn.tag - Define_Tag_add + 2) >= [_array4Btn count]){
        pt.x = (_array4Btn.count - 4) * Min_Width_4_Button;
        canScrolle = YES;
    }else if (_array4Btn.count > 4 && (btn.tag - Define_Tag_add) < 2){
        pt.x = 0;
        canScrolle = YES;
    }
    
    if (canScrolle) {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = pt;
        } completion:^(BOOL finished) {
           // [UIView animateWithDuration:0.2 animations:^{
          //      self.bottomLineView.frame = rect4boottomLine;
          //  }];
        }];
    }else{
       // [UIView animateWithDuration:0.2 animations:^{
        //    self.bottomLineView.frame = rect4boottomLine;
       // }];
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hySegmentedControlSelectAtIndex:)]) {
        [self.delegate hySegmentedControlSelectAtIndex:btn.tag - 1000];
    }
}



- (void)segmentedControlChangeLine:(UIButton *)btn
{
    btn.selected = YES;
    for (UIButton *subBtn in self.array4Btn) {
        if (subBtn != btn) {
            subBtn.selected = NO;
        }
    }
    
    CGRect rect4boottomLine = self.bottomLineView.frame;
    rect4boottomLine.origin.x = btn.frame.origin.x+15 ;
    rect4boottomLine.size.width=btn.frame.size.width-30;
   
    
    CGPoint pt = CGPointZero;
    BOOL canScrolle = NO;
    if ((btn.tag - Define_Tag_add) >= 2 && [_array4Btn count] > 4 && [_array4Btn count] > (btn.tag - Define_Tag_add + 2)) {
        //pt.x = btn.frame.origin.x - Min_Width_4_Button*1.5f;
        canScrolle = YES;
    }else if ([_array4Btn count] > 4 && (btn.tag - Define_Tag_add + 2) >= [_array4Btn count]){
       // pt.x = (_array4Btn.count - 4) * Min_Width_4_Button;
        canScrolle = YES;
    }else if (_array4Btn.count > 4 && (btn.tag - Define_Tag_add) < 2){
        pt.x = 0;
        canScrolle = YES;
    }
    self.bottomLineView.backgroundColor=RGB(254,85,78);
    
    if (canScrolle) {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = pt;
        } completion:^(BOOL finished) {
             [UIView animateWithDuration:0.2 animations:^{
                  self.bottomLineView.frame = rect4boottomLine;
              }];
        }];
    }else{
         [UIView animateWithDuration:0.2 animations:^{
            self.bottomLineView.frame = rect4boottomLine;
         }];
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hySegmentedControlSelectAtIndex:)]) {
        [self.delegate hySegmentedControlSelectAtIndex:btn.tag - 1000];
    }

}

// index 从 0 开始
// delegete method
- (void)changeSegmentedControlWithIndex:(NSInteger)index
{
    if (index > [_array4Btn count]-1) {
        NSLog(@"index 超出范围");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"index 超出范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        return;
    }
    
    UIButton *btn = [_array4Btn objectAtIndex:index];
    [self segmentedControlChange:btn];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
