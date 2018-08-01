//
//  FoundListCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/11/20.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "FoundListCell.h"
#import "UIImage+Color.h"
@interface FoundListCell()
Strong UIImageView *stateImage;//活动状态
@end
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
    [self.typeimgsrc.layer setCornerRadius:kSizeFrom750(5)];
    [self.contentView addSubview:self.typeimgsrc];
    
    
    self.stateImage = [[UIImageView alloc]initWithFrame:RECT(screen_width - kSizeFrom750(110) - kSizeFrom750(25), kSizeFrom750(62), kSizeFrom750(109), kSizeFrom750(48))];
    [self.contentView addSubview:self.stateImage];
    
    self.title= [[UILabel alloc] initWithFrame:CGRectMake(self.typeimgsrc.left, self.typeimgsrc.bottom+kSizeFrom750(20),self.typeimgsrc.width, kSizeFrom750(30))];
    self.title.font = SYSTEMSIZE(28);
    self.title.textColor=RGB_51;
    self.title.numberOfLines = 0;
    [self.contentView addSubview: self.title];
    
    self.date= [[UILabel alloc] initWithFrame:CGRectMake(self.title.left, self.title.bottom+kSizeFrom750(20),self.title.width, kSizeFrom750(25))];
    self.date.font = NUMBER_FONT(24);
    self.date.textColor=RGB_153;
    [self.contentView addSubview: self.date];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kSizeFrom750(400),screen_width , kSizeFrom750(20))];
    self.lineView.backgroundColor =COLOR_Background;
    [self.contentView  addSubview:self.lineView];
}

-(void) setDataBind:(FoundListModel *) model{
    
  
    self.title.text=model.title;
    self.date.text=model.date;
    switch ([model.status integerValue]) {
        case 1://进行中
        {
            [self.stateImage setImage:IMAGEBYENAME(@"activity_ing")];
            [self.typeimgsrc setImageWithString:model.pic_url];
        }
            break;
        case 2://已过期
        {
            [self.stateImage setImage:IMAGEBYENAME(@"activity_over")];
            [self.typeimgsrc sd_setImageWithURL:URLStr(model.pic_url) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [self.typeimgsrc setImage:[UIImage covertToGrayImageFromImage:image]];
            }];
        }
            break;
        case 3://未开始
            [self.stateImage setImage:IMAGEBYENAME(@"activity_unstart")];
            break;
        default:
            break;
    }
}


@end
