//
//  UINavigationController+MBNavigation.m
//  MBTools
//
//  Created by wbzhan on 2017/12/15.
//  Copyright © 2017年 MedicalBeauty. All rights reserved.
//

#import "UINavigationController+MBNavigation.h"
#import <objc/runtime.h>
@implementation UINavigationController (MBNavigation)
@dynamic tag;

static const void *tagKey = @"tagKey";

-(void)setTag:(NSString *)tag
{
    objc_setAssociatedObject(self, tagKey, tag, OBJC_ASSOCIATION_ASSIGN);
}
-(NSString *)tag{
    return objc_getAssociatedObject(self, tagKey);
}
@end
