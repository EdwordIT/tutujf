//
//  GuideRegisterCell.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/19.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "GuideRegisterCell.h"

@implementation GuideRegisterCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews{
    
    UIImageView * leftImage=[[UIImageView alloc] initWithFrame:CGRectMake(kSizeFrom750(160), kSizeFrom750(310), kSizeFrom750(75), kSizeFrom750(25))];
    [leftImage setImage:[UIImage imageNamed:@"wings_left"]];
    [self.contentView addSubview:leftImage];
    
    
    UILabel * lab1=  [[UILabel alloc] initWithFrame:CGRectMake(leftImage.right, leftImage.top - kSizeFrom750(5),kSizeFrom750(280),kSizeFrom750(30))];
    lab1.font = SYSTEMBOLDSIZE(32);
    lab1.textColor=RGB(102,102,102);
    lab1.text = @"四步开启安全投资";
    lab1.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:lab1];
    
   UIImageView *rightimg=[[UIImageView alloc] initWithFrame:CGRectMake(screen_width - kSizeFrom750(230), leftImage.top, leftImage.width, leftImage.height)];
    [rightimg setImage:[UIImage imageNamed:@"wings_right"]];
    [self.contentView addSubview:rightimg];
    
    NSArray *nameArr = @[@"注册账号",@"实名认证",@"开通存管账户",@"安心投资"];
    
    CGFloat space = (screen_width - kSizeFrom750(40)*2 - kSizeFrom750(150)*4)/3+kSizeFrom750(150);
    for (int i=0; i<4; i++) {
        
        UILabel *textLabel = [[UILabel alloc]initWithFrame:RECT(kSizeFrom750(40)+space*i, lab1.bottom+kSizeFrom750(112), kSizeFrom750(150), kSizeFrom750(24))];
        [textLabel setFont:SYSTEMSIZE(24)];
        [textLabel setTextColor:RGB_166];
        textLabel.text = nameArr[i];
        textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:textLabel];
        
        UIImageView *img  = [[UIImageView alloc]initWithFrame:CGRectMake(textLabel.centerX - kSizeFrom750(58)/2, lab1.bottom+kSizeFrom750(40), kSizeFrom750(58), kSizeFrom750(58))];
        NSString *iconsImage = [NSString stringWithFormat:@"home_0%d",i+1];
        [img setImage:IMAGEBYENAME(iconsImage)];
        [self.contentView addSubview:img];
    }
    
    UIButton *registerBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(0,lab1.bottom+kSizeFrom750(185),kSizeFrom750(450), kSizeFrom750(72));
    registerBtn.centerX = lab1.centerX;
    [registerBtn addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.showsTouchWhenHighlighted = NO;
    [registerBtn setTitle:@"注册即领688红包" forState:UIControlStateNormal];//button title
    [registerBtn.titleLabel setFont:SYSTEMSIZE(28)];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//title color
    registerBtn.backgroundColor=RGB_Red;
    [registerBtn.layer setCornerRadius:registerBtn.height/2]; 
    [self.contentView addSubview:registerBtn];

    
}
-(void)registerClick:(UIButton *)sender{
    if (self.registerBlock) {
        self.registerBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
