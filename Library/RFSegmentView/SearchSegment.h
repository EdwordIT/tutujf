//
//  SearchSegment.h
//  psychic
//
//  Created by zhanbiguang on 15/10/13.
//  Copyright (c) 2015年 wzkn. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RFSegmentViewDelegate <NSObject>
- (void)segmentViewSelectIndex:(NSInteger)index;
@end
@interface SearchSegment : UIView

/**
 *  设置风格颜色 默认蓝色风格
 */
@property(nonatomic ,strong) UIColor *tintColor;
@property(nonatomic) id<RFSegmentViewDelegate> delegate;

/**
 *  默认构造函数
 *
 *  @param frame frame
 *  @param items title字符串数组
 *
 *  @return 当前实例
 */
- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;
@end
