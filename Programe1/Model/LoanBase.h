//
//  LoanBase.h
//  TTJF
//
//  Created by 占碧光 on 2017/12/15.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoanInfo.h"
#import "LoanBase.h"
#import "TenderModel.h"


@interface LoanBase : NSObject
@property(nonatomic, strong)    NSString * loan_id;
@property(nonatomic, strong) NSString  *  user_token; //
@property(nonatomic, strong) LoanInfo  *  loan_info; //
@property(nonatomic, strong) NSString  *  repay_type_name; //还款方式
@property(nonatomic, strong) NSMutableArray  *  security_audit; //
@property(nonatomic, strong) TenderModel  *  tender_list; //投资人列表
@property(nonatomic, strong) NSMutableArray  *  repay_plan; //还款信息
@property(nonatomic, strong) NSString  *  islogin; // 登录状态， -1 未登录 1 登录
@property(nonatomic, strong) NSString  *  trust_account; // 托管账号是否开通， -1 未开通  1已开通
@property(nonatomic, strong) NSString  *  recharge_url; // 充值地址
@property(nonatomic, strong) NSString  *  balance_amount; //账号余额
@property(nonatomic, strong) NSString  *  trust_reg_url;  //  汇付注册地址
@end
