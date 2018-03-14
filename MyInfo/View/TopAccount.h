//
//  TopAccount.h
//  TTJF
//
//  Created by 占碧光 on 2017/10/23.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopAccountModel.h"


typedef void(^SelectedTopAccountAtIndex)(NSInteger index) ;

@interface TopAccount : UIView


@property(nonatomic, strong) UILabel *account;

@property(nonatomic, strong) UIButton *chongzhi;

@property(nonatomic, strong) UIButton *tixian;

-(void) setDataBind:(TopAccountModel *)data;

- (instancetype)initWithFrame:(CGRect)frame  DataDir:(TopAccountModel *)data
                  SelectBlock:(SelectedTopAccountAtIndex)block;
@end
