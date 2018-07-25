//
//  PlatformDataCell.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/19.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "PlatformDataCell.h"

@interface PlatformDataCell()
Strong UIImageView *platBtn;

Strong UIImageView *infoBtn;
@end

@implementation PlatformDataCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews{
    
    UIImageView *leftBtn = [[UIImageView alloc]initWithFrame:RECT(kSizeFrom750(30), kSizeFrom750(22.5), kSizeFrom750(334), kSizeFrom750(140))];
    [leftBtn setImage:IMAGEBYENAME(@"platform_data")];
    [leftBtn addTapGesture];
    leftBtn.clickBlock = ^(UIImageView *imageView) {
        if (self.platBlock) {
            self.platBlock();
        }
    };
    [self.contentView addSubview:leftBtn];
    
    UIImageView *rightBtn = [[UIImageView alloc]initWithFrame:RECT(kSizeFrom750(384), kSizeFrom750(22.5), kSizeFrom750(334), kSizeFrom750(140))];
    [rightBtn setImage:IMAGEBYENAME(@"info_disclosure")];
    [rightBtn addTapGesture];
    rightBtn.clickBlock = ^(UIImageView *imageView) {
        if (self.infoBlock) {
            self.infoBlock();
        }
    };
    [self.contentView addSubview:rightBtn];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
