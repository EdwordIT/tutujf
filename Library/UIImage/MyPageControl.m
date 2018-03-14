//
//  MyPageControl.m
//  DingXinDai
//
//  Created by 占碧光 on 2016/12/18.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import "MyPageControl.h"

@implementation MyPageControl

//重写setCurrentPage方法，可设置圆点大小
- (void) setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 0.1;
        size.width = 0.1;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
    }
}

@end
