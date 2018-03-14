//
//  MineMenuCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/10/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "MineMenuCell.h"
#import "UIImageView+WebCache.h"

@implementation MineMenuCell
{
    UIView * ubg;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
     
      //  [ubg.layer setCornerRadius:20];
        
  
        
    }
    
    return self;
}

-(UIButton *) getBtnView:(CGFloat)y  index:(NSInteger)index title:(NSString *)title imgurl:(NSString *)imgurl count:(NSInteger)count
{
    UIButton *  btn1=[[UIButton alloc] initWithFrame:CGRectMake(0,y, screen_width-30, 54)];
   // [btn1 setImage:[UIImage imageNamed:@"rmbg12"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"rmbg13"] forState:UIControlStateHighlighted];
    [btn1 setBackgroundColor:[UIColor whiteColor]];
  
    UIImageView *imagev1 = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 24.2,22)];
    [imagev1 sd_setImageWithURL:[NSURL URLWithString:imgurl]];
    [btn1 addSubview:imagev1];
    UILabel * lab1 = [[UILabel alloc] initWithFrame:CGRectMake(45, 20, screen_width/2,15)];
    lab1.font = CHINESE_SYSTEM(15);
    lab1.textColor =  RGB(53,53,53);
    lab1.text=title;
    [btn1 addSubview:lab1];
        UIBezierPath *fieldPath;
      if(index==1)
      {
      fieldPath = [UIBezierPath bezierPathWithRoundedRect:btn1.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8 , 8)];
          CAShapeLayer *fieldLayer = [[CAShapeLayer alloc] init];
          fieldLayer.frame = btn1.bounds;
          fieldLayer.path = fieldPath.CGPath;
          btn1.layer.mask = fieldLayer;
      }
      if(index==count)
      {
          fieldPath = [UIBezierPath bezierPathWithRoundedRect:btn1.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8 , 8)];
          CAShapeLayer *fieldLayer = [[CAShapeLayer alloc] init];
          fieldLayer.frame = btn1.bounds;
          fieldLayer.path = fieldPath.CGPath;
          btn1.layer.mask = fieldLayer;
      }
  

   
    UIImageView * img0=[[UIImageView alloc] initWithFrame:CGRectMake(screen_width-47, 20, 7, 14)];
    [img0 setImage:[UIImage imageNamed:@"o.png"]];
    [btn1 addSubview:img0];
    if(index!=count)
    {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 53.5,screen_width-50 , 0.5)];
    lineView.backgroundColor =lineBg;
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
//didpMineMenuAtIndex
-(void) setMenuData:(NSArray *) ary1 ayr2:(NSArray *)ayr2
{
    NSInteger count=[ary1 count];

    if(ubg==nil)
    {
    ubg=[[UIView  alloc] init];
    ubg.backgroundColor=RGB(255,255,255);
    ubg.userInteractionEnabled=YES;
    ubg.backgroundColor=[UIColor clearColor];
    [self addSubview:ubg];
    }
   ubg.frame=CGRectMake(15, 0, screen_width-30, count*54);
    for (UIView *subviews in [ubg subviews]) {
        if ([subviews isKindOfClass:[UIButton class]]) {
            [subviews removeFromSuperview];
        }
    }
    for(int k=0;k<count;k++)
    {
      CGFloat hh=(k*54);
      UIButton *  btn=[self getBtnView:hh index:k+1 title:ary1[k] imgurl:ayr2[k] count:count];
        btn.tag=k+1;
      [ubg addSubview:btn];
        
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
