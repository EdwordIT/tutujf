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

//获取项目列表的数据接口 Get
#define loanList @"%@/api/Loan/LoanList?page=%ld&sign=%@"

#define loginUrl @"%@/api/Users/Login?user_name=%@&password=%@&terminal_type=%@&terminal_id=%@&terminal_name=%@&terminal_model=%@&terminal_token=%@&sign=%@"
//会员在项目中登录之后，需要在web中调用一次登录接口，使web上的会员同时处于登录状态
#define webLoginUrl @"%@/wap/system/login2?user_name=%@&user_token=%@&sign=%@"

#define getMyUserData @"%@/api/Users/getMyUserData?user_token=%@&sign=%@"

#define getMyAccountData @"%@/api/Users/getMyAccountData?user_token=%@&sign=%@"

#define getFindActivity @"%@/api/Platform/GetFindActivity?user_token=%@&sign=%@"

#define getSystemConfig @"%@/api/Platform/GetSystemConfig?v_number=%@"

//未登录，老标
#define getLoanInfoview1 @"%@/api/Loan/GetLoanInfoview?loan_id=%@&user_token=%@&sign=%@"

//未登录，可抢
#define getLoanInfoview2 @"%@/api/Loan/GetLoanInfoview?loan_id=%@&user_token=%@&sign=%@"

//未登录，新手标
#define getLoanInfoview3 @"%@/api/Loan/GetLoanInfoview?loan_id=%@&user_token=%@&sign=%@"

//已登录，新手标
#define getLoanInfoview4 @"%@/api/Loan/GetLoanInfoview?loan_id=%@&user_token=%@&sign=%@"

//已登录，普通标
#define getLoanInfoview5 @"%@/api/Loan/GetLoanInfoview?loan_id=%@&user_token=%@&sign=%@"

//已登录，普通标，不可购买本人借款标
#define getLoanInfoview6 @"%@/api/Loan/GetLoanInfoview?loan_id=%@&user_token=%@&sign=%@"

//已登录，密码标
#define getLoanInfoview7 @"%@/api/Loan/GetLoanInfoview?loan_id=%@&user_token=%@&sign=%@"

//已登录，未开始
#define getLoanInfoview8 @"%@/api/Loan/GetLoanInfoview?loan_id=%@&user_token=%@&sign=%@"

#define investInterest @"%@/api/Loan/InvestInterest?amount=%@&period=%@&apr=%@&repay_type=%@&sign=%@"

#define tenderNow  @"%@/api/Loan/TenderNow?loan_id=%@&amount=%@&loan_password=%@&user_token=%@&sign=%@"

//#define webLoginUrl  @"%@/User/Token/Login?user_token=%@&expiration_date=%@&sign=%@"



