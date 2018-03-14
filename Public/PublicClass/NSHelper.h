//
//  NSHelper.h
//  SmartLink
//
//  Created by xtmac on 5/2/15.
//  Copyright (c) 2015年 xtmac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ISBEFOREOFIOS7 ([[UIDevice currentDevice].systemVersion floatValue] <  7.0 ? true : false)
#define STATUSBAR_HEIGHT (ISBEFOREOFIOS7 ? 0 : 20)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define ISIPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? true : false)
#define NSLocalized(key) NSLocalizedString((key), @"")
#define NSHELPER [NSHelper sharedHelper]

@interface NSHelper : NSObject

+(NSHelper*)sharedHelper;

+(CGRect)getScreenRectIsNavigation:(BOOL)isNavigation isHorizontal:(BOOL)isHorizontal;

+(CGSize)getScreenSizeIsNavigation:(BOOL)isNavigation isHorizontal:(BOOL)isHorizontal;

+(CGPoint)getScreenOriginIsNavigation:(BOOL)isNavigation isHorizontal:(BOOL)isHorizontal;

+(CGFloat)getScreenWidthIsNavigation:(BOOL)isNavigation isHorizontal:(BOOL)isHorizontal;

+(CGFloat)getScreenHeightIsNavigation:(BOOL)isNavigation isHorizontal:(BOOL)isHorizontal;

+(BOOL)validateEmail:(NSString *)email;

+(BOOL)validateSpecialCharacter:(NSString *)chr;

+(NSString*)md5:(NSString*)input;

-(void)showAlertControllerWithTitle:(NSString*)title withMsg:(NSString*)msg;

-(void)showAlertControllerWithTitle:(NSString*)title withMsg:(NSString*)msg target:(id)target;

-(void)showWaitViewWithHint:(NSString*)hint;

-(void)removeWaitView;

@end
