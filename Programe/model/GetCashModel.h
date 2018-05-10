//
//  GetCashModel.h
//  TTJF
//
//  Created by wbzhan on 2018/5/10.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"

/**
 提现页面数据
 */
@interface GetCashModel : BaseModel
Copy NSString * amount_title ;//   string    金额标题
Copy NSString * amount  ;//   string    可提现金额
Copy NSString * min_amount  ;//   string    最低充值金额
Copy NSString * txtamount_placeholder  ;//   string    输入框提示
Copy NSString * left_msg   ;//  string    输入框左下边提示
Copy NSString * cash_list_title  ;//   string    充值明细
Copy NSString * prompt   ;//  string    温馨提示
Copy NSString * prompt_content  ;//   string    温馨提示内容
Copy NSString * trust_account  ;//   string    托管账号是否开通， -1 未开通  1已开通
Copy NSString * trust_reg_url  ;//   string    托管开通地址
Copy NSString * bt_state    ;// string    提交按钮状态 ，-1 不可提交，1 可提交
Copy NSString * bt_name   ;//  string    提交按钮文本
Copy NSString * is_bind_bank   ;//  string    是否绑定银行卡，-1 未绑定，1已绑定
Copy NSString * bind_bank_txt   ;//  string    绑定银行卡文本
Copy NSString * bind_bank_url   ;//  string    银行卡绑定连接

@end
