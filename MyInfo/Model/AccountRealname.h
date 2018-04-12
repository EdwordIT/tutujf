//
//  AccountRealname.h
//  TTJF
//
//  Created by 占碧光 on 2017/10/31.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "BaseModel.h"

@interface AccountRealname : BaseModel
@property (nonatomic, copy) NSString   *name;
@property (nonatomic, copy) NSString   *url;
@property (nonatomic, copy) NSString   *realname;
@property (nonatomic, copy) NSString   *card_id;
@end
