//
//  ClubeCell.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/19.
//  Copyright © 2018年 TTJF. All rights reserved.
//社区信息

#import <UIKit/UIKit.h>
#import "ClubeMsgModel.h"
@interface ClubeCell : UITableViewCell

-(void)loadInfoWithModel:(ClubeMsgModel *)model;
@end