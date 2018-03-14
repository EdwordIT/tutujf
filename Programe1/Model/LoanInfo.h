//
//  LoanInfo.h
//  TTJF
//
//  Created by 占碧光 on 2017/12/15.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoanInfo : NSObject

@property(nonatomic, strong) NSString    * id;
@property(nonatomic, strong) NSString  *  ind; //借款识别码
@property(nonatomic, strong) NSString  *  serialno; //借款序号
@property(nonatomic, strong) NSString  *  name; //借款标题

@property(nonatomic, strong) NSString  *  amount; //借款金额
@property(nonatomic, strong) NSString  *  credited_amount; //已借到金额
@property(nonatomic, strong) NSString  *  apr; //年利率

@property(nonatomic, strong) NSString  *  additional_status; //1 是新手标 ，其他普通标
@property(nonatomic, strong) NSString  *  activity_url_img; //活动标识图片
@property(nonatomic, strong) NSString  *  activity_img_width; //活动标识图片宽

@property(nonatomic, strong) NSString  *  type_period_name; //项目期限标题
@property(nonatomic, strong) NSString  *  period; //项目期限，计算利息用
@property(nonatomic, strong) NSString  *  period_name; //项目期限正文

@property(nonatomic, strong) NSString  *  progress; //借款完成度百分比
@property(nonatomic, strong) NSString  *  left_amount; //剩余可投金额
@property(nonatomic, strong) NSString  *  select_type_img; //支持可查询种类图片

@property(nonatomic, strong) NSString  *  select_type_img_width; //支持可查询种类图片宽
@property(nonatomic, strong) NSString  *  select_type_img_height; //支持可查询种类图片高
@property(nonatomic, strong) NSString  *  tender_amount_min; //借款最小金额

@property(nonatomic, strong) NSString  *  status_name; //借款状态名称
@property(nonatomic, strong) NSString  *  overdue_time_date; //借款截止日期，需要倒计时功能
@property(nonatomic, strong) NSString  *  contents_url; //借款项目详情信息地址

@property(nonatomic, strong) NSString  *  tender_count; //已有多少位投资人
@property(nonatomic, strong) NSString  *  buy_state; //购买状态， -1 不可购买， 1 可购买
@property(nonatomic, strong) NSString  *  buy_name; //购买按钮文字

@property(nonatomic, strong) NSString  *  open_up_date; //开放购买时间
@property(nonatomic, strong) NSString  *  open_up_status; //状态：-1 可购买， 1 不可购买
@property(nonatomic, strong) NSString  *  password_status; //借款密码， -1 代表没密码，  1 代表有密码

@end
