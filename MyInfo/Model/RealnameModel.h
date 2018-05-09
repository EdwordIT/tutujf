//
//  RealnameModel.h
//  TTJF
//
//  Created by wbzhan on 2018/5/8.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"

@interface RealnameModel : BaseModel

Copy NSString * top_title;// "根据国家监管要求，土土金服已接入汇付资金托管系统。用户实名认证，绑定银行卡，投资，充值，提现，转让前需开通汇付托管账户",
Copy NSString * bottom_title;// "点击“下一步”后，你将跳转到<汇付资金托管系统>进行托管账户的开通。",
Copy NSString * realname_status;// "-1",
Copy NSString * is_trust_reg;// "-1",
Copy NSString * trust_reg_url;// "https://cs.www.tutujf.com/wap/member/verifyTrustReg?appatc=jump"
@end
