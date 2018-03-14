//
//  HomeBanner.h
//  XPjrpro
//
//  Created by 占碧光 on 16/6/3.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BannerDelegate <NSObject>

@optional
-(void)didSelectedBannerAtIndex:(NSInteger)index;

@end

@interface HomeBanner : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property(nonatomic, assign) id<BannerDelegate> delegate;
-(void)setModelArray:(NSArray *)modelArray;
-(void) setTopJinE:(CGFloat)jine;
@end
