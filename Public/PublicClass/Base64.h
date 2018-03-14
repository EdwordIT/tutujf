//
//  Base64.h
//  TTJF
//
//  Created by 占碧光 on 2017/5/22.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject

+(NSString *)encode:(NSData *)data;

+(NSData *)decode:(NSString *)data;

@end
