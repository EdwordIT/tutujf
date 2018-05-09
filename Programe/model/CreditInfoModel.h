//
//  CreditInfoModel.h
//  TTJF
//
//  Created by wbzhan on 2018/5/8.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"

@interface CreditInfoModel : BaseModel

Copy NSString * actual_amount  ;//  string    转让金额
Copy NSString * period   ;//  string    转让期数
Copy NSString * total_period  ;//   string    总期数
Copy NSString * next_repay_time ;//    string    还款期限
Copy NSString * buy_state  ;//   string    购买状态， -1 不可购买， 1 可购买
Copy NSString * buy_name   ;//  string    购买按钮文字
Copy NSString * wait_principal   ;//  string    待收本金
Copy NSString * wait_interest  ;//   string    待收利息
Copy NSString * amount_money  ;//   string    债权价值

@end
