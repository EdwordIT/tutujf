//
//  OneDetailTopCell.h
//  TTJF
//
//  Created by 占碧光 on 2017/4/11.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneDetailModel.h"

@protocol DetailTopDelegate <NSObject>

@optional
-(void)didSelectedDetailAtIndex:(NSInteger)index;

@end

@interface OneDetailTopCell : UITableViewCell

@property(nonatomic, assign) id<DetailTopDelegate> delegate;
-(void)setModel:(OneDetailModel *)model;

@end
