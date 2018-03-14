//
//  Utils.m
//  P2PDemo
//
//  Created by huanxunIH1338 on 16/3/29.
//  Copyright © 2016年 huanxunIH1338. All rights reserved.
//

#import "Utils.h"
#import "GTMBase64.h"
@implementation Utils
//3DES加密
+ (NSString*)TripleDES:(NSString*)plainText
{
    //    NSString *desKey=@"e3vHRXdHAlE3uorYPYKJ8vx3";     //得到3DES密钥desKey=key.substr(0,24)
    //    NSString *desIv=@"MBHpnZPs";    //得到3DES向量desIv=key.substr (24)
    //    NSString *desKey=@"GJXRf1S2PX4lQvjaG1edW5Cb";     //得到3DES密钥desKey=key.substr(0,24)
    //    NSString *desIv=@"rsapSSKO";    //得到3DES向量desIv=key.substr (24)
    NSString *desKey=@"mLQEQmy53ffJXQBZNu6ShwkU";     //得到3DES密钥desKey=key.substr(0,24)
    NSString *desIv=@"vnlN5Dre";    //得到3DES向量desIv=key.substr (24)
    //将明文做3DES加密：encrypted=3des.encrypt(content,desKey,desIv)
    NSString* encrypted = [Utils TripleDES:plainText encryptOrDecrypt:kCCEncrypt key:desKey desIv:desIv];
    return encrypted;
}
//3DES加密，解密
+(NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key desIv:(NSString*)desIv{
    
    
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        //        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        NSData* EncryptData = [[NSData alloc] initWithBase64EncodedString:plainText options:0];//使用系统自带编码库
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
        
    }
    else
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    // CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    //uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [desIv UTF8String] ;
    
    CCCrypt(encryptOrDecrypt,
            kCCAlgorithm3DES,
            kCCOptionPKCS7Padding,
            vkey,
            kCCKeySize3DES,
            vinitVec,
            vplainText,
            plainTextBufferSize,
            (void *)bufferPtr,
            bufferPtrSize,
            &movedBytes);
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        //        result = [GTMBase64 stringByEncodingData:myData];
        result = [myData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//使用系统自带编码库
        
    }
    free(bufferPtr);
    return result;
    
    
}

//MD5 32位加密
+(NSString *)MD532: (NSString *)inPutText
{
    
    //const char *cStr = [inPutText  UTF8String];
    const char *cStr =[inPutText cStringUsingEncoding: NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

//签名
+(NSString *)MD5getSign:(NSString *)content
{
    NSLog(@"%s(%d):", __func__, __LINE__);NSLog(@"jsonStr is %@ ",content);
    NSString *desKey=@"mLQEQmy53ffJXQBZNu6ShwkU";     //得到3DES密钥desKey=key.substr(0,24)
    NSString *desIv=@"vnlN5Dre";    //得到3DES向量desIv=key.substr (24)
    NSString *DES = [NSString stringWithFormat:@"%@%@", desKey, desIv];
    NSString *Md5SignString=[content stringByAppendingString:DES];//(2.content+key)
    // MD5 签名
    NSString *Md5Sign=[Utils MD532:Md5SignString];//2. 得到签名 sign=md5(content+key)
    return Md5Sign;
}

@end
