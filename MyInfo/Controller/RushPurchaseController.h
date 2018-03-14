//
//  RushPurchaseController.h
//  TTJF
//
//  Created by 占碧光 on 2017/10/24.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LoanBase.h"

@interface RushPurchaseController : BaseViewController

@property(nonatomic, strong) NSString *vistorType;
@property(nonatomic, strong) NSString *loan_id;


-(void)setBindData:(LoanBase *)data;

@end
