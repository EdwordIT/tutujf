//
//  BankCardModel.h
//  TTJF
//
//  Created by wbzhan on 2018/6/12.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"
/**
 银行卡
 */
@interface BankCardModel : BaseModel

Copy NSString * bank_logo ;//   string    银行卡logo
Copy NSString * bank_name ;//   string    银行名称
Copy NSString * relieve_type ;//   string    解绑类型：1--是快捷充值卡（解绑走提示） 2 ，提现卡（解绑走接口） 3，不可解绑
Copy NSString * relieve_txt ;//   string    解绑按钮文字
Copy NSString * express_flag_txt ;//   string    银行卡类型文字
Copy NSString * show_card_id ;//   string    显示用的银行卡号
Copy NSString * card_id ;//   string    解绑用的银行卡号

@end
