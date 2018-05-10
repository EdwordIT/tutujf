//
//  RechargeModel.h
//  TTJF
//
//  Created by wbzhan on 2018/4/25.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"

@interface PromptContentModel :BaseModel
Copy NSString *url;//超链接
Copy NSString *text;//超链接文本
@end
/**
 充值记录
 */
@interface RechargeModel : BaseModel
Copy NSString * amount_title ;//   string    金额标题
Copy NSString * amount  ;//    string    金额
Copy NSString * txtamount_placeholder  ;//    string    输入框提示
Copy NSString * recharge_quota_title ;//     string    快捷充值额度说明
Copy NSString * recharge_quota_url  ;//    string    快捷充值额度说明链接
Copy NSString * recharge_list_title  ;//    string    充值明细文本
Copy NSString * prompt  ;//    string    温馨提示标题
Copy NSString * prompt_content ;//     string    温馨提示内容
Copy NSArray * prompt_content_repurl;//     string    温馨提示内容超链接文字替换
Copy NSString * bt_state  ;//    string    提交按钮状态 ，-1 不可提交，1 可提交
Copy NSString * bt_name ;//     string    提交按钮文本
Copy NSString * trust_account ;//     string    托管账号是否开通， -1 未开通  1已开通（注：要先判断是否实名认证）
Copy NSString * trust_reg_url  ;//    string    汇付托管注册地址
Copy NSString *min_amount;//最低充值金额
@end
