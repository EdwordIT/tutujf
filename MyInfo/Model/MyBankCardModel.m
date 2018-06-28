//
//  MyBankCardModel.m
//  TTJF
//
//  Created by wbzhan on 2018/6/25.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyBankCardModel.h"


@implementation AddBankCardModel

@end

@implementation PostInfoModel

@end


@implementation RelieveRemindModel

@end

@implementation MyBankCardModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"bank_list":[BankCardModel class]
             };
    
}

@end
