//
//  MyIncomeModel.h
//  TTJF
//
//  Created by wbzhan on 2018/6/1.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"
@interface InfoContentModel : BaseModel
Copy NSString * title ;//   string    标题
Copy NSString * amount  ;//  string    金额
Copy NSString *color;
Copy NSString *proportion;//百分比

@end
/**
 总资产、总收益
 */
@interface MyIncomeModel : BaseModel
Copy NSString * total_amount  ;//  string    总资产
Copy NSString * total_amount_txt ;//   string    总资产文本
Copy NSString * total_profit_amount;//总收益
Copy NSString * total_profit_amount_txt;//总收益文本
Strong NSArray * amount_info ;//   array    资金信息
Strong NSArray * profit_amount_info ;//   array    收益信息


@end
