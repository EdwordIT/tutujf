//
//  MyBankCardCell.h
//  TTJF
//
//  Created by wbzhan on 2018/6/12.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseCell.h"
#import "BankCardModel.h"

typedef void (^AddBankCardBlock)(void);
@interface AddBankCardCell : BaseCell
Copy AddBankCardBlock addBankCardBlock;
@end

@interface MyBankCardCell : BaseCell
-(void)loadInfoWithModel:(BankCardModel *)model;

@end
