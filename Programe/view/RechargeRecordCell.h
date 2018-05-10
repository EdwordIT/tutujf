//
//  RechargeRecordCell.h
//  TTJF
//
//  Created by wbzhan on 2018/4/25.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseCell.h"
#import "RechargeListModel.h"
/**
 充值记录、提现记录
 */
@interface RechargeRecordCell : BaseCell
-(void)loadInfoWithModel:(RechargeListModel *)model;
@end
