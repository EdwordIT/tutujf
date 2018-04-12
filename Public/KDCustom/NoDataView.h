//
//  NodataView.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/27.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^NodataRefreshBlock)(void);
@interface NoDataView : UIView
//+(instancetype)noDataEmpty;
//+(instancetype)noDataRefreshBlock:(NodataRefreshBlock)refreshBlock;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel     *titleLabel;
Strong UIButton *clickBtn;
Copy NodataRefreshBlock refreshBlock;
+ (NoDataView *)noDataRefreshBlock:(NodataRefreshBlock )block;//无数据

+(NoDataView *)noNetWorkView;//无网络
@end
