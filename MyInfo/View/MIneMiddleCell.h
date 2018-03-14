//
//  MIneMidddleCell.h
//  TTJF
//
//  Created by 占碧光 on 2017/10/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MIneMiddleDelegate <NSObject>

@optional
-(void)didopMIneMiddleAtIndex:(NSInteger)index;

@end

@interface MIneMiddleCell : UITableViewCell


@property(nonatomic, assign) id<MIneMiddleDelegate> delegate;

-(void) setModelData:(NSArray *) ary1 ary2:(NSArray *)ary2 ary3:(NSArray *)ary3;

@end
