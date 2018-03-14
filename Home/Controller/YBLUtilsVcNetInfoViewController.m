//
//  YBLUtilsVcViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/5/1.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLUtilsVcNetInfoViewController.h"
#import "YBLNetWorkHudBar.h"
#import "NSString+XN.h"
static NSString * const sharedApplication_App_WIFI = @"App-Prefs:root=WIFI";
static NSString * const sharedApplication_WIFI     = @"prefs:root=WIFI";

@interface YBLUtilsVcNetInfoViewController ()

@end

@implementation YBLUtilsVcNetInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"无网络连接";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [YBLNetWorkHudBar setHudViewHidden:YES];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[self newImageWithNamed:@"login_close" size:CGSizeMake(26, 26)] style:UIBarButtonItemStyleDone target:self action:@selector(goback)];
    backItem.tintColor = RGBA(126, 126, 126, 1);
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self createUI];
}

- (void)createUI{
    
    self.view.backgroundColor = RGBA(236, 235, 236, 1);
    
    NSArray *titles = @[@[@"请设置您的网络",@"1.打开设备的“系统设置”>“无线和网络”>“移动网络”。",@"2.打开设备的“系统设置”>“WLAN”,“启动WLAN”后从中选择一个可用的热点连接。"],
                        @[@"如果您已经连接Wi-Fi网络",@"请确认您所接入的Wi-Fi网络已经连入互联网,或者确认您的设备是否被允许访问该热点。"]];
    
    NSInteger index = 0;
    CGFloat bg_all_height = 0;
    for (NSArray *itemArray in titles) {
        
        UIView *textBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
        textBGView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:textBGView];
        
        NSInteger index_1 = 0;
        CGFloat textAllHeigh = 0;
        for (NSString *text in itemArray) {
            CGFloat textFont = 13;
            CGFloat top_space = space;
            UIColor *color_text = RGBA(180, 180, 180, 1);
            if (index_1 == 0) {
                textFont = 16;
                color_text = RGBA(40,40,40,1);
            }
            if (index_1 == 2) {
                top_space = space/2;
            }
            CGFloat mixWi = textBGView.frame.size.width-2*space;
            CGSize textSize = [text heightWithFont:[UIFont systemFontOfSize:textFont] MaxWidth:mixWi];
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, top_space+textAllHeigh, mixWi, textSize.height)];
            textLabel.textColor = color_text;
            textLabel.numberOfLines = 0;
            textLabel.font = [UIFont systemFontOfSize:textFont] ;
            textLabel.text = text;
            [textBGView addSubview:textLabel];
            
            textAllHeigh += (textLabel.frame.size.height+top_space);
            
            if (index_1 == itemArray.count-1) {
                CGFloat lessHi =textLabel.frame.origin.y + textLabel.frame.size.height +space;
                CGRect frame = textBGView.frame;
                frame.size.height=lessHi;

                frame.origin.y=bg_all_height+space*index;
                   textBGView.frame = frame;
                 bg_all_height += lessHi;
            }
            
            index_1++;
        }
        
        index++;
    }
}



- (UIImage *)newImageWithNamed:(NSString *)name size:(CGSize)size {

     UIImage *icon = [UIImage imageNamed:name];
    CGSize itemSize = size;
    UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    [self OpenURL:[NSURL URLWithString:sharedApplication_App_WIFI]];
}
- (void)OpenURL:(NSURL *)url{
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        if ([url isEqual:[NSURL URLWithString:sharedApplication_App_WIFI]]) {
            url = [NSURL URLWithString:sharedApplication_WIFI];
        }
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

- (void)goback{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [YBLNetWorkHudBar setHudViewHidden:NO];
    }];
//    [self.navigationController popViewControllerAnimated:YES];
}
@end
