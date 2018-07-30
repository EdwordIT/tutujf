//
//  EmptyView.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/4/11.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "LYEmptyView.h"
#import <LYEmptyView/LYEmptyViewHeader.h>
typedef void (^EmptyRefreshBlock)(void);
@interface EmptyView : LYEmptyView
+(instancetype)noDataEmpty;
+(instancetype)noDataRefreshBlock:(EmptyRefreshBlock)refreshBlock;
+(instancetype)emptyWithRefreshBlock:(EmptyRefreshBlock)refreshBlock;//点击刷新数据
@end
