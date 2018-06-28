//
//  MyRegAccountModel.h
//  TTJF
//
//  Created by wbzhan on 2018/6/25.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"
@interface RegAccountInfoModel : BaseModel

Copy NSString * trust_account;//   string     托管号
Copy NSString * trust_account_txt;//   string     托管号文本
Copy NSString * balance;//   string     帐号总额
Copy NSString * balance_txt;//   string     帐号总额文本
Copy NSString * availableamount;//   string     可用余额
Copy NSString * availableamount_txt;//   string     可用余额文本
Copy NSString * freezeamount;//   string     冻结金额
Copy NSString * freezeamount_txt;//   string     冻结金额文本
Copy NSString * trust_usename;//   string     汇付托管账户
Copy NSString * trust_usename_txt;//   string     汇付托管账户文本
@end
@interface MyRegAccountModel : BaseModel
Copy NSString * realname_status;//   string     实名认证状态，-1 未认证， 1已认证
Copy NSString * trust_account;//   string     托管账号是否开通， -1 未开通  1已开通
Copy NSString * trust_reg_url;//   string     托管开通地址
Strong RegAccountInfoModel * trust_account_info ;//      支付帐号信息

@end
