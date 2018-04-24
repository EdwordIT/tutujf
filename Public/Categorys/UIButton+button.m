//
//  UIButton+button.m
//  TTJF
//
//  Created by wbzhan on 2018/4/24.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "UIButton+button.h"

@implementation UIButton (button)
-(instancetype)init{
    self = [super init];
    if (self) {
        //
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}
@end
