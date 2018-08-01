//
//  CreditAssignDetailController.h
//  TTJF
//
//  Created by wbzhan on 2018/4/26.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseViewController.h"
#import "LoanBase.h"
/**
 债权转让详情
 */
@interface CreditAssignDetailController : BaseViewController
Copy NSString *transfer_id;//转让标的id
Strong LoanBase *baseModel;
@end
