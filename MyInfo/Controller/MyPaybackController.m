//
//  MyPaybackController.m
//  TTJF
//
//  Created by wbzhan on 2018/7/6.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyPaybackController.h"
#import "PaybackSelectView.h"
#import "PaybackCell.h"
#import "GradientButton.h"
#import <FSCalendar.h>
#import "UIImage+Color.h"
#import "MyCalendarPaybackCell.h"
#define calendarColor RGB(234, 78, 71)
#define sliderTag 101
//页面两种显示方式，一种带日历，一直列表
@interface MyPaybackController ()<UITableViewDelegate,UITableViewDataSource,FSCalendarDelegate,FSCalendarDataSource>
Strong UIView *listBgView;

Strong UIView *calendarBgView;
Strong PaybackSelectView *selectView;
Strong UIView *menuView;//菜单栏
Strong NSMutableArray *btnArray;//button
Strong BaseUITableView *listTab;//常规列表
Strong NSMutableArray *dataArray;
Assign BOOL isCalendar;//是否切换到带日历的内容显示页面


Strong GradientButton *headerView;
Strong UILabel *headerTitle;
Strong UILabel *headerTextL;
Strong UIView *calendarHeaderView;//日历标题
Strong UIScrollView *monthScroll;//月份
Strong UILabel *yearLabel;//年份
Strong FSCalendar *calendar;//日历
Strong NSMutableArray *monthArray;
Strong NSMutableArray *eventArray;//含有点击事件的数组：当天有回款
Strong NSCalendar *gregorian;
Assign NSInteger year;//年份
Strong NSDateFormatter *dateFormat;//时间格式
Strong NSDate *currentDate;//日历滑动完成之后的日期
Strong NSDate *lastDate;//滑动日历之前当前日期
Strong UIButton *selectedMonth;//当前处于的月份选中按钮
Assign BOOL isClickBtnSwap;//是否点击切换月份
Strong UIView *tableHeaderView;//
Strong UILabel *dateLabel;//
Strong UILabel *amountLabel;//当天待回款
Strong BaseUITableView *mainTab;//
Strong UIButton *showTabBtn;
Strong NSMutableArray *dayPaybackArray;//当天的待回款金额

@end

@implementation MyPaybackController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNav];

    [self.view addSubview:self.listBgView];
    
    [self.view addSubview:self.calendarBgView];
    
    [self.listBgView addSubview:self.menuView];

    [self loadMenuView];

    [self.listBgView addSubview:self.listTab];
    
    [self.listBgView addSubview:self.selectView];
    
    [self.calendarBgView addSubview:self.headerView];
    
    [self.calendarBgView addSubview:self.calendarHeaderView];
    
    [self loadCalendarHeader];
    
    [self.calendarBgView addSubview:self.calendar];
    
    [self.calendarBgView addSubview:self.tableHeaderView];
    
    [self.tableHeaderView addSubview:self.dateLabel];
    
    [self.tableHeaderView addSubview:self.amountLabel];
    
    [self.tableHeaderView addSubview:self.showTabBtn];
    
    [self.calendarBgView addSubview:self.mainTab];

    [self.calendarBgView sendSubviewToBack:self.mainTab];
    
    [self loadLayout];
    
    [self getRequest];
    // Do any additional setup after loading the view.
}
#pragma mark --lazyLoading
-(NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = InitObject(NSMutableArray);
    }
    return _btnArray;
}
-(NSMutableArray *)monthArray{
    if (!_monthArray) {
        _monthArray = InitObject(NSMutableArray);
    }
    return _monthArray;
}
-(NSMutableArray *)eventArray{
    if (!_eventArray) {
        _eventArray = InitObject(NSMutableArray);
        [_eventArray addObject:@"2018-07-13"];
        [_eventArray addObject:@"2018-07-15"];
        [_eventArray addObject:@"2018-07-19"];

    }
    return _eventArray;
}
-(NSMutableArray *)dayPaybackArray{
    if (!_dayPaybackArray) {
        _dayPaybackArray = InitObject(NSMutableArray);
    }
    return _dayPaybackArray;
}
-(UIView *)listBgView{
    if (!_listBgView) {
        _listBgView = [[UIView alloc]initWithFrame:RECT(0, kNavHight, screen_width, kViewHeight)];
    }
    return _listBgView;
}
-(UIView *)calendarBgView{
    if (!_calendarBgView) {
        _calendarBgView = [[UIView alloc]initWithFrame:RECT(0, kNavHight, screen_width, kViewHeight)];
        _calendarBgView.alpha = 0;
        _calendarBgView.transform = CGAffineTransformScale(_calendarBgView.transform, 0.01, 0.01);

    }
    return _calendarBgView;
}
-(PaybackSelectView *)selectView{
    if (!_selectView) {
        _selectView = [[PaybackSelectView alloc]initWithFrame:RECT(0, self.menuView.bottom, screen_width, kViewHeight)];
        _selectView.hidden = YES;
    }
    return _selectView;
}
-(UIView *)menuView{
    if (!_menuView) {
        _menuView  = [[UIView alloc]initWithFrame:RECT(0, 0, screen_width, kSizeFrom750(80))];
        _menuView.backgroundColor = COLOR_White;
    }
    return _menuView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = InitObject(NSMutableArray);
    }
    return _dataArray;
}
-(BaseUITableView *)listTab{
    if (!_listTab) {
        _listTab = [[BaseUITableView alloc]initWithFrame:CGRectMake(0, self.menuView.bottom, screen_width, screen_height - self.menuView.bottom) style:UITableViewStylePlain];
        _listTab.delegate = self;
        _listTab.dataSource = self;
        [_listTab registerClass:[PaybackCell class] forCellReuseIdentifier:@"PaybackCell"];
        _listTab.rowHeight = kSizeFrom750(365);
    }
    return _listTab;
}
#pragma mark --load Calendar
-(NSDateFormatter *)dateFormat{
    if (!_dateFormat) {
        _dateFormat = InitObject(NSDateFormatter);
        _dateFormat.dateFormat = @"yyyy-MM-dd";

    }
    return _dateFormat;
}
-(GradientButton *)headerView
{
    if (!_headerView) {
        _headerView = [[GradientButton alloc]init];
        _headerView.frame =RECT(0, 0, screen_width, kSizeFrom750(110));
        [_headerView setGradientColors:@[COLOR_DarkBlue,COLOR_LightBlue]];
        [_headerView addSubview:self.headerTitle];
        [_headerView addSubview:self.headerTextL];
        
    }
    return _headerView;
}
-(UILabel *)headerTitle{
    if (!_headerTitle) {
        _headerTitle = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, 0, kSizeFrom750(200), kSizeFrom750(30))];
        _headerTitle.centerY = self.headerView.height/2;
        [_headerTitle setFont:SYSTEMBOLDSIZE(30)];
        _headerTitle.textColor = COLOR_White;
        _headerTitle.text = @"本月待回款";
    }
    return _headerTitle;
}

-(UILabel *)headerTextL{
    if (!_headerTextL) {
        _headerTextL = [[UILabel alloc]initWithFrame:RECT(screen_width/2, 0, screen_width/2 - kOriginLeft, kSizeFrom750(50))];
        [_headerTextL setFont:SYSTEMBOLDSIZE(30)];
        _headerTextL.centerY = self.headerTitle.centerY;
        _headerTextL.textAlignment = NSTextAlignmentRight;
        _headerTextL.textColor = COLOR_White;
        _headerTextL.text = [CommonUtils getHanleNums:@"30000"];
    }
    return _headerTextL;
}
//日历标题
-(UIView *)calendarHeaderView{
    if (!_calendarHeaderView) {
        _calendarHeaderView = [[UIView alloc]initWithFrame:RECT(0, self.headerView.bottom, screen_width, kButtonHeight)];
        _calendarHeaderView.backgroundColor = COLOR_White;
    }
    return _calendarHeaderView;
}
-(UILabel *)yearLabel{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc]initWithFrame:RECT(0, 0, kSizeFrom750(130), self.calendarHeaderView.height)];
        _yearLabel.font = NUMBER_FONT(30);
        _yearLabel.textColor = RGB_102;
        _yearLabel.textAlignment = NSTextAlignmentCenter;
        _yearLabel.text = @"2018年";
    }
    return _yearLabel;
}
-(UIScrollView *)monthScroll{
    if (!_monthScroll) {
        _monthScroll = [[UIScrollView alloc]initWithFrame:RECT(kSizeFrom750(200), 0, kSizeFrom750(470), self.calendarHeaderView.height)];
        _monthScroll.showsHorizontalScrollIndicator = NO;
        _monthScroll.pagingEnabled = YES;
    }
    return _monthScroll;
}
-(FSCalendar *)calendar{
    if (!_calendar) {
        _calendar = InitObject(FSCalendar);
        _calendar.frame = RECT(0, self.calendarHeaderView.bottom, screen_width, kSizeFrom750(460));
        _calendar.dataSource = self;
        _calendar.delegate = self;
        _calendar.backgroundColor = COLOR_Background;
        
        //默认全是灰色的日期隐藏(当月不存在的日期隐藏)
        _calendar.placeholderType = FSCalendarPlaceholderTypeNone;
        _calendar.appearance.headerMinimumDissolvedAlpha = 0;
        _calendar.headerHeight = 0;
        _calendar.weekdayHeight = kSizeFrom750(100);
        _calendar.appearance.weekdayFont = SYSTEMSIZE(30);
        _calendar.calendarHeaderView.alpha = 0;
        _calendar.appearance.weekdayTextColor = RGB_51;//默认星期字体颜色
        _calendar.appearance.titleDefaultColor = RGB_102;//默认内容字体颜色
        _calendar.appearance.todayColor = calendarColor;//今天的背景颜色
        //带有事件的默认点的颜色
        _calendar.appearance.eventSelectionColor = calendarColor;//带有事件的标记点选中后的颜色
        _calendar.appearance.eventDefaultColor = calendarColor;//带有事件的标记点默认颜色
        _calendar.appearance.selectionColor = calendarColor;//选中背景颜色
        _calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
        self.lastDate = _calendar.currentPage;
        
    }
    return _calendar;
}
-(UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView =[[UIView alloc]init];
        _tableHeaderView.backgroundColor = COLOR_White;
        _tableHeaderView.layer.borderWidth = kLineHeight;
        _tableHeaderView.layer.borderColor = [RGB_183 CGColor];
    }
    return _tableHeaderView;
}
-(UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel =  [[UILabel alloc]initWithFrame:RECT(kOriginLeft, kOriginLeft, kSizeFrom750(500), kLabelHeight)];
        _dateLabel.font = NUMBER_FONT(35);
        _dateLabel.textColor = RGB_51;
        _dateLabel.text = @"2018-07-09";
    }
    return _dateLabel;
}
-(UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel =  [[UILabel alloc]initWithFrame:RECT(kOriginLeft, self.dateLabel.bottom+kSizeFrom750(20), kSizeFrom750(500), kLabelHeight)];
        _amountLabel.font = SYSTEMSIZE(28);
        _amountLabel.textColor = RGB_183;
        _amountLabel.text = @"当天待回款30000元";
    }
    return _amountLabel;
}
-(UIButton *)showTabBtn{
    if (!_showTabBtn) {
        _showTabBtn = InitObject(UIButton);
        [_showTabBtn setTitle:@"收起" forState:UIControlStateNormal];
        [_showTabBtn setTitle:@"展开" forState:UIControlStateSelected];
        [_showTabBtn.titleLabel setFont:SYSTEMSIZE(26)];
        [_showTabBtn setTitleColor:COLOR_LightBlue forState:UIControlStateNormal];
        [_showTabBtn setTitleColor:COLOR_LightBlue forState:UIControlStateSelected];
        _showTabBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_showTabBtn setImageEdgeInsets:UIEdgeInsetsMake(0, kSizeFrom750(90), 0,0)];
        [_showTabBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -kSizeFrom750(10), 0, 0)];

        [_showTabBtn setImage:IMAGEBYENAME(@"bottomArrow") forState:UIControlStateNormal];
        [_showTabBtn addTarget:self action:@selector(showTabBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _showTabBtn;
}
-(BaseUITableView *)mainTab{
    if (!_mainTab) {
        _mainTab = [[BaseUITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTab.delegate = self;
        _mainTab.dataSource = self;
        _mainTab.rowHeight = kSizeFrom750(162);
        _mainTab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
         [_mainTab registerClass:[MyCalendarPaybackCell class] forCellReuseIdentifier:@"MyCalendarPaybackCell"];
    }
    return _mainTab;
}
-(void)loadLayout{
    
    [self.tableHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(-kLineHeight);
        make.right.mas_equalTo(self.view).offset(kLineHeight);
        make.top.mas_equalTo(self.calendar.mas_bottom);
        make.height.mas_equalTo(kSizeFrom750(140));
    }];

    [self.showTabBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.mas_equalTo(self.tableHeaderView);
        make.width.mas_equalTo(kSizeFrom750(140));
        make.height.mas_equalTo(kSizeFrom750(50));
    }];
    [self.mainTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.mas_equalTo(self.tableHeaderView);
        make.top.mas_equalTo(self.tableHeaderView.mas_bottom);
        make.bottom.mas_equalTo(self.calendarBgView);
    }];
    
    [self.calendarBgView layoutIfNeeded];
}
#pragma mark --loadUI
-(void)loadNav{
    self.titleString = @"回款计划";
    [self.rightBtn setImage:IMAGEBYENAME(@"icons_calendar") forState:UIControlStateNormal];
    [self.rightBtn setImage:IMAGEBYENAME(@"menu_payback") forState:UIControlStateSelected];
    [self.rightBtn setHidden:NO];
    self.rightBtn.timeInterval = ANIMATION_TIME;//按钮点击间隔
    [self.rightBtn addTarget:self action:@selector(calendarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
}
-(void)loadMenuView
{
    NSArray *arr = @[@"时间排序",@" 金额 ",@" 利率 ",@" 筛选 "];

    CGFloat btnW = (screen_width - kSizeFrom750(230))/3;
    for (int i=0; i<arr.count; i++) {
        UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconBtn setTitle:arr[i] forState:UIControlStateNormal];
        [iconBtn setTitleColor:RGB_183 forState:UIControlStateNormal];
        [iconBtn setTitleColor:COLOR_DarkBlue forState:UIControlStateSelected];
        [iconBtn.titleLabel setFont:SYSTEMSIZE(28)];
        iconBtn.tag = i;
        iconBtn.adjustsImageWhenHighlighted = NO;
        iconBtn.frame = RECT(kSizeFrom750(230)*(i>0?1:0)+(btnW)*(i>0?(i-1):0), 0, i>0?btnW:kSizeFrom750(230), kSizeFrom750(80));
        [self.menuView addSubview:iconBtn];
        if (i==3) {
            [iconBtn setImage:IMAGEBYENAME(@"icons_select") forState:UIControlStateNormal];
            [iconBtn setImage:IMAGEBYENAME(@"icons_select") forState:UIControlStateHighlighted];

            
        }else{
            [iconBtn setImage:IMAGEBYENAME(@"sharp") forState:UIControlStateNormal];
            [iconBtn setImage:IMAGEBYENAME(@"sharp") forState:UIControlStateHighlighted];

            [iconBtn setImage:IMAGEBYENAME(@"sharp_sel") forState:UIControlStateSelected];
        }
        [iconBtn layoutIfNeeded];
        [iconBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,- kSizeFrom750(40), 0, 0)];
        [iconBtn setImageEdgeInsets:UIEdgeInsetsMake(0, iconBtn.titleLabel.width + iconBtn.imageView.width + kSizeFrom750(20), 0, 0)];
        [iconBtn addTarget:self action:@selector(iconsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArray addObject:iconBtn];
        if (i!=3) {
            UIView *line = [[UIView alloc]initWithFrame:RECT(iconBtn.right, kSizeFrom750(25), kLineHeight, kSizeFrom750(30))];
            [line setBackgroundColor:separaterColor];
            [self.menuView addSubview:line];
        }
    }
}
//加载月份切换菜单栏
-(void)loadCalendarHeader{
    
    [self.calendarHeaderView addSubview:self.yearLabel];
    
    UIButton *leftBtn = [[UIButton alloc]init];
    leftBtn.timeInterval = ANIMATION_TIME;
    leftBtn.frame = RECT(self.yearLabel.right, 0, kSizeFrom750(70), self.yearLabel.height);
    [leftBtn setImage:IMAGEBYENAME(@"rightArrow") forState:UIControlStateNormal];
    leftBtn.transform = CGAffineTransformMakeRotation(M_PI);
    leftBtn.tag = 0;
    [leftBtn addTarget:self action:@selector(switchMonthClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.calendarHeaderView addSubview:leftBtn];
    
    [self.calendarHeaderView addSubview:self.monthScroll];
    
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.timeInterval = ANIMATION_TIME;
    rightBtn.frame = RECT(self.monthScroll.right, 0, leftBtn.width, leftBtn.height);
    [rightBtn setImage:IMAGEBYENAME(@"rightArrow") forState:UIControlStateNormal];
    rightBtn.tag = 1;
    [rightBtn addTarget:self action:@selector(switchMonthClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.calendarHeaderView addSubview:rightBtn];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitMonth;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger month = [dateComponent month];//当前月份
    CGFloat btnWidth = self.monthScroll.width/4;
    for (NSInteger i=month; i<month+25; i++) {
        NSInteger monthNumber = i;
        if (i>12) {
            if (i>24) {
                monthNumber = i-24;
            }else
            monthNumber = i-12;
        }else{
            monthNumber = i;
        }
        
        UIButton *monthBtn = [[UIButton alloc]init];
        monthBtn.frame = RECT((i - month)*btnWidth, 0, btnWidth, leftBtn.height);
        NSString *btnText = [NSString stringWithFormat:@"%ld月",monthNumber];
        [monthBtn.titleLabel setFont:SYSTEMSIZE(28)];
        monthBtn.tag = i;
        [monthBtn setTitle:btnText forState:UIControlStateNormal];
        [monthBtn setTitle:btnText forState:UIControlStateSelected];
        [monthBtn setTitleColor:COLOR_DarkBlue forState:UIControlStateSelected];
        [monthBtn setTitleColor:RGB_183 forState:UIControlStateNormal];
        [monthBtn addTarget:self action:@selector(monthBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.monthArray addObject:monthBtn];
        [self.monthScroll addSubview:monthBtn];
        
        UIImageView *selImageView = [[UIImageView alloc]initWithFrame:RECT(0, monthBtn.height - kSizeFrom750(2), kSizeFrom750(40), kSizeFrom750(2))];
        selImageView.centerX = monthBtn.width/2;
        [selImageView setImage:[UIImage imageWithColor:COLOR_DarkBlue]];
        selImageView.tag = sliderTag;
        [selImageView setHidden:YES];
        if (i==month+12) {
            [selImageView setHidden:NO];
            monthBtn.selected = YES;//默认显示当前月份
            self.selectedMonth = monthBtn;
        }
        [monthBtn addSubview:selImageView];
        
        if (i==month+24) {
            self.monthScroll.contentSize = CGSizeMake(monthBtn.right, monthBtn.height);
            self.monthScroll.contentOffset = CGPointMake(btnWidth*12, 0);
        }
        
    }
    
}
#pragma mark --loadRequest
-(void)getRequest{
    
    
}
#pragma mark --scrollViewDelegate

#pragma mark --tableView Delegate and DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.mainTab) {
//        return self.dayPaybackArray.count;
        return 5;
    }else
        return 3;
    //    return self.dataArray.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.mainTab) {
        static NSString *cellId1 = @"MyCalendarPaybackCell";
        MyCalendarPaybackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        return cell;
    }else{
        static NSString *cellId = @"PaybackCell";
        PaybackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.mainTab) {
        //
    }else{
        
    }
}
#pragma mark --FSCalendar Delegate and DataSource
-(void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
}
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormat stringFromDate:date];
    if ([self.eventArray containsObject:dateString]) {
        return 1;
    }
    return 0;
}
- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @"今";
    }
    return nil;
}
//月份切换
-(void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    if (self.isClickBtnSwap) {//点击切换月份
        self.lastDate = calendar.currentPage;
        self.isClickBtnSwap = NO;
        return;
    }else{//滑动切换月份
        NSTimeInterval second = [CommonUtils getSecondForFromDate:self.lastDate toDate:calendar.currentPage];
        [self reloadHeaderWithDate:calendar.currentPage isNext:second>0?YES:NO];
        //记录最后时间
        self.lastDate = calendar.currentPage;
    }
}
//日期点击事件
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"-点击日期 = %@",date);
}
//最小日期
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate dateWithTimeIntervalSinceNow: -365*DAY];
}
//最大日期为一年后
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate dateWithTimeIntervalSinceNow:DAY*365];
}
#pragma mark --buttonClick
//切换一批月份
-(void)switchMonthClick:(UIButton *)sender{
    //回切
    if (sender.tag==0) {
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            self.monthScroll.contentOffset = CGPointMake(MAX(0, self.monthScroll.contentOffset.x - self.monthScroll.width), 0);

        }];
    }else{
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            self.monthScroll.contentOffset = CGPointMake(MIN(self.monthScroll.contentSize.width - self.monthScroll.width, self.monthScroll.contentOffset.x + self.monthScroll.width), 0);
        }];
    }
}
//点击跳转到该月份
-(void)monthBtnClick:(UIButton *)sender{
   
    for (UIButton *button in self.monthArray) {
        if (button.tag == sender.tag) {
            button.selected = YES;
            [[button viewWithTag:sliderTag] setHidden:NO];
            self.isClickBtnSwap = YES;
            //跳转到该月份
            NSDate *toMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:(button.tag - self.selectedMonth.tag) toDate:self.lastDate options:0];
            [self.calendar setCurrentPage:toMonth animated:YES];
            self.selectedMonth = button;//选中状态变更
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSUInteger unitFlags = NSCalendarUnitMonth|NSCalendarUnitYear;
            NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:toMonth];
            NSInteger year = [dateComponent year];//当前年份
            [self.yearLabel setText:[NSString stringWithFormat:@"%ld年",year]];

        }else{
            button.selected = NO;
            [[button viewWithTag:sliderTag] setHidden:YES];
        }
    }
}
//切换不同视图
-(void)calendarBtnClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    [self showCalendar:sender.selected];
}

-(void)iconsBtnClick:(UIButton *)sender
{
    for (UIButton *btn in self.btnArray) {
        if (sender.tag==btn.tag) {
            sender.selected = YES;
            if (btn.tag==3) {//筛选按钮
                [self.selectView hideSelectView:!self.selectView.hidden];
            }else{
                [self.selectView hideSelectView:YES];
            }
        }else{
            btn.selected = NO;
            
        }
    }
}
-(void)showTabBtnClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
            self.mainTab.frame = RECT(0, self.mainTab.top - self.mainTab.height, self.mainTab.width, self.mainTab.height);
        }];
    }else{
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            sender.imageView.transform = CGAffineTransformMakeRotation(2*M_PI);
            self.mainTab.frame = RECT(0, self.mainTab.top + self.mainTab.height, self.mainTab.width, self.mainTab.height);
        }];
    }
}
#pragma mark -- custom
-(void)showCalendar:(BOOL)isShow{
    
    CGAffineTransform transform = CGAffineTransformScale(self.listBgView.transform,isShow?0.01:100,isShow?0.01:100);
    [UIView beginAnimations:@"scale" context:nil];
    [UIView setAnimationDuration:ANIMATION_TIME];
    [UIView setAnimationDelegate:self];
    [self.listBgView setTransform:transform];
    [UIView commitAnimations];
    
    CGAffineTransform transform1 = CGAffineTransformScale(self.calendarBgView.transform,isShow?100:0.01,isShow?100:0.01);
    [UIView beginAnimations:@"scale" context:nil];
    [UIView setAnimationDuration:ANIMATION_TIME];
    [UIView setAnimationDelegate:self];
    [self.calendarBgView setTransform:transform1];
    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.calendarBgView.alpha = isShow?1:0;
        self.listBgView.alpha = isShow?0:1;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)reloadHeaderWithDate:(NSDate *)currentDate isNext:(BOOL)isNext{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitMonth|NSCalendarUnitYear;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:currentDate];
    NSInteger year = [dateComponent year];//当前年份
    [self.yearLabel setText:[NSString stringWithFormat:@"%ld年",year]];
    
    for (UIButton *btn in self.monthArray) {
      
        if (btn.selected == YES) {
            btn.selected = NO;
            [[btn viewWithTag:sliderTag] setHidden:YES];
            UIButton *nextBtn;
            if (isNext) {
                nextBtn = [self.monthScroll viewWithTag:btn.tag+1];//下一个
            }else{
                nextBtn = [self.monthScroll viewWithTag:btn.tag-1];//上一个
            }
            [[nextBtn viewWithTag:sliderTag] setHidden:NO];
            nextBtn.selected = YES;
            self.selectedMonth = nextBtn;
            self.monthScroll.contentOffset = CGPointMake(nextBtn.left, 0);
            return;
        }else{
         
            
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
