//
//  CommonUtils.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/9.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+HexString.h"
@interface CommonUtils : NSObject

typedef enum{
    DirectionFromLeft,//渐变色方向
    DirectionFromTop
}GradientDirectionType;
#define HEXCOLOR(c) [UIColor colorWithHexString:c]
/**
 获取手机型号
 */
+(NSString*)getDeviceVersion;
/**
 获取手机UUID
 */
+(NSString *)getUUID;
/**
 获取手机deviceToken
 */
+(NSString *)getDeviceToken;
/**
 获取当前时间戳
 */
+(NSString *)getCurrentTimestamp;
//上送token（非用户唯一标示，为校验码）
+(NSString *)getToken;

+(NSString *)getUsername;

+(NSString *)getNikename;
//获取版本号
+(NSString *)getVersion;
//判断是否登录
+(BOOL)isLogin;
//是否已经托管到汇付
+(BOOL)isTrustReg;
//是否实名认证过
+(BOOL)isVerifyRealName;
//是否需要版本升级
+(BOOL)isUpdate;
//判断中英混合的的字符串长度
+ (int)convertToInt:(NSString*)strtemp;
//校验字符串是否含空格
+ (BOOL)checkEmptyString:(NSString *)string ;
//校验是否是数字
+(BOOL)isNumber:(NSString *)str;
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
/*******************缓存处理***********************************************/
//加入缓存
+ (void)cacheDataWithObject:(NSDictionary *)object WithPathName:(NSString *)withPathName;
//通过key值取得缓存数据
+(NSDictionary *)getCacheDataWithKey:(NSString *)cacheKey;
//移除特定缓存
+(void)removeCacheWithKey:(NSString *)cacheKey;
//移除所有缓存内容
+(void)removeAllCache;
/*******************常用方法***********************************************/
/**
 获取千分位的数字
 */
+(NSString *)getHanleNums:(NSString *)numbers;

/**
 获取根视图控制器
 */
+ (UIViewController *)appRootViewController;
/**
 系统自带提示框显示
 */
+(void)showAlerWithTitle:(NSString*)title withMsg:(NSString*)msg;
/*!
 *                      获取时间差
 *
 *  @param fromdate     起始时间
 *  @param todate       结束时间
 *
 *  @return             时间差(秒)
 */
+ (int)getSecondForFromDate:(NSDate *)fromdate toDate:(NSDate *)todate;
/*!
 *                      获取给定时间到当前时间的时间差
 *  @param todate       结束时间
 *  @return             时间差(秒)
 */
+ (NSInteger)getDifferenceByDate:(NSString *)creat_time;
/**
 获取倒计时显示字符串
 */
+(NSString *)getCountDownTime:(NSInteger)timeInval;
/**
带有行间距的label的高度
 */
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width lineSpace:(CGFloat)lineSpace;
/**设置带圆角带阴影*/
+(void)setShadowCornerRadiusToView:(UIView *)view;
//给view添加渐变色
+(void)addGradientLayer:(UIView *)view startColor:(UIColor *)startColor endColor:(UIColor *)endColor withDirection:(GradientDirectionType)direction;
/**
 设置带有行间距的label
 */
+(void)setAttString:(NSString *)title withLineSpace:(CGFloat)space titleLabel:(UILabel *) titleLabel;

/**
 设置字符串的字体大小和颜色
 
 @param string 当前处理的可变字符串
 @param range range
 @param fontValue 字体大小
 @param colorString 颜色
 @return
 */
+ (NSMutableAttributedString *)diffierentFontWithString:(NSString *)string rang:(NSRange)range font:(UIFont *)font color:(UIColor *)color spacingBeforeValue:(CGFloat)spacingBeforeValue lineSpace:(CGFloat)lineSpace;
@end
