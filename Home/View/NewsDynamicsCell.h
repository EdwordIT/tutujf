//
//  NewsDynamicsCell.h
//  TTJF
//
//  Created by 占碧光 on 2017/10/1.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsDynamicsModel.h"

@protocol NewsDynamicsDelegate <NSObject>

@optional
-(void)didSelectedNewsDynamicsAtIndex:(NSInteger)index;

@end


@interface NewsDynamicsCell : UITableViewCell

@property(nonatomic, assign) id<NewsDynamicsDelegate> delegate;


-(void)setDaiBangSj: (NSMutableArray *)array;

-(void)setXuanZhuanDh;
@end
