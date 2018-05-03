//
//  HttpUrlAddress.h
//  TTJF
//
//  Created by 占碧光 on 2017/10/8.
//  Copyright © 2017年 占碧光. All rights reserved.
//

/*************||首页信息相关接口||*************/

//获取快速投资标的数据接口 Get
#define  loanTopList @"%@/api/Loan/LoanTopList?top=%@&sign=%@"
//获取新手标的数据接口 Get
#define  noviceLoanInfo @"%@/api/Loan/NoviceLoanInfo"
//获取首页广告图片数据接口  Get
#define  getAdvert @"%@/api/Advert/GetAdvert?user_token=%@&sign=%@"
//获取首页界面数据  Get
#define getInterface @"%@/api/Platform/GetInterface"
//获取网站公告数据  Get
#define getArticlesNotice @"%@/api/Articles/GetArticlesNotice?top=%@&sign=%@"


/**
 会员在项目中登录之后，需要在web中调用一次登录接口，使web上的会员同时处于登录状态
 1、此链接不是接口，是web访问地址
 2、equipment不加入sign验签
 */
#define webLoginUrl @"%@/wap/system/login2?user_name=%@&user_token=%@&sign=%@&equipment=%@"



#define getSystemConfig @"%@/api/Platform/GetSystemConfig"

//未登录，老标
#define getLoanInfoview1 @"%@/api/Loan/GetLoanInfoview?loan_id=%@&user_token=%@&sign=%@"

#define investInterest @"%@/api/Loan/InvestInterest?amount=%@&period=%@&apr=%@&repay_type=%@&sign=%@"



//#define webLoginUrl  @"%@/User/Token/Login?user_token=%@&expiration_date=%@&sign=%@"
/*****************************************~1.4.8************************************************************/
/**
 立即投资接口
 ?loan_id=%@&amount=%@&loan_password=%@&user_token=%@&sign=%@
 */
#define tenderUrl  oyApiUrl@"/api/Loan/TenderNow"
//登录接口
#define loginUrl oyApiUrl@"/api/Users/Login"
//获取我的账户信息相关接口
#define getMyAccountUrl oyApiUrl@"/api/Users/getMyAccountData"
//获取发现页面数据
#define getDiscoverUrl oyApiUrl@"/api/Platform/GetFindActivity"
//获取项目列表的数据接口 Get
//?page=%ld&sign=%@
#define getLoanListUrl oyApiUrl@"/api/Loan/LoanList"
/**
 标的详情页面接口
 */
#define getLoanDetailUrl oyApiUrl@"/api/Loan/GetLoanInfoview"
/**
 投资接口 ?amount=%@&period=%@&apr=%@&repay_type=%@&sign=%@
 */
#define investUrl oyApiUrl@"/api/Loan/InvestInterest"
/**
 新版获取首页全部数据（土土社区，消息，快速投资，新手标
 ?version=%@&device_id=%@&user_token=%@&sign=%@
 */
#define getHomePageInfoUrl oyApiUrl@"/api/Platform/GetInterface"
//首次打开应用上送deviceToken到服务器
/**
 phone_type=&terminal_id=&terminal_name=&terminal_model=&terminal_device_token=&sign=
 */
#define sendDeviceTokenUrl oyApiUrl@"/api/users/bindUserEquipment"
/**获取短信验证码
 type:reg  注册验证码  resetpwd忘记密码验证码
 phone=%@&type=%@&time_stamp=%@&sign=%@
 */
#define getMessageCodeUrl oyApiUrl@"/api/users/sendSmscode"
/**会员注册
 referrer：推荐人识别码
 phone=%@&password=%@&sms_code=%@&referrer=%@&sign=%@
 */
#define registerUrl oyApiUrl@"/api/users/Register"
/**
 找回密码
 api/users/phoneGetPwd?phone=%@&password=%@&sms_code=%@&sign=%@
 */
#define forgetPasswordUrl oyApiUrl@"/api/users/phoneGetPwd"

/**
 修改密码
 user_token=%@&password=%@&new_password=%@&sign=e6e7a78f8fc324e6
 */
#define changePasswordUrl oyApiUrl@"/api/users/editPwd"
/**
 获取我的页面信息
*/
#define getMyUserDataUrl oyApiUrl@"/api/Users/getMyUserData"
/**
 获取风控合作接口
 */
#define getCooperationUrl oyApiUrl@"/api/articles/GetRiskManaCooperation"


