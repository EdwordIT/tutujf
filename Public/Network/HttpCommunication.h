//
//  HttpCommunication.h
//  cloudSound
//
//  Created by wbzhan on 2017/08/02.
//  Copyright © 2017年 hzlh. All rights reserved.
//网络请求相关
#import <Foundation/Foundation.h>

#import"AFNetworking.h"
#import "HttpUrlAddress.h"
#import <MJRefreshComponent.h>
typedef void (^TTJFCallBackSuccess)(NSDictionary *successDic);//正确返回
typedef void (^TTJFCallBackFailed)(NSDictionary *errorDic);//连接服务器成功，返回其他错误码
typedef void(^TTJFConnectServiceFailed)(void);//连接服务器失败

typedef NS_ENUM(NSUInteger, AnalyzeType) {
   kReqSuccess = 0,//    操作成功
   kReqSignError =  100001 ,//  sign 错误，需特殊处理
   kReqParamaterEmpty = 100010 ,//   参数为空或其他错误
   kReqFunctionFail = 100012 ,//   操作失败
   kReqParamaterError = 100013,//    参数错误或其他错误
   kAccessDenied = 100014,//    禁止访问
   kLoginError =  100015 ,//   未登录或登录识别码错误，需特殊处理
    
    
};
/*
 状态码定义
 */
#define RESPONSE_CODE @"resultStatus" // 0：失败 1：成功    status
#define RESPONSE_MESSAGE @"msg"
#define RESPONSE_DATA @"resultData"
#define RESPONSE_SUCCESS @"0" //服务器返回的数据成功信息1、成功，-1，异常，0，错误
#define RESPONSE_LIST @"con"//获取数组列表
#define RESPONSE_OBJECT @"object"//获取字典数据

@interface HttpCommunication : NSObject

+ (HttpCommunication *)sharedInstance;
//带sign签名的POST请求
- (void)postSignRequestWithPath:(NSString *)urlString
                      keysArray:(NSArray *)keys
                    valuesArray:(NSArray *)values
                        refresh:(UIScrollView *)scrollView
                        success:(TTJFCallBackSuccess)success
                        failure:(TTJFCallBackFailed)failure;


/*!
 
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/**
 字典转json字符串
 
 @param dic 字典对象
 @return json字符串
 */
- (NSString *)dictionaryToJson:(NSDictionary *)dic;
/**
 获取短信验证码
 */
-(void)getMessage:(NSString *)urlString
       parameters:(NSDictionary *)parameters
          refresh:(MJRefreshComponent *)refresh
          success:(TTJFCallBackSuccess)success
          failure:(TTJFCallBackFailed)failure;
/**
 获取充值到汇付相关的form表单
 */
-(NSString *)getFormUrl:(NSDictionary *)formDic;
@end
