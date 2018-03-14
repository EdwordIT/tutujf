//
//  YBLNetWorkHudBar.m
//  YC168
//
//  Created by 乔同新 on 2017/5/1.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLNetWorkHudBar.h"
#import "YBLNavigationViewController.h"
#import "YBLUtilsVcNetInfoViewController.h"
#import "ReactiveObjC.h"

static YBLNetWorkHudBar *hudBar = nil;

@interface YBLNetWorkHudBar()

@property (nonatomic, strong) UIButton *clickButton;

@property (nonatomic, weak  ) UIViewController *selfVc;

@end

@implementation YBLNetWorkHudBar

+ (void)startMonitorWithVc:(UIViewController *)selfVc{
    if (!hudBar) {
        hudBar = [[YBLNetWorkHudBar alloc] initWithFrame:CGRectMake(0, 20, screen_width, 50) selfVc:selfVc];
        [self showHudView];
    }
}

- (instancetype)initWithFrame:(CGRect)frame selfVc:(UIViewController *)selfVc
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _selfVc = selfVc;
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.backgroundColor = RGBA(80, 80, 80, 0.9);
    
    self.clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clickButton.frame = [self bounds];
    [self addSubview:self.clickButton];
     @weakify(self)
    [[self.clickButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        YBLUtilsVcNetInfoViewController *netVC = [YBLUtilsVcNetInfoViewController new];
        YBLNavigationViewController *nav = [[YBLNavigationViewController alloc] initWithRootViewController:netVC];
        [self.selfVc presentViewController:nav animated:YES completion:nil];
    }];
    
    CGFloat rightImageWi = 20;
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"network_icon"]];
    leftImageView.frame = CGRectMake(space, 17.5, rightImageWi, rightImageWi);
  //  [leftImageView centerY:self.clickButton.frame.size.height/2];
    [self.clickButton addSubview:leftImageView];
    CGFloat right=leftImageView.frame.size.width+leftImageView.frame.origin.x;
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(right+space, 2, screen_width-right-space*3-rightImageWi, self.clickButton.frame.size.height)];
    textLabel.numberOfLines = 0;
    textLabel.text = @"网络请求失败,请检查您的网络设置";
    textLabel.font = CHINESE_SYSTEM(15);
    textLabel.textColor = RGBA(234, 234, 234, 1);
    [self.clickButton addSubview:textLabel];
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newworking_arrow"]];
    rightImageView.frame = CGRectMake(self.clickButton.frame.size.width-3*space+5,  17.5, rightImageWi, rightImageWi);
   // rightImageView.right = self.clickButton.width-space;
   // rightImageView.centerY = self.clickButton.height/2;
    [self.clickButton addSubview:rightImageView];
    
}

+ (void)showHudView{

    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:hudBar];
}

+ (void)dismissHudView{
    
    if (hudBar) {
        [hudBar removeFromSuperview];
        hudBar = nil;
    }
}

+ (void)setHudViewHidden:(BOOL)isHidden{
    
    hudBar.hidden = isHidden;
}

@end
