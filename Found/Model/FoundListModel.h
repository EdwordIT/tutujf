//
//  FoundListModel.h
//  TTJF
//
//  Created by 占碧光 on 2017/11/20.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "BaseModel.h"
@interface FoundListModel : BaseModel

@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *pic_url;
@property(nonatomic, strong) NSString *link_url;
@property(nonatomic, strong) NSString *width;
@property(nonatomic, strong) NSString *height;

@end
