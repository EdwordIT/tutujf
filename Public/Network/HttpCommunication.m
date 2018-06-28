//
//  HttpCommunication.m
//  cloudSound
//
//  Created by wbzhan on 2017/08/02.
//  Copyright © 2017年 hzlh. All rights reserved.

#import "HttpCommunication.h"
#import "SVProgressHUD.h"
#import "HttpSignCreate.h"
#import "LoginViewController.h"
#import <AFNetworkReachabilityManager.h>
#import <MJRefreshFooter.h>
#import "JSONKit.h"
@interface HttpCommunication ()
@property (nonatomic, strong)AFHTTPSessionManager *manager;
@end

@implementation HttpCommunication

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
        //请求超时时间为15秒
        _manager.requestSerializer.timeoutInterval = 15;
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
//       // 内容类型
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];

//
//        NSString*cerPath = [[NSBundle mainBundle]pathForResource:@"tutujf.cer"ofType:nil];
//
//        NSData *certData =[NSData dataWithContentsOfFile:cerPath];
//
//        NSSet *certSet = [[NSSet alloc]initWithObjects:certData,nil];
//
//        /**
//        AFSSLPinningModeNone,
//        表示不做SSL pinning，只跟浏览器一样在系统的信任机构列表里验证服务端返回的证书。若证书是信任机构签发的就会通过，若是自己服务器生成的证书，这里是不会通过的。
//        AFSSLPinningModePublicKey,
//        表示用证书绑定方式验证证书，需要客户端保存有服务端的证书拷贝，这里验证分两步，第一步验证证书的域名/有效期等信息，第二步是对比服务端返回的证书跟客户端返回的是否一致。
//        AFSSLPinningModeCertificate,
//        //这个模式同样是用证书绑定方式验证，客户端要有服务端的证书拷贝，只是验证时只验证证书里的公钥，不验证证书的有效期等信息。
//         */
//        AFSecurityPolicy *securityPolicy =[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];//证书验证。
//
//        securityPolicy.allowInvalidCertificates = YES;//这个一属性是设置无效证书(过期、失效证书)是否认同，yes为认同，NO为不认同
//
//        securityPolicy.validatesDomainName = YES;//是否验证
//
//        [securityPolicy setPinnedCertificates:certSet];//添加证书
//
//        _manager.securityPolicy= securityPolicy;
//



    }
    return self;
}

+ (HttpCommunication *)sharedInstance
{
    static HttpCommunication *_instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [[self alloc] init];
        
    });
    return _instance;
}
//判断当前是否接入有网络
+ (BOOL)isReachable
{
//    return [[AFNetworkReachabilityManager sharedManager] isReachable];
    return YES;
}
//获取get请求链接
-(NSString *)getRequestPath:(NSString *)urlPath keysArray:(NSArray *)keys valuesArray:(NSArray *)values signStr:(NSString *)sign{
    urlPath = [urlPath stringByAppendingString:@"?"];
    for (int i=0; i<keys.count; i++) {
        NSString *keyValue = values[i];
      NSString *  newValue = [keyValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        urlPath = [urlPath stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",keys[i],newValue]];
    }
    urlPath = [urlPath stringByAppendingString:[NSString stringWithFormat:@"sign=%@",sign]];
    return urlPath;
}
//获取post请求体
-(NSDictionary *)getParametersWithKeys:(NSArray *)keys values:(NSArray *)values{
    NSMutableDictionary *parameters = InitObject(NSMutableDictionary);
    if (keys==nil) {
        //不需要sign
        return nil;
    }else{
        for (int i=0; i<keys.count; i++) {
            [parameters setObject:values[i] forKey:keys[i]];
        }
        NSString *sign = [HttpSignCreate GetSignStrWithKeys:keys andValues:values];
        [parameters setObject:sign forKey:@"sign"];
        return parameters;
    }
}
-(NSMutableURLRequest *)getUrlRequestWithPath:(NSString *)urlString keysArray:(NSArray *)keys valuesArray:(NSArray *)values{
    
    urlString = [oyApiUrl stringByAppendingString:urlString];
    NSString *newPath = @"";
    if (keys==nil) {
        newPath = urlString;//不需要sign
    }else{
        NSString *sign = [HttpSignCreate GetSignStrWithKeys:keys andValues:values];
        newPath = [self getRequestPath:urlString keysArray:keys valuesArray:values signStr:sign];
    }
    NSLog(@"requestUrl = %@",newPath);//请求地址
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:15];//超时时间15秒
    [urlRequest setHTTPMethod:@"POST"];//请求方式post
    NSString *bodyStr;
    if (keys==nil) {
        bodyStr = [newPath substringFromIndex:urlString.length];
    }else
        bodyStr = [newPath substringFromIndex:urlString.length+1];//请求体封装(有？的情况)
    NSData *bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    urlRequest.HTTPBody = bodyData;
    return urlRequest;
}
//带sign签名的POST请求
- (void)postSignRequestWithPath:(NSString *)urlString
                     keysArray:(NSArray *)keys
                   valuesArray:(NSArray *)values
                       refresh:(UIScrollView *)scrollView
                       success:(TTJFCallBackSuccess)success
                       failure:(TTJFCallBackFailed)failure
{
    

    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *urlRequest = [self getUrlRequestWithPath:urlString keysArray:keys valuesArray:values];
    NSURLSessionDataTask *sessionDataTask  = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

         if ([data length] >0  &&
             error == nil){
             [self endRefresh:scrollView];
             //特殊接口：登录和注册，都需要静默登录webView，需等到webView加载完成之后才退出提示框
             if ([urlString hasSuffix:loginUrl]||[urlString hasSuffix:registerUrl]) {
                 //不隐藏提示框
             }else
                 [SVProgressHUD dismissWithDelay:0.5];
             id resalut = [data objectFromJSONData];
             NSLog(@"获取数据 resalut = %@",resalut);
             if ([resalut isKindOfClass:[NSDictionary class]]) {
                 NSString *resCode = [NSString stringWithFormat:@"%@",[resalut objectForKey:RESPONSE_CODE]];//状态码
                 //返回数据正确 ，则解析到数据接收内容
                 if([resCode integerValue]==kReqSuccess)
                 {
                     //如果仅返回成功码而无其他返回内容,则resultData默认返回值为空数组
                     NSDictionary *dataDic = [resalut objectForKey:RESPONSE_DATA];
                     /**
                      获取后台给定的正确码0，做逻辑处理
                      */
                     dispatch_async(dispatch_get_main_queue(), ^{
                         //直接显示成功信息
                         if ([dataDic isKindOfClass:[NSArray class]]&&((NSArray *)dataDic).count==0) {
                             [SVProgressHUD showSuccessWithStatus:[resalut objectForKey:RESPONSE_MESSAGE]];
                         }
                         success(dataDic);
                     });
                 }else{
                     /*
                      获取后台给定的其他错误码，做逻辑处理
                      */
                     //如果是token失效，则直接跳转到重新登录页面
                     if ([resCode integerValue]==kLoginError) {
                         [[NSNotificationCenter defaultCenter] postNotificationName:Noti_AutoLogin object:nil];
                     }
                     dispatch_async(dispatch_get_main_queue(), ^{
                         //错误信息展示（其他相关错误处理在具体的类里进行）
                         [SVProgressHUD showInfoWithStatus:[resalut objectForKey:RESPONSE_MESSAGE]];
                         failure(resalut);
                     });
                 }
             }else{

                 NSLog(@"json格式错误");
                 [self endRefresh:scrollView];
                 dispatch_async(dispatch_get_main_queue(), ^{

                     if ([scrollView isKindOfClass:[UITableView class]]) {
                         [((UITableView *)scrollView) reloadData];
                     }
                 });
             }
         }
         else if ([data length] == 0 &&
                  error == nil){
             //反馈错误信息（网络连接失败（服务器关停）等信息）
             if (error) {
                 [SVProgressHUD showInfoWithStatus:@"请求数据失败"];
             }
             [self endRefresh:scrollView];
             dispatch_async(dispatch_get_main_queue(), ^{

                 if ([scrollView isKindOfClass:[UITableView class]]) {
                     [((UITableView *)scrollView) reloadData];
                 }
             });
         }
         else if (error != nil){
             //反馈错误信息（网络连接失败（服务器关停）等信息）
             if (error) {
                 [SVProgressHUD showInfoWithStatus:@"请求数据失败"];
             }
             [self endRefresh:scrollView];
             dispatch_async(dispatch_get_main_queue(), ^{

                 if ([scrollView isKindOfClass:[UITableView class]]) {
                     [((UITableView *)scrollView) reloadData];
                 }
             });
         }

     }];
    [sessionDataTask resume];
//
//    NSDictionary *parameters = [self getParametersWithKeys:keys values:values];
//
//    if ([HttpCommunication isReachable]) {
////        [_manager.operationQueue cancelAllOperations];//取消所有网络请求，然后在进行下一步的网络请求
//
//        [_manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
//            //数据请求的进度
//            //            [SVProgressHUD show];
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
//            [self endRefresh:scrollView];
//            //特殊接口：登录和注册，都需要静默登录webView，需等到webView加载完成之后才退出提示框
//            if ([urlString isEqualToString:loginUrl]||[urlString isEqualToString:registerUrl]) {
//                //不隐藏提示框
//            }else
//                [SVProgressHUD dismissWithDelay:0.5];
//            //解析response内容
//            if([responseObject isKindOfClass:[NSDictionary class]]){
//                NSDictionary *resalut = (NSDictionary *)responseObject;
//                NSLog(@"获取数据 resalut = %@",resalut);
//                NSString *resCode = [NSString stringWithFormat:@"%@",[resalut objectForKey:RESPONSE_CODE]];
//                //返回数据正确 ，则解析到数据接收内容
//                if([resCode integerValue]==kReqSuccess)
//                {
//                    /**
//                     获取后台给定的正确码0，做逻辑处理
//                     */
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        success([resalut objectForKey:RESPONSE_DATA]);
//                    });
//                }else{
//                    /*
//                     获取后台给定的其他错误码，做逻辑处理
//                     */
//                    //如果是token失效，则直接跳转到重新登录页面
//                    if ([resCode integerValue]==kLoginError) {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:Noti_AutoLogin object:nil];
//                    }
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //错误信息展示（其他相关错误处理在具体的类里进行）
//                        [SVProgressHUD showInfoWithStatus:[resalut objectForKey:RESPONSE_MESSAGE]];
//                        failure(resalut);
//                    });
//                }
//            }
//            else{
//
//                NSLog(@"JSON格式错误");
//            }
//        } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
//            //反馈错误信息（网络连接失败（服务器关停）等信息）
//            if (error) {
//                [SVProgressHUD showInfoWithStatus:@"请求数据失败"];
//            }
//            [self endRefresh:scrollView];
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                if ([scrollView isKindOfClass:[UITableView class]]) {
//                    [((UITableView *)scrollView) reloadData];
//                }
//            });
//        }];
//    }
//    else
//    {
//
//        [self endRefresh:scrollView];
//        [SVProgressHUD showInfoWithStatus:@"没有网络"];
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            if ([scrollView isKindOfClass:[UITableView class]]) {
//                [((UITableView *)scrollView) reloadData];
//            }
//        });
//
//    }
}

-(void)endRefresh:(UIScrollView *)scrollView
{
    if (scrollView!=nil) {
        [scrollView.mj_header endRefreshing];
        [scrollView.mj_footer endRefreshing];
    }
}
/**
 *  获取文件上传的请求体信息(二进制)
 *
 *  @param serverFileName 服务器接收文件的字段名
 *  @param filePath       要上传的文件的路径
 *
 *  @return 返回文件上传的请求体二进制信息
 */
- (NSData *)getHTTPBodyWithServerFileName:(NSString *)serverFileName imageData:(NSData *)imageData
{
    // 定义可变的二进制容器,拼接请求体的二进制信息
    NSMutableData *dataM = [NSMutableData data];
    NSDate *date = [NSDate date];
    NSDateFormatter *formormat = [[NSDateFormatter alloc]init];
    [formormat setDateFormat:@"HHmmss"];
    NSString *dateString = [formormat stringFromDate:date];
    NSString *fileName = [NSString  stringWithFormat:@"%@.png",dateString];
    // 定义可变字符串,拼接开始的请求体字符串信息
    NSMutableString *stringM = [NSMutableString string];
    // 拼接文件开始上传的分隔符
    [stringM appendString:@"--mac\r\n"];
    // 拼接表单数据
    [stringM appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",serverFileName,fileName];
    // 拼接要上传的文件的类型 : 如果你不想告诉服务器你的文件类型具体是什么,就可以使用 "Content-Type: application/octet-stream"
    [stringM appendString:@"Content-Type: image/jpg/png/jpeg\r\n"];
    // 拼接单穿的换行
    [stringM appendString:@"\r\n"];
    // 在这里(拼接文件的二进制数据之前),把前面的请求体字符串转换成二进制,先拼接一次
    NSData *stringM_data = [stringM dataUsingEncoding:NSUTF8StringEncoding];
    [dataM appendData:stringM_data];
    // 拼接文件的二进制数据
    NSData *file_data = imageData;
    [dataM appendData:file_data];
    NSString *end = @"\r\n--mac--";
    [dataM appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    return dataM.copy;
}
/******************************图片上传*************************************/
- (void)uploadImageWithUrl:(NSString *)urlString
                      keysArray:(NSArray *)keys
                    valuesArray:(NSArray *)values
                     image:(NSData  *)imageData
                        success:(TTJFCallBackSuccess)success
                        failure:(TTJFCallBackFailed)failure
{
    
//    NSMutableURLRequest *urlRequest = [self getUrlRequestWithPath:urlString keysArray:keys valuesArray:values];
//    [urlRequest setValue:@"multipart/form-data; boundary=mac" forHTTPHeaderField:@"Content-Type"];
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSData *data = [self getHTTPBodyWithServerFileName:@"uploadimg" imageData:imageData];
//    NSURLSessionDataTask *sessionDataTask = [session uploadTaskWithRequest:urlRequest fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if ([data length] >0  &&
//            error == nil){
//            id resalut = [data objectFromJSONData];
//            NSLog(@"获取数据 resalut = %@",resalut);
//            if ([resalut isKindOfClass:[NSDictionary class]]) {
//                NSString *resCode = [NSString stringWithFormat:@"%@",[resalut objectForKey:RESPONSE_CODE]];//状态码
//                //返回数据正确 ，则解析到数据接收内容
//                if([resCode integerValue]==kReqSuccess)
//                {
//                    //如果仅返回成功码而无其他返回内容,则resultData默认返回值为空数组
//                    NSDictionary *dataDic = [resalut objectForKey:RESPONSE_DATA];
//                    /**
//                     获取后台给定的正确码0，做逻辑处理
//                     */
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //直接显示成功信息
//                        if ([dataDic isKindOfClass:[NSArray class]]&&((NSArray *)dataDic).count==0) {
//                            [SVProgressHUD showSuccessWithStatus:[resalut objectForKey:RESPONSE_MESSAGE]];
//                        }
//                        success(dataDic);
//                    });
//                }else{
//                    /*
//                     获取后台给定的其他错误码，做逻辑处理
//                     */
//                    //如果是token失效，则直接跳转到重新登录页面
//                    if ([resCode integerValue]==kLoginError) {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:Noti_AutoLogin object:nil];
//                    }
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //错误信息展示（其他相关错误处理在具体的类里进行）
//                        [SVProgressHUD showInfoWithStatus:[resalut objectForKey:RESPONSE_MESSAGE]];
//                        failure(resalut);
//                    });
//                }
//            }else{
//                NSLog(@"json格式错误");
//            }
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //错误信息展示（其他相关错误处理在具体的类里进行）
//                [SVProgressHUD showInfoWithStatus:@"上传失败"];
//            });
//        }
//    }];
//    [sessionDataTask resume];

    urlString = [oyApiUrl stringByAppendingString:urlString];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15;
    NSDictionary *parameters = [self getParametersWithKeys:keys values:values];
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formormat = [[NSDateFormatter alloc]init];
        [formormat setDateFormat:@"HHmmss"];
        NSString *dateString = [formormat stringFromDate:date];
        NSString *fileName = [NSString  stringWithFormat:@"%@.png",dateString];
        [formData  appendPartWithFileData:imageData name:@"uploadimg" fileName:fileName mimeType:@"image/jpg/png/jpeg"];

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        // @property int64_t totalUnitCount;     需要上传文件的总大小
        // @property int64_t completedUnitCount; 当前已经上传的大小
        CGFloat progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        // 给Progress添加监听 KVO
        NSLog(@"%f",progress);
        // 回到主队列刷新UI,用户自定义的进度条
        dispatch_async(dispatch_get_main_queue(), ^{
//            self.progressView.progress = 1.0 *
//            uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        });

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        id resalut = (NSDictionary *)responseObject;
                        NSLog(@"获取数据 resalut = %@",resalut);
                        NSString *resCode = [NSString stringWithFormat:@"%@",[resalut objectForKey:RESPONSE_CODE]];//状态码
                        //返回数据正确 ，则解析到数据接收内容
                        if([resCode integerValue]==kReqSuccess)
                        {
                            //如果仅返回成功码而无其他返回内容,则resultData默认返回值为空数组
                            NSDictionary *dataDic = [resalut objectForKey:RESPONSE_DATA];
                            /**
                             获取后台给定的正确码0，做逻辑处理
                             */
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //直接显示成功信息
                                if ([dataDic isKindOfClass:[NSArray class]]&&((NSArray *)dataDic).count==0) {
                                    [SVProgressHUD showSuccessWithStatus:[resalut objectForKey:RESPONSE_MESSAGE]];
                                }
                                success(dataDic);
                            });
                        }else{
                            /*
                             获取后台给定的其他错误码，做逻辑处理
                             */
                            //如果是token失效，则直接跳转到重新登录页面
                            if ([resCode integerValue]==kLoginError) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:Noti_AutoLogin object:nil];
                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //错误信息展示（其他相关错误处理在具体的类里进行）
                                [SVProgressHUD showInfoWithStatus:[resalut objectForKey:RESPONSE_MESSAGE]];
                                failure(resalut);
                            });
                        }
                    }else{
                        NSLog(@"json格式错误");
                    }
        NSLog(@"上传成功 %@", responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败 %@", error);
        [SVProgressHUD showErrorWithStatus:@"反馈失败"];
    }];
}
/*!
 
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
    }

    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options: NSJSONReadingAllowFragments
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析字符串失败：%@",err);
        return nil;
    }
    return dic;
    
}

-(void)getMessage:(NSString *)urlString
       parameters:(NSDictionary *)parameters
          refresh:(MJRefreshComponent *)refresh
          success:(TTJFCallBackSuccess)success
          failure:(TTJFCallBackFailed)failure{
    
    
}
-(NSString *)getFormUrl:(NSDictionary *)formDic
{
    NSArray *keys = [formDic allKeys];
    NSString * url_parame=@"";
    NSString * url=[formDic objectForKey:@"url"];
    for (int i=0; i<keys.count; i++) {
        NSString *key = [keys objectAtIndex:i];
        
        NSString *keyValue = [formDic objectForKey:key];
        NSString *  newValue = [HttpSignCreate encodeString:keyValue];
        
        if ([key isEqualToString:@"url"]) {
            continue;
        }
        if (i==keys.count-1) {
            url_parame = [url_parame stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,newValue]];
        }else
            url_parame = [url_parame stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,newValue]];
    }
    [HttpSignCreate encodeString:url_parame];
    return [NSString stringWithFormat:@"%@?%@",url,url_parame];
}
/**
 字典转json字符串
 
 @param dic 字典对象
 @return json字符串
 */
- (NSString *)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
//替换不规则的json数据
-(NSDictionary *)getJSONWith:(NSData *)responseObject
{
    NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
    
    NSString * str2 = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    str2 = [str2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    str2 = [str2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[str2 dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    return dict;
}
@end
