//
//  MyRedEnvelopeCell.h
//  TTJF
//
//  Created by wbzhan on 2018/5/17.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseCell.h"
#import "MyRedenvelopeModel.h"
typedef void (^InvestBlock)(void);
/**
 我的红包
 */
@interface MyRedEnvelopeCell : BaseCell
Copy InvestBlock investBlock;
-(void)loadInfoWithModel:(MyRedenvelopeModel *)model;
@end
