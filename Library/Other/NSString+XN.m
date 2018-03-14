//
//  NSString+XN.m
//  51XiaoNiu
//
//  Created by 乔同新 on 16/4/6.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "NSString+XN.h"
#import <objc/runtime.h>

@implementation NSString (XN)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method systemStringAppending = class_getInstanceMethod([self class], @selector(stringByAppendingString:));
        Method newStringAppending = class_getInstanceMethod([self class], @selector(new_stringByAppendingString:));
        method_exchangeImplementations(systemStringAppending, newStringAppending);        
    });
    
}

- (NSString *)new_stringByAppendingString:(NSString *)appendingString{
 
    if (appendingString.length==0) {
        return nil;
    }else {
        return [self new_stringByAppendingString:appendingString];
    }
}

- (CGSize)heightWithFont:(UIFont *)font
                MaxWidth:(float)width{
    if (self.length==0) {
        return CGSizeMake(0, 0);
    }
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingTruncatesLastVisibleLine |
                                             NSStringDrawingUsesLineFragmentOrigin|
                                             NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    
    return CGSizeMake((rect.size.width), (rect.size.height));
    
}
- (CGFloat)heightWithStringAttribute:(NSDictionary <NSString *, id> *)attribute fixedWidth:(CGFloat)width {
    
    NSParameterAssert(attribute);
    
    CGFloat height = 0;
    
    if (self.length) {
        
        CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                         options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil];
        
        height = rect.size.height;
    }
    
    return height;
}

- (CGFloat)widthWithStringAttribute:(NSDictionary <NSString *, id> *)attribute {
    
    NSParameterAssert(attribute);
    
    CGFloat width = 0;
    
    if (self.length) {
        
        CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                         options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil];
        
        width = rect.size.width;
    }
    
    return width;
}

+ (CGFloat)aLineOfTextHeightWithStringAttribute:(NSDictionary <NSString *, id> *)attribute {
    
    CGFloat height = 0;
    CGRect rect    = [@"One" boundingRectWithSize:CGSizeMake(200, MAXFLOAT)
                                          options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil];
    
    height = rect.size.height;
    return height;
}





@end
