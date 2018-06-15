//
//  NavHomeView.m
//  DingXinDai
//
//  Created by 占碧光 on 2016/12/12.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import "NavHomeView.h"

@implementation NavHomeView
{
 
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    
    self.backgroundColor = [UIColor clearColor];
    
    _navLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width /2.0 -100, 20, 200, 44)];
    _navLabel.text = @"土土金服";
    _navLabel.textAlignment = NSTextAlignmentCenter;
    _navLabel.textColor = [UIColor whiteColor];
    [_navLabel setFont:[UIFont systemFontOfSize:Title_Font]];
    [self addSubview:_navLabel];
    

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
