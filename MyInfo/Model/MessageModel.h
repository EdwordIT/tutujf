//
//  MessageModel.h
//  TTJF
//
//  Created by wbzhan on 2018/5/9.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseModel.h"

@interface MessageModel : BaseModel
Copy NSString * title ;//   string    标题
Copy NSString * contents  ;//   string    内容
Copy NSString * link_url  ;//   string    详情连接
Copy NSString * status   ;//  string    状态 ：2 已读， 其他未读
Copy NSString * add_time   ;//  string    时间

@end
