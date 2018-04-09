//
//  MyAccountModel.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/4/2.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyAccountModel.h"

@implementation MyCapitalModel

@end

@implementation UserContentModel

@end

@implementation MyAccountModel
+(NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"bt_user_content":[UserContentModel class]
             };
}
@end
