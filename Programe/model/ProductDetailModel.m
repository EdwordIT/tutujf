//
//  LoanDetailModel.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/29.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "ProductDetailModel.h"

//九宫格图片显示
@implementation ImgModel:BaseModel

@end
//信息详情
@implementation InfoDetailModel: BaseModel

@end

//审核内容类目
@implementation AuditColumnModel:BaseModel

@end
/**
 项目说明
 */
@implementation ProjectDescModel :BaseModel


@end
/**
 借款人各类信息
 */
@implementation BorrowerModel:BaseModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"list":[InfoDetailModel class]
             };
}
@end

@implementation AuditInfoModel:BaseModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"list":[AuditColumnModel class]
             };
}
@end


@implementation PicturesModel:BaseModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"pic_list":[ImgModel class]
             };
}
@end


@implementation ProductDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"borrower_list":[BorrowerModel class]
             };
}
////自定义字段名
//+ (NSDictionary *)modelCustomPropertyMapper{
//    
//    return @{
//             @"platformModel":@"index_bottom_ad"
//             };
//}
@end
