//
//  NSHelper.m
//  SmartLink
//
//  Created by xtmac on 5/2/15.
//  Copyright (c) 2015年 xtmac. All rights reserved.
//

#import "NSHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import "WaitView.h"

@implementation NSHelper{
    WaitView *_waitView;
}

+(NSHelper*)sharedHelper{
    static NSHelper *sharedHelper = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedHelper = [[NSHelper alloc] init];
    });
    
    return sharedHelper;
}

+(CGRect)getScreenRectIsNavigation:(BOOL)isNavigation isHorizontal:(BOOL)isHorizontal{
    CGRect rect = [UIScreen mainScreen].bounds;
    
    rect.size.width = rect.size.width < rect.size.height ? rect.size.width : rect.size.height;
    rect.size.height = rect.size.width > rect.size.height ? rect.size.width : rect.size.height;
    
    if (isHorizontal) {
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.height, rect.size.width);
    }
    
    if (isNavigation) {
        rect = CGRectMake(rect.origin.x, rect.origin.y + 44, rect.size.width, rect.size.height - 44);
    }
    
    if (!ISBEFOREOFIOS7) {
        rect = CGRectMake(rect.origin.x, rect.origin.y + 20, rect.size.width, rect.size.height - 20);
    }
    
    return rect;
}

+(CGSize)getScreenSizeIsNavigation:(BOOL)isNavigation isHorizontal:(BOOL)isHorizontal{
    return [self getScreenRectIsNavigation:isNavigation isHorizontal:isHorizontal].size;
}

+(CGPoint)getScreenOriginIsNavigation:(BOOL)isNavigation isHorizontal:(BOOL)isHorizontal{
    return [self getScreenRectIsNavigation:isNavigation isHorizontal:isHorizontal].origin;
}

+(CGFloat)getScreenWidthIsNavigation:(BOOL)isNavigation isHorizontal:(BOOL)isHorizontal{
    return [self getScreenSizeIsNavigation:isNavigation isHorizontal:isHorizontal].width;
}

+(CGFloat)getScreenHeightIsNavigation:(BOOL)isNavigation isHorizontal:(BOOL)isHorizontal{
    return [self getScreenSizeIsNavigation:isNavigation isHorizontal:isHorizontal].height;
}

//邮箱正则表达式
+(BOOL)validateEmail:(NSString *)email{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//特殊字符正则表达式
+(BOOL)validateSpecialCharacter:(NSString *)chr{
    NSString *passwordRegex = @"^[a-zA-Z0-9_]+$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passwordTest evaluateWithObject:chr];
}

//md5运算
+(NSString*)md5:(NSString*)input{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

-(void)showAlertControllerWithTitle:(NSString*)title withMsg:(NSString*)msg{
    [self showAlertControllerWithTitle:title withMsg:msg target:[self appRootViewController]];
}

-(void)showAlertControllerWithTitle:(NSString*)title withMsg:(NSString*)msg target:(id)target{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:alertAction];
    [target presentViewController:alertController animated:YES completion:nil];
}

-(void)showWaitViewWithHint:(NSString *)hint{
    if (!_waitView) {
        _waitView = [[WaitView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [[self appRootViewController].view addSubview:_waitView];
//        [[UIApplication sharedApplication].keyWindow addSubview:_waitView];
    }
    [_waitView setLabelText:hint];
}

-(void)removeWaitView{
    [_waitView removeFromSuperview];
    _waitView = nil;
}

@end
