//
//  SystemConfigModel.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/22.
//  Copyright © 2018年 TTJF. All rights reserved.
//Appdelegate里的系统配置页面

#import "BaseModel.h"

@interface SystemConfigModel : BaseModel
Copy NSString *v_number  ;//  string    APP版本号
Copy NSString * start_adver_imgurl  ;//   string    APP广告图地址（3 2 1倒计时）
Copy NSString * android_version  ;//   string    android 版本号
Copy NSString * android_downurl  ;//   string    android 下载地址
Copy NSString * ios_version   ;//  string    IOS 版本号
Copy NSString * ios_forceup;//    string    IOS 版本强制更更新，  0 不强制， 1 强制
Copy NSString * ios_downurl  ;//   string    IOS 下载地址
Copy NSString * register_link ;//    string    注册链接
Strong NSArray * allow_domain  ;//   string    允许访问域名，屏蔽webview 广告使用
Copy NSString * register_txt  ;//  string    注册文本
Copy NSString * cust_serv_tel  ;//   string    客服电话
Copy NSString * com_problem_link  ;//   string    常见问题连接
Copy NSString * cust_serv_time  ;//   string    客服服务时间
Copy NSString * reg_agreement_link  ;//   string    注册协议连接地址

@end
