//
//  LoanBase.h
//  TTJF
//
//  Created by 占碧光 on 2017/12/15.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "BaseModel.h"
#import "LoanInfo.h"
#import "LoanBase.h"
#import "TenderModel.h"
#import "ProductDetailModel.h"
#import "SecurityModel.h"
#import "RepayModel.h"
@interface LoanBase : BaseModel
@property(nonatomic, strong)    NSString * loan_id;
@property(nonatomic, strong) LoanInfo  *  loan_info; //产品相关信息
Strong ProductDetailModel *loan_details;//产品详情介绍
@property(nonatomic, strong) NSString  *  repay_type_name; //还款方式
@property(nonatomic, strong) NSArray  *  security_audit; //"风险备付金计划"、"严格的风控流程"、"投资人监督委员会监督"
@property(nonatomic, strong) TenderModel  *  tender_list; //投资人列表
@property(nonatomic, strong) RepayModel  *  repay_plan; //还款信息
@property(nonatomic, strong) NSString  *  islogin; // 登录状态， -1 未登录 1 登录
@property(nonatomic, strong) NSString  *  trust_account; // 托管账号是否开通， -1 未开通  1已开通
@property(nonatomic, strong) NSString  *  recharge_url; // 充值地址
@property(nonatomic, strong) NSString  *  balance_amount; //账号余额
@property(nonatomic, strong) NSString  *  trust_reg_url;  //  汇付注册地址
@end
