//
//  MainBanner.h
//  TTJF
//
//  Created by 占碧光 on 2017/7/18.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BannerDelegate <NSObject>

@optional
-(void)didSelectedBannerAtIndex:(NSInteger)index;

@end

@interface MainBanner : UITableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property(nonatomic, assign) id<BannerDelegate> delegate;
-(void)setModelArray:(NSArray *)modelArray;

@end
