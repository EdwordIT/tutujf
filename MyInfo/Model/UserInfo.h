//
//  UserInfo.h
//  TTJF
//
//  Created by 占碧光 on 2017/10/25.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, copy) NSString   *user_name;
@property (nonatomic, copy) NSString   *is_trust_reg;
@property (nonatomic, copy) NSString   *trust_reg_link;
@property (nonatomic, copy) NSString   *trust_reg_log;

@property (nonatomic, copy) NSString   *trust_reg_title;
@property (nonatomic, copy) NSString   *trust_reg_sub_title;
@property (nonatomic, copy) NSString   *bt_my_investment;
@property (nonatomic, copy) NSString   *title;

@property (nonatomic, copy) NSString   *sub_title;
@property (nonatomic, copy) NSString   *link_url;
@property (nonatomic, copy) NSString   *message;
@property (nonatomic, copy) NSString   *total_amount;

@property (nonatomic, copy) NSString   *to_interest_award;
@property (nonatomic, copy) NSString   *balance_amount;
@property (nonatomic, copy) NSString   *recharge_url;
@property (nonatomic, copy) NSString   *cash_url;



@end
