//
//  BankCardRemindView.h
//  TTJF
//
//  Created by wbzhan on 2018/6/12.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseView.h"
#import "MyBankCardModel.h"
typedef void (^BankCardRemindBlock)(NSInteger tag);
/**
 银行解绑温馨提示
 */
@interface BankCardRemindView : BaseView
Copy BankCardRemindBlock remindBlock;
-(void)loadInfoWithModel:(RelieveRemindModel *)model;
@end
