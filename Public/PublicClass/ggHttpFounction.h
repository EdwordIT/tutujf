//
//  ggHttpFounction.h
//  iVideoMonitor
//  http访问方法类
//  Created by gogo on 12-11-18.
//  Copyright (c) 2012年 Senlan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DefaultUrlstr @"http://120.55.191.11:9000/web/com.ashx";
@interface ggHttpFounction : NSObject{
 
    
}
//httpGet请求
+(NSString *)HttpGet:(NSString *)urlAsString;
//http异步Get请求
+(NSString *)asynHttpGet:(NSString *)urlAsString;

//http同步Get请求
+(NSString *)synHttpGet:(NSString *)urlAsString;
//http异步Get请求
+(NSString *)asynQueueHttpGet:(NSString *)urlAsString;

//http异步Post请求
+(NSString *)asynHttpPost:(NSString *)urlAsString ParamName:(NSString *)bodyParam1 ParamValue:(NSString *)bodyValue1;
//http异步Post请求
+(NSString *)asynHttpPost:(NSString *)urlAsString  ParamValue:(NSString *)bodyValue1;
//http同步Post请求
+(NSString *)synHttpPost:(NSString *)urlAsString ParamName:(NSString *)bodyParam1 ParamValue:(NSString *)bodyValue1;

+(NSString *)synHttpPost:(NSString *)urlAsString ParamValue:(NSString *)bodyValue1;
+(NSData *)synHttpPostData:(NSString *)urlAsString ParamValue:(NSString *)bodyValue1;

+(BOOL) getJsonIsOk:(NSData *) jsondata;
+(NSString *) getJsonMsg:(NSData *) jsondata;

+(NSArray *) getJsonData:(NSData *) jsondata;

+(NSDictionary *) getJsonData1:(NSData *) jsondata;
@end
