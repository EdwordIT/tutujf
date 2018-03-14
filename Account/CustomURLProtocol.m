//
//  CustomURLProtocol.m
//  NSURLProtocolExample
//
//  Created by lujb on 15/6/15.
//  Copyright (c) 2015年 lujb. All rights reserved.
//

#import "CustomURLProtocol.h"
//#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import "AppDelegate.h"

static NSString * const URLProtocolHandledKey = @"URLProtocolHandledKey";

@interface CustomURLProtocol ()<NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLConnection *connection;

@end

//static HttpDnsService *httpdns;

@implementation CustomURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame))
    {
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request]) {
            return NO;
        }
        
        return YES;
    }
    return NO;
}

+ (NSURLRequest *) canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    mutableReqeust = [self redirectHostInRequset:mutableReqeust];
    return mutableReqeust;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading
{
    /* 如果想直接返回缓存的结果，构建一个NSURLResponse对象
     if (cachedResponse) {
     
     NSData *data = cachedResponse.data; //缓存的数据
     NSString *mimeType = cachedResponse.mimeType;
     NSString *encoding = cachedResponse.encoding;
     
     NSURLResponse *response = [[NSURLResponse alloc] initWithURL:self.request.URL
     MIMEType:mimeType
     expectedContentLength:data.length
     textEncodingName:encoding];
     
     [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
     [self.client URLProtocol:self didLoadData:data];
     [self.client URLProtocolDidFinishLoading:self];
     */
    
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    
    //打标签，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:mutableReqeust];
    
    self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
}

- (void)stopLoading
{
    [self.connection cancel];
}

#pragma mark - NSURLConnectionDelegate

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

#pragma mark -- private

+(NSMutableURLRequest*)redirectHostInRequset:(NSMutableURLRequest*)request
{
    if ([request.URL host].length == 0) {
        return request;
    }
    
    NSString *originUrlString = [request.URL absoluteString];
    NSString *originHostString = [request.URL host];
    NSRange hostRange = [originUrlString rangeOfString:originHostString];
    if (hostRange.location == NSNotFound) {
        return request;
    }
    
 
    //定向到bing搜索主页
  //  NSString *ip = originUrlString;
      if([originHostString rangeOfString:@".tutujf.com"].location != NSNotFound)
   {
     //ip = @"mshop.dingxindai.com";
        return request;
   }
    else  if([originHostString rangeOfString:@"ufunds.ips.com.cn"].location != NSNotFound)
    {
      
         return request;
        
    }
    else  if([originHostString rangeOfString:@"http://mertest.chinapnr.com"].location != NSNotFound)
    {
        
        return request;
        
    }
    else  if([originHostString rangeOfString:@"https://lab.chinapnr.com"].location != NSNotFound)
    {
        
        return request;
        
    }
    
    else  if([originHostString rangeOfString:@"qq.com"].location != NSNotFound)
    {
        return request;
    }
    else if([originHostString rangeOfString:@"log.umsns.com"].location != NSNotFound)
    {
      return request;
    }
    else if([originHostString rangeOfString:@"api.share.mob.com"].location != NSNotFound)
    {
        return request;
    }
   else if([originHostString rangeOfString:@"61.160.200.242"].location != NSNotFound)
    {
          NSURL *url = [NSURL URLWithString:[urlCheckAddress stringByAppendingString:@"/wap/member/index"]];
          request.URL = url;
        return request;
    }
   else if([originHostString rangeOfString:@"222.186.61.91"].location != NSNotFound)
   {
       NSURL *url = [NSURL URLWithString:[urlCheckAddress stringByAppendingString:@"/wap/member/index"]];
       request.URL = url;
       return request;
   }
    else if([originHostString rangeOfString:@"dx.daomengad.com"].location != NSNotFound)
    {
        NSURL *url = [NSURL URLWithString:[urlCheckAddress stringByAppendingString:@"/wap/member/index"]];
        request.URL = url;
        return request;
    }
    else if([originHostString rangeOfString:@"hl.quw18.com"].location != NSNotFound)
    {
        NSURL *url = [NSURL URLWithString:[urlCheckAddress stringByAppendingString:@"/wap/member/index"]];
        request.URL = url;
        return request;
    }
    else if([originHostString rangeOfString:@"dx01.daomengad.com"].location != NSNotFound)
    {
        NSURL *url = [NSURL URLWithString:[urlCheckAddress stringByAppendingString:@"/wap/member/index"]];
        request.URL = url;
        return request;
    }
    else  if([originHostString rangeOfString:@".tutujf.com"].location != NSNotFound)
    {
        return request;
    }
    else
    {
        
        
        
        return request;
    }
    
    // 替换host
  
    
    return request;
}


@end
