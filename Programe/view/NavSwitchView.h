//
//  NavSwitchView.h
//  TTJF
//
//  Created by wbzhan on 2018/4/26.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^NavSwitchBlock)(NSInteger tag);
/**
 切换视图
 */
@interface NavSwitchView : UIView

Copy NavSwitchBlock switchBlock;
Assign NSInteger selectIndex;//默认选中状态
-(instancetype)initWithFrame:(CGRect)frame Array:(NSArray <NSString *>*)titleArray;

@end
