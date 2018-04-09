//
//  HomepageModel.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/22.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"
#import "BannerModel.h"
#import "QuicklyModel.h"
#import "ImmediateModel.h"

//公告
@interface NoticeModel :BaseModel
Copy NSString *title;//
Copy NSString *hits;//点击数
Copy NSString *add_time;//发布时间
Copy NSString *link_url;
@end
//行业资讯列表
@interface InformationModel :NoticeModel
Copy NSString *pic;//行业资讯比公告多了个pic
@end
//首页浮动动态按钮
@interface ActivityAdModel :BaseModel
Copy NSString *status;//状态  1显示  0隐藏
Copy NSString *images_url;
Copy NSString *link_url;
@end

@interface PlatformModel: BaseModel
Copy NSString *left_link_url;//string  平台数据
Copy NSString *right_link_url;//string  信息披露
@end

@interface HomepageModel : BaseModel
Strong NSArray *advert_items;//banner数组
Strong NSArray *loan_items;//投资标的数组
Strong NSArray *notice_items;//公告数组
Strong NSArray *lcgh_items;//热门资讯数组
Strong ActivityAdModel *activity_ad_info;//动态按钮
Copy NSString *guarantee_txt;//底部footer文字
Copy NSString *guarantee_sub_txt;//"理财有风险，投资需谨慎"
Strong ImmediateModel *novice_loan_data;//新手标
Copy NSString *unread_msg_num ;//   string    头部未读消息数量
Copy NSString *unread_msg_link ;//   string    头部未读消息链接地址
Copy NSString *trans_num ;//   string    累计成交额
Copy NSString *trans_num_txt;//    string    累计成交额文本
Copy NSString *average_apr;//    string    借款平均利率
Copy NSString *average_apr_txt;//    string    借款平均利率文本
Copy NSString *operate_day ;//   string    平台运营天数
Copy NSString *operate_day_txt;//        平台运营天数文本
Copy NSString *reg_button_txt;//    string    注册领取文字
Strong PlatformModel *platformModel;// 平台数据+信息披露
@end


