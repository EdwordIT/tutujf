//
//  ZDCalendarPicker.h
//  DingXinDai
//
//  Created by 占碧光 on 16/7/11.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarDelegate <NSObject>

@optional
-(void)didCalendar:(NSInteger)index;

@end

@interface ZDCalendarPicker : UIView<UICollectionViewDelegate , UICollectionViewDataSource>
@property (nonatomic , strong) NSDate *date;
@property (nonatomic , strong) NSDate *today;
@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);

@property(nonatomic, assign) id<CalendarDelegate> delegate;

//+ (instancetype)showOnView:(UIView *)view;

@end
