//
//  EmptyView.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/4/11.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "EmptyView.h"

@implementation EmptyView

//重写view
- (void)prepare{
    [super prepare];
//主标题自定义
    self.self.titleLabFont = SYSTEMSIZE(28);
    self.self.titleLabTextColor = RGB_153;
//按钮自定义
    self.actionBtnBorderColor = RGB_153;
    self.actionBtnTitleColor = RGB_153;
    self.actionBtnFont = SYSTEMSIZE(30);
    self.actionBtnBorderWidth = kLineHeight;
//图片大小自定义
    self.imageSize = CGSizeMake(kSizeFrom750(330), kSizeFrom750(330));

    self.autoShowEmptyView = NO;//改为手动控制是否显示
}
+(instancetype)noDataEmpty{

    return [EmptyView emptyViewWithImageStr:@"nodata"
                                    titleStr:@"暂无数据"
                                   detailStr:@"请检查您的网络连接是否正确!"];
}

//带刷新的nodataView
+(instancetype)noDataRefreshBlock:(EmptyRefreshBlock)refreshBlock
{
  return [EmptyView emptyActionViewWithImageStr:@"icons_nodata" titleStr:@"暂无数据" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
        refreshBlock();
    }];
  }

@end
