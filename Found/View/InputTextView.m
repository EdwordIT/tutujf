//
//  InputTextView.m
//  cloudSound
//
//  Created by renxlin on 17/2/23.
//  Copyright © 2017年 hzlh. All rights reserved.
//

#import "InputTextView.h"

#import "UITextFieldDelegateModel.h"

@interface InputTextView () <TextViewModelDelegate>
@property (nonatomic, strong) UITextViewDelegateModel   *textViewModel;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UIColor   *textColor;
@property (nonatomic, strong) NSString  *placeHolderString;
@property (nonatomic, assign) NSInteger  textSize;
@property (nonatomic, assign) NSInteger  textMaxNumber;

@end

@implementation InputTextView
- (id)initWithMaxLength:(NSInteger)length {
    self = [super init];
    if (self) {
        [self setUp];
        self.textMaxNumber = length;
        
        [self addSubviews];
        [self makeConstraints];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setUp];
        [self addSubviews];
        [self makeConstraints];
    }
    return self;
}

- (void)setUp {
    self.textColor = [UIColor blackColor];
    self.textSize = 14;
    self.textMaxNumber = NSIntegerMax;
}

- (void)addSubviews {
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.textColor = self.textColor;
    _textView.font = [UIFont systemFontOfSize:self.textSize];
    
    _textViewModel = [[UITextViewDelegateModel alloc] initWithInputSource:_textView target:self maxLength:self.textMaxNumber];
    
    _placeHolder = [[UILabel alloc] init];
    _placeHolder.textColor = [UIColor lightGrayColor];
    _placeHolder.text = self.placeHolderString;
    _placeHolder.font = [UIFont systemFontOfSize:self.textSize];
    _placeHolder.textAlignment = NSTextAlignmentLeft;
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.textColor = [UIColor lightGrayColor];
    _numberLabel.font = [UIFont systemFontOfSize:self.textSize];
    _numberLabel.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:_textView];
    [self addSubview:_placeHolder];
    [self addSubview:_numberLabel];
    
    if (self.textMaxNumber == NSIntegerMax) {
        self.numberLabel.hidden = YES;
    } else {
        self.numberLabel.hidden = NO;
        self.numberLabel.text = [NSString stringWithFormat:@"0/%ld", (long)self.textMaxNumber];
    }
}

- (void)makeConstraints {
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.numberLabel.mas_top).mas_offset(-5);
    }];
    
    [self.placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textView).mas_offset(10);
        make.top.mas_equalTo(self.textView).mas_offset(8);
        make.width.mas_equalTo(self.textView);
        make.height.mas_equalTo(kSizeFrom750(40));
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self);
    }];
}

#pragma mark - TextViewModelDelegate
- (void)textViewInputChange:(UITextView *)inputView maxLength:(NSInteger)length {
    if (inputView.text.length < length) {
        _numberLabel.text = [NSString stringWithFormat:@"%ld/%ld", inputView.text.length, (long)length];
    } else {
        _numberLabel.text = [NSString stringWithFormat:@"%ld/%ld", length, length];
    }
        
    if (inputView.text.length == 0) {
        _placeHolder.hidden = NO;
    } else {
        _placeHolder.hidden = YES;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(inputTextView:didEdit:)]) {
        [self.delegate inputTextView:self didEdit:inputView.text];
    }
}


#pragma mark - Public Methods
- (NSString *)text {
    return self.textView.text;
}

- (void)setText:(NSString *)text {
    self.textView.text = text;
    
    if (text.length == 0) {
        _placeHolder.hidden = NO;
    } else {
        _placeHolder.hidden = YES;
    }
}

- (void)setTextColor:(UIColor *)textColor placeHolder:(NSString *)placeHoder {
    self.placeHolderString = placeHoder;
    self.placeHolder.text = placeHoder;
    self.textView.textColor = textColor;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
