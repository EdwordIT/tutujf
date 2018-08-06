//
//  TotolAmountCell.h
//  TTJF
//
//  Created by wbzhan on 2018/8/4.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseCell.h"
#import "HomepageModel.h"
/**
    总收益
 */
@interface TotolAmountCell : BaseCell
-(void)loadInfoWithModel:(HomepageModel *)model;
//金额变动
-(void)countTradeNum;
@end
