//
//  LoanBase.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/15.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "LoanBase.h"

@implementation LoanBase
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"security_audit":[SecurityModel class]
             };
    
}
@end
