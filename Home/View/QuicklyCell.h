//
//  QuicklyCell.h
//  TTJF
//
//  Created by 占碧光 on 2017/3/12.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuicklyModel.h"

@protocol QuicklyDelegate <NSObject>

@optional
-(void)didSelectedQuicklyAtIndex:(NSInteger)index;

@end

@interface QuicklyCell : UITableViewCell

@property(nonatomic, assign) id<QuicklyDelegate> delegate;
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UIImageView *typeimgsrc;
@property(nonatomic, strong) UILabel *percentLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(strong,nonatomic) UIView *timeView;
@property(nonatomic,strong)UIView *sepView;//分割段落

-(void)setQuicklyModel:(QuicklyModel *)model;


@end
