//
//  SZCalendarPicker.m
//  SZCalendarPicker
//
//  Created by Stephen Zhuang on 14/12/1.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import "SZCalendarPicker.h"
#import "SZCalendarCell.h"
#import "UIColor+ZXLazy.h"

NSString *const SZCalendarCellIdentifier = @"cell";

@interface SZCalendarPicker ()
{
    UILabel *monthLabel;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIImageView *qdbg;

//@property (nonatomic , weak) IBOutlet UIButton *previousButton;
//@property (nonatomic , weak) IBOutlet UIButton *nextButton;
@property (nonatomic , strong) NSArray *weekDayArray;
//@property (weak, nonatomic) IBOutlet UIImageView *qdbg;
@property (weak, nonatomic) IBOutlet UIImageView *lkjd;



@property (weak, nonatomic) IBOutlet UILabel *labnr;

@property (nonatomic , strong) UIView *mask;
@end

@implementation SZCalendarPicker


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    

    _lianxudd=1;
    // Drawing code
// [self addTap];
//[self addSwipe];
   [self show];
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(18, 305, 250, 30);
    btn1.backgroundColor=[UIColor clearColor];
    [btn1 addTarget:self action:@selector(BtnAdClick:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag=1;
    [self addSubview:btn1];
    
   
}

- (void)awakeFromNib
{
    [_collectionView registerClass:[SZCalendarCell class] forCellWithReuseIdentifier:SZCalendarCellIdentifier];
     _weekDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
}

- (void)customInterface
{
    CGFloat itemWidth = _collectionView.frame.size.width / 7;
    CGFloat itemHeight = _collectionView.frame.size.height / 7;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
 
    [_collectionView setCollectionViewLayout:layout animated:YES];
        [_collectionView.layer setBorderColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1].CGColor];//边框颜色
    [_collectionView.layer setCornerRadius:2.0]; //设置矩形四个圆角半径
    [_collectionView.layer setBorderWidth:0.5]; //边框宽度
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    [monthLabel setText:[NSString stringWithFormat:@"签到日期%.2ld-%li",(long)[self year:date],(long)[self month:date]]];
    [_collectionView reloadData];
}

#pragma mark - date

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSInteger)totaldaysInThisMonth:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}

- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

#pragma -mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _weekDayArray.count;
    } else {
        return 42;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SZCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SZCalendarCellIdentifier forIndexPath:indexPath];
    NSDate *today = [NSDate date];
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:today];
 

    if (indexPath.section == 0) {
        [cell.dateLabel setText:_weekDayArray[indexPath.row]];
        [cell.dateLabel setTextColor:RGB(110,110,110)];
        [cell.dateLabel setFont:[UIFont systemFontOfSize:12]];
        [cell.dateLabel setBackgroundColor:[UIColor whiteColor]];
    
        
        
    } else {
        NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i < firstWeekday) {
            day = days.length-( firstWeekday-i-1);
            [cell.dateLabel setText:[NSString stringWithFormat:@"%li",(long)day]];
            [cell.dateLabel setFont:[UIFont systemFontOfSize:12]];
            [cell.dateLabel setTextColor:RGB(110,110,110)];
            [cell.dateLabel setBackgroundColor:[UIColor whiteColor]];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
             day = i - firstWeekday -days.length;
            [cell.dateLabel setText:[NSString stringWithFormat:@"%li",(long)day]];
                [cell.dateLabel setFont:[UIFont systemFontOfSize:12]];
            [cell.dateLabel setTextColor:RGB(110,110,110)];
             [cell.dateLabel setBackgroundColor:[UIColor whiteColor]];
          
        }else{
            day = i - firstWeekday + 1;
            [cell.dateLabel setText:[NSString stringWithFormat:@"%li",(long)day]];
            [cell.dateLabel setTextColor:RGB(32,32,32)];
            [cell.dateLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
            [cell.dateLabel setBackgroundColor:[UIColor whiteColor]];
            
            //this month
            if ([_today isEqualToDate:_date]) {
                NSUInteger dd= [self day:_date];
            
                if(_lianxudd!=1)
                    dd=_lianxudd;
                
                if (day == dd) {
                    
                } else if (day > dd) {
                  //  [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#cbcbcb"]];
                      if((dd+6)==day||(dd+14)==day||(dd+26)==day)
                      {
                        
                          UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 16, 19)];
                            [imageView setImage:[UIImage imageNamed:@"liwubao@2x.png"]];
                          [cell.dateLabel addSubview:imageView];
                      }

                }
                
                
            } else if ([_today compare:_date] == NSOrderedAscending) {
               // [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#cbcbcb"]];
            }
            
            if(_dataArray!=nil&&_dataArray.count>0)
            {
              //  NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
              //  unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
             //   NSDateComponents *comp1 = [myCal components:units fromDate:day];
                for( int i=0; i< _dataArray.count;i++)
                {
                    
                 NSString* str1= [NSString stringWithFormat:@"%ld",(long)day];
                  
                    NSString* str2=  [NSString stringWithFormat:@"%@",[_dataArray objectAtIndex:i]];
                    if([str1 isEqual:str2])
                    {
                        [cell.dateLabel setTextColor:[UIColor colorWithHexString:@"#ffffff"]];
                        cell.dateLabel.backgroundColor=RGB(254,85,78);
                        break;
                    }
                }
            }
        }
    }
    return cell;
}
//liwubao@2x.png


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i >= firstWeekday && i <= firstWeekday + daysInThisMonth - 1) {
            day = i - firstWeekday + 1;
            
            //this month
            if ([_today isEqualToDate:_date]) {
                if (day <= [self day:_date]) {
                    //[self hide];
                    return YES;
                }
            } else if ([_today compare:_date] == NSOrderedDescending) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
    
    NSInteger day = 0;
    NSInteger i = indexPath.row;
    day = i - firstWeekday + 1;
  //  if (self.calendarBlock) {
        
      // self.calendarBlock(day, [comp month], [comp year]);
 
  //  }
 //   else self.backgroundColor=RGB(254, 85, 78);
 
}
/*

- (IBAction)previouseAction:(UIButton *)sender
{
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
        self.date = [self lastMonth:self.date];
    } completion:nil];
}

- (IBAction)nexAction:(UIButton *)sender
{
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^(void) {
        self.date = [self nextMonth:self.date];
    } completion:nil];
}
*/
+ (instancetype)showOnView:(UIView *)view
{
    SZCalendarPicker *calendarPicker = [[[NSBundle mainBundle] loadNibNamed:@"SZCalendarPicker" owner:self options:nil] firstObject];
    calendarPicker.mask = [[UIView alloc] initWithFrame:view.bounds];
    calendarPicker.mask.backgroundColor = [UIColor blackColor];
    calendarPicker.mask.alpha = 0.3;
    calendarPicker.mask.tag=9999;
    [view addSubview:calendarPicker.mask];
    [view addSubview:calendarPicker];
    return calendarPicker;
}

- (void)show
{
    self.transform = CGAffineTransformTranslate(self.transform, 0, - self.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL isFinished) {
        [self customInterface];
      
    }];
   
}

- (void)hide
{
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.transform = CGAffineTransformTranslate(self.transform, 0, - self.frame.size.height);
        self.mask.alpha = 0;
    } completion:^(BOOL isFinished) {
        [self.mask removeFromSuperview];
        [self removeFromSuperview];
    }];
}



/*

- (void)addSwipe
{
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nexAction:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previouseAction:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipRight];
}
*/
- (void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.mask addGestureRecognizer:tap];
    
    
}
- (void)BtnAdClick:(UIButton *)sender {
    [self hide];
       if([_showtype isEqual:@"2"])
       {
        NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
       if (self.calendarBlock) {
        
        self.calendarBlock([comp day], [comp month], [comp year]);
        
       }
       }
  
}

-(void)setDefaultInfo:(NSString *) info
{
    _labnr.text=info;
    _labnr.textAlignment=NSTextAlignmentCenter;
    if([_showtype isEqual:@"1"])
    {
        _lkjd.image=[UIImage imageNamed:@"btn.png"];
    }
    if([_showtype isEqual:@"2"])
    {
        _lkjd.image=[UIImage imageNamed:@"btn11@2x.png"];
    }
}

@end
