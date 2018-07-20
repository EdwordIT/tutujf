//
//  PaybackSelectView.m
//  TTJF
//
//  Created by wbzhan on 2018/7/9.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "PaybackSelectView.h"
#import "SDRangeSliderView.h"
@interface PaybackSelectView ()<UITextFieldDelegate>
Strong UIView *headerView;
Strong UITextField *searchTextField;
Strong UIButton *leftBtn;
Strong UIButton *rightBtn;
Strong SDRangeSliderView *sliderView;

Copy NSString *keyword;//关键字
Copy NSDate *startTime;
Copy NSDate *endTime;
Assign NSInteger page;
Assign NSInteger totalPage;

@end

@implementation PaybackSelectView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews{
    

    self.keyword = @"";
    self.clipsToBounds = YES;
    self.backgroundColor = RGBA(0, 0, 0, 0.6);
    
    self.headerView = [[UIView alloc]initWithFrame:RECT(0, -kSizeFrom750(590), screen_width, kSizeFrom750(590))];
    self.headerView.backgroundColor = COLOR_Background;
    [self addSubview:self.headerView];
    
    UILabel *titleL = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, kSizeFrom750(35), kContentWidth, kLabelHeight)];
    titleL.text = @"关键词搜索";
    titleL.font = SYSTEMSIZE(30);
    titleL.textColor = RGB_51;
    [self.headerView addSubview:titleL];
    
   
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(titleL.left, titleL.bottom+kSizeFrom750(25), kContentWidth, kSizeFrom750(70))];
    searchView.backgroundColor = COLOR_White;
    searchView.layer.cornerRadius = CORNER_RADIUS;
    searchView.layer.borderColor = [COLOR_Background CGColor];
    searchView.layer.borderWidth = kLineHeight;
    searchView.layer.masksToBounds = YES;
    [self.headerView addSubview:searchView];
    
    _searchTextField = [[UITextField alloc]initWithFrame:RECT(kOriginLeft, 0, kContentWidth - kOriginLeft, searchView.height)];
    _searchTextField.delegate = self;
    _searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//内容垂直居中
    _searchTextField.placeholder = @"请输入要搜索的关键词";
    _searchTextField.font =SYSTEMSIZE(26);
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [searchView addSubview:self.searchTextField];

    
    UIView *middleView = [[UIView alloc]initWithFrame:RECT(0,  searchView.bottom+kSizeFrom750(40), screen_width, kSizeFrom750(300))];
    middleView.backgroundColor = COLOR_White;
    [self.headerView addSubview:middleView];
    
    UILabel *timeTitleL = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, kSizeFrom750(42), kContentWidth, kLabelHeight)];
    timeTitleL.text = @"日期区间选择";
    timeTitleL.font = SYSTEMSIZE(30);
    timeTitleL.textColor = RGB_51;
    [middleView addSubview:timeTitleL];
    
    self.rightBtn = [[UIButton alloc]init];
    self.rightBtn.frame = RECT(screen_width - kSizeFrom750(150), timeTitleL.top, kSizeFrom750(150), kLabelHeight);
    [self.rightBtn setTitle:@"后12个月" forState:UIControlStateNormal];
    [self.rightBtn.titleLabel setFont:SYSTEMSIZE(28)];
    self.rightBtn.tag = 1;
    self.rightBtn.selected = YES;
    [self.rightBtn setTitleColor:COLOR_DarkBlue forState:UIControlStateSelected];
    [self.rightBtn addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.rightBtn setTitleColor:RGB_183 forState:UIControlStateNormal];
    [middleView addSubview:self.rightBtn];
    
    self.leftBtn = [[UIButton alloc]init];
    self.leftBtn.frame = RECT(self.rightBtn.left -self.rightBtn.width, self.rightBtn.top, self.rightBtn.width, self.rightBtn.height);
    [self.leftBtn setTitle:@"后6个月" forState:UIControlStateNormal];
    [self.leftBtn.titleLabel setFont:SYSTEMSIZE(28)];
    [self.leftBtn setTitleColor:COLOR_DarkBlue forState:UIControlStateSelected];
    self.leftBtn.tag = 0;
    [self.leftBtn addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn setTitleColor:RGB_183 forState:UIControlStateNormal];
    self.leftBtn.selected = NO;
    [middleView addSubview:self.leftBtn];
    
   

    self.sliderView = [[SDRangeSliderView alloc]initWithFrame:RECT(kOriginLeft, timeTitleL.bottom+kLabelHeight, kContentWidth, kSizeFrom750(80))];
    self.sliderView.minValue = 0;
    self.sliderView.minimumSize = 1;
    self.sliderView.highlightLineColor = COLOR_DarkBlue;
    self.sliderView.lineColor = RGB_183;
    self.sliderView.maxValue = 7;//分为6段
    self.sliderView.lineHeight = kSizeFrom750(10);
    [self.sliderView usingValueUnequal];//使用游标的中心取值
    [self.sliderView customUIUsingBlock:^(UIButton *leftCursor, UIButton *rightCursor) {
            [leftCursor setImage:IMAGEBYENAME(@"icons_slider") forState:UIControlStateNormal];
            leftCursor.timeInterval = 0;
            [rightCursor setImage:IMAGEBYENAME(@"icons_slider") forState:UIControlStateNormal];
            rightCursor.timeInterval = 0;
    }];
    
   
    NSArray *sepArr = @[@"0",@"2",@"4",@"6",@"8",@"10",@"12"];
    CGFloat labelW = self.sliderView.itemSize;
    CGFloat spaceX = (kContentWidth - sepArr.count*labelW)/(sepArr.count-1);
    for (int i=0; i<sepArr.count; i++) {
        UILabel *label = InitObject(UILabel);
        label.frame = RECT(self.sliderView.left+(labelW+spaceX)*i, self.sliderView.bottom+kSizeFrom750(20), labelW, kSizeFrom750(30));
        label.textColor = RGB_153;
        label.font = NUMBER_FONT(25);
        label.text = sepArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        [middleView addSubview:label];
    }
    
    [self.sliderView eventValueDidChanged:^(double left, double right) {
        //左右滑动触发回调
        NSLog(@"left=%.0f,right = %.0f",left,right);
        if (left==0&&right==4) {
            self.leftBtn.selected = YES;
            self.rightBtn.selected = NO;
        }
        if (left==0&&right==7) {
            self.leftBtn.selected = NO;
            self.rightBtn.selected = YES;
        }
        self.startTime = [self getPriousorLaterDateWwithMonth:[[sepArr objectAtIndex:left] integerValue]];
        self.endTime = [self getPriousorLaterDateWwithMonth:[[sepArr objectAtIndex:right-1] integerValue]];
    }];
    
    [middleView addSubview:self.sliderView];
    [self.sliderView update];
    
    UIButton *resetBtn = [[UIButton alloc]initWithFrame:RECT(0,self.headerView.height - kButtonHeight, kSizeFrom750(170), kButtonHeight)];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    
    [resetBtn.titleLabel setFont:SYSTEMSIZE(30)];
    resetBtn.backgroundColor = RGB_240;
    resetBtn.tag = 0;
    [resetBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [resetBtn setTitleColor:RGB_51 forState:UIControlStateNormal];
    [self.headerView addSubview:resetBtn];
    
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:RECT(resetBtn.right,resetBtn.top, screen_width-resetBtn.right, kButtonHeight)];
    [searchBtn setTitle:@"开始搜索" forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:SYSTEMSIZE(30)];
    [searchBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setTitleColor:COLOR_White forState:UIControlStateNormal];
    searchBtn.tag = 1;
    searchBtn.backgroundColor = COLOR_DarkBlue;
    [self.headerView addSubview:searchBtn];
    
    UIButton *bottomBtn = [[UIButton alloc]initWithFrame:RECT(0, self.headerView.height, screen_width, self.height - self.headerView.height)];
    bottomBtn.backgroundColor = [UIColor clearColor];
    [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bottomBtn];
    
}
#pragma mark --textField Delegate
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSString *    str = [theTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(str.length >0)
    {
        self.keyword = str;
    }
}
#pragma mark --button Click
-(void)timeBtnClick:(UIButton *)sender{
    sender.selected = YES;
    if (sender.tag==0) {
        [self.sliderView setLeftValue:0];
        [self.sliderView setRightValue:4];
        self.startTime = [self getPriousorLaterDateWwithMonth:0];
        self.endTime = [self getPriousorLaterDateWwithMonth:4];
        self.rightBtn.selected = NO;
    }else{
        self.startTime = [self getPriousorLaterDateWwithMonth:0];
        self.endTime = [self getPriousorLaterDateWwithMonth:7];
        [self.sliderView setLeftValue:0];
        [self.sliderView setRightValue:7];
        self.leftBtn.selected = NO;
    }
}
//重置条件、开始搜索
-(void)btnClick:(UIButton *)sender{
    if (sender.tag==0) {
        self.startTime = nil;
        self.endTime = nil;
        self.searchTextField.text = @"";
        self.keyword = @"";
    }else{
      
    }
    if (self.selectedBlock) {
        self.selectedBlock(self.startTime, self.endTime, self.keyword);
    }
    [self hideSelectView:YES];
}
-(void)bottomBtnClick:(UIButton *)sender{
    [self hideSelectView:YES];
}
#pragma mark --custom
-(NSDate *)getPriousorLaterDateWwithMonth:(NSInteger)month
 {
    NSDateComponents *comps = [[NSDateComponents alloc] init];

    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:[NSDate date] options:0];
  
     return mDate;
    
}
-(void)hideSelectView:(BOOL)isHide{
    
    if (!isHide) {
        self.hidden = NO;
    }else{
       
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        if (!isHide) {
            self.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
            self.headerView.frame = RECT(0, 0, screen_width, self.headerView.height);
        }else{
            self.backgroundColor = [UIColor clearColor];
            self.headerView.frame = RECT(0, -self.headerView.height, screen_width, self.headerView.height);
        }
        
    } completion:^(BOOL finished) {
        self.hidden = isHide;
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
