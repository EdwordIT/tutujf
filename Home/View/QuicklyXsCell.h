//
//  QuicklyXsCell.h
//  TTJF
//
//  Created by 占碧光 on 2017/10/3.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuicklyModel.h"

@protocol QuicklyDelegate <NSObject>

@optional
-(void)didSelectedQuicklyAtIndex:(NSInteger)index;

@end

@interface QuicklyXsCell : UITableViewCell

@property(nonatomic, assign) id<QuicklyDelegate> delegate;
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UIImageView *typeimgsrc;
@property(nonatomic, strong) UILabel *yuqiinh;
@property(nonatomic, strong) UILabel *yuqisj;

-(void)setQuicklyModel:(QuicklyModel *)model;


@end
