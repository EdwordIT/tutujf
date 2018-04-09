//
//  FoundListCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/11/20.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "FoundListCell.h"

@implementation FoundListCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    //self.backgroundColor=RGB(221,221,221);
    if (self) {
        [self initViews];
    }
    return self;
}

-(void)initViews {
    self.typeimgsrc= [[UIImageView alloc] initWithFrame:CGRectMake(kSizeFrom750(30), kSizeFrom750(30),kSizeFrom750(690), kSizeFrom750(260))];
    [ self.typeimgsrc setImage:[UIImage imageNamed:@"gqzq.png"]];
    [self.typeimgsrc.layer setCornerRadius:kSizeFrom750(5)];
    [self.contentView addSubview:self.typeimgsrc];
    

    self.title= [[UILabel alloc] initWithFrame:CGRectMake(self.typeimgsrc.left, self.typeimgsrc.bottom+kSizeFrom750(20),self.typeimgsrc.width, kSizeFrom750(30))];
    self.title.font = SYSTEMSIZE(28);
    self.title.textColor=RGB_51;
    self.title.text=@"十一月注册送百元";
    self.title.numberOfLines = 0;
    [self.contentView addSubview: self.title];
    
    self.date= [[UILabel alloc] initWithFrame:CGRectMake(self.title.left, self.title.bottom+kSizeFrom750(20),self.title.width, kSizeFrom750(25))];
    self.date.font = NUMBER_FONT(24);
    self.date.textColor=RGB_153;
    self.date.text=@"2017-10-17";
    [self.contentView addSubview: self.date];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kSizeFrom750(400),screen_width , kSizeFrom750(20))];
    self.lineView.backgroundColor =separaterColor;
    [self.contentView  addSubview:self.lineView];
}

-(void) setDataBind:(FoundListModel *) model{
    [self.typeimgsrc setImageWithString:model.pic_url];
    self.title.text=model.title;
    self.date.text=model.date;
}


@end
