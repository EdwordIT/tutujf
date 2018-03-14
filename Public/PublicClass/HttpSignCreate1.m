//
//  HttpSignCreate1.m
//  TTJF
//
//  Created by 占碧光 on 2017/5/23.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "HttpSignCreate1.h"
#import <objc/runtime.h>

@implementation HttpSignCreate1

+(NSString *) getSysToken
{
    
    return @"!Y9v9OK41w(2";
}

/// <summary>
/// 生成 sign
/// </summary>
/// <param name="dict_data"></param>
/// <returns></returns>
+(NSString *) GetSignStr:(NSMutableDictionary *) dict_data array:(NSArray *)array
{
    @try
    {
        //数据包尾部中加入 令牌参数
        // if(![[list_upper allKeys] containsObject:@"sign"])
        [dict_data setObject:[self getSysToken] forKey:@"sign"];
        
        // [[list_upper objectForKey:@"sign"] addObject:[self getSysToken]];
        //生成 sign
        NSString *lowerstr = [[self Getmd5:[self DictToUrlParame:dict_data array:array]] lowercaseString];
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
+(BOOL)  IsSignStr:(NSDictionary *) dict_data sign: (NSString *) sign array:(NSArray *)array
{
    if ([sign  isEqual: @""])
    {
        return FALSE;
    }
    NSString * current_sign =[self GetSignStr:dict_data array:array];
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
    NSEnumerator * enumeratorKey = [dict_data keyEnumerator];
    //得到词典中所有Value值
    //   NSEnumerator * enumeratorValue = [dict_data objectEnumerator];
    int k=0;
  
 
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
    if(array.count>1)
        url_parame = [url_parame stringByAppendingFormat:@"&%@=%@",@"token", [dict_data objectForKey:@"sign"]];
    else
        url_parame = [url_parame stringByAppendingFormat:@"%@=%@",@"token", [dict_data objectForKey:@"sign"]];
    //  url_parame = [url_parame stringByAppendingFormat:@"&%@=%@",@"sign", [dict_data objectForKey:@"sign"]];
    return url_parame;
}


+(NSString *)Getmd5:(NSString *)str {
    /*
     const char *cStr = [str UTF8String];//转换成utf-8
     unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
     CC_MD5( cStr, strlen(cStr), result);
     /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    /*
     return [NSString stringWithFormat:
     @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
     result[0], result[1], result[2], result[3],
     result[4], result[5], result[6], result[7],
     result[8], result[9], result[10], result[11],
     result[12], result[13], result[14], result[15]
     ];
     */
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    /*
     
     NSMutableString *Mstr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
     for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
     [Mstr appendFormat:@"%d",(char)result[i]];
     }
     return Mstr;
     */
    const char* cStr = [str UTF8String];
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

@end

