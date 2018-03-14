//
//  TopScrollBasePage.h
//  TTJF
//
//  Created by 占碧光 on 2017/10/22.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopScrollMode.h"

typedef void(^SelectedPageBannerAtIndex)(TopScrollMode * data);

@interface TopScrollBasePage : UIView


-(void) setDataBind:(NSMutableArray *)data;

- (instancetype)initWithFrame:(CGRect)frame
                    DataArray:(NSMutableArray *)dataArray
                  selectBlock:(SelectedPageBannerAtIndex)block;
@property (nonatomic, strong)  UILabel *title1;
@property (nonatomic, strong)  UILabel *title2;
@property (nonatomic, strong)  UILabel *jiner1;
@property (nonatomic, strong)  UILabel *jiner2;

@end
