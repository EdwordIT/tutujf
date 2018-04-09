//
//  ProgrameNewDetailController.h
//  TTJF
//
//  Created by 占碧光 on 2017/12/13.
//  Copyright © 2017年 占碧光. All rights reserved.
//项目详情页面

#import "BaseViewController.h"


@interface ProgrameNewDetailController : BaseViewController

@property(nonatomic, strong)     NSString * loan_id;
@property(nonatomic, strong) NSString  *  user_token;
 /* 1  未登录，老标  2 未登录，可抢 3 未登录，新手标   4 已登录，新手标 5   已登录，普通标  6 已登录，普通标，不可购买本人借款标  7 已登录，密码标  8 已登录，未开始
  */

@end
