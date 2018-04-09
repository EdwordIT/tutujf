//
//  LoanDetailModel.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/29.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"

//信息详情
@interface InfoDetailModel: BaseModel
Copy NSString * title  ;//  string    标题
Copy NSString * content ;//  string    内容
@end

@interface ImgModel:BaseModel
Copy NSString *imgurl;
Copy NSString *minimg;
Copy NSString *title;
@end

//审核内容类目
@interface AuditColumnModel:BaseModel
Copy NSString *info_name ;//审核资料
Copy NSString *audit_result ;//审核结果
@end
/**
 项目说明
 */
@interface ProjectDescModel :BaseModel
Copy NSString * title  ;//  string    标题
Copy NSString * content   ;//  string    内容
Copy NSString * sub_title   ;//  string    副标题
Copy NSString * sub_title_link  ;//   string    副标题连接

@end
/**
 借款人各类信息
 */
@interface BorrowerModel:BaseModel
Copy NSString *title;//string 标题
Strong NSArray *list ;//基本信息数组（内含InfoDetailModel）

@end

@interface AuditInfoModel:BaseModel
Strong AuditColumnModel *column;//审核标题
Strong NSArray *list;//审核具体类目
@end


@interface PicturesModel:BaseModel
Copy NSString *title;
Strong NSArray *pic_list;//图片数组


@end


@interface ProductDetailModel : BaseModel
Strong ProjectDescModel *project_desc;//项目说明

Strong NSArray *borrower_list;//借款人信息列表

Strong AuditInfoModel *audit_info;//审核所需类目以及审核结果

Strong PicturesModel *material_pic;//审核图片内容

@end
