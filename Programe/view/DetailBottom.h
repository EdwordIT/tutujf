//
//  DetailBottom.h
//  TTJF
//
//  Created by 占碧光 on 2017/12/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoanBase.h"
@protocol BottomDelegate <NSObject>

@optional
-(void)didSelectedBottomAtIndex:(NSInteger)index height:(CGFloat)height;

@end

@interface DetailBottom : UIView
@property(nonatomic, assign) id<BottomDelegate> delegate;
-(void)loadBottomWithModel:(LoanBase *)model;
@end
