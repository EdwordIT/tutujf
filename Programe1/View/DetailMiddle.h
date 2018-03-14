//
//  DetailMiddle.h
//  TTJF
//
//  Created by 占碧光 on 2017/12/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoanBase.h"

@interface DetailMiddle : UIView

//-(void) setModel:(LoanBase *) model;
- (instancetype)initWithFrame:(CGRect)frame data:(LoanBase *) data;
@end
