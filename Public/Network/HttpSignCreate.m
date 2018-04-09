//
//  HttpSignCreate.m
//  DingXinDai
//
//  Created by 占碧光 on 16/7/8.
//  Copyright © 2016年 占碧光. All rights reserved.
//加签名

#import "HttpSignCreate.h"
#import <objc/runtime.h>

@implementation HttpSignCreate

+(NSString *) getSysToken
{
    
      return systemToken;
}

/// <summary>
/// 生成 sign
/// </summary>
/// <param name="dict_data"></param>
/// <returns></returns>
+(NSString *) GetSignStr:(NSDictionary *) dict_data
{
    @try
    {
        //大写参数
          NSMutableDictionary *list_upper = [NSMutableDictionary dictionary];
        //小写参数
           NSMutableDictionary *list_lower = [NSMutableDictionary dictionary];
        
        NSEnumerator * enumeratorKey = [dict_data keyEnumerator];
        //得到词典中所有Value值
//        NSEnumerator * enumeratorValue = [dict_data objectEnumerator];
        for (NSObject *obj in enumeratorKey) {
            //通过KEY找到value
            NSObject *objv = [dict_data objectForKey:obj];
            NSString * key=(NSString *)obj;
           
             if (![ [key lowercaseString]  isEqual: @"sign"])
             {
                 if (! [self IsLower:key])
                 {
                   //  list_upper.Add(item + "", dict_data[item.ToString()] + "");
                     
                     [list_upper setObject:objv forKey:key];
                 }
                 else
                 {
                  
                    [list_lower setObject:objv forKey:key];
                 }
             
             }
        }
        
        
         NSEnumerator * enumeratorKey1 = [list_lower keyEnumerator];
         NSEnumerator * enumeratorKey2 = [list_upper keyEnumerator];
        NSMutableArray * paixu= [NSMutableArray array];
        for (NSObject *obj1 in enumeratorKey2)
        {
            NSString * key1=(NSString *)obj1;
            [paixu addObject:key1];
        }
        for (NSObject *obj1 in enumeratorKey1)
        {
                NSObject *objv = [dict_data objectForKey:obj1];
            NSString * key1=(NSString *)obj1;
            [paixu addObject:key1];
               [list_upper setObject:objv forKey:key1];
        }

        //数据包尾部中加入 令牌参数
        // if(![[list_upper allKeys] containsObject:@"sign"])
         [list_upper setObject:[self getSysToken] forKey:@"token"];
        
       // [[list_upper objectForKey:@"sign"] addObject:[self getSysToken]];
         //生成 sign
      NSString *lowerstr = [[self Getmd5:[self DictToUrlParame:list_upper array:paixu]] lowercaseString];
       NSString * signstr=@"";
        //【16 – 19】 +【 4 - 7 】+【 6 - 9 】+【 14 - 17 】
      // lowerstr= _md5Str = _md5Str.Substring(16, 4) + _md5Str.Substring(4, 4) + _md5Str.Substring(6, 4) + _md5Str.Substring(14, 4);
       // signstr= [lowerstr substringWithRange:NSMakeRange(16,4)];
         signstr=[signstr stringByAppendingString:[lowerstr substringWithRange:NSMakeRange(16,4)]];
        signstr=[signstr stringByAppendingString:[lowerstr substringWithRange:NSMakeRange(4,4)]];
        signstr=[signstr stringByAppendingString:[lowerstr substringWithRange:NSMakeRange(6,4)]];
        signstr=[signstr stringByAppendingString:[lowerstr substringWithRange:NSMakeRange(14,4)]];
       return  signstr;
    }
    @catch (NSException * e)
    {
         NSLog(@"Exception: %@", e);
        return nil;
    }
}

+(NSString *) GetSignStrWithKeys:(NSArray *)keys andValues:(NSArray *)values
{
    @try
    {
//        NSMutableDictionary *signDic = [[NSMutableDictionary alloc]init];
//        for (int i=0; i<keys.count; i++) {
//            [signDic setObject:values[i] forKey:keys[i]];
//        }
//        //大写参数
//        NSMutableDictionary *list_upper = [NSMutableDictionary dictionary];
//        //小写参数
//        NSMutableDictionary *list_lower = [NSMutableDictionary dictionary];
//
//        for (NSString *key in keys) {
//            //通过KEY找到value
//            NSObject *objv = [signDic objectForKey:key];
//
//            if (![ [key lowercaseString]  isEqual: @"sign"])
//            {
//                if (! [self IsLower:key])
//                {
//                    [list_upper setObject:objv forKey:key];
//                }
//                else
//                {
//
//                    [list_lower setObject:objv forKey:key];
//                }
//
//            }
//        }
        
        
//        NSEnumerator * enumeratorKey1 = [list_lower keyEnumerator];
//        NSEnumerator * enumeratorKey2 = [list_upper keyEnumerator];
//
//        for (NSObject *obj1 in enumeratorKey1)
//        {
//            NSObject *objv = [signDic objectForKey:obj1];
//            NSString * key1=(NSString *)obj1;
////            [paixu addObject:key1];
//            [list_upper setObject:objv forKey:key1];
//        }
//
        
        //数据包尾部中加入 令牌参数
        // if(![[list_upper allKeys] containsObject:@"sign"])
//        [list_upper setObject:[self getSysToken] forKey:@"token"];
        NSMutableArray *newkeysArr = [NSMutableArray arrayWithArray:keys];
        [newkeysArr addObject:@"token"];
        NSMutableArray *newValuesArr = [NSMutableArray arrayWithArray:values];
        [newValuesArr addObject:[self getSysToken]];
        // [[list_upper objectForKey:@"sign"] addObject:[self getSysToken]];
        //生成 sign
//        NSString *lowerstr = [[self Getmd5:[self DictToUrlParame:list_upper array:arr]] lowercaseString];
        NSString *lowerstr = [[self Getmd5:[self getMD5String:newkeysArr andValues:newValuesArr]] lowercaseString];

        NSString * signstr=@"";
        //【16 – 19】 +【 4 - 7 】+【 6 - 9 】+【 14 - 17 】
        // lowerstr= _md5Str = _md5Str.Substring(16, 4) + _md5Str.Substring(4, 4) + _md5Str.Substring(6, 4) + _md5Str.Substring(14, 4);
        // signstr= [lowerstr substringWithRange:NSMakeRange(16,4)];
        signstr=[signstr stringByAppendingString:[lowerstr substringWithRange:NSMakeRange(16,4)]];
        signstr=[signstr stringByAppendingString:[lowerstr substringWithRange:NSMakeRange(4,4)]];
        signstr=[signstr stringByAppendingString:[lowerstr substringWithRange:NSMakeRange(6,4)]];
        signstr=[signstr stringByAppendingString:[lowerstr substringWithRange:NSMakeRange(14,4)]];
        return  signstr;
    }
    @catch (NSException * e)
    {
        NSLog(@"Exception: %@", e);
        return nil;
    }
}



/// <summary>
/// 生成 sign
/// </summary>
/// <param name="dict_data"></param>
/// <returns></returns>
+(NSString *) GetSignStr:(NSDictionary *) dict_data paixu:(NSMutableArray *) paixu
{
    @try
    {
        //大写参数
        
        NSMutableDictionary *list_upper = [NSMutableDictionary dictionary];
        //小写参数
        NSMutableDictionary *list_lower = [NSMutableDictionary dictionary];
        
        NSEnumerator * enumeratorKey = [dict_data keyEnumerator];
        //得到词典中所有Value值
        for (NSObject *obj in enumeratorKey) {
            //通过KEY找到value
            NSObject *objv = [dict_data objectForKey:obj];
            NSString * key=(NSString *)obj;
            
            if (![ [key lowercaseString]  isEqual: @"sign"])
            {
                if (! [self IsLower:key])
                {
                    //  list_upper.Add(item + "", dict_data[item.ToString()] + "");
                    
                    [list_upper setObject:objv forKey:key];
                }
                else
                {
                    
                    [list_lower setObject:objv forKey:key];
                }
                
            }
        }
        
        
        NSEnumerator * enumeratorKey1 = [list_lower keyEnumerator];
   
      
        for (NSObject *obj1 in enumeratorKey1)
        {
            NSObject *objv = [dict_data objectForKey:obj1];
            NSString * key1=(NSString *)obj1;
            [list_upper setObject:objv forKey:key1];
        }
        
        //数据包尾部中加入 令牌参数
        // if(![[list_upper allKeys] containsObject:@"sign"])
        [list_upper setObject:[self getSysToken] forKey:@"token"];
        
        // [[list_upper objectForKey:@"sign"] addObject:[self getSysToken]];
        //生成 sign
        NSString *lowerstr = [[self Getmd5:[self DictToUrlParame:list_upper array:paixu]] lowercaseString];
        NSString * signstr=@"";
        //【16 – 19】 +【 4 - 7 】+【 6 - 9 】+【 14 - 17 】
        // lowerstr= _md5Str = _md5Str.Substring(16, 4) + _md5Str.Substring(4, 4) + _md5Str.Substring(6, 4) + _md5Str.Substring(14, 4);
        // signstr= [lowerstr substringWithRange:NSMakeRange(16,4)];
        signstr=[signstr stringByAppendingString:[lowerstr substringWithRange:NSMakeRange(16,4)]];
        signstr=[signstr stringByAppendingString:[lowerstr substringWithRange:NSMakeRange(4,4)]];
        signstr=[signstr stringByAppendingString:[lowerstr substringWithRange:NSMakeRange(6,4)]];
        signstr=[signstr stringByAppendingString:[lowerstr substringWithRange:NSMakeRange(14,4)]];
        return  signstr;
    }
    @catch (NSException * e)
    {
        NSLog(@"Exception: %@", e);
        return nil;
    }
}
/// <summary>
/// 验证 sign 是否正确
/// </summary>
/// <returns></returns>
+(BOOL)  IsSignStr:(NSDictionary *) dict_data sign: (NSString *) sign
{
    if ([sign  isEqual: @""])
    {
        return FALSE;
    }
    NSString * current_sign =[self GetSignStr:dict_data ];
    if (current_sign == nil)
    {
        return FALSE;
    }
    if ([current_sign  isEqual: @""])
    {
        return FALSE;
    }
    if (current_sign == sign)
    {
        return TRUE;
    }
    return FALSE;
}

/// <summary>
/// 首字母是否为小写
/// </summary>
/// <param name="str">str</param>
/// <returns></returns>
+(BOOL)  IsLower:(NSString * )str
{
 //   NSMutableArray *array = [[NSMutableArray alloc] init];
  //  NSString *str = @"password";

       // [array addObject:[NSNumber numberWithChar:[str characterAtIndex:i]]];
        NSNumber  *a1=   [NSNumber numberWithChar:[str characterAtIndex:0]];
        if(a1>= [NSNumber numberWithChar:'a']&&a1<= [NSNumber numberWithChar:'z'])
        {
         return TRUE;
        }
        else if(a1>= [NSNumber numberWithChar:'A']&&a1<= [NSNumber numberWithChar:'Z'])
            return FALSE;
    
    return TRUE;
}

/// <summary>
/// 将键值对 转换 生成 url 参数
/// </summary>
/// <param name="dict_data"></param>
/// <returns></returns>
+(NSString *)  DictToUrlParame:(NSDictionary *)dict_data array:(NSArray *)array
{
    NSString *url_parame = @"";
    //得到词典中所有Value值
//   NSEnumerator * enumeratorValue = [dict_data objectEnumerator];
    int k=0;
    //NSMutableArray *array1 = [[NSMutableArray alloc] initWithCapacity:0];
   // for (NSObject *obj in enumeratorKey) {
   //     [array1 addObject:obj];
   // }
 //   array1 = [array1 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
  //      NSComparisonResult result = [obj1 compare: obj2];
        //obj1 compare obj2 是正序排列
  //      return result;
  //  }];
    
    for (NSString *obj in array) {
       // NSLog(@"遍历KEY的值: %@",object);
        //通过KEY找到value
        NSObject *objv = [dict_data objectForKey:obj];
        if(![obj isEqual:@"sign"])
        {
         if (k!=0)
         {
            url_parame=[url_parame stringByAppendingString:@"&"];
         }
          url_parame = [url_parame stringByAppendingFormat:@"%@=%@",obj, objv];
          k++;
            
        }
    }
    if(array.count>0)
        url_parame = [url_parame stringByAppendingFormat:@"&%@=%@",@"token", [dict_data objectForKey:@"token"]];
    else
        url_parame = [url_parame stringByAppendingFormat:@"%@=%@",@"token", [dict_data objectForKey:@"token"]];
   //  url_parame = [url_parame stringByAppendingFormat:@"&%@=%@",@"sign", [dict_data objectForKey:@"sign"]];
    return url_parame;
}
//获取用于MD5加密的字符串
+(NSString *)getMD5String:(NSArray *)keys andValues:(NSArray *)values
{
    NSString *urlParame = @"";
    for (int i=0; i<keys.count; i++) {
        if (i!=keys.count-1) {
            urlParame =[urlParame stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",keys[i],values[i]]];

        }else{
            urlParame = [urlParame stringByAppendingString:[NSString stringWithFormat:@"%@=%@",keys[i],values[i]]];
        }
    }
    return urlParame;
}
//字符串进行 BASEPAGE64 编码
+(NSString *)Getmd5:(NSString *)str {
   
    NSData *encodeData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
    const char* cStr = [base64String UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    
    return ret;
}


/// <summary>
/// 将对象属性转换为key-value对  获取对象的所有属性
/// </summary>
/// <param name="o">对象</param>
/// <returns></returns>
+(NSDictionary *) ObjToDictionary:(NSObject *) o
{
 //   Dictionary<String, Object> map = new Dictionary<string, object>();
    

    NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
    
   // NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([o class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [map setObject:propertyValue forKey:propertyName];
    }

    return map;
}

+(NSString*)encodeString:(NSString*)unencodedString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

//URLDEcode
+(NSString *)decodeString:(NSString*)encodedString

{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

+(NSDictionary *) postURL:(NSString *) urlstr
{
    
    
    NSURL *url = [NSURL URLWithString:urlstr];
    //  __block NSString *resault=@"";
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30];
    [urlRequest setHTTPMethod:@"POST"];
    
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *returndata = [NSURLConnection sendSynchronousRequest:urlRequest
                                               returningResponse:&response
                                                           error:&error];
    
     NSDictionary *content = [NSJSONSerialization JSONObjectWithData:returndata options:NSJSONReadingMutableContainers error:nil];//转换数据格式
    
    return content;
    
    
    
}

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
+ (NSMutableDictionary *)getURLParameters:(NSString *)urlStr {
    
    // 查找参数
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}

@end
