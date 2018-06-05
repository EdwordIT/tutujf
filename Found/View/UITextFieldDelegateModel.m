//
//  UITextFieldDelegateModel.m
//  cloudSound
//
//  Created by renxlin on 17/2/22.
//  Copyright © 2017年 hzlh. All rights reserved.
//

#import "UITextFieldDelegateModel.h"

@interface UITextFieldDelegateModel ()

@property (nonatomic, weak) UITextField                         *sourceField;
@property (nonatomic, weak) id <TextFieldModelDelegate>         callbackTarget;
@property (nonatomic, assign) NSInteger                         maxLength;

@end

@implementation UITextFieldDelegateModel
- (void)dataInit {
    _maxLength = 10;
}

- (id)initWithInputSource:(id)sourceView target:(id <TextFieldModelDelegate>)target maxLength:(NSInteger)maxLength {
    self = [super init];
    if (self) {
        [self dataInit];
        _sourceField = sourceView;
        _callbackTarget = target;
        _maxLength = maxLength;
        
        _sourceField.delegate = self;
    }
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.callbackTarget && [self.callbackTarget respondsToSelector:@selector(shouldBeginEdit:)]) {
        return [self.callbackTarget shouldBeginEdit:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL returnValue = YES;
    if (string.length > _maxLength) {
        string = [string substringToIndex:_maxLength];
        [textField setText:string];
        returnValue = NO;
    }
    
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && pos) {
        NSInteger startOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < _maxLength) {
            returnValue = YES;
        } else {
            if (self.callbackTarget && [self.callbackTarget respondsToSelector:@selector(textFieldInputChange:maxLength:)]) {
                [self.callbackTarget textFieldInputChange:textField maxLength:self.maxLength];
            }
            returnValue = NO;
        }
    } else {
        if (textField.text.length + string.length > _maxLength) {
            NSString *allString = [NSString stringWithFormat:@"%@%@", textField.text ? : @"", string];
            textField.text = [allString substringToIndex:_maxLength];
            returnValue = NO;
        }
    }

    
    if (self.callbackTarget && [self.callbackTarget respondsToSelector:@selector(textFieldInputChange:maxLength:)]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.callbackTarget textFieldInputChange:textField maxLength:self.maxLength];
        });
    }

    return returnValue;
}

- (void)textFiledEditChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    
    if ([lang isEqualToString:@"zh-Hans"]) {
        // 简体中文输入
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > self.maxLength) {
                textField.text = [toBeString substringToIndex:self.maxLength];
            } else {
                
            }
        }
    } else {
        if (toBeString.length > self.maxLength) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.maxLength];
            if (rangeIndex.length == 1) {
                textField.text = [toBeString substringToIndex:self.maxLength];
            } else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    
    if (self.callbackTarget && [self.callbackTarget respondsToSelector:@selector(textFieldInputChange:maxLength:)]) {
        [self.callbackTarget textFieldInputChange:textField maxLength:self.maxLength];
    }
}

@end


@interface UITextViewDelegateModel ()

@property (nonatomic, weak) UITextView                          *sourceTextView;
@property (nonatomic, weak) id <TextViewModelDelegate>          clallbackTarget;
@property (nonatomic, assign) NSInteger                         maxLength;

@end

@implementation UITextViewDelegateModel

- (id)initWithInputSource:(UITextView *)sourceView target:(id <TextViewModelDelegate>)target maxLength:(NSInteger)maxLength {
    self = [super init];
    if (self) {
        _sourceTextView = sourceView;
        _clallbackTarget = target;
        _maxLength = maxLength;
        
        sourceView.delegate = self;
    }
    return self;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && pos) {
        if (self.clallbackTarget && [self.clallbackTarget respondsToSelector:@selector(textViewInputChange:maxLength:)]) {
            [self.clallbackTarget textViewInputChange:textView maxLength:self.maxLength];
        }
        return;
    }
    
    NSString *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;

    if (existTextNum > self.maxLength) {
        NSString *s = [nsTextContent substringToIndex:self.maxLength];
        [textView setText:s];
    }
    
    if (self.clallbackTarget && [self.clallbackTarget respondsToSelector:@selector(textViewInputChange:maxLength:)]) {
        [self.clallbackTarget textViewInputChange:textView maxLength:self.maxLength];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL returnValue = NO;

    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < self.maxLength) {
            returnValue = YES;
        } else {
            returnValue = NO;
        }
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = self.maxLength - comcatstr.length;
    if (caninputlen == 0) {
        returnValue = YES;
    } else if (caninputlen>0) {
        returnValue = YES;
    } else {
        NSInteger len = text.length + caninputlen;
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0) {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByAppendingString:s]];
        }
        returnValue = NO;
    }
    
    if (self.clallbackTarget && [self.clallbackTarget respondsToSelector:@selector(textViewInputChange:maxLength:)]) {
        [self.clallbackTarget textViewInputChange:textView maxLength:self.maxLength];
    }
    return returnValue;
}

@end

