//
//  MyIncomeModel.m
//  TTJF
//
//  Created by wbzhan on 2018/6/1.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyIncomeModel.h"

@implementation InfoContentModel

@end
@implementation MyIncomeModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"amount_info":[InfoContentModel class],
             @"profit_amount_info":[InfoContentModel class]
             };
    
}
@end
