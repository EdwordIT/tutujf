//
//  MyTransferDetailModel.m
//  TTJF
//
//  Created by wbzhan on 2018/5/30.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyTransferDetailModel.h"
@implementation ContentInfoModel

@end


@implementation coefficientModel

@end

@implementation MyTransferDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"transfer":[ContentInfoModel class]
             };
    
}
@end
