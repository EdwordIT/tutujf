//
//  MyTransferBuyDetailModel.h
//  TTJF
//
//  Created by wbzhan on 2018/5/31.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"

@interface BuyDetailInfoModel :BaseModel
Copy NSString * title   ;// string      标题
Copy NSString * content   ;// string      内容
Copy NSString * link_url   ;// string    链接
Copy NSString *color_type;//content内容显示颜色 1常规  2标红
@end

@interface BuyDetailInfoRepayModel :BaseModel//还款情况（可能存在多期）
Strong  BuyDetailInfoModel *recover_title  ;//  array    还款信息标题
Strong NSArray * info;//列表内容
@end
@interface MyTransferBuyDetailModel : BaseModel
Copy NSString * loan_name   ;// string      项目名称
Copy NSString * status_name   ;// string      状态文本
Strong NSArray * transfer_info  ;//  array    债权信息
Strong BuyDetailInfoModel * transfer_amount ;//   model    承接价格
Strong BuyDetailInfoModel * amount_interest ;//   model    盈利金额
Strong BuyDetailInfoModel * agreement  ;//  model    协议
Strong NSArray * recover_info ;//   array    还款信息列表

@end
