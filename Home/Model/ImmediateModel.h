//
//  ImmediateModel.h
//  TTJF
//
//  Created by 占碧光 on 2017/3/12. 新手标数据结构
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImmediateModel : NSObject
@property(nonatomic, strong) NSString *loan_id;//标的id

@property(nonatomic, strong) NSString *additional_status; //数据状态：1 有数据， 0没数据（没数据时下面的参数都没）
@property(nonatomic, strong) NSString *activity_url_img;//名称旁边的标识图片
@property(nonatomic, strong) NSString *apr_val; //预期利率
@property(nonatomic, strong) NSString *apr_txt; //预期利率文本

@property(nonatomic, strong) NSString * period;//借款期限
@property(nonatomic, strong) NSString * period_txt;//借款期限文本

@property(nonatomic, strong) NSString *tender_amount_min_val;//最小投资金额
@property(nonatomic, strong) NSString *tender_amount_min_txt;//起投金额文本

@end
