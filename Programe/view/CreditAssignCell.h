//
//  CreditAssignCell.h
//  TTJF
//
//  Created by wbzhan on 2018/4/26.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditModel.h"
/**
 债权转让
 */
typedef void (^CreditAssignBlock)(void);
@interface CreditAssignCell : UITableViewCell
Copy CreditAssignBlock buyBlock;
-(void)loadInfoWithModel:(CreditModel *)model;
@end
