//
//  TenderModel.h
//  TTJF
//
//  Created by 占碧光 on 2017/12/15.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "BaseModel.h"

@interface TenderModel : BaseModel
@property(nonatomic, strong) NSArray *   items; //投资人数据列表
@property(nonatomic, strong) NSString  *   is_show_tenlist;  //是否可以查看投资记录 -1，不可查看， 1可查看
@property(nonatomic, strong) NSString  *   not_lktenlist_title; //不可查看投资记录时显示文字


@end
