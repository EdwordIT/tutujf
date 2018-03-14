//
//  InputGestureLockController.h
//  TTJF
//
//  Created by 占碧光 on 2017/3/9.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^NoticeSwitchOffBlock)(BOOL isCancel);

@protocol autoLoginTopDelegate <NSObject>

@optional
-(void)didAutoLogin:(NSString *)password;

@end


@interface InputGestureLockController : NSObject

@property(nonatomic, copy)NoticeSwitchOffBlock noticBlock;

- (void)SetupSubviews;

@property(nonatomic, assign) id<autoLoginTopDelegate> delegate;

@end
