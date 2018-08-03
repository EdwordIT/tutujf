//
//  MyRedenvelopeModel.h
//  TTJF
//
//  Created by wbzhan on 2018/5/18.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"
//
@interface MyRedenvelopeModel : BaseModel
Copy NSString * name ;//   string    红包名称
Copy NSString * amount ;//   string    红包金额
Copy NSString * type_name ;//   string    红包类型名称
Copy NSString * end_time ;//   string    有效期截止时间
Copy NSString *end_time_txt; //过期时间
Copy NSString * condition_txt ;//   string    使用条件
Copy NSString * status ;//   string    状态-4=已过期 ，-3=未开始 ，-2='失效', -1='冻结', 1='待激活',2='激活成功'
Copy NSString * status_name ;//   string    状态名称

@end
