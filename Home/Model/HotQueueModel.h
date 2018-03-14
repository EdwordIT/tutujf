//
//  HotQueueModel.h
//  meituan
//
//  Created by jinzelu on 15/7/1.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotQueueModel : NSObject

@property (nonatomic, copy) NSString   *trans_num;//累计成交额
@property (nonatomic, copy) NSString   *left_pic_url;
@property (nonatomic, copy) NSString   *left_link_url;
@property (nonatomic, copy) NSString   *right_pic_url;
@property (nonatomic, copy) NSString   *right_link_url;

@property (nonatomic, copy) NSString   *guarantee_txt; //首页底部文本信息


@end
