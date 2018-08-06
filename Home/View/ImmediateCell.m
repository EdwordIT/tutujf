//
//  ImmediateCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/3/12.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "ImmediateCell.h"
@interface ImmediateCell()

Strong UIImageView *rectView;
Strong UILabel *incomeTitle;
Strong UILabel *subTitle;
@end

@implementation ImmediateCell
{
    UIImageView * rightimg;
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        [self initViews];
    }
    return self;
}

-(void)initViews {

    self.rectView = InitObject(UIImageView);
    self.rectView.frame = RECT(kSizeFrom750(40), kSizeFrom750(50), kSizeFrom750(670), kSizeFrom750(340));
    [self.contentView addSubview:self.rectView];
    [CommonUtils setShadowCornerRadiusToView:self.rectView];

    
    self.incomeTitle = [[UILabel alloc]initWithFrame:RECT(0, kSizeFrom750(50), kSizeFrom750(250), kSizeFrom750(70))];
    self.incomeTitle.centerX = self.rectView.width/2;
    self.incomeTitle.font = SYSTEMSIZE(34);
    self.incomeTitle.textColor = RGB_51;
    self.incomeTitle.text = @"新手专享体验标";
    [self.rectView addSubview:self.incomeTitle];
    
    _incomeLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, self.incomeTitle.bottom+kSizeFrom750(60),kSizeFrom750(200),kSizeFrom750(40))];
    _incomeLabel.centerX = self.incomeTitle.centerX;
    _incomeLabel.textAlignment=NSTextAlignmentCenter;
    _incomeLabel.font = NUMBER_FONT_BOLD(60);
    _incomeLabel.textColor = COLOR_Red;
    [self.contentView addSubview:_incomeLabel];
    
    self.subTitle = [[UILabel alloc]initWithFrame:RECT(0, self.incomeLabel.bottom+kSizeFrom750(16), kSizeFrom750(250), kSizeFrom750(70))];
    self.subTitle.centerX = self.rectView.width/2;
    self.subTitle.font = SYSTEMSIZE(34);
    self.subTitle.textColor = HEXCOLOR(@"#b8b8b8");
    self.subTitle.text = @"预期利率";
    [self.rectView addSubview:self.subTitle];
    
    
    
     self.minPointLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, self.subTitle.bottom+kSizeFrom750(40),screen_width/2, kSizeFrom750(25))];
     self.minPointLabel.font = NUMBER_FONT_BOLD(26);
    self.minPointLabel.textColor=RGB(54,54,54);
     self.minPointLabel.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview: self.minPointLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.minPointLabel.right, self.minPointLabel.top, 1, self.minPointLabel.height)];
    lineView.backgroundColor = RGB_166;
    [self.contentView addSubview:lineView];
    
    //投资时间
    self.timeLabel= [[UILabel alloc] initWithFrame:CGRectMake((screen_width-30)/2, self.minPointLabel.top,self.minPointLabel.width, self.minPointLabel.height)];
    self.timeLabel.font = NUMBER_FONT_BOLD(26);
    self.timeLabel.textColor=RGB(54,54,54);
    self.timeLabel.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.timeLabel];
    

}

-(void)button_event:(UIButton*) sender
{
    [self.delegate didSelectedImmediateAtIndex:sender.tag];
}

-(void)setImmediateModel:(ImmediateModel *)model {
     if([model.additional_status isEqual:@"0"])
         return ;
     self.incomeLabel.text=model.apr_val;
    NSString *minPoint =[[model.tender_amount_min_txt stringByAppendingString:@" "] stringByAppendingString:model.tender_amount_min_val];
    [self.minPointLabel setAttributedText:[CommonUtils diffierentFontWithString:minPoint rang:NSMakeRange(0, 4) font:SYSTEMSIZE(26) color:RGB_166 spacingBeforeValue:0 lineSpace:0]];
    [self.timeLabel setAttributedText:[CommonUtils diffierentFontWithString:[[model.period_txt stringByAppendingString:@" "] stringByAppendingString:model.period] rang:NSMakeRange(0, 4) font:SYSTEMSIZE(26) color:RGB_166 spacingBeforeValue:0 lineSpace:0]];
    [self.incomeLabel setAttributedText:[CommonUtils diffierentFontWithString:model.apr_val rang:NSMakeRange(model.apr_val.length - 4, 4) font:SYSTEMBOLDSIZE(30) color:COLOR_Red spacingBeforeValue:0 lineSpace:0]];

}
-(void)hiddenSubViews:(BOOL)isHidden
{
    for (UIView *view in self.contentView.subviews) {
        [view setHidden:!isHidden];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
