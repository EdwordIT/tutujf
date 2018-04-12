//
//  BaseUITableView.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/4/11.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseUITableView.h"

@implementation BaseUITableView
//
//
//- (void)dealloc {
//    self.noDataView = nil;
//}
//
//- (void)setNoDataView:(NoDataView *)noDataView {
//    if (_noDataView.superview) {
//        [_noDataView removeFromSuperview];
//    }
//    [noDataView removeFromSuperview];
//
//    _noDataView = noDataView;
//    [self addSubview:_noDataView];
//
//    [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.edges.mas_equalTo(self);
//    }];
//
//
//}

- (void)reloadData {
    [super reloadData];
    if (self.ly_emptyView!=nil) {
        MainThreadFunction([self ly_endLoading]);
    }
//    if ([self.dataSource numberOfSectionsInTableView:self] > 0 &&
//        [self.dataSource tableView:self numberOfRowsInSection:0] > 0) {
//        self.noDataView.hidden = YES;
//    } else {
//        self.noDataView.hidden = NO;
//    }
}
////重写reloadData方法
//-(void)reloadData{
//    [super reloadData];
//    if (self.ly_emptyView!=nil) {
//        [self ly_endLoading];
//    }
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
