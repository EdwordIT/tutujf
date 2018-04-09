//
//  ImmediateCell.h
//  TTJF
//
//  Created by 占碧光 on 2017/3/12.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImmediateModel.h"

@protocol ImmediateDelegate <NSObject>

@optional
-(void)didSelectedImmediateAtIndex:(NSInteger)index;

@end



@interface ImmediateCell : UITableViewCell


@property(nonatomic, assign) id<ImmediateDelegate> delegate;
/**收益*/
@property(nonatomic, strong) UILabel *incomeLabel;
/**起投金额*/
@property(nonatomic, strong) UILabel *minPointLabel;
/**投资时间*/
@property(nonatomic, strong) UILabel *timeLabel;
//数据加载
-(void)setImmediateModel:(ImmediateModel *)mode;
//无数据隐藏视图
-(void)hiddenSubViews:(BOOL)isHidden;
@end
