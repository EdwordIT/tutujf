//
//  MineMenuCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/10/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "MineMenuCell.h"
#import "MyAccountModel.h"
@implementation MineMenuCell
{
    UIView * ubg;
    CGFloat cellHeight ;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cellHeight = kSizeFrom750(125);
        self.contentView.backgroundColor = COLOR_Background;
    }
    
    return self;
}

-(UIButton *) getBtnView:(CGFloat)y  index:(NSInteger)index model:(UserContentModel *)model count:(NSInteger)count
{
    
    
    UIButton *  btn1=[[UIButton alloc] initWithFrame:CGRectMake(0,y, screen_width-kOriginLeft*2, cellHeight)];
    [btn1 setImage:[UIImage imageNamed:@"rmbg13"] forState:UIControlStateHighlighted];
    [btn1 setBackgroundColor:[UIColor whiteColor]];
  
    //图片
    UIImageView *imagev1 = [[UIImageView alloc] initWithFrame:CGRectMake(kSizeFrom750(25), kSizeFrom750(30), kSizeFrom750(50),kSizeFrom750(44))];
    imagev1.centerY = cellHeight/2;
    [imagev1 setImageWithString:model.logo_url];
    [btn1 addSubview:imagev1];
    
    UILabel * lab1 = [[UILabel alloc] initWithFrame:CGRectMake(kSizeFrom750(90), 0, screen_width/2,kSizeFrom750(35))];
    lab1.centerY = imagev1.centerY;
    lab1.font = SYSTEMSIZE(30);
    lab1.textColor =  RGB_51;
    lab1.text=model.title;
    [btn1 addSubview:lab1];
        UIBezierPath *fieldPath;
      if(index==0)
      {
      fieldPath = [UIBezierPath bezierPathWithRoundedRect:btn1.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8 , 8)];
          CAShapeLayer *fieldLayer = [[CAShapeLayer alloc] init];
          fieldLayer.frame = btn1.bounds;
          fieldLayer.path = fieldPath.CGPath;
          btn1.layer.mask = fieldLayer;
      }
      if(index==count-1)
      {
          fieldPath = [UIBezierPath bezierPathWithRoundedRect:btn1.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8 , 8)];
          CAShapeLayer *fieldLayer = [[CAShapeLayer alloc] init];
          fieldLayer.frame = btn1.bounds;
          fieldLayer.path = fieldPath.CGPath;
          btn1.layer.mask = fieldLayer;
      }
  

   
    UIImageView * rightArrow=[[UIImageView alloc] initWithFrame:CGRectMake(btn1.width - kSizeFrom750(45), 0, kSizeFrom750(14), kSizeFrom750(28))];
    rightArrow.centerY = lab1.centerY;
    [rightArrow setImage:[UIImage imageNamed:@"rightArrow"]];
    [btn1 addSubview:rightArrow];
    if(index!=count)
    {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kSizeFrom750(20), cellHeight - kLineHeight,btn1.width - kSizeFrom750(20)*2 , kLineHeight)];
    lineView.backgroundColor =RGB_233;
    [btn1 addSubview:lineView];
    }
    btn1.tag=index;
     [btn1 addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
     return btn1;
    
}

-(void)menuClick:(UIButton *)button
{
    [self.delegate didMineMenuAtIndex:button.tag];
}

-(void)setMenuData:(NSArray *)array
{
    NSInteger count=[array count];

    if(ubg==nil)
    {
    ubg=[[UIView  alloc] init];
    ubg.backgroundColor=RGB(255,255,255);
    ubg.userInteractionEnabled=YES;
    ubg.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:ubg];
    }
   ubg.frame=CGRectMake(kOriginLeft, 0, screen_width-kOriginLeft*2, count*cellHeight);
    [ubg removeAllSubViews];
    for(int k=0;k<count;k++)
    {
        UserContentModel *model = array[k];
      CGFloat hh=(k*cellHeight);
        UIButton *  btn=[self getBtnView:hh index:k model:model count:count];
        btn.tag=k;
      [ubg addSubview:btn];
        
    }
    //默认显示
    if (array==nil) {
      NSArray * iconsArray= [NSArray arrayWithObjects: @"http://www.tutujf.com/wapassets/trust/images/news/mylogo01.png",@"http://www.tutujf.com/wapassets/trust/images/news/mylogo02.png",@"http://www.tutujf.com/wapassets/trust/images/news/mylogo04.png",nil];
       NSArray *titleArray= [NSArray arrayWithObjects: @"我的邀请",@"我的借款",@"托管账户",nil];
        NSMutableArray *defArr = InitObject(NSMutableArray);
        for (int i=0; i<iconsArray.count; i++) {
            UserContentModel *defaultModel = InitObject(UserContentModel);
            defaultModel.title = titleArray[i];
            defaultModel.logo_url = iconsArray[i];
            [defArr addObject:defaultModel];
        }

        [self setMenuData:defArr];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
