//
//  HomepageModel.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/22.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "HomepageModel.h"

@implementation NoticeModel

@end

@implementation InformationModel

@end

@implementation ActivityAdModel

@end

@implementation PlatformModel

@end

@implementation HomepageModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"advert_items":[BannerModel class],
             @"loan_items":[QuicklyModel class],
             @"notice_items":[NoticeModel class],
             @"lcgh_items":[InformationModel class],
             };
    
}
//自定义字段名
+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{
             @"platformModel":@"index_bottom_ad"
             };
}
@end
