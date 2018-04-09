//
//  JGGView.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/29.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import <UIKit/UIKit.h>

///九宫格图片间隔
#define kJGG_GAP kSizeFrom750(20)
/**
 *
 *  @param index      点击index
 *  @param dataSource 数据源
 */
typedef void (^TapBlcok)(NSInteger index,NSArray *dataSource,NSIndexPath *indexpath);

///九宫格图片间隔
#define kJGG_GAP kSizeFrom750(20)
/**
 *
 *  @param index      点击index
 *  @param dataSource 数据源
 */
typedef void (^TapBlcok)(NSInteger index,NSArray *dataSource,NSIndexPath *indexpath);
@interface JGGView : UIView
/**
 *  九宫格显示的数据源，dataSource中可以放UIImage对象和NSString(http://sjfjfd.cjf.jpg)，还有NSURL也可以
 */
@property (nonatomic, retain)NSArray * dataSource;
@property (nonatomic, strong)NSArray *maxDataSource;
/**
 *  TapBlcok
 */
@property (nonatomic, copy)TapBlcok  tapBlock;
/**
 *  TapBlcok
 */
@property (nonatomic, copy)NSIndexPath  *indexpath;
/**
 *  Description 九宫格
 *
 *  @param frame      frame
 *  @param dataSource 数据源
 *  @param tapBlock tapBlock点击的block
 *  @return JGGView对象
 */
/**
 *  Description 九宫格
 *
 *  @param dataSource 数据源
 *  @param tapBlock tapBlock点击的block
 *  @return JGGView对象
 */
-(void)loadJGGViewWithDataSource:(NSArray *)dataSource completeBlock:(TapBlcok)tapBlock;

@end
