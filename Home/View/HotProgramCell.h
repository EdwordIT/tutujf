//
//  HotProgramCell.h
//  TTJF
//
//  Created by 占碧光 on 2017/3/12.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotQueueModel.h"

@protocol ProgramDelegate <NSObject>

@optional
-(void)didSelectedProgramAtIndex:(NSInteger)index;

@end


@interface HotProgramCell : UITableViewCell

//@property(nonatomic, strong) HotQueueModel *hotQueue;

@property(nonatomic, strong) UILabel *topLeftLabel1;
@property(nonatomic, strong) UIImageView *topLeftImg;
@property(nonatomic, strong) UILabel *bottomLeftLabel1;


@property(nonatomic, strong) UILabel *topRightLabel1;
@property(nonatomic, strong) UIImageView *topRightImg;
@property(nonatomic, strong) UILabel *bottomRightLabel1;

-(void)setHotQueueData:(HotQueueModel *)hotQueue;

@property(nonatomic, assign) id<ProgramDelegate> delegate;

@end
