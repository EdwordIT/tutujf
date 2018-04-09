//
//  CustomerServiceView.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/20.
//  Copyright © 2018年 TTJF. All rights reserved.
//客户服务页面

#import <UIKit/UIKit.h>
#import "SystemConfigModel.h"
typedef void (^CustomerServiceBlock)(NSInteger tag);
@interface CustomerServiceView : UIView
Copy CustomerServiceBlock serviceBlock;

-(void)reloadInfoWithModel:(SystemConfigModel *)model;
@end
