//
//  MyBankCardCell.h
//  TTJF
//
//  Created by wbzhan on 2018/6/12.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseCell.h"
#import "MyBankCardModel.h"

typedef void (^AddBankCardBlock)(void);
@interface AddBankCardCell : BaseCell
Copy AddBankCardBlock addBankCardBlock;
-(void)loadInfoWithModel:(AddBankCardModel *)model;
@end


typedef void (^UnlinkBankCardBlock)(NSString *cardId);
@interface MyBankCardCell : BaseCell
Copy UnlinkBankCardBlock unlinkBankCardBlock;
-(void)loadInfoWithModel:(BankCardModel *)model;

@end
