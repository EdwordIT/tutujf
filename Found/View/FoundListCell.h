//
//  FoundListCell.h
//  TTJF
//
//  Created by 占碧光 on 2017/11/20.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoundListModel.h"

@protocol TreasureListDelegate <NSObject>

@optional
-(void)didTreasureListDelegateIndex:(NSInteger)index;

@end

@interface FoundListCell : UITableViewCell

@property(nonatomic, assign) id<TreasureListDelegate> delegate;

-(void) setDataBind:(FoundListModel *) model;
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UIImageView *typeimgsrc;
@property(nonatomic, strong) UILabel *date;
Strong     UIView *lineView;

@end
