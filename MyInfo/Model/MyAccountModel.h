//
//  MyAccountModel.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/4/2.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"

//    我的投资按钮(投资 红包 资金记录)
@interface MyCapitalModel:BaseModel
Copy NSString * title  ;//    string    标题
Copy NSString * sub_title  ;//    string    副标题
Copy NSString * link_url   ;//   string    连接
@end

@interface UserContentModel:BaseModel

Copy NSString * title  ;//    string    标题
Copy NSString * logo_url  ;//    string    logo连接
Copy NSString * link_url  ;//    string    连接
Copy NSString * width   ;//    string    按钮图片宽
Copy NSString * height   ;//    string    按钮图片高
@end

@interface MyAccountModel : BaseModel
Copy NSString * user_name   ;// string    用户名
Copy NSString * is_trust_reg  ;//   int    是否显示注册托管 ,0  去注册， 1 关闭注册
Copy NSString * trust_reg_link   ;//   string    托管注册连接
//Copy NSString * trust_reg_log  ;//    string    托管注册log地址
//Copy NSString * trust_reg_title  ;//    string    托管注册标题
//Copy NSString * trust_reg_sub_title  ;//    string    托管注册标题
//新版托管
Copy NSString *trust_reg_imgurl;//单图
Strong MyCapitalModel * bt_my_investment  ;//我的投资按钮
Strong MyCapitalModel *bt_my_red;//我的红包
Strong MyCapitalModel *bt_my_capital_log;//资金记录
Strong NSArray *bt_user_content;//会员功能列表
Copy NSString * message;//    string    站内信数量
Copy NSString * total_amount ;//    string    总资产
Copy NSString * to_interest_award ;//    string    累计收益
Copy NSString * balance_amount ;//    string    可用余额
Copy NSString * recharge_url  ;//   string    充值连接地址
Copy NSString * cash_url ;//    string    提现连接地址

@end
