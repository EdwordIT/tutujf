//
//  AccountModel.h
//  TTJF
//
//  Created by 占碧光 on 2017/10/31.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountRealname.h"
#import "AccountPhone.h"

@interface AccountModel : NSObject
@property (nonatomic, copy) NSString   *user_name;
@property (nonatomic, copy) NSString   *update_pwd_link;
@property (nonatomic, copy) NSString   *exit_link;

@end
