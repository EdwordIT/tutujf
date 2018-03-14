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

@property(nonatomic, strong) UILabel *shouyi;
@property(nonatomic, strong) UILabel *shengyueje;
@property(nonatomic, strong) UILabel *xianmuqx;

-(void)setImmediateModel:(ImmediateModel *)mode;

@end
