//
//  FoundListCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/11/20.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "FoundListCell.h"

@implementation FoundListCell
{
    UIView *lineView;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    //self.backgroundColor=RGB(221,221,221);
    if (self) {
        [self initViews];
    }
    return self;
}

-(void)initViews {
    self.typeimgsrc= [[UIImageView alloc] initWithFrame:CGRectMake(15, 15,screen_width-30, 130)];
    [ self.typeimgsrc setImage:[UIImage imageNamed:@"gqzq.png"]];
    [self.typeimgsrc.layer setCornerRadius:2];
    [self.contentView addSubview:self.typeimgsrc];
    

    self.title= [[UILabel alloc] initWithFrame:CGRectMake(15, 156,screen_width-55, 14)];
    self.title.font = CHINESE_SYSTEM(14);
    self.title.textColor=RGB(51,51,51);
    self.title.text=@"十一月注册送百元";
    self.title.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview: self.title];
    
    self.date= [[UILabel alloc] initWithFrame:CGRectMake(15, 180,screen_width-55, 12)];
    self.date.font = CHINESE_SYSTEM(12);
    self.date.textColor=RGB(151,151,151);
    self.date.text=@"2017-10-17";
    self.date.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview: self.date];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 200,screen_width , 10)];
    lineView.backgroundColor =separaterColor;
    [self.contentView  addSubview:lineView];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setDataBind:(FoundListModel *) model IsLast:(BOOL)IsLast{
    [self.typeimgsrc sd_setImageWithURL:[NSURL URLWithString:model.pic_url]];
    self.title.text=model.title;
    self.date.text=model.date;
    CGFloat hh=0;
    hh=([model.height floatValue]/[model.width floatValue])*screen_width;
    self.typeimgsrc.frame=CGRectMake(15, 15,screen_width-30, hh);
    self.title.frame=CGRectMake(15, hh+26,screen_width-55, 14);
    self.date.frame=CGRectMake(15, hh+50,screen_width-55, 12);
    lineView.frame=CGRectMake(0, hh+70,screen_width , 10);
    if(IsLast)
    {
      lineView.frame=CGRectMake(0, hh+70,screen_width , 60);
      [lineView setHidden:FALSE];
    }
}


@end
