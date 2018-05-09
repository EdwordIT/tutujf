//
//  MessageCell.h
//  TTJF
//
//  Created by wbzhan on 2018/5/9.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseCell.h"
#import "MessageModel.h"
@interface MessageCell : BaseCell
-(void)loadInfoWithModel:(MessageModel *)model;
@end
