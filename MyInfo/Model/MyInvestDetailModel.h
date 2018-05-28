//
//  MyInvestDetailModel.h
//  TTJF
//
//  Created by wbzhan on 2018/5/22.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"


@interface MyInvestInfoModel:BaseModel
Copy NSString * title ;//   string    标题
Copy NSString * content ;//   string    内容
@end

@interface ReplyItemModel:BaseModel
Copy NSString * recover_time ;//   string    回款时间
Copy NSString * principal_yes ;//   string    回款本金
Copy NSString * interest_yes ;//   string    收益
Copy NSString * status_name ;//   string    状态名称
Copy NSString * status ;//   string    状态名称 //投资中=tzz；已回款=yhk；投资失败=tzsb；回购中=hgz；已回购=yhg；回款中=hkz

@end


@interface MyInvestDetailModel : BaseModel
Copy NSString * loan_id  ;//  string    项目ID
Copy NSString * loan_name ;//   string    项目名称
Strong NSArray * loan_info ;//   Array    项目信息
Copy NSString * repay_title ;//   string    回款计划标题
Strong NSArray * repay_items ;//   Array    回款数据
Copy NSString *repay_not_msg;//无回款计划时候的提示语


@end
