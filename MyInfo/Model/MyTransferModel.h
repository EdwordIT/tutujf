//
//  CreditAssignHistoryModel.h
//  TTJF
//
//  Created by wbzhan on 2018/5/16.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"

@interface MyTransferModel : BaseModel
Copy NSString * tender_id  ;//  string    债权ID
Copy NSString * loan_name  ;//  string    项目名称
Copy NSString * expire_time  ;//  string    还款日期
Copy NSString * transfer_amount  ;//  string    承接价格
Copy NSString * transfer_amount_txt  ;//  string    承接价格文本
Copy NSString * transfer_amount_notes; //文本提示
Copy NSString * actual_amount_money  ;//  string    债权价值
Copy NSString * actual_amount_money_txt  ;//  string    债权价值文本
Copy NSString * amount_money_notes; //债权价值文本提示
Copy NSString * repay_amount  ;//  string    待收本息金额
Copy NSString * repay_amount_txt  ;//  string    待收本息金额文本
Copy NSString *  repay_amount_notes ;//
Copy NSString * status_name  ;//  string    状态文本
Copy NSString * status  ;//  string    状态 -1 不可转让，1 可以转让 2 转让中 3 已转让
Assign BOOL isBuy;//区分债权购买和债权转让
@end
