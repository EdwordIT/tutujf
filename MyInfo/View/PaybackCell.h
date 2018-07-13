//
//  PaybackCell.h
//  TTJF
//
//  Created by wbzhan on 2018/7/7.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseCell.h"
#import "PaybackModel.h"
/**
 回款计划cell
 */
@interface PaybackCell : BaseCell

-(void)loadInfoWithModel:(PaybackModel *)model;

@end
