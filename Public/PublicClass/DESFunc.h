//
//  DESFunc.h
//  TTJF
//
//  Created by 占碧光 on 2017/5/22.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DESFunc : NSObject

+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;

+(NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key;

+(NSString *) parseByte2HexString:(Byte *) bytes;

+(NSString *) parseByteArray2HexString:(Byte[]) bytes;

@end
