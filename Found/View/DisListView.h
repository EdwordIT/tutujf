//
//  DisListView.h
//  TTJF
//
//  Created by wbzhan on 2018/8/2.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DisListViewDelegate <NSObject>

@optional
-(void)didClickListButtonIndex:(NSInteger)index;

@end
/**
 发现页面为了匹配上滑动list随滑动上移且不被遮挡
 */
@interface DisListView : UIScrollView
Assign id<DisListViewDelegate>listDelegate;
-(void)loadInfoWithArray:(NSArray *)array andTitle:(NSString *)title;
@end
