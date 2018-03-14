//
//  1MyBottomCell.h
//  TTJF
//
//  Created by 占碧光 on 2017/3/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyBottomDelegate <NSObject>

@optional
-(void)didMyBottomAtIndex:(NSInteger)index;

@end

@interface _MyBottomCell : UITableViewCell

@property(nonatomic, assign) id<MyBottomDelegate> delegate;

@end
