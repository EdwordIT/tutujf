//
//  HttpSignCreate.h
//  DingXinDai
//
//  Created by 占碧光 on 16/7/8.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonDigest.h>

@interface HttpSignCreate : NSObject

//@"!M6vZ%PCN"

+(NSString *) getSysToken:(NSString *)token;

+(NSString *)Getmd5:(NSString *)str;
+(NSString *)  DictToUrlParame:(NSDictionary *)dict_data;

+(BOOL)  IsLower:(NSString * )str;

+(NSDictionary *) ObjToDictionary:(NSObject *) o;
+(NSString *) GetSignStr:(NSDictionary *) dict_data;

+(BOOL)  IsSignStr:(NSDictionary *) dict_data sign: (NSString *) sign;

+(NSString*)encodeString:(NSString*)unencodedString;
//@property (weak, nonatomic)   NSString*  sys_token;
+(NSString *)decodeString:(NSString*)encodedString;
+(NSDictionary *) postURL:(NSString *) urlstr;
+(NSString *) GetSignStr:(NSDictionary *) dict_data paixu:(NSMutableArray *) paixu;
//获取url 参数
+ (NSMutableDictionary *)getURLParameters:(NSString *)urlStr ;
@end
