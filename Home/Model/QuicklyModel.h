//
//  QuicklyModel.h
//  TTJF
//
//  Created by 占碧光 on 2017/3/12.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "BaseModel.h"
typedef NS_ENUM (NSInteger,LoanStatus){
    LoanStatusBuy =3,//可购买
    LoanStatusFull = 4,//满标待审
    LoanStatusRepay = 6,//还款中
    LoanStatusPayed = 7//已还完
};
@interface QuicklyModel : BaseModel

@property(nonatomic, strong) NSString *nrid;

@property(nonatomic, strong) NSString *loan_id;
@property(nonatomic, strong) NSString *link_url;//链接地址
@property(nonatomic, strong) NSString *bt_link_url;//抢购地址


@property(nonatomic, strong) NSString *name; //名称
@property(nonatomic, strong) NSString *activity_url_img;//名称旁边的标识图片
@property(nonatomic, strong) NSString *apr; //年利率
@property(nonatomic, strong) NSString *additional_apr; //附加年利率，要判断，当additional_apr>0时显示，13.2% + 1.2% (这是文本)

@property(nonatomic, strong) NSString * period;//理财期限

@property(nonatomic, strong) NSString *progress;//进度条  %
@property(nonatomic, strong) NSString *amount; //金额
@property(nonatomic, strong) NSString *repay_type_name; //还款方式
@property(nonatomic, strong) NSString *status_name; //状态名称
@property(nonatomic, strong) NSString *status; //状态，3 可以购买， 其他 不可购买

@property(nonatomic, strong) NSString *activity_url_img_height;

@property(nonatomic, strong) NSString *activity_img_width;

@property(nonatomic, strong) NSString *open_up_status;//开放购买状态：-1 可购买，显示进度条  1 不可购买 显示倒计时
@property(nonatomic, strong) NSString *open_up_date;//开放购买时间


@end
