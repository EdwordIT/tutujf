//
//  Utils.h
//  P2PDemo
//
//  Created by huanxunIH1338 on 16/3/29.
//  Copyright © 2016年 huanxunIH1338. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import <CommonCrypto/CommonCrypto.h>

@interface Utils : NSObject

+ (NSString*)TripleDES:(NSString*)plainText;

+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key desIv:(NSString*)desIv;

+(NSString *)MD532: (NSString *)inPutText;

+(NSString *)MD5getSign:(NSString *)content;
@end
