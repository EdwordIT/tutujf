//
//  MyTransferBuyDetailModel.m
//  TTJF
//
//  Created by wbzhan on 2018/5/31.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyTransferBuyDetailModel.h"

@implementation BuyDetailInfoModel

@end


@implementation BuyDetailInfoRepayModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"info":[BuyDetailInfoModel class]
             };
    
}
@end

@implementation MyTransferBuyDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"recover_info":[BuyDetailInfoRepayModel class],
             @"transfer_info":[BuyDetailInfoModel class]
             };
    
}
@end
