//
//  MessageComboBoxView.h
//  TTJF
//
//  Created by wbzhan on 2018/7/5.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 消息页面下拉框
 */
typedef void (^MessageComboBoxBlock)(NSInteger tag);
@interface MessageComboBoxView :UIImageView
Copy MessageComboBoxBlock comboxBlock;
@end
