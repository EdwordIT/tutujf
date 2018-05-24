//
//  CreditInfoModel.h
//  TTJF
//
//  Created by wbzhan on 2018/5/8.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"

@interface CreditInfoModel : BaseModel

Copy NSString * actual_amount   ; //  string    承接价格
Copy NSString * actual_amount_notes   ; //  string    承接价格 ? 注解
Copy NSString * period   ; //  string    转让期数
Copy NSString * total_period   ; //  string    总期数
Copy NSString * expire_date   ; //  string    剩余天数
Copy NSString * expire_date_txt   ; //  string    剩余天数

Copy NSString * next_repay_time   ; //  string    还款期限
Copy NSString * buy_state   ; //  string    购买状态， -1 不可购买， 1 可购买
Copy NSString * buy_name   ; //  string    购买按钮文字
Copy NSString * amount_money   ; //  string    债权价值
Copy NSString * amount_money_notes   ; //  string    债权价值 ? 注解
Copy NSString * wait_prin_inte   ; //  string    待收本息
Copy NSString * wait_prin_intenotes   ; //  string    待收本息? 注解


@end
