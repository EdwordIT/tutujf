//
//  AccountModel.h
//  TTJF
//
//  Created by 占碧光 on 2017/10/31.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "BaseModel.h"
#import "AccountRealname.h"
#import "AccountPhone.h"

@interface AccountModel : BaseModel
@property (nonatomic, copy) NSString   *user_name;
@property (nonatomic, copy) NSString   *exit_link;
Strong NSString *my_bank_url;//我的银行卡页面
Strong NSString *my_bank_statusname;//是否已经绑定银行卡
Strong NSString *qr_code_url;//我的二维码页面链接
Strong AccountRealname *is_realname;//是否实名的字典
Strong AccountPhone *is_phone;//是否绑定手机

@end
