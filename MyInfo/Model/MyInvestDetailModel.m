//
//  MyInvestDetailModel.m
//  TTJF
//
//  Created by wbzhan on 2018/5/22.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyInvestDetailModel.h"

@implementation MyInvestInfoModel

@end

@implementation ReplyItemModel

@end
@implementation MyInvestDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"loan_info":[MyInvestInfoModel class],
             @"repay_items":[ReplyItemModel class]
             };
}
@end
