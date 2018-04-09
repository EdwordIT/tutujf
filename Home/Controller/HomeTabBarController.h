//
//  HomeTabBarController.h
//  CloudSoundPlus
//
//  Created by renxlin on 2017/4/21.
//  Copyright © 2017年 hzlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTabBarController : UITabBarController

- (void)setCustomTabBarHidden:(BOOL)hidden;
//新消息标红
- (void)setNewMessage:(NSInteger)navType isHaveNew:(BOOL)haveNewMessage;

@end
