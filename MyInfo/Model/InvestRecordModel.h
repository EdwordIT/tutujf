//
//  InvestRecordModel.h
//  TTJF
//
//  Created by wbzhan on 2018/5/18.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"

@interface InvestRecordModel : BaseModel
Copy NSString * fee_name  ;//  string    资金操作名称
Copy NSString * add_time  ;//  string    操作时间
Copy NSString * loan_name ;//   string    标的名称
Copy NSString * balance_txt ;//   string    余额文本
Copy NSString * oper_amount_txt ;//   string    操作资金额度文本
Copy NSString * money_color ;//   string    资金颜色，blue 蓝色；red 红色；green 绿色

@end
