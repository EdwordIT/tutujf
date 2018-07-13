//
//  PaybackSelectView.h
//  TTJF
//
//  Created by wbzhan on 2018/7/9.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseView.h"

typedef void (^PaybackSelectBlock)(NSInteger tag,NSString *timeInterval,NSString *keyWord);
/**
 回款筛选
 */
@interface PaybackSelectView : BaseView
Copy PaybackSelectBlock selectedBlock;
-(void)hideSelectView:(BOOL)isHide;
@end
