//
//  RepayModel.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/15.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "RepayModel.h"
#import "SecurityModel.h"
@implementation RepayModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"items":[SecurityModel class]
             };
    
}
@end
