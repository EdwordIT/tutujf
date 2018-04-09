//
//  MainViewController.h
//  TTJF
//
//  Created by 占碧光 on 2017/2/26.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef void (^NoticeSwitchOffBlock)(BOOL isCancel);

@interface MainViewController : BaseViewController

@property(nonatomic, copy)NoticeSwitchOffBlock noticBlock;

-(void) setBanndrNum;

@end
