//
//  MyRedEnvelopeCell.m
//  TTJF
//
//  Created by wbzhan on 2018/5/17.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyRedEnvelopeCell.h"

@implementation MyRedEnvelopeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews
{
  
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
