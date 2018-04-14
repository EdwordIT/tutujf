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
//#import "NSString+Extension.h"
@interface HttpCommunication ()

@property (nonatomic, copy)NSString *baseUrl;
@property (nonatomic, strong)AFHTTPSessionManager *manager;


@end

@implementation HttpCommunication

- (instancetype)init
{
    self = [super init];
    if (self) {
        _baseUrl = oyApiUrl;
        _manager = [AFHTTPSessionManager manager];
        //请求超时时间为15秒
        _manager.requestSerializer.timeoutInterval = 15;
//        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //申明请求的数据是json类型
        //_manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //内容类型
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    
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
//    return  [[AFNetworkReachabilityManager sharedManager] isReachable];
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
//带sign签名的get请求
- (void)getSignRequestWithPath:(NSString *)urlString
                     keysArray:(NSArray *)keys
                   valuesArray:(NSArray *)values
                       refresh:(UIScrollView *)scrollView
                  success:(TTJFCallBackSuccess)success
                  failure:(TTJFCallBackFailed)failure
{
    
    NSString *newPath = @"";
    if (keys==nil) {
        newPath = urlString;//不需要sign
    }else{
        NSString *sign = [HttpSignCreate GetSignStrWithKeys:keys andValues:values];
        newPath = [self getRequestPath:urlString keysArray:keys valuesArray:values signStr:sign];
    }
    NSLog(@"requestUrl = %@",newPath);//请求地址
    if (scrollView.ly_emptyView!=nil) {
        MainThreadFunction( [scrollView ly_startLoading]);
    }
    if ([HttpCommunication isReachable]) {
        [_manager.operationQueue cancelAllOperations];//取消所有网络请求，然后在进行下一步的网络请求
        [_manager GET:newPath parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            //数据请求的进度
            //            [SVProgressHUD show];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            if (scrollView!=nil) {
                [scrollView.mj_header endRefreshing];
            }
            //解析response内容
            if([responseObject isKindOfClass:[NSDictionary class]]){
                NSDictionary *resalut = (NSDictionary *)responseObject;
                NSLog(@"获取数据 resalut = %@",resalut);
                NSString *resCode = [NSString stringWithFormat:@"%@",[resalut objectForKey:RESPONSE_CODE]];
                //返回数据正确 ，则解析到数据接收内容
                if([resCode integerValue]==kReqSuccess)
                {
                    /**
                     获取后台给定的正确码0，做逻辑处理
                     */
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success([resalut objectForKey:RESPONSE_DATA]);
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
                        [SVProgressHUD showErrorWithStatus:[resalut objectForKey:RESPONSE_MESSAGE]];
                        failure(resalut);
                    });
                }
            }
            else{
               
                [SVProgressHUD dismiss];
                NSLog(@"JSON格式错误");
            }
        } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
            [SVProgressHUD dismiss];
            //反馈错误信息（网络连接失败（服务器关停）等信息）
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"请求数据失败"];
            }
            if (scrollView!=nil) {
                [scrollView.mj_header endRefreshing];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([scrollView isKindOfClass:[UITableView class]]) {
                    [((UITableView *)scrollView) reloadData];
                }
            });
        }];
    }
    else
    {
        if (scrollView!=nil) {
            [scrollView.mj_header endRefreshing];
        }
        [SVProgressHUD showErrorWithStatus:@"没有网络"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([scrollView isKindOfClass:[UITableView class]]) {
                [((UITableView *)scrollView) reloadData];
            }
        });
       
    }

}

- (void)getRequestWithURL:(NSString *)urlString
                  refresh:(MJRefreshComponent *)refresh
                  success:(TTJFCallBackSuccess)success
                  failure:(TTJFCallBackFailed)failure
//                    newWorkError:(TTJFConnectServiceFailed)newWorkError
{
   // URL 不能包含 ASCII 字符集
//    urlString = [oyApiUrl stringByAppendingString:urlString];

    NSLog(@"GET Req path = %@",urlString);
    //get请求
    if ([HttpCommunication isReachable])
    {
        [_manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            //数据请求的进度
//            [SVProgressHUD show];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            [refresh endRefreshing];
//            NSLog(@"获取数据 response = %@",responseObject);
            //解析response内容
            if([responseObject isKindOfClass:[NSDictionary class]]){
                NSDictionary *resalut = (NSDictionary *)responseObject;
                NSLog(@"获取数据 resalut = %@",resalut);

                NSString *resCode = [NSString stringWithFormat:@"%@",[resalut objectForKey:RESPONSE_CODE]];
                //返回数据正确 ，则解析到数据接收内容
                if([resCode isEqualToString:RESPONSE_SUCCESS])
                {
                    /*
                     获取后台给定的正确码200，做逻辑处理
                     */
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success([resalut objectForKey:RESPONSE_DATA]);
                    });
                }else{
                    /*
                     获取后台给定的其他错误码，做逻辑处理
                     */
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //错误信息展示（其他相关错误处理在具体的类里进行）
                        [SVProgressHUD showErrorWithStatus:[resalut objectForKey:RESPONSE_MESSAGE]];
                        failure(resalut);
                    });
                }
            }
            else{
                [SVProgressHUD dismiss];
                NSLog(@"JSON格式错误");
            }
        } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
            [SVProgressHUD dismiss];
            //反馈错误信息（网络连接失败（服务器关停）等信息）
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"请求数据失败"];
            }

            [refresh endRefreshing];
            NSLog(@"error = %@",error);
        }];
    }
    else
    {
        [refresh endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"没有网络"];
    }
    
}

- (void)postRequestWithURL:(NSString *)urlString
                parameters:(id)parameters
                   success:(TTJFCallBackSuccess)success
                   failure:(TTJFCallBackFailed)failure
//                     newWorkError:(TTJFConnectServiceFailed)newWorkError

{
    
    urlString  = [oyApiUrl stringByAppendingString:urlString];
    NSLog(@"请求头path = %@",urlString);
    NSLog(@"POST请求体 = %@",parameters);

    //post请求
    //因为header和body属于两个key值
    if ([HttpCommunication isReachable])
    {
        [_manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            //数据请求的进度
//            [SVProgressHUD show];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            [SVProgressHUD dismiss];
            //解析response内容
            if([responseObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *resalut = (NSDictionary *)responseObject;
                NSLog(@"resault = %@",resalut);
                NSString *status = [NSString stringWithFormat:@"%@",[resalut objectForKey:RESPONSE_CODE]];
                //返回数据正确 ，则解析到数据接收内容
                if([status isEqualToString:RESPONSE_SUCCESS])
                {
                    NSLog(@"post成功");
                    /*
                     获取后台给定的正确码1，做逻辑处理
                     */
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //获取正确信息中的data数据
                        success(resalut);
                    });
                }
                else
                {
                    /*
                     获取后台给定的其他错误码，做逻辑处理
                     */
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //错误信息展示（其他相关错误处理在具体的类里进行）
                        [SVProgressHUD showErrorWithStatus:[resalut objectForKey:RESPONSE_MESSAGE]];
                        failure(resalut);
                    });
                }
            }
            else
            {
            [SVProgressHUD dismiss];
                //从服务器获取数据不是json格式
                NSLog(@"JSON格式错误");
            }
        } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
            //反馈错误信息（网络连接失败（服务器关停）等信息）
            [SVProgressHUD dismiss];
            NSLog(@"error = %@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                //错误信息展示（其他具体相关错误处理在具体的类里进行）
                if (error) {
                    [SVProgressHUD showErrorWithStatus:@"请求数据失败"];
                }
            });
            
        }];
    }
    else
    {
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            //错误信息展示（其他相关错误处理在具体的类里进行）
            NSLog(@"网络错误");
            //本地无网络显示框（校验无法连接到百度）
        });
    }
    
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

@end
