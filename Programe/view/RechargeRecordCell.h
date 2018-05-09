//
//  RechargeRecordCell.h
//  TTJF
//
//  Created by wbzhan on 2018/4/25.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeListModel.h"
/**
 投资记录
 */
@interface RechargeRecordCell : UITableViewCell
-(void)loadInfoWithModel:(RechargeListModel *)model;
@end
