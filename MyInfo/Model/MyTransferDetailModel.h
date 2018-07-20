//
//  MyTransferDetailModel.h
//  TTJF
//
//  Created by wbzhan on 2018/5/30.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"
@interface ContentInfoModel:BaseModel
Copy NSString * title;//标题
Copy NSString *content;//内容
Copy NSString *notes;//注解
@end

@interface coefficientModel:BaseModel
Copy NSString * title   ;// string    标题
Copy NSString * coefficient_min   ;//  float    最小转让折扣：95.99
Copy NSString * coefficient_max   ;//  float    最大转让折扣：99.99
@end
@interface MyTransferDetailModel : BaseModel
Copy NSString *actual_amount_money;//债权价值
Copy NSString * status_name  ;//  string    状态文本
Copy NSString * transfer_id   ;// string    债权ID
Copy NSString * loan_name   ;// string    债权名称
Strong NSArray * transfer   ;//  Array    列表数据
Copy NSString * coefficient   ;// string    转让折扣
Strong coefficientModel * coefficient_config  ;//   model    转让折扣输入框配置

Strong ContentInfoModel * transfer_amount   ;//  array    承接价格信息

Copy NSString * bt_state  ;//  int    提交按钮状态 ，-1 不可提交，1 可提交， 2 撤销转让

Copy NSString * bt_name   ;// string    按钮文字

Strong ContentInfoModel *reminder_msg;//温馨提示内容


@end
