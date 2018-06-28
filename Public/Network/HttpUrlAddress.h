//
//  HttpUrlAddress.h
//  TTJF
//
//  Created by 占碧光 on 2017/10/8.
//  Copyright © 2017年 占碧光. All rights reserved.
//


/**
 获取系统配置
 */
#define getSystemConfig @"/api/Platform/GetSystemConfig"
/**
 首次打开应用上送deviceToken到服务器?phone_type=&terminal_id=&terminal_name=&terminal_model=&terminal_device_token=&sign=
 */
#define sendDeviceTokenUrl  @"/api/users/bindUserEquipment"
/**
 获取风控合作接口
 */
#define getCooperationUrl  @"/api/articles/GetRiskManaCooperation"
/*****************************************~1.4.8************************************************************/
/**
 新版获取首页全部数据（土土社区，消息，快速投资，新手标?version=%@&device_id=%@&user_token=%@&sign=%@
 */
#define getHomePageInfoUrl  @"/api/Platform/GetInterface"
//获取发现页面数据
#define getDiscoverUrl  @"/api/Platform/GetFindActivity"
/**
 获取项目列表的数据接口 Get
 */
#define getLoanListUrl  @"/api/Loan/LoanList"
/*
 债权转让列表接口
 */
#define getCreditAssignListUrl  @"/api/transfer/transferList"

/**
 标的详情页面接口
 */
#define getLoanDetailUrl  @"/api/Loan/GetLoanInfoview"
/**
 债权转让详情页面接口
 */
#define getCreditAssignDetailUrl  @"/api/transfer/GetTransferView"
/**
 获取我的页面信息
 */
#define getMyUserDataUrl  @"/api/Users/getMyUserData"
/*****************************************个人投资************************************************************/
/**
 预期收益接口?amount=%@&period=%@&apr=%@&repay_type=%@&sign=%@
 */
#define getExpectInvestUrl  @"/api/Loan/InvestInterest"
/**
 立即投资接口
 */
#define tenderUrl   @"/api/Loan/TenderNow"
/**
 债权转让投资接口
 */
#define postTransferUrl @"/api/transfer/buyTransfer"
/**
 充值界面信息
 */
#define getRechargeInfoUrl @"/api/recharge/getRecharge"
/**
 发起充值接口
 */
#define postRechargeUrl @"/api/recharge/rechargeSubmit"
/**
 充值记录
 */
#define getRechargeRecordUrl @"/api/recharge/getRechargeLog"
/**
 提现界面信息
 */
#define getCashInfoUrl @"/api/cash/getCash"
/**
 发起提现接口
 */
#define postCashUrl @"/api/cash/cashSubmit"
/**
 提现记录
 */
#define getCashRecordUrl @"/api/cash/getCashLog"
/**
 即时到账提现手续费接口
 */
#define getCashFeeAmtUrl @"/api/cash/cashFeeAmt"
/*****************************************我的************************************************************/
//登录接口
#define loginUrl  @"/api/Users/Login"
/**
 会员在项目中登录之后，需要在web中调用一次登录接口，使web上的会员同时处于登录状态
 1、此链接不是接口，是web访问地址
 2、equipment不加入sign验签
 */
#define loginWebUrl @"%@/wap/system/login2?user_name=%@&user_token=%@&sign=%@&equipment=ios"
//获取我的账户信息相关接口
#define getMyAccountUrl  @"/api/Users/getMyAccountData"
/**
 获取短信验证码
 type:reg  注册验证码  resetpwd忘记密码验证码
 phone=%@&type=%@&time_stamp=%@&sign=%@
 */
#define getMessageCodeUrl  @"/api/users/sendSmscode"
/**会员注册
 referrer：推荐人识别码
 phone=%@&password=%@&sms_code=%@&referrer=%@&sign=%@
 */
#define registerUrl  @"/api/users/Register"
/**
 找回密码
 api/users/phoneGetPwd?phone=%@&password=%@&sms_code=%@&sign=%@
 */
#define forgetPasswordUrl  @"/api/users/phoneGetPwd"

/**
 修改密码
 user_token=%@&password=%@&new_password=%@&sign=e6e7a78f8fc324e6
 */
#define changePasswordUrl  @"/api/users/editPwd"
/**
 获取实名认证页面内容token
 */
#define getRealnameInfoUrl  @"/api/users/getUserRealname"
/**
 进行实名认证接口
 */
#define postCertificationUrl  @"/api/users/editUserRealname"
/**
 获取站内信列表
 */
#define getUserMessageUrl @"/api/users/getUserMessage"
/**
 一键标记为已读
 */
#define postMarkedAsReadedUrl  @"/api/users/batchDelUserMessage"
/**
 我的投资页面接口
 */
#define getMyInvestUrl @"/api/tender/myTenderData"
/**
 我的投资详情接口
 */
#define myInvestDetailUrl @"/api/tender/myTenderInfo"
/**
 我的红包接口
 */
#define myRedEnvelopeUrl @"/api/bounty/myBountyList"
/**
 资金列表接口
 */
#define myAccountLogUrl @"/api/account/myAccountLog"
/**
 我的债权转让列表接口
 */
#define myTransferListUrl @"/api/transfer/myusertransferlist"
/**
 我的债权转让详情接口
 */
#define myTransferInfoUrl @"/api/transfer/myUserTransferInfo"
/**
 我购买的债权列表接口
 */
#define myTransferBuyUrl @"/api/transfer/myUserTransferBuyList"
/**
 我的债权购买详情接口
 */
#define myTransferBuyDetailUrl @"/api/transfer/myUserTransferBuyInfo"
/**
 债权转让提交接口
 */
#define postMyTransferSubmitUrl @"/api/transfer/myUserTransferSubmit"
/**
 债权转让撤销接口
 */
#define cancelMyTransferUrl @"/api/transfer/myUserTransferCancel"
/**
 获取会员总资产
 */
#define getMyTotalAmountUrl @"/api/Users/getUserToAssets"
/**
 获取会员总收益
 */
#define getMyTotalIncomeUrl @"/api/Users/getUserToProfit"

/*****************************************图片或者大文件上传************************************************************/
#define uploadImagesUrl @"/api/Uploads/fileFlow"
/**
 意见反馈
 */
#define postSuggestUrl @"/api/Feedback/addFeedback"
/**
 银行卡列表
 */
#define getBankCardListUrl @"/api/Bank/getBankIndex"
/**
 解绑银行卡
 */
#define relieveBankCardUrl @"/api/Bank/relieveBank"
/**
我的托管账户
 */
#define getMyRegAccountUrl @"/api/Trust/relieveBank"


