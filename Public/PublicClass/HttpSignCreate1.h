//
//  HttpSignCreate1.h
//  TTJF
//
//  Created by 占碧光 on 2017/5/23.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface HttpSignCreate1 : NSObject


+(NSString *) getSysToken:(NSString *)token;

+(NSString *)Getmd5:(NSString *)str;
+(NSString *)  DictToUrlParame:(NSDictionary *)dict_data array:(NSArray *)array;

+(BOOL)  IsLower:(NSString * )str;

+(NSDictionary *) ObjToDictionary:(NSObject *) o;
+(NSString *) GetSignStr:(NSMutableDictionary *) dict_data array:(NSArray *)array;

+(BOOL)  IsSignStr:(NSDictionary *) dict_data sign: (NSString *) sign;

+(NSString*)encodeString:(NSString*)unencodedString;
//@property (weak, nonatomic)   NSString*  sys_token;
+(NSString *)decodeString:(NSString*)encodedString;
+(NSDictionary *) postURL:(NSString *) urlstr;


@end
