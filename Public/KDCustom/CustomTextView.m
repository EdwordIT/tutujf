//
//  CustomTextView.m
//  DingXinDai
//
//  Created by 占碧光 on 16/7/27.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import "CustomTextView.h"

@implementation CustomTextView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
        
        self.autoresizesSubviews = NO;
        self.placeholder = @"";
        self.placeholderColor = [UIColor lightGrayColor];
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    //内容为空时才绘制placeholder
    if ([self.text isEqualToString:@""]) {
        CGRect placeholderRect;
        placeholderRect.origin.y = 8;
        placeholderRect.size.height = CGRectGetHeight(self.frame)-8;
        if (IOS_VERSION >= 7) {
            placeholderRect.origin.x = 5;
            placeholderRect.size.width = CGRectGetWidth(self.frame)-5;
        } else {
            placeholderRect.origin.x = 10;
            placeholderRect.size.width = CGRectGetWidth(self.frame)-10;
        }
        [self.placeholderColor set];
        NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        NSDictionary*attribute = @{NSFontAttributeName:self.font,NSParagraphStyleAttributeName:paragraphStyle};

        [self.placeholder drawInRect:placeholderRect withAttributes:attribute];
      
    }
}
//但- (void)drawRect:(CGRect)rect在self绘制或大小位置改变的时候被调用,我们输入文字是不会被调用的. 所以要调用self的setNeedsDisplay来重新绘制self里面的内容(placeholder).

- (void)textChanged:(NSNotification *)not
{
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
