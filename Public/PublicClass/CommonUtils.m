//
//  CommonUtils.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/9.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "CommonUtils.h"
#import <YYCache.h>
#import <sys/utsname.h>
@implementation CommonUtils

//******************************输入内容正确性校验*****************************************//
#pragma 正则匹配用户密码6-15位数字和字母和符号的组合
+ (BOOL)checkPassword:(NSString *) password
{
        NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,15}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    
    return isMatch;
    
}

#pragma 正则匹配用户姓名,8位的中文或英文或数字
+ (BOOL)checkUserName : (NSString *) userName
{
    //    NSString *pattern = @"^[\u4e00-\u9fa5]{1,8}$|^[0-9A-Za-z]{1,16}$";
    NSString *pattern = @"^[0-9a-zA-Z\u4E00-\u9FA5]{1,8}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
    
}


#pragma 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}
#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url
{
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
}

//手机号识别
+ (BOOL)checkTelNumber:(NSString *)telNumber{
  
//    if (telNumber.length != 11)
//    {
//        return NO;
//    }
//    /**
//     * 手机号码:
//     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
//     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
//     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
//     * 电信号段: 133,153,180,181,189,177,1700
//     */
//    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
//    /**
//     * 中国移动：China Mobile
//     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
//     */
//    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
//    /**
//     * 中国联通：China Unicom
//     * 130,131,132,155,156,185,186,145,176,1709
//     */
//    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
//    /**
//     * 中国电信：China Telecom
//     * 133,153,180,181,189,177,1700
//     */
//    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
//
//
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//
//    if (([regextestmobile evaluateWithObject:telNumber] == YES)
//        || ([regextestcm evaluateWithObject:telNumber] == YES)
//        || ([regextestct evaluateWithObject:telNumber] == YES)
//        || ([regextestcu evaluateWithObject:telNumber] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
    return YES;//测试需要
}
/*******************缓存处理***********************************************/
/**
 加入缓存
 */
+ (void)cacheDataWithObject:(NSDictionary *)object WithPathName:(NSString *)withPathName{
    YYCache *yyCache=[YYCache cacheWithName:@"TTJFCache"];
    //根据key写入缓存value
    [yyCache setObject:object forKey:withPathName];
}
/**
 通过key值取得缓存数据
 */
+(NSDictionary *)getCacheDataWithKey:(NSString *)cacheKey{
    YYCache *yyCache=[YYCache cacheWithName:@"TTJFCache"];
    return (NSDictionary *)[yyCache objectForKey:cacheKey];
}
/**
移除特定缓存
 */
+(void)removeCacheWithKey:(NSString *)cacheKey{
    YYCache *yyCache=[YYCache cacheWithName:@"TTJFCache"];
    [yyCache removeObjectForKey:cacheKey];
    
}
/**
 移除所有缓存
 */
+(void)removeAllCache{
    YYCache *yyCache=[YYCache cacheWithName:@"TTJFCache"];
    [yyCache removeAllObjects];
}
//移除所有缓存内容
//**************************获取当前版本号*********************************************//
+(NSString *)getVersion{
    NSString *version = [TTJFUserDefault strForKey:kVersion];
    if (IsEmptyStr(version)) {
        return @"";
    }else{
        return version;
    }
}
+(NSString *)getUUID{
    NSString *uuid = [TTJFUserDefault strForKey:@"ttjf_uuid"];
    if (uuid==nil) {
        uuid =  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [TTJFUserDefault setStr:uuid key:@"ttjf_uuid"];
        return uuid;
    }else
        return [TTJFUserDefault strForKey:@"ttjf_uuid"];
}
//获取手机型号
+(NSString*)getDeviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * phoneType = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if([phoneType  isEqualToString:@"iPhone4,1"])  return@"iPhone 4S";
    
    if([phoneType  isEqualToString:@"iPhone5,1"])  return@"iPhone 5";
    
    if([phoneType  isEqualToString:@"iPhone5,2"])  return@"iPhone 5";
    
    if([phoneType  isEqualToString:@"iPhone5,3"])  return@"iPhone 5c";
    
    if([phoneType  isEqualToString:@"iPhone5,4"])  return@"iPhone 5c";
    
    if([phoneType  isEqualToString:@"iPhone6,1"])  return@"iPhone 5s";
    
    if([phoneType  isEqualToString:@"iPhone6,2"])  return@"iPhone 5s";
    
    if([phoneType  isEqualToString:@"iPhone7,1"])  return@"iPhone 6 Plus";
    
    if([phoneType  isEqualToString:@"iPhone7,2"])  return@"iPhone 6";
    
    if([phoneType  isEqualToString:@"iPhone8,1"])  return@"iPhone 6s";
    
    if([phoneType  isEqualToString:@"iPhone8,2"])  return@"iPhone 6s Plus";
    
    if([phoneType  isEqualToString:@"iPhone8,4"])  return@"iPhone SE";
    
    if([phoneType  isEqualToString:@"iPhone9,1"])  return@"iPhone 7";
    
    if([phoneType  isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    
    if([phoneType  isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([phoneType  isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([phoneType  isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([phoneType  isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([phoneType  isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([phoneType  isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    

    return @"iPhone";
}
/**
 获取当前时间戳
 */
+(NSString *)getCurrentTimestamp{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;

}
//**************************获取token*********************************************//
+(NSString *)getToken{
    NSString *token = [TTJFUserDefault strForKey:kToken];
    if (IsEmptyStr(token)) {
        return @"";
    }else{
        return token;
    }
}
+(NSString *)getDeviceToken{
    NSString *token = [TTJFUserDefault strForKey:kDeviceToken];
    if (IsEmptyStr(token)) {
        return [self getUUID];
    }else{
        return token;
    }
}
//**************************获取userName*********************************************//
+(NSString *)getUsername{
    NSString *username = [TTJFUserDefault strForKey:kUsername];
    if (IsEmptyStr(username)) {
        return @"";
    }else{
        return username;
    }
}
/**获取昵称*/
+(NSString *)getNikename
{
    NSString *nikename = [TTJFUserDefault strForKey:kNikename];
    if (IsEmptyStr(nikename)) {
        return @"";
    }else{
        return nikename;
    }
}
//是否登录
+(BOOL)isLogin
{
   NSString *token = [TTJFUserDefault strForKey:kToken];
    if (!IsEmptyStr(token)) {
        return YES;
    }else
        return NO;
   
}

//是否需要版本升级
+(BOOL)isUpdate{
    NSString *version = [TTJFUserDefault strForKey:kVersion];
    if (IsEmptyStr(version)) {
        return NO;
    }else{
        if ([version isEqualToString:currentVersion]) {
            return NO;
        }else{
            return YES;
        }
    }
}
/**
 是否实名认证过
 */
+(BOOL)isVerifyRealName{
    BOOL isCer = [TTJFUserDefault boolForKey:isCertificationed];
    
    return isCer;
}
/*! 获取时间差(秒) */
+ (int)getSecondForFromDate:(NSDate *)fromdate toDate:(NSDate *)todate {
    NSTimeInterval fromInt = [fromdate timeIntervalSince1970];  // 获取离1970年间隔
    NSTimeInterval toInt = [todate timeIntervalSince1970];
    
    NSTimeInterval interval = toInt - fromInt;  // 获取时间差值
    return interval*1;
}
//获取时间差（48小时内需要倒计时显示）
+ (NSInteger)getDifferenceByDate:(NSString *)creat_time {
    if (IsEmptyStr(creat_time)) {
        return 0;
    }
    NSDate *nowDate = [NSDate date]; // 当前时间
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
    NSDate *creat = [formatter dateFromString:creat_time]; // 传入的时间
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *compas = [calendar components:unit fromDate:nowDate toDate:creat options:0];
    
    
    NSInteger day= [compas day];
    if(day<0)
        return 0;
    NSInteger sss= [compas second]+compas.hour*60*60+[compas minute]*60+day*24*60*60;
    if(sss<0)
        return 0;
    return sss;
}
+ (int)convertToInt:(NSString*)strtemp//判断中英混合的的字符串长度
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}
//判断字符串中是否包含空格
+ (BOOL)checkEmptyString:(NSString *)string {
    NSRange range = [string rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}

//判断是否为空或全为空格
+ (BOOL)isEmptyWithString:(NSString *)str {
    if (str == nil) {
        return YES;
    } else if (!str.length) {
        return  YES;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *string = [str stringByTrimmingCharactersInSet:set];
        if (string.length == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}
+ (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
+(void)showAlerWithTitle:(NSString*)title withMsg:(NSString*)msg{
    [self showAlertControllerWithTitle:title withMsg:msg target:[self appRootViewController]];
}

+(void)showAlertControllerWithTitle:(NSString*)title withMsg:(NSString*)msg target:(id)target{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:alertAction];
    [target presentViewController:alertController animated:YES completion:nil];
}
//动态获取label高度
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width lineSpace:(CGFloat)lineSpace{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    //获得带有行间距为2的高度
    paraStyle.lineSpacing = lineSpace;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //字间距为0
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.f
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, 999.f) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:dic context:nil].size;
    
    return size.height ;
}
/**
 设置带有行间距的内容
 */
+(void)setAttString:(NSString *)title withLineSpace:(CGFloat)space titleLabel:(UILabel *) titleLabel
{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:space];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
    
    titleLabel.attributedText = attributedString;
}
//设置带圆角带阴影
+(void)setShadowCornerRadiusToView:(UIView *)view{
    view.layer.cornerRadius = kSizeFrom750(10);
    
    view.layer.shadowColor = [UIColor grayColor].CGColor;
    
    view.layer.shadowOffset = CGSizeMake(0, kSizeFrom750(10));

    view.layer.shadowOpacity = 0.2;
    
    view.layer.shadowRadius = kSizeFrom750(8);
    
}
/**
 设置字符串的字体大小和颜色
 
 @param string 当前处理的可变字符串
 @param range range
 @param fontValue 字体
 @param colorString 颜色
 @return
 */
+ (NSMutableAttributedString *)diffierentFontWithString:(NSString *)string rang:(NSRange)range font:(UIFont *)font color:(UIColor *)color spacingBeforeValue:(CGFloat)spacingBeforeValue lineSpace:(CGFloat)lineSpace{
    if (IsEmptyStr(string)) {
        return [NSMutableAttributedString new];
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    if (string.length) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];
        paragraphStyle.hyphenationFactor = 1.0;
        paragraphStyle.firstLineHeadIndent = 0.0;
        paragraphStyle.paragraphSpacingBefore = spacingBeforeValue;
        paragraphStyle.headIndent = 0;
        paragraphStyle.tailIndent = 0;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attributeString addAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color, NSParagraphStyleAttributeName:paragraphStyle} range:range];
    }
    return attributeString;
}
@end
