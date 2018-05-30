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
Copy NSString *link_url;//链接
Copy NSString *color;//content颜色
@end
@interface MyTransferDetailModel : BaseModel
Copy NSString * loan_name ;//   string    项目名称
Copy NSString * status_name  ;//  string    状态文本
Strong ContentInfoModel * transfer_info  ;//  array    债权信息

@end
