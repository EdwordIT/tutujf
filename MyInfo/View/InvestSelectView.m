//
//  InvestSelectView.m
//  TTJF
//
//  Created by wbzhan on 2018/5/19.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "InvestSelectView.h"
#import "UIImage+Color.h"
@interface InvestSelectView()<UITextFieldDelegate>
Strong UIView *headerView;
Strong UILabel *titleLabel;
Strong NSMutableArray *buttonArray;
Strong UITextField *startTextField;//开始时间
Strong UITextField *endTextField;//结束时间
Copy NSString *startTime;
Copy NSString *endTime;
Assign NSInteger selectTag;//选中状态
Strong UIDatePicker *datePicker;
@end
@implementation InvestSelectView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews
{
    self.startTime = @"";
    self.endTime = @"";
    self.clipsToBounds = YES;
    
    self.headerView = [[UIView alloc]initWithFrame:RECT(0, -kSizeFrom750(480), screen_width, kSizeFrom750(480))];
    self.headerView.backgroundColor = COLOR_White;
    [self addSubview:self.headerView];
    
    self.buttonArray = InitObject(NSMutableArray);
    self.titleLabel  = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, kOriginLeft, kSizeFrom750(200), kSizeFrom750(30))];
    self.titleLabel.textColor = RGB_51;
    self.titleLabel.text = @"交易分类";
    self.titleLabel.font = SYSTEMSIZE(28);
    [self.headerView addSubview:self.titleLabel];
    NSArray *nameArr = @[@"回款中",@"投资中",@"已回款"];
    for (int i=0; i<nameArr.count; i++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:RECT(kOriginLeft+kSizeFrom750(160)*i, self.titleLabel.bottom+kSizeFrom750(30), kSizeFrom750(126), kSizeFrom750(55))];
        [btn.titleLabel setFont:SYSTEMSIZE(26)];
        [btn setTitleColor:RGB_102 forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_DarkBlue forState:UIControlStateSelected];
        btn.tag = i;
        [btn setBackgroundImage:[UIImage imageWithColor:separaterColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:RGB(248, 253, 255)] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[nameArr objectAtIndex:i] forState:UIControlStateNormal];
        btn.adjustsImageWhenHighlighted = NO;
        if (i==0) {
            btn.selected = YES;
        }
        [self.headerView addSubview:btn];
        [self.buttonArray addObject:btn];
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:RECT(0, self.titleLabel.bottom+kSizeFrom750(125), screen_width, kLineHeight)];
    lineView.backgroundColor = separaterColor;
    [self.headerView addSubview:lineView];
    
    UILabel *subTitle = [[UILabel alloc]initWithFrame:RECT(self.titleLabel.left, lineView.bottom+kSizeFrom750(30), self.titleLabel.width, self.titleLabel.height)];
    subTitle.font = SYSTEMSIZE(28);
    subTitle.textColor = RGB_51;
    subTitle.text = @"投资时间";
    [self.headerView addSubview:subTitle];
    
    //时间选择器
    self.datePicker = [[UIDatePicker alloc]init];
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.maximumDate = [NSDate date];
    [self.datePicker addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];


    self.startTextField = [[UITextField alloc]initWithFrame:RECT(kOriginLeft, subTitle.bottom+kSizeFrom750(30), kSizeFrom750(280), kSizeFrom750(55))];
    [self.headerView addSubview:self.startTextField];
    self.startTextField.backgroundColor = separaterColor;
    self.startTextField.font = SYSTEMSIZE(26);
    self.startTextField.placeholder = @"   选择开始时间";
    self.startTextField.textColor = RGB_183;
    self.startTextField.delegate = self;
    self.startTextField.inputView = self.datePicker;
    
    
    UIView *sepLine = [[UIView alloc]initWithFrame:RECT(self.startTextField.right+kSizeFrom750(20), 0, kSizeFrom750(30), 1)];
    [sepLine setBackgroundColor:RGB_51];
    sepLine.centerY = self.startTextField.centerY;
    [self.headerView addSubview:sepLine];
    
    self.endTextField = [[UITextField alloc]initWithFrame:RECT(sepLine.right+kSizeFrom750(20), subTitle.bottom+kSizeFrom750(30), kSizeFrom750(280), kSizeFrom750(55))];
    [self.headerView addSubview:self.endTextField];
    self.endTextField.delegate = self;
    self.endTextField.backgroundColor = separaterColor;
    self.endTextField.font = SYSTEMSIZE(26);
    self.endTextField.placeholder = @"   选择结束时间";
    self.endTextField.textColor = RGB_183;
    self.endTextField.inputView = self.datePicker;

    
    UIButton *resetBtn = [[UIButton alloc]initWithFrame:RECT(0,self.headerView.height - kSizeFrom750(88), screen_width/2, kSizeFrom750(88))];
    [resetBtn setTitle:@"条件重置" forState:UIControlStateNormal];
    [resetBtn.titleLabel setFont:SYSTEMSIZE(30)];
    resetBtn.layer.borderColor = [COLOR_DarkBlue CGColor];
    resetBtn.layer.borderWidth = kLineHeight;
    resetBtn.tag = 0;
    [resetBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [resetBtn setTitleColor:COLOR_DarkBlue forState:UIControlStateNormal];
    resetBtn.backgroundColor = COLOR_White;
    [self.headerView addSubview:resetBtn];
    
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:RECT(resetBtn.right,resetBtn.top, screen_width/2, kSizeFrom750(88))];
    [searchBtn setTitle:@"开始搜索" forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:SYSTEMSIZE(30)];
    [searchBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setTitleColor:COLOR_White forState:UIControlStateNormal];
    searchBtn.tag = 1;
    searchBtn.backgroundColor = COLOR_DarkBlue;
    [self.headerView addSubview:searchBtn];
    
    UIButton *bottomBtn = [[UIButton alloc]initWithFrame:RECT(0, kSizeFrom750(480), screen_width, screen_height - kSizeFrom750(480))];
    bottomBtn.backgroundColor = [UIColor clearColor];
    [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bottomBtn];
}
#pragma mark --textfield
- (void)textFieldDidBeginEditing:(UITextField *)textField;{
    //确保加载时也能获取datePicker的文字
    [self valueChange:self.datePicker];
}
-(void)valueChange:(UIDatePicker *)datePicker{
    
    //创建一个日期格式
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //设置日期的显示格式
    fmt.dateFormat = @"yyyy-MM-dd";
    //将日期转为指定格式显示
    NSString *dateStr = [fmt stringFromDate:datePicker.date];
    if ([self.startTextField isFirstResponder]) {
        self.startTextField.text = [NSString stringWithFormat:@"  %@",dateStr];
    }else if([self.endTextField isFirstResponder]){
        self.endTextField.text = [NSString stringWithFormat:@"  %@",dateStr];
    }
    
}
-(void)bottomBtnClick:(UIButton *)sender{
    [self showSelectView:NO];
}
-(void)sectionClick:(UIButton *)sender{
    
    for (UIButton *btn in self.buttonArray) {
        if (btn.tag==sender.tag) {
            btn.selected = YES;
            self.selectTag = sender.tag;
        }else{
            btn.selected = NO;
        }
    }
}
//重置条件、开始搜索
-(void)btnClick:(UIButton *)sender{
    if (sender.tag==0) {
        self.startTime = @"";
        self.endTime = @"";
        self.startTextField.text = @"";
        self.endTextField.text = @"";
    }else{
        self.startTime = [self.startTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.endTime = [self.endTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (self.selectBlock) {
            self.selectBlock(self.selectTag,self.startTime,self.endTime);
        }
        [self showSelectView:NO];
        
    }
}
-(void)showSelectView:(BOOL)isShow{
    if (isShow) {
        self.hidden = NO;
    }else{
        [self.startTextField resignFirstResponder];
        [self.endTextField resignFirstResponder];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        if (isShow) {
            self.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
            self.headerView.frame = RECT(0, 0, screen_width, self.headerView.height);
        }else{
            self.backgroundColor = [UIColor clearColor];
            self.headerView.frame = RECT(0, -self.headerView.height, screen_width, self.headerView.height);
        }
        
    } completion:^(BOOL finished) {
        self.hidden = !isShow;
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
