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


@protocol MineTopDelegate <NSObject>

@optional
-(void)didopMineAtIndex:(NSInteger)index;

@end

@interface MineTopCell : UITableViewCell

@property(nonatomic, assign) id<MineTopDelegate> delegate;

@property(nonatomic, strong) UIButton *leftBtn;

@property(nonatomic, strong) UILabel *leftName;

@property(nonatomic, strong) UIView *rightView;


@property(nonatomic, strong) UIView *infolimg ;

@property(nonatomic, copy) NSString *ishaveinfo;

@property (nonatomic ,strong) TopAccount *account; //
@property (nonatomic ,strong) TopScrollBasePage *basepage;

-(void)setModelData:(UserInfo *)userinfo;

@end
