//
//  Environment.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/20.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#ifndef Environment_h
#define Environment_h

//#define App_Environment 2 //1.正式环境 2.测试环境
//webView页面跳转域名校验
#define urlCheckAddress @"tutujf.com"
//#if(App_Environment==1)
#ifdef DEBUG//正式环境
//app接口域名
#define oyApiUrl            @"https://api.tutujf.com"
//图片前置地址
#define oyImageBigUrl       @"https://www.tutujf.com"
//webView相关前置地址
#define oyUrlAddress        @"https://www.tutujf.com"
//webView的cookie值添加domin
#define dominUrl @"www.tutujf.com"
//系统加密所需要的系统token
#define systemToken @"!Y9v9OK41w(2"

//#elif(App_Environment==2)//测试环境
#elif TTJF_DEV//开发测试环境
//app接口域名
#define oyApiUrl             @"https://cs.api.tutujf.com"
//图片前置地址
#define oyImageBigUrl        @"https://cs.www.tutujf.com"
//webView相关前置地址
#define oyUrlAddress       @"https://cs.www.tutujf.com"
//webView的cookie值添加domin
#define dominUrl @"cs.www.tutujf.com"
//系统加密所需要的系统token
#define systemToken @"O1v!6Ikl(2w83"
#else
#endif

#endif /* Environment_h */
