//
//  MineTopCell.h
//  TTJF
//
//  Created by 占碧光 on 2017/10/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopScrollBasePage.h"
#import "TopAccount.h"
#import "TopAccountModel.h"
#import "UserInfo.h"
#import "MyAccountModel.h"

@protocol MineTopDelegate <NSObject>

@optional
-(void)didopMineAtIndex:(NSInteger)index;

@end

@interface MineTopCell : UITableViewCell

@property(nonatomic, assign) id<MineTopDelegate> delegate;

@property (nonatomic ,strong) TopAccount *account; //充值、提现

@property (nonatomic ,strong) TopScrollBasePage *basepage;

-(void)setModelData:(MyAccountModel *)accountModel;

@end
