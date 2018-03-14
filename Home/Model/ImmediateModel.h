//
//  ImmediateModel.h
//  TTJF
//
//  Created by 占碧光 on 2017/3/12. 新手标数据结构
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImmediateModel : NSObject
@property(nonatomic, strong) NSString *loanid;
@property(nonatomic, strong) NSString *link_url; //链接地址

@property(nonatomic, strong) NSString *bt_link_url;

@property(nonatomic, strong) NSString *additional_status; //数据状态：1 有数据， 0没数据（没数据时下面的参数都没）
@property(nonatomic, strong) NSString *activity_url_img;//名称旁边的标识图片
@property(nonatomic, strong) NSString *apr; //年利率
@property(nonatomic, strong) NSString *additional_apr; //附加年利率，要判断，当additional_apr>0时显示，13.2% + 1.2% (这是文本)

@property(nonatomic, strong) NSString * period;//借款期限

@property(nonatomic, strong) NSString *tender_amount_min;//最小投资金额

@end
