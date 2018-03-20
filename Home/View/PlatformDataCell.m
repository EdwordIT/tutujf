//
//  PlatformDataCell.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/19.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "PlatformDataCell.h"

@interface PlatformDataCell()
Strong UIButton *platBtn;

Strong UIButton *infoBtn;
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
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:RECT(kSizeFrom750(30), kSizeFrom750(22.5), kSizeFrom750(334), kSizeFrom750(140))];
    [leftBtn setImage:IMAGEBYENAME(@"platform_data") forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:RECT(kSizeFrom750(384), kSizeFrom750(22.5), kSizeFrom750(334), kSizeFrom750(140))];
    [rightBtn setImage:IMAGEBYENAME(@"info_disclosure") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:rightBtn];
    
}
-(void)leftBtnClick:(UIButton *)sender{
    
    if (self.platBlock) {
        self.platBlock();
    }
}
-(void)rightBtnClick:(UIButton *)sender{
    if (self.infoBlock) {
        self.infoBlock();
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
