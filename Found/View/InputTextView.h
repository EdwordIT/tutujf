//
//  InputTextView.h
//  cloudSound
//
//  Created by renxlin on 17/2/23.
//  Copyright © 2017年 hzlh. All rights reserved.
//  文字输入框视图，用于多行文字输入。

#import <UIKit/UIKit.h>

@class InputTextView;

@protocol InputTextViewDelegate <NSObject>

- (void)inputTextView:(InputTextView *)view didEdit:(NSString *)editString;

@end

@interface InputTextView : UIView

@property (nonatomic, weak) id <InputTextViewDelegate> delegate;

@property (nonatomic, strong) UITextView  *textView;

- (id)initWithMaxLength:(NSInteger)length;

@property (nonatomic, strong) UILabel *placeHolder;

- (NSString *)text;

- (void)setText:(NSString *)text;

- (void)setTextColor:(UIColor *)textColor placeHolder:(NSString *)placeHoder;

@end
