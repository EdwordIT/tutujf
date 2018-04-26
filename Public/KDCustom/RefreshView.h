//
//  RefreshView.h
//  TTJF
//
//  Created by wbzhan on 2018/4/26.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 自定义刷新View
 */
@interface RefreshView : UIView
//根据scrollView的偏移量
-(void)refreshWithContentOffset:(CGFloat)contentOffset;
@end
