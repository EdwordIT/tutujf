//
//  NodataView.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/27.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "NodataView.h"

@implementation NodataView
//重写view
- (void)prepare{
    [super prepare];
    
//    self.titleLabFont = [UIFont systemFontOfSize:25];
//    self.titleLabTextColor = MainColor(90, 180, 160);
//    
//    self.detailLabFont = [UIFont systemFontOfSize:17];
//    self.detailLabTextColor = MainColor(180, 120, 90);
//    self.detailLabMaxLines = 5;
//    
//    self.actionBtnBackGroundColor = MainColor(90, 180, 160);
//    self.actionBtnTitleColor = [UIColor whiteColor];
}
+(instancetype)noDataEmpty{
    
    return [NodataView emptyViewWithImageStr:@"nodata"
                                    titleStr:@"暂无数据"
                                   detailStr:@"请检查您的网络连接是否正确!"];
}
//带刷新的nodataView
+(instancetype)noDataRefreshBlock:(NodataRefreshBlock)refreshBlock
{
    return [NodataView emptyActionViewWithImageStr:@"webback.jpg" titleStr:@"121" detailStr:@"211" btnTitleStr:@"重新加载" btnClickBlock:^{
        refreshBlock();
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
