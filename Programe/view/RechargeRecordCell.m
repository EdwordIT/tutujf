//
//  RechargeRecordCell.m
//  TTJF
//
//  Created by wbzhan on 2018/4/25.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "RechargeRecordCell.h"
@interface RechargeRecordCell()
Strong UILabel *statusLabel;//
Strong UILabel *timeLabel;
Strong UILabel *contentLabel;
@end
@implementation RechargeRecordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = COLOR_White;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews
{
    self.statusLabel=[[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, kSizeFrom750(30), screen_width-kOriginLeft*2, kSizeFrom750(30))];
    self.statusLabel.textColor=RGB(31,31,31);
    self.statusLabel.font=SYSTEMSIZE(26);
    self.statusLabel.text = @"充值失败";
    [self.contentView addSubview:self.statusLabel];
    
    
    self.timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.statusLabel.left, self.statusLabel.bottom+kSizeFrom750(15), self.statusLabel.width, kSizeFrom750(30))];
    self.timeLabel.textColor=RGB(146,146,146);
    self.timeLabel.font=NUMBER_FONT(26);
    self.timeLabel.text = @"2018-04-22 12:12:12";
    [self.contentView addSubview:self.timeLabel];
    
    self.contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(screen_width/2, kSizeFrom750(50), screen_width/2-kOriginLeft, kSizeFrom750(38))];
    self.contentLabel.textAlignment=NSTextAlignmentRight;
    self.contentLabel.textColor=navigationBarColor;
    self.contentLabel.font=NUMBER_FONT(36);
    self.contentLabel.text=[CommonUtils getHanleNums:@"5300.00"];
    [self.contentView addSubview:self.contentLabel];
}
-(void)loadInfoWithModel:(RechargeModel *)model
{
    //充值失败
    if (1) {
        self.statusLabel.text = @"充值失败";
        self.statusLabel.textColor = RGB_153;
        
        self.contentLabel.textColor = RGB_153;
    }else{
        self.statusLabel.textColor = RGB_51;
        self.statusLabel.text = @"充值成功";
        self.contentLabel.textColor = navigationBarColor;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
