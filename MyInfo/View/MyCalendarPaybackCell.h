//
//  MyCalendarPaybackCell.h
//  TTJF
//
//  Created by wbzhan on 2018/7/12.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseCell.h"
#import "PaybackModel.h"
/**
 我的回款计划（带日历页面）
 */
@interface MyCalendarPaybackCell : BaseCell
-(void)loadInfoWithModel:(PaybackModel *)model;
@end
