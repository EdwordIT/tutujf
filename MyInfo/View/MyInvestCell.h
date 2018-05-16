//
//  MyInvestCell.h
//  TTJF
//
//  Created by wbzhan on 2018/5/15.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseCell.h"
#import "MyInvestModel.h"
/**
 我的投资
 */
@interface MyInvestCell : BaseCell

-(void)loadInfoWithModel:(MyInvestModel *)model;
@end
