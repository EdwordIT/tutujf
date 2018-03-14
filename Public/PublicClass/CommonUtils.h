//
//  CommonUtils.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/9.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtils : NSObject
//手机号识别
+ (BOOL)isAvaliableNumber:(NSString *)mobileNum;
//上送token（非用户唯一标示，为校验码）
+(NSString *)getToken;
//获取版本号
+(NSString *)getVersion;
//判断是否登录
+(BOOL)isLogin;
//判断中英混合的的字符串长度
+ (int)convertToInt:(NSString*)strtemp;
//校验字符串是否含空格
+ (BOOL)checkEmptyString:(NSString *)string ;
//******************************输入内容正确性校验*****************************************//
#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;
#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;
#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName;
#pragma 正则匹配用户身份证号
+ (BOOL)checkUserIdCard: (NSString *) idCard;
#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url;
@end
