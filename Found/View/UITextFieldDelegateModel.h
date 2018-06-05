//
//  UITextFieldDelegateModel.h
//  cloudSound
//
//  Created by renxlin on 17/2/22.
//  Copyright © 2017年 hzlh. All rights reserved.
//  抽出UITextField 代理 用于判断输入合法性。

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TextFieldModelDelegate <NSObject>
@optional
- (void)textFieldInputChange:(UITextField *)inputField maxLength:(NSInteger)length;
- (BOOL)shouldBeginEdit:(UITextField *)inputField;
@end

@interface UITextFieldDelegateModel : NSObject <UITextFieldDelegate>

- (id)initWithInputSource:(UITextField *)sourceField target:(id <TextFieldModelDelegate>)target maxLength:(NSInteger)maxLength;

@end


@protocol TextViewModelDelegate <NSObject>
- (void)textViewInputChange:(UITextView *)inputView maxLength:(NSInteger)length;
@end

@interface UITextViewDelegateModel : NSObject <UITextViewDelegate>

- (id)initWithInputSource:(UITextView *)sourceView target:(id <TextViewModelDelegate>)target maxLength:(NSInteger)maxLength;

@end
