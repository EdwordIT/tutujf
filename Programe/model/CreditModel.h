//
//  CreditModel.h
//  TTJF
//
//  Created by wbzhan on 2018/4/26.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"
/**
 债权转让(列表数据)
 */
@interface CreditModel : BaseModel
Copy NSString * transfer_id;// "48",id
Copy NSString * loan_name;// "测试债权转让A-03",
Copy NSString * apr;// "13.20%",
Copy NSString * apr_txt;// "预期利率",
Copy NSString * expire_date;// "1/1",
Copy NSString * expire_date_txt;// "转让期数",
Copy NSString * actual_amount;// "20220.00",转让金额
Copy NSString * status;// "1",1可购买 其他不可购买
Copy NSString * status_name;// "购买债权"
@end
