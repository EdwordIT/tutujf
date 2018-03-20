//
//  TotalTradesView.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/17.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoanInfo.h"
#import "HotQueueModel.h"
@interface TotalTradesView : UIView
-(void)loadInfoWithModel:(HotQueueModel *)model;
//金额变动
-(void)countTradeNum;
@end
