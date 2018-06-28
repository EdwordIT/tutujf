//
//  MyBankCardModel.h
//  TTJF
//
//  Created by wbzhan on 2018/6/25.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"
#import "BankCardModel.h"
@interface RelieveRemindModel:BaseModel

Copy NSString * title ;//   string     温馨提示
Copy NSString * title_msg ;//   string     银行卡解绑请到电脑端操作
Copy NSString * relieve_msg ;//   string     查看银行卡解绑操作流程
Copy NSString * relieve_link ;//   string     操作流程连接
Copy NSString * cust_ser_title ;//   string     客服服务热线
Copy NSString * cust_ser_num ;//   string     客服号码

@end

@interface AddBankCardModel:BaseModel

Copy NSString * is_add  ;//  string    银行卡添加状态，-1 不可添加，1 可添加
Copy NSString * btaddname  ;//  string    银行卡添加按钮名称

@end

@interface PostInfoModel:BaseModel

Copy NSString * form  ;//  string    提交表单
Copy NSString * sign  ;//  string    密钥

@end

@interface MyBankCardModel : BaseModel
Copy NSString * realname_status ;//   string     实名认证状态，-1 未认证， 1已认证
Copy NSString * trust_account ;//   string     托管账号是否开通， -1 未开通  1已开通
Copy NSString * trust_reg_url ;//   string     托管开通地址
Strong NSArray * bank_list  ;//  array    银行卡列表
Strong RelieveRemindModel *relieve;//解绑提示
Strong AddBankCardModel *add_bank;//添加银行卡
Strong PostInfoModel *sumbit_data;//添加表单数据
@end
