//
//  DetailTop.h
//  TTJF
//
//  Created by 占碧光 on 2017/12/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoanBase.h"
@interface DetailTop : UIView
-(instancetype)init;
//加载投资详情
-(void)loadInfoWithModel:(LoanInfo *)infoModel;
//加载债权详情
-(void)loadCreditInfoWithModel:(LoanBase *)infoModel;

@end
