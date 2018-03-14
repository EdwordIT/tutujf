//
//  SZCalendarCell.m
//  SZCalendarPicker
//
//  Created by Stephen Zhuang on 14/12/1.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import "SZCalendarCell.h"

@implementation SZCalendarCell
- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:15]];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,35, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
        [_dateLabel addSubview:lineView];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(35, 0,0.5, 35)];
        lineView1.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
        [_dateLabel addSubview:lineView1];
        
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}
@end
