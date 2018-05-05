//
//  Public.h
//  aoyouHH
//
//  Created by jinzelu on 15/4/21.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#ifndef aoyouHH_Public_h
#define aoyouHH_Public_h
/**
 时间格式
 */
#define SECOND 1
#define MINUTE 60
#define HOUR (60*60)
#define DAY (60*60*24)
#define WEEK (60*60*24*7)
// 1.判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define iOS11 ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0)
//当前版本号
#define currentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// 2.获得RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)
#define RGBCOLOR(r,g,b)                     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a)                  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define navigationBarColor RGB(0, 160, 240)

//#define navigationBarColor RGB(53, 171, 245)


#define COLOR_White RGB(255,255,255)
//分割线颜色
#define separaterColor RGB(243,243,243)
/**亮红色*/
#define COLOR_Red RGB(246,47,25)
/**淡蓝色*/
#define COLOR_LightBlue RGB(48,186,255)
/**深蓝色*/
#define COLOR_DarkBlue RGB(0,160,240)
/**主标题显示黑色*/
#define RGB_51 RGB(51,51,51)
/**主标题淡灰色*/
#define RGB_102 RGB(102, 102, 102)
/**默认显示灰色*/
#define RGB_166 RGB(166, 166, 166)
//副标题灰色
#define RGB_153 RGB(153, 153, 153)

#define RGB_158 RGB(158, 158, 158)
//按钮不可点击时候背景色
#define COLOR_Btn_Unsel RGB(184, 184, 184)
//系统默认整体页面背景色
#define COLOR_Background RGB(246 ,246, 246)

#define RGB_233 RGB(233, 233, 233)

#define RGB_237 RGB(237, 237, 237)
//淡灰色背景
#define RGB_240 RGB(240 ,240, 240)

//**  简单的property 定义
#define Strong          @property(nonatomic, strong)
#define Weak            @property(nonatomic, weak)
#define Retain          @property(nonatomic, retain)
#define Copy            @property(nonatomic, copy)
#define Assign          @property(nonatomic, assign)

#define URLStr(str)     [NSURL URLWithString:str];
/**
 图片简写
 */
#define IMAGEBYENAME(name)       [UIImage imageNamed:name]
//** 初始化***********************************************************************************
#define InitObject(vc) [[vc alloc]init]
#define InitROOTVC(vc) [[UINavigationController alloc] initWithRootViewController:[[vc alloc]init]];
#define WEAK_SELF __weak typeof(self) weakSelf = self
#define Title_Font 18
//中文字体
#define CHINESE_FONT_NAME  @"STHeitiK-Light"

//#define CHINESE_SYSTEM(x) [UIFont systemFontOfSize:x]
//#define CHINESE_SYSTEM(x) [UIFont fontWithName:@"Source Han Sans CN" size:x]
//#define CHINESE_SYSTEM_BOLD(x) [UIFont boldSystemFontOfSize:x]
//#define SYSTEMSIZE(x) [UIFont fontWithName:@"Source Han Sans CN" size:kSizeFrom750(x)]
//#define SYSTEMBOLDSIZE(x)  [UIFont boldSystemFontOfSize:kSizeFrom750(x)]

#define CHINESE_SYSTEM(x) [UIFont fontWithName:@"Source Han Sans CN" size:x]
#define CHINESE_SYSTEM_BOLD(x) [UIFont boldSystemFontOfSize:x]
#define SYSTEMSIZE(x) [UIFont fontWithName:@"Source Han Sans CN" size:kSizeFrom750(x)]
#define SYSTEMBOLDSIZE(x)  [UIFont boldSystemFontOfSize:kSizeFrom750(x)]
//Helvetica-Bold
#define NUMBER_FONT(x)   [UIFont fontWithName:@"Helvetica" size:kSizeFrom750(x)]
#define NUMBER_FONT_BOLD(x)   [UIFont fontWithName:@"Helvetica-Bold" size:kSizeFrom750(x)]
//


// 3.是否为4inch
#define fourInch ([UIScreen mainScreen].bounds.size.height == 568)

// 4.屏幕大小尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height


//UI设计尺寸，在开发过程中需要用次方法转换
#define kSizeFrom750(x) ((x) * ([UIScreen mainScreen].bounds.size.width/750.f))

static CGFloat const space                   = 10;
// 系统控件默认高度
#define kStatusBarHeight    (kDevice_Is_iPhoneX ? 44 : 20)
//导航栏高度
#define kNavHight (kSizeFrom750(88)+kStatusBarHeight)

#define kOriginLeft kSizeFrom750(30)

#define kContentWidth kSizeFrom750(690)
//默认label行间距
#define kLabelSpace kSizeFrom750(12)

#define kLineHeight 1.0f/[[UIScreen mainScreen] scale]
//底部标签栏高度
#define kTabbarHeight (kDevice_Is_iPhoneX ? 83 : 49)

#define navBarHeight   self.navigationController.navigationBar.frame.size.height
#define kViewHeight (screen_height - kNavHight)



#define kScreen_Bounds [UIScreen mainScreen].bounds
#define isPadDev   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad   ? YES : NO)
#define isPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? YES : NO)
#define isRetina ([[UIScreen mainScreen] scale] > 1 ? YES : NO)
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height == 568) ? YES : NO)
#define IS_IPhone6 (667 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)
#define IS_IPhone6plus (736 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


//重新设定view的Y值
/*
#define setFrameY(view, newY) view.frame = CGRectMake(view.frame.origin.x, newY, view.frame.size.width, view.frame.size.height)
#define setFrameX(view, newX) view.frame = CGRectMake(newX, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
#define setFrameH(view, newH) view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, newH)
*/

//取view的坐标及长宽
/*
#define W(view)    view.frame.size.width
#define H(view)    view.frame.size.height
#define X(view)    view.frame.origin.x
#define Y(view)    view.frame.origin.y
 */

//5.常用对象
//#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

//6.经纬度
#define LATITUDE_DEFAULT 39.983497
#define LONGITUDE_DEFAULT 116.318042
/*
#define kPaddingLeftWidth 15.0
#define kLoginPaddingLeftWidth 18.0
#define kMySegmentControl_Height 44.0
#define kMySegmentControlIcon_Height 70.0

#define  kBackButtonFontSize 16
#define  kNavTitleFontSize 18
 */
#define LocalVersion @"20"  //当前内部版本号
//7.系统版本号
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//8.一些常用自定义方法

#define RECT( a, b, c, d) CGRectMake(a, b, c, d)
/**
 在主线程刷新UI
 */
#define MainThreadFunction(x)  if ([NSThread currentThread]== [NSThread mainThread]) {\
                                        x;\
                                        }else{\
                                        dispatch_async(dispatch_get_main_queue(), ^{\
                                        x;\
                                        });\
                                    }
/**
 校验字符串是否为空
 */
#define IsEmptyStr(str) (str==nil||[str isEqualToString:@""]||[str isEqualToString:@"<null>"]||[str isEqualToString:@"nil"]||[str isEqualToString:@"(null)"])
//宏定义检测block是否可用
#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };
//自定义NSLog
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#endif
