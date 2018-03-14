//
//  1MyMiddleCell.h
//  TTJF
//
//  Created by 占碧光 on 2017/3/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyMiddleDelegate <NSObject>

@optional
-(void)didMyMiddleAtIndex:(NSInteger)index;

@end

@interface _MyMiddleCell : UITableViewCell

//@property(nonatomic, assign) id<Menu2TopDelegate> delegate;

@property(nonatomic, assign) id<MyMiddleDelegate> delegate;

-(void)setDefaultValue: (NSString*) title;

@end
