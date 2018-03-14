//
//  QuicklyModel.h
//  TTJF
//
//  Created by 占碧光 on 2017/3/12.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuicklyModel : NSObject

@property(nonatomic, strong) NSString *nrid;

@property(nonatomic, strong) NSString *loanid;
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

@property(nonatomic, strong) NSString *open_up_status;
@property(nonatomic, strong) NSString *open_up_date;


@end
