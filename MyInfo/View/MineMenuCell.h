//
//  MineMenuCell.h
//  TTJF
//
//  Created by 占碧光 on 2017/10/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineMenuDelegate <NSObject>

@optional
-(void)didMineMenuAtIndex:(NSInteger)index;

@end


@interface MineMenuCell : UITableViewCell

  @property(nonatomic, assign) id<MineMenuDelegate> delegate;

-(void) setMenuData:(NSArray *) ary1 ayr2:(NSArray *)ayr2;

@end
