//
//  BaseUITableView.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/4/11.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseUITableView.h"

@implementation BaseUITableView
{
    BOOL isFirstLoad;//无数据第一时间不加载
}
-(instancetype)init{
    self = [super init];
    if (self) {
        [self loadBaseInfo];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self loadBaseInfo];
    }
    return self;
}
-(void)loadBaseInfo{
    self.backgroundColor = COLOR_Background;
     [self setSeparatorColor:separaterColor];
    isFirstLoad = YES;
}

- (void)reloadData {
    [super reloadData];
    if (isFirstLoad) {
        isFirstLoad = NO;
    }else{
        if (self.ly_emptyView!=nil) {
            [self ly_endLoading];
        }
    }
}


@end
