//
//  RedEnvelopeContentController.h
//  TTJF
//
//  Created by wbzhan on 2018/7/3.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^RefreshRemindBlock)(NSString *remindTxt);
@interface RedEnvelopeContentController : BaseViewController
Copy RefreshRemindBlock remindBlock;
Assign NSInteger selectedIndex;
@end
