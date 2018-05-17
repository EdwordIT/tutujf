//
//  MyInvestRecordCell.h
//  TTJF
//
//  Created by wbzhan on 2018/5/16.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseCell.h"
#import "CreditAssignHistoryModel.h"
/**
 债权转让记录
 */
@interface CreditAssignHistoryCell : BaseCell
-(void)loadInfoWithModel:(CreditAssignHistoryModel *)model;
@end
