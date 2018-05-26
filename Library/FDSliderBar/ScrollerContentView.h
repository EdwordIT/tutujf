//
//  ScrollerContentView.h
//  CloudSoundPlus
//
//  Created by renxlin on 2017/4/21.
//  Copyright © 2017年 hzlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollerContentView;

typedef void(^ContentViewScrollCallback)(NSUInteger index);

@protocol ScrollerContentViewDataSource <NSObject>

- (UIViewController *)slideContentView:(ScrollerContentView *)contentView viewControllerForIndex:(NSUInteger)index;

- (NSInteger)numOfContentView:(ScrollerContentView*)contentView;

@end

@interface ScrollerContentView : UIView

@property (weak, nonatomic) id <ScrollerContentViewDataSource> dataSource;

- (void)slideContentViewScrollFinished:(ContentViewScrollCallback)callback;

- (void)scrollSlideContentViewToIndex:(NSUInteger)index;

- (NSUInteger)currentIndex;

- (UIViewController *)currentViewController;

- (NSArray *)vcs;

@end

