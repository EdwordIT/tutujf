//
//  DisSectionView.h
//  TTJF
//
//  Created by wbzhan on 2018/7/31.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseView.h"
#import "DiscoverMenuModel.h"

@protocol DiscoverSectionDelegate <NSObject>

@optional
-(void)didTapSectionButton:(NSInteger)index;

@end
/**
 发现模块section
 */
@interface DisSectionView : BaseView

@property(nonatomic, assign) id<DiscoverSectionDelegate> delegate;

-(void)loadSectionWithArray:(NSArray *)data;
@end
