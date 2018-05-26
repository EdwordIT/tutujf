//
//  ScrollerContentView.m
//  CloudSoundPlus
//
//  Created by renxlin on 2017/4/21.
//  Copyright © 2017年 hzlh. All rights reserved.
//

#import "ScrollerContentView.h"


@interface ScrollerView : UIScrollView

@end

@implementation ScrollerView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (point.x <= 10) {
        hitView = nil;
    } else {
        hitView = [super hitTest:point withEvent:event];
    }
    return hitView;
}

@end

@interface ScrollerContentView () <UIScrollViewDelegate>

@property (strong, nonatomic) ScrollerView *scrollView;
@property (strong, nonatomic) ContentViewScrollCallback callback;

@property (assign, nonatomic) NSUInteger currentIndex;

@property (strong, nonatomic) NSMutableDictionary *viewControllers;

@end

@implementation ScrollerContentView
- (id)init {
    self = [super init];
    if (self) {
        self.viewControllers = [NSMutableDictionary new];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    _currentIndex = 0;
    [self initScrollView];
    [self initContentView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSUInteger index = offsetX / CGRectGetWidth(_scrollView.frame);
    self.currentIndex = index;
    
    UIViewController *vc = [self viewControllerForIndex:index];
    vc.view.frame = CGRectMake(index * CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
    
    _callback(index);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark - Private
- (void)initScrollView {
    ScrollerView *scrollView = [[ScrollerView alloc] initWithFrame:self.bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    _scrollView = scrollView;
    [self addSubview:_scrollView];
}

- (void)initContentView {
    UIViewController *vc = [self viewControllerForIndex:_currentIndex];
    vc.view.frame = CGRectMake(_currentIndex * CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
    
    _scrollView.contentSize = CGSizeMake([self contentNumber] * CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
}

- (UIViewController *)viewControllerForIndex:(NSInteger)index {
    UIViewController *vc = [self.viewControllers objectForKey:@(index)];

    if (!vc) {
        vc = [self.dataSource slideContentView:self viewControllerForIndex:index];
        [_scrollView addSubview:vc.view];
        [self.viewControllers setObject:vc forKey:@(index)];
    }
    NSLog(@"viewControllers: %@ index: %ld", [vc class], index);

    return vc;
}

- (NSInteger)contentNumber {
    NSInteger num = 0;
    if (self.dataSource) {
        num = [self.dataSource numOfContentView:self];
    }
    return num;
}

#pragma mark - Public
- (void)slideContentViewScrollFinished:(ContentViewScrollCallback)callback {
    _callback = callback;
}

- (void)scrollSlideContentViewToIndex:(NSUInteger)index {
    self.currentIndex = index;
    [self.scrollView scrollRectToVisible:CGRectMake(index * CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame)) animated:YES];
    
    UIViewController *vc = [self viewControllerForIndex:index];
    vc.view.frame = CGRectMake(index * CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
}

- (UIViewController *)currentViewController {
    UIViewController *vc = [self.viewControllers objectForKey:@(_currentIndex)];
    return vc;
}

- (NSArray *)vcs {
    return [_viewControllers allValues];
}

@end


