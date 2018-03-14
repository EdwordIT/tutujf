//
//  WalletTopCell.h
//  DingXinDai
//
//  Created by 占碧光 on 16/6/26.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WalletTopDelegate <NSObject>

@optional
-(void)didopWalletAtIndex:(NSInteger)index;

@end

@interface WalletTopCell : UITableViewCell

-(void) setDxb:(NSString *)str  kyye:(NSString *)kyye;

-(void) setHongbao:(NSString *)str;

@property(nonatomic, assign) id<WalletTopDelegate> delegate;


@end
