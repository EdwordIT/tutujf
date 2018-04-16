//
//  RepayModel.h
//  TTJF
//
//  Created by 占碧光 on 2017/12/15.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "BaseModel.h"

@interface RepayDetailModel :BaseModel

@property(nonatomic, strong) NSString *total; //还款金额
@property(nonatomic, strong) NSString *type_name; //类型名称
@property(nonatomic, strong) NSString *repay_date; //时间
@property(nonatomic, strong) NSString *repay_type_name; //状态名称

@end

@interface RepayModel : BaseModel

@property(nonatomic, strong) NSArray *items;//还款数据列表
@property(nonatomic, strong) NSString *display; //还款计划显示， 2 显示  ，其他不显示
@end
