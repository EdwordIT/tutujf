//
//  MyInvestRecordCell.h
//  TTJF
//
//  Created by wbzhan on 2018/5/16.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseCell.h"
#import "CreditAssignHistoryModel.h"
typedef void (^CreditAssignBlock)(NSInteger tag);
/**
 债权转让记录
 */
@interface CreditAssignHistoryCell : BaseCell
-(void)loadInfoWithModel:(CreditAssignHistoryModel *)model;
Copy CreditAssignBlock alertBlock;//点击显示温馨提示内容
@end
