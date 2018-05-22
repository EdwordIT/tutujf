//
//  InvestSelectView.h
//  TTJF
//
//  Created by wbzhan on 2018/5/19.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseView.h"
typedef void (^SelectBlock)(NSInteger tag,NSString *startTime,NSString *endTime);
@interface InvestSelectView : BaseView
Copy SelectBlock selectBlock;
-(void)showSelectView:(BOOL)isShow;
@end
