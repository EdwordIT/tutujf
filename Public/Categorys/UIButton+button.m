//
//  UIButton+button.m
//  TTJF
//
//  Created by wbzhan on 2018/4/24.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "UIButton+button.h"
#import <objc/runtime.h>

@interface UIButton()
 @property (nonatomic, assign) BOOL isIgnoreEvent;
@end

@implementation UIButton (button)

static const char *UIControl_timeInterval = "UIControl_timeInterval";
static const char *UIControl_enventIsIgnoreEvent = "UIControl_enventIsIgnoreEvent";

-(instancetype)init{
    self = [super init];
    if (self) {
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}
-(void)setHighlighted:(BOOL)highlighted{
    
    [super setHighlighted:NO];
}
// runtime 动态绑定 属性
- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent
{
    objc_setAssociatedObject(self, UIControl_enventIsIgnoreEvent, @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isIgnoreEvent{
    return [objc_getAssociatedObject(self, UIControl_enventIsIgnoreEvent) boolValue];
}

- (NSTimeInterval)timeInterval
{
    return [objc_getAssociatedObject(self, UIControl_timeInterval) doubleValue];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    objc_setAssociatedObject(self, UIControl_timeInterval, @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load
{
    // Method Swizzling
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selA = @selector(sendAction:to:forEvent:);
        SEL selB = @selector(after_sendAction:to:forEvent:);
        Method methodA = class_getInstanceMethod(self,selA);
        Method methodB = class_getInstanceMethod(self, selB);
        
        BOOL isAdd = class_addMethod(self, selA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
        
        if (isAdd) {
            class_replaceMethod(self, selB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
        }else{
            //添加失败了 说明本类中有methodB的实现，此时只需要将methodA和methodB的IMP互换一下即可。
            method_exchangeImplementations(methodA, methodB);
        }
    });
}

- (void)after_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    self.timeInterval = self.timeInterval == 0 ? defaultInterval : self.timeInterval;
    if (self.isIgnoreEvent){
        return;
    }else if (self.timeInterval > 0){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setIsIgnoreEvent:NO];
        });
    }
    
    self.isIgnoreEvent = YES;
    // 这里看上去会陷入递归调用死循环，但在运行期此方法是和sendAction:to:forEvent:互换的，相当于执行sendAction:to:forEvent:方法，所以并不会陷入死循环。
    [self after_sendAction:action to:target forEvent:event];
}
@end
