//
//  NodataView.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/27.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "LYEmptyView.h"
typedef void (^NodataRefreshBlock)(void);
@interface NodataView : LYEmptyView
+(instancetype)noDataEmpty;
+(instancetype)noDataRefreshBlock:(NodataRefreshBlock)refreshBlock;
@end
