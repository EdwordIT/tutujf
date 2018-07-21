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
+ (BOOL)checkUserIdCard: (NSString *) userID
{
    //长度不为18的都排除掉
    if (userID.length!=18) {
        return NO;
    }
    
    //校验格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL flag = [identityCardPredicate evaluateWithObject:userID];
    
    if (!flag) {
        return flag;    //格式错误
    }else {
        //格式正确在判断是否合法
        
        //将前17位加权因子保存在数组里
        NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;
        for(int i = 0;i < 17;i++)
        {
            NSInteger subStrIndex = [[userID substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            
            idCardWiSum+= subStrIndex * idCardWiIndex;
            
        }
        
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        
        //得到最后一位身份证号码
        NSString * idCardLast= [userID substringWithRange:NSMakeRange(17, 1)];
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2)
        {
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
            {
                return YES;
            }else
            {
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
//    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//    BOOL isMatch = [pred evaluateWithObject:idCard];
//    return isMatch;
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
  
    if (telNumber.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[0-9]|5[0-9]|6[0-9]|7[0-9]|8[0-9]|9[0-9])\\d{8}$";
   


    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];


    if ([regextestmobile evaluateWithObject:telNumber] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
/**
 获取字符串中的数字内容
 */
+(NSString *)getNumberFromString:(NSString *)str{
    NSScanner *scanner = [NSScanner scannerWithString:str];
    
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    
    float number;
    
    [scanner scanFloat:&number];
    
    NSString *num=[NSString stringWithFormat:@"%.2f",number];
    
    return num;
}
+(BOOL)isNumber:(NSString *)str {
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if (str.length>0) {
        //带小数点的数字
        if ([str isEqualToString:@"."]) {
            return YES;
        }else
            return NO;
    }
    return YES;
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
+(NSString*)getPhoneModel
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
 是否已经托管到汇付
 */
+(BOOL)isTrustReg{
    NSString *str = [TTJFUserDefault strForKey:isReged];
    if (IsEmptyStr(str)||[str isEqualToString:@"-1"]) {
        return NO;
    }else
    return YES;
}
/**
 是否实名认证过
 */
+(BOOL)isVerifyRealName{
   
    NSString *str = [TTJFUserDefault strForKey:isCertificationed];
    if (IsEmptyStr(str)||[str isEqualToString:@"-1"]) {
        return NO;
    }else
        return YES;
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
    NSTimeInterval timeInterval = [creat timeIntervalSinceDate:nowDate];
    
    if (timeInterval<=0) {
        return 0;
    }else{
        return [[NSString stringWithFormat:@"%.0f",timeInterval] integerValue];
    }
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//    NSDateComponents *compas = [calendar components:unit fromDate:nowDate toDate:creat options:0];
//
//
//    NSInteger day= [compas day];
//    NSInteger mounth = [compas month];
//    NSInteger year = [compas year];
//    NSInteger hour = [compas hour];
//    NSInteger minute = [compas minute];
//    NSInteger second = [compas second];
//    if(day<0)
//        return 0;
//    NSInteger sss= [compas second]+compas.hour*HOUR+[compas minute]*MINUTE+day*DAY;
//    if(sss<0)
//        return 0;
//    return sss;
}
//获取倒计时字符串
+(NSString *)getCountDownTime:(NSInteger)timeInval
{
    NSInteger hour=timeInval/HOUR;
    NSInteger day=(hour-(hour%24))/24;
    
    NSString *str_day = [NSString stringWithFormat:@"%ld",day];
    NSString *str_hour = [NSString stringWithFormat:@"%ld",hour%24];
    NSString *str_minute = [NSString stringWithFormat:@"%ld",(timeInval%HOUR)/MINUTE];
    NSString *str_second = [NSString stringWithFormat:@"%ld",timeInval%MINUTE];
    //修改倒计时标签现实内容
    NSString * countDown=[NSString stringWithFormat:@"%@天%@时%@分%@秒",str_day,str_hour,str_minute, str_second];
    if ([[countDown substringToIndex:2] isEqualToString:@"0天"]) {
        countDown = [countDown stringByReplacingOccurrencesOfString:@"0天" withString:@""];
    }
    if ([[countDown substringToIndex:2] isEqualToString:@"0时"]) {
        countDown = [countDown stringByReplacingOccurrencesOfString:@"0时" withString:@""];
    }
    if ([[countDown substringToIndex:2] isEqualToString:@"0分"]) {
        countDown = [countDown stringByReplacingOccurrencesOfString:@"0分" withString:@""];
    }
    
    return countDown;
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

/**
 获取千分位的数字字符串
 */
+(NSString *)getHanleNums:(NSString *)numbers{
   
    NSString *resault ;
    if ([numbers isEqualToString:@"-"]) {
        return resault;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    if ([numbers rangeOfString:@"."].location!=NSNotFound) {
        [formatter setPositiveFormat:@"###,##0.00"];//千分位格式
    }else
        [formatter setPositiveFormat:@"###,##0"];//千分位格式,带小数点

    resault = [formatter stringFromNumber:[NSNumber numberWithDouble:[numbers doubleValue]]];//此处使用doublevale，防止失真
    return resault;

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
//给view添加渐变色
+(void)addGradientLayer:(UIView *)view startColor:(UIColor *)startColor endColor:(UIColor *)endColor withDirection:(GradientDirectionType)direction
{
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    
    if (direction==DirectionFromTop) {//从上到下
        gradientLayer.startPoint = CGPointMake(0.5, 0);//绘图起始点（x/Y）//顶部中间位置
        gradientLayer.locations = @[@(0.5),@(1.0)];
        gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    }else{
        gradientLayer.startPoint = CGPointMake(0, 0.5);//绘图起始点（x/Y）//左边距中间位置
        gradientLayer.locations = @[@(0.5),@(1.0)];
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    }
    gradientLayer.frame = view.bounds;
    [view.layer addSublayer:gradientLayer];
}
/**
 设置字符串的字体大小和颜色
 
 @param string 当前处理的可变字符串
 @param range range
 @param fontValue 字体
 @param colorString 颜色
 @param spacingBeforeValue 首行缩进
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
        
        [attributeString addAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle} range:range];
        if (color!=nil) {
             [attributeString addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
       
    }
    return attributeString;
}

//获取随机数
+ (NSString *)getRandomStringWithNum:(NSInteger)num
{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < num; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}
@end
