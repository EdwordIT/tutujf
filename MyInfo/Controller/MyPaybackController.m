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
#import "TTJFRefreshNormalHeader.h"
#import "UIButton+Gradient.h"
#define calendarColor RGB(234, 78, 71)
#define sliderTag 101


//页面两种显示方式，一种带日历，一直列表
@interface MyPaybackController ()<UITableViewDelegate,UITableViewDataSource,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance,UIScrollViewDelegate>
Strong UIView *listBgView;
Strong UIScrollView *calendarBgView;
Strong PaybackSelectView *selectView;
Strong UIView *menuView;//菜单栏
Strong NSMutableArray *btnArray;//button
Strong BaseUITableView *listTab;//常规列表
Strong NSMutableArray *listDataArray;//常规数据源
Assign BOOL isCalendar;//是否切换到带日历的内容显示页面
Assign BOOL isLoadCalendar;//月份数据只加载一次

Strong UIButton *headerView;
Strong UILabel *headerTitle;
Strong UILabel *headerTextL;
Strong UIView *calendarHeaderView;//日历标题
Strong UIScrollView *monthScroll;//月份
Strong UILabel *yearLabel;//年份
Strong FSCalendar *calendar;//日历
Strong NSMutableArray *monthArray;
Strong NSArray *eventArray;//含有点击事件的数组：当天有回款
Strong NSCalendar *gregorian;
Assign NSInteger year;//年份
Strong NSDateFormatter *dateFormat;//时间格式
Copy NSString *currentDate;//现在的日期
Strong NSDate *lastDate;//滑动日历之前当前日期
Strong UIButton *selectedMonth;//当前处于的月份选中按钮
Assign BOOL isClickBtnSwap;//是否点击切换月份
Strong UIView *tableHeaderView;//
Strong UILabel *dateLabel;//当天日期
Strong UILabel *amountLabel;//当天待回款
Strong BaseUITableView *mainTab;//
Strong UIButton *showTabBtn;
Strong NSArray *calendarArray;//当天的待回款金额
Weak UIButton *timeBtn;//时间排序按钮
Weak UIButton *selectBtn;//筛选按钮
//筛选条件
Copy NSString *keyword;//关键字
Copy NSString *startTime;
Copy NSString *endTime;
Assign NSInteger page;
Assign NSInteger totalPage;
Assign NSString *order;//排序 ：recover_time_up 时间升序，recover_time_down 时间降序，amount_up 金额升序，amount_down 金额降序，apr_up 利率升序，apr_down利率降序
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
-(UIView *)listBgView{
    if (!_listBgView) {
        _listBgView = [[UIView alloc]initWithFrame:RECT(0, kNavHight, screen_width, kViewHeight)];
    }
    return _listBgView;
}
-(UIScrollView *)calendarBgView{
    if (!_calendarBgView) {
        _calendarBgView = [[UIScrollView alloc]initWithFrame:RECT(0, kNavHight, screen_width, kViewHeight)];
        TTJFRefreshNormalHeader *header = [TTJFRefreshNormalHeader headerWithRefreshingBlock:^{
            
        }];
        header.canRefresh = NO;
        _calendarBgView.mj_header = header;
        _calendarBgView.alpha = 0;
        _calendarBgView.showsVerticalScrollIndicator = NO;
        _calendarBgView.delegate = self;
    }
    return _calendarBgView;
}
-(PaybackSelectView *)selectView{
    if (!_selectView) {
        _selectView = [[PaybackSelectView alloc]initWithFrame:RECT(0, self.menuView.bottom, screen_width, kViewHeight)];
        _selectView.hidden = YES;
        WEAK_SELF;
        _selectView.selectedBlock = ^(NSDate *start, NSDate *end, NSString *key) {
            if (start==nil) {
                weakSelf.startTime = @"";
            }else{
                weakSelf.startTime = [weakSelf.dateFormat stringFromDate:start];
            }
            if (end==nil) {
                weakSelf.endTime = @"";
            }else{
                weakSelf.endTime = [weakSelf.dateFormat stringFromDate:end];
            }
            //点击筛选搜索之后，默认为按时间降序排列
            weakSelf.order = @"recover_time_down";
            weakSelf.selectBtn.selected = NO;
            weakSelf.timeBtn.selected = YES;
            weakSelf.timeBtn.imageView.transform = CGAffineTransformMakeRotation(0);
            weakSelf.keyword = key;
            [weakSelf getRequest];//筛选数据
        };
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
-(NSMutableArray *)listDataArray{
    if (!_listDataArray) {
        _listDataArray = InitObject(NSMutableArray);
    }
    return _listDataArray;
}
-(BaseUITableView *)listTab{
    if (!_listTab) {
        _listTab = [[BaseUITableView alloc]initWithFrame:CGRectMake(0, self.menuView.bottom, screen_width, self.listBgView.height - self.menuView.bottom) style:UITableViewStylePlain];
        _listTab.delegate = self;
        _listTab.dataSource = self;
        [_listTab registerClass:[PaybackCell class] forCellReuseIdentifier:@"PaybackCell"];
        _listTab.rowHeight = kSizeFrom750(365);
    }
    return _listTab;
}
#pragma mark --load Calendar
//时间格式：精确到天
-(NSDateFormatter *)dateFormat{
    if (!_dateFormat) {
        _dateFormat = InitObject(NSDateFormatter);
        _dateFormat.dateFormat = @"yyyy-MM-dd";

    }
    return _dateFormat;
}
-(UIButton *)headerView
{
    if (!_headerView) {
        _headerView = [[UIButton alloc]initWithFrame:RECT(0, 0, screen_width, kSizeFrom750(110))];
        [_headerView gradientButtonWithSize:_headerView.frame.size colorArray:@[COLOR_DarkBlue,COLOR_LightBlue] percentageArray:@[@(0.5),@(1)] gradientType:GradientFromTopToBottom];
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
//当月待回款
-(UILabel *)headerTextL{
    if (!_headerTextL) {
        _headerTextL = [[UILabel alloc]initWithFrame:RECT(screen_width/2, 0, screen_width/2 - kOriginLeft, kSizeFrom750(50))];
        [_headerTextL setFont:SYSTEMBOLDSIZE(50)];
        _headerTextL.centerY = self.headerTitle.centerY;
        _headerTextL.textAlignment = NSTextAlignmentRight;
        _headerTextL.textColor = COLOR_White;
        NSString *txt = [[CommonUtils getHanleNums:@"0"] stringByAppendingString:@"元"];
        [_headerTextL setAttributedText:[CommonUtils diffierentFontWithString:txt rang:[txt rangeOfString:@"元"] font:SYSTEMSIZE(30) color:nil spacingBeforeValue:0 lineSpace:0]];
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
        _calendar.appearance.todayColor = [UIColor clearColor];//今天的背景颜色
        _calendar.appearance.titleTodayColor = calendarColor;//今天标题的颜色
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
//当天日期
-(UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel =  [[UILabel alloc]initWithFrame:RECT(kOriginLeft, kOriginLeft, kSizeFrom750(500), kLabelHeight)];
        _dateLabel.font = NUMBER_FONT(35);
        _dateLabel.textColor = RGB_51;
        
    }
    return _dateLabel;
}
//当天待回款
-(UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel =  [[UILabel alloc]initWithFrame:RECT(kOriginLeft, self.dateLabel.bottom+kSizeFrom750(20), kSizeFrom750(500), kLabelHeight)];
        _amountLabel.font = SYSTEMSIZE(28);
        _amountLabel.textColor = RGB_183;
        NSString *txt = @"当天待回款 0.00 元";
        [_amountLabel setAttributedText:[CommonUtils diffierentFontWithString:txt rang:[txt rangeOfString:@"0.00"] font:SYSTEMSIZE(30) color:COLOR_Red spacingBeforeValue:0 lineSpace:0]];
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
        _mainTab = [[BaseUITableView alloc]initWithFrame:RECT(0, self.tableHeaderView.bottom, screen_width, 0) style:UITableViewStylePlain];
        _mainTab.delegate = self;
        _mainTab.dataSource = self;
        _mainTab.rowHeight = kSizeFrom750(162);
        _mainTab.estimatedRowHeight = 0;
        _mainTab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        _mainTab.ly_emptyView = [EmptyView noDataRefreshBlock:^{
//            
//        }];//zan'wu'shu
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
    
    self.calendarBgView.transform = CGAffineTransformScale(_calendarBgView.transform, 0.01, 0.01);

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
    self.page = 1;
    self.startTime = @"";
    self.endTime = @"";
    self.keyword = @"";
    self.order = @"recover_time_down";//默认按时间降序排列
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
            [iconBtn setImage:IMAGEBYENAME(@"icons_select_sel") forState:UIControlStateSelected];
            self.selectBtn = iconBtn;
            
        }else{
            [iconBtn setImage:IMAGEBYENAME(@"sharp") forState:UIControlStateNormal];
            [iconBtn setImage:IMAGEBYENAME(@"sharp_sel") forState:UIControlStateSelected];
        }
        if (i==0) {
            
            iconBtn.selected = YES;//默认按时间降序排列
            self.timeBtn = iconBtn;
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
    for (NSInteger i=month; i<month+13; i++) {
        NSInteger monthNumber = i;
        if (i>12) {
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
        if (i==month) {
            [selImageView setHidden:NO];
            monthBtn.selected = YES;//默认显示当前月份
            self.selectedMonth = monthBtn;
        }
        [monthBtn addSubview:selImageView];
        
        if (i==month+12) {
            self.monthScroll.contentSize = CGSizeMake(monthBtn.right, monthBtn.height);
            self.monthScroll.contentOffset = CGPointMake(0, 0);
        }
        
    }
    
}

#pragma mark --loadRequest
-(void)getRequest{
    [self.listTab setContentOffset:CGPointMake(0, 0) animated:YES];//滚动到顶端
    [SVProgressHUD show];
    NSArray *keys = @[kToken,@"keyword",@"start_time",@"end_time",@"page",@"order"];
    NSArray *values = @[[CommonUtils getToken],self.keyword,self.startTime,self.endTime,[NSString stringWithFormat:@"%ld",self.page],self.order];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getMyRecoverUrl keysArray:keys valuesArray:values refresh:self.listTab success:^(NSDictionary *successDic) {
        if (self.page==1) {
            [self.listDataArray removeAllObjects];
        }
        self.totalPage = [[successDic objectForKey:RESPONSE_TOTALPAGES] integerValue];
        for (NSDictionary *item in successDic[RESPONSE_LIST]) {
            PaybackModel *model = [PaybackModel yy_modelWithJSON:item];
            [self.listDataArray addObject:model];
        }
        [self.listTab reloadData];
       
        if (!self.isLoadCalendar) {
            [self reloadCalendarView];
            self.isLoadCalendar = YES;
        }
        
    } failure:^(NSDictionary *errorDic) {
        
    }];

}
#pragma mark --scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==self.calendarBgView) {
        if (scrollView.contentOffset.y>self.calendar.bottom) {
            [self.tableHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.calendar.mas_bottom).offset(scrollView.contentOffset.y -self.calendar.bottom);
            }];
        }else{
            [self.tableHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.calendar.mas_bottom);
            }];
        }
    }
}
#pragma mark --tableView Delegate and DataSource
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.mainTab) {
        //去掉最后一行的分割线
        if ([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row) {
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
    }
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.mainTab) {
        for (NSArray *arr in self.calendarArray) {
            PaybackModel *model = [arr lastObject];
            if ([model.recover_time isEqualToString:self.currentDate] ) {
                return arr.count;
            }
        }
        return 0;
    }else
        return self.listDataArray.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.mainTab) {
        static NSString *cellId1 = @"MyCalendarPaybackCell";
        MyCalendarPaybackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        for (NSArray *arr in self.calendarArray) {
            PaybackModel *model = [arr lastObject];
            if ([model.recover_time isEqualToString:self.currentDate] ) {
                PaybackModel *cellModel = [arr objectAtIndex:indexPath.row];
                [cell loadInfoWithModel:cellModel];
            }
        }
        return cell;
    }else{
        static NSString *cellId = @"PaybackCell";
        PaybackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        [cell loadInfoWithModel:self.listDataArray[indexPath.row]];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.mainTab) {
        //
    }else{
        
    }
}
#pragma mark --FSCalendarAppearanceDelegate
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date{
    if ([self.gregorian isDateInToday:date]) {//今天的背景layer的颜色
        return  calendarColor;
    }
    return nil;
}


#pragma mark --FSCalendar Delegate and DataSource
//calendar的frame发生变化会调用此方法
-(void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    [self.calendarBgView layoutIfNeeded];
    if (self.showTabBtn.selected==NO) {//tableView隐藏状态下，不刷新mainTab的位置
        self.mainTab.frame = RECT(0, self.tableHeaderView.bottom, screen_width, self.mainTab.contentSize.height);
    }else{
        self.mainTab.frame = RECT(0,self.tableHeaderView.bottom-self.mainTab.contentSize.height, screen_width, self.mainTab.contentSize.height);
    }
    
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
        [self reloadCurrentDayInfo];
        self.currentDate = [self.dateFormat stringFromDate:date];//当天日期
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
    [self reloadCurrentMonthInfo];
}
//日期点击事件
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    self.currentDate = [self.dateFormat stringFromDate:date];
    [self reloadCurrentDayInfo];//刷新当天数据
    NSLog(@"-点击日期 = %@",date);
}
//最小日期为当天
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate date];
}
//最大日期为一年后
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    NSDate *maxDay = [self.gregorian dateByAddingUnit:NSCalendarUnitYear value:1 toDate:[NSDate date] options:0];
    return maxDay;
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
            self.lastDate = toMonth;//月份切换完成后的日期

        }else{
            button.selected = NO;
            [[button viewWithTag:sliderTag] setHidden:YES];
        }
    }
    [self reloadCurrentMonthInfo];
}
//切换不同视图
-(void)calendarBtnClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    [self showCalendar:sender.selected];
}

-(void)iconsBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 0://时间排序
            {
               // recover_time_up 时间升序，recover_time_down 时间降序，amount_up 金额升序，amount_down 金额降序，apr_up 利率升序，apr_down利率降序
                if ([self.order isEqualToString:@"recover_time_down"]) {
                    self.order = @"recover_time_up";
                    sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
                }else{
                     self.order = @"recover_time_down";
                    sender.imageView.transform = CGAffineTransformMakeRotation(0);
                }
            }
            break;
        case 1://金额排序
        {
            if ([self.order isEqualToString:@"amount_down"]) {
                self.order = @"amount_up";
                sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
            }else{
                self.order = @"amount_down";
                sender.imageView.transform = CGAffineTransformMakeRotation(0);
            }
        }
            break;
        case 2://利率排序
        {
            if ([self.order isEqualToString:@"apr_down"]) {
                self.order = @"apr_up";
                sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
            }else{
                self.order = @"apr_down";
                sender.imageView.transform = CGAffineTransformMakeRotation(0);
            }
        }
            break;
            
        default:
            break;
    }
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
    
    if (sender.tag!=3) {
        [self getRequest];
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
//刷新当月待回款数据
-(void)reloadCurrentMonthInfo{
     NSString *currentMonth =  [[self.dateFormat stringFromDate:self.lastDate] substringWithRange:NSMakeRange(0, 7)];
    CGFloat totalAmount = 0;//
    for (int i=0; i<self.listDataArray.count; i++) {
        PaybackModel *model = self.listDataArray[i];
        NSString *month = [model.recover_time substringWithRange:NSMakeRange(0, 7)];
        if ([month isEqualToString:currentMonth]) {
            totalAmount +=[model.amount floatValue];
        }
    }
    NSString *txt = [[CommonUtils getHanleNums:[NSString stringWithFormat:@"%.2f",totalAmount]] stringByAppendingString:@"元"];
    [self.headerTextL setAttributedText:[CommonUtils diffierentFontWithString:txt rang:[txt rangeOfString:@"元"] font:SYSTEMSIZE(30) color:nil spacingBeforeValue:0 lineSpace:0]];
    
}
//刷新当天待回款数据
-(void)reloadCurrentDayInfo{
    
    self.dateLabel.text = self.currentDate;
    BOOL isHaveEvent = NO;//
    for (int i=0; i<self.calendarArray.count; i++) {
        NSArray *arr = self.calendarArray[i];
        NSString *currentDate = ((PaybackModel *)[arr lastObject]).recover_time;
        if ([currentDate isEqualToString:self.currentDate]) {
            CGFloat totalAmount = 0;//
            for (int i=0; i<arr.count; i++) {
                PaybackModel *model = [arr objectAtIndex:i];
                totalAmount+=[model.amount floatValue];
            }
            isHaveEvent = YES;
            NSString *amount = [CommonUtils getHanleNums:[NSString stringWithFormat:@"%.2f",totalAmount]];
            NSString *txt = [NSString stringWithFormat:@"当天待回款 %@ 元",amount];
            [self.amountLabel setAttributedText:[CommonUtils diffierentFontWithString:txt rang:[txt rangeOfString:amount] font:SYSTEMSIZE(30) color:COLOR_Red spacingBeforeValue:0 lineSpace:0]];
            self.dateLabel.text = currentDate;
        }
        
    }
    if (!isHaveEvent) {
        NSString *txt = @"当天待回款 0.00 元";
        [self.amountLabel setAttributedText:[CommonUtils diffierentFontWithString:txt rang:[txt rangeOfString:@"0.00"] font:SYSTEMSIZE(30) color:COLOR_Red spacingBeforeValue:0 lineSpace:0]];
    }
    [self.mainTab reloadData];
    [self.mainTab layoutIfNeeded];
    self.mainTab.frame = RECT(0, self.tableHeaderView.bottom, screen_width, self.mainTab.contentSize.height);
    self.calendarBgView.contentSize = CGSizeMake(screen_width, self.mainTab.bottom);
    
    self.showTabBtn.imageView.transform = CGAffineTransformMakeRotation(2*M_PI);
    self.showTabBtn.selected = NO;
    
}
-(void)reloadCalendarView{
    
    //按日期区分数组
    self.calendarArray  = [self arraySplitSubArrays:self.listDataArray];
    [self.calendar reloadData];
    [self reloadCurrentMonthInfo];
    self.dateLabel.text = self.currentDate;//默认选择当天日期
}
- (NSMutableArray *)arraySplitSubArrays:(NSArray *)array {
    
    NSMutableArray *resaultArr = InitObject(NSMutableArray);
    // 数组去重,根据数组元素对象中time字段去重
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    for(PaybackModel *obj in array)
    {
        [dic setValue:obj.recover_time forKey:obj.recover_time];
    }
    
    NSMutableArray *tempArr = InitObject(NSMutableArray);
    for (NSString *dictKey in dic) {
        [tempArr addObject:dictKey];
    }
    self.eventArray = tempArr;//当天有回款
    for (int i=0; i<[tempArr count]; i++) {
        NSMutableArray *addArr = InitObject(NSMutableArray);
        NSString *key = tempArr[i];
        for (PaybackModel *model in array) {
            if ([key isEqualToString:model.recover_time]) {
                [addArr addObject:model];
            }
        }
            [resaultArr addObject:addArr];
    }

    return resaultArr;
}
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
            self.monthScroll.contentOffset = CGPointMake(MIN(self.monthScroll.contentSize.width - btn.width*4, nextBtn.left), 0);
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
