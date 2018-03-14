//
//  TreasureMiddleCell.h
//  DingXinDai
//
//  Created by 占碧光 on 2016/12/8.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TreasureMiddleDelegate <NSObject>

@optional
-(void)didTreasureMiddleIndex:(NSInteger)index;

@end

@interface TreasureMiddleCell : UITableViewCell

@property(nonatomic, assign) id<TreasureMiddleDelegate> delegate;

-(void) setDataBind:(NSMutableArray *) data;


@end
