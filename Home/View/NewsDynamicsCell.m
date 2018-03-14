//
//  NewsDynamicsCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/10/1.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "NewsDynamicsCell.h"
#import "SDCycleScrollView.h"
#define kRadianToDegrees(radian) (radian*180.0)/(M_PI)

@interface NewsDynamicsCell ()<SDCycleScrollViewDelegate>
{
    SDCycleScrollView *cycleScrollView4;
    UIImageView * myimg;
}
@end

@implementation NewsDynamicsCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=separaterColor;
        [self initViews];
    }
    return self;
}

-(void)initViews {
    
    UIView * bgv=[[UIView alloc] initWithFrame:CGRectMake(10, 6.25, screen_width-20, 50)];
    bgv.backgroundColor=RGB(255, 255, 255);
  //  bgv.layer.shadowColor=[UIColor grayColor].CGColor;
    
   // bgv.layer.shadowOffset=CGSizeMake(1,1);
    
 //   bgv.layer.shadowOpacity=0.5;
    
  //  bgv.layer.shadowRadius=2;
      
   UIImageView * leftimg= [[UIImageView alloc] initWithFrame:CGRectMake(13, 11.5,27, 27)];
    [ leftimg setImage:[UIImage imageNamed:@"zuixindt"]];
    [bgv addSubview:leftimg];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50, 17.5,0.5f, 15)];
    lineView.backgroundColor = RGB(233,233,233);
    [bgv addSubview:lineView];
    //zuixindt
      UIView * bgimge= [[UIView alloc] initWithFrame:CGRectMake(60, 12.5,25, 25)];
    bgimge.backgroundColor=RGB(70,207,212);
       bgimge.layer.cornerRadius=12.5;
      myimg= [[UIImageView alloc] initWithFrame:CGRectMake(4.5, 4.5,16, 16)];
        [ myimg setImage:[UIImage imageNamed:@"img02.png"]];
        [bgimge addSubview:myimg];
    [bgv addSubview:bgimge];

    
    // 情景三：图片配文字
    /*  NSArray *titles = @[@"新建交流QQ群：185534916 ",
     @"感谢您的支持，如果下载的",
     @"如果代码在使用过程中出现问题",
     @"您可以发邮件到gsdios@126.com"
     ];*/
    // 网络加载 --- 创建只上下滚动展示文字的轮播器
    // 由于模拟器的渲染问题，如果发现轮播时有一条线不必处理，模拟器放大到100%或者真机调试是不会出现那条线的
    cycleScrollView4 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(89, 10, screen_width-126,30) delegate:self placeholderImage:nil];
    cycleScrollView4.scrollDirection = UICollectionViewScrollDirectionVertical;
    cycleScrollView4.onlyDisplayText = YES;
    cycleScrollView4.titleLabelBackgroundColor=[UIColor clearColor];
    cycleScrollView4.autoScrollTimeInterval=2;
    
   
     NSMutableArray *titlesArray = [NSMutableArray new];
   //  [titlesArray addObject:@"代办任务：首次投资定期项目"];
  //   [titlesArray addObject:@"代办任务：首次投资定期项目结束"];
  
    //Me_iceo_Return
    //  [titlesArray addObjectsFromArray:titles];
    //   cycleScrollView4.
    
  //  NSMutableArray *   titlesArray=[NSMutableArray new];
    
    cycleScrollView4.titlesGroup = [titlesArray copy];
    cycleScrollView4.titleLabelHeight=18;
    cycleScrollView4.titleLabelTextFont=CHINESE_SYSTEM(12);
    cycleScrollView4.titleLabelTextColor=RGB(51,51,51);
    //  [cycleScrollView4 setBackgroundColor:[UIColor clearColor]];
    [bgv addSubview:cycleScrollView4];
    
    
    [self.contentView addSubview:bgv];
}

///绑定数据
-(void)setDaiBangSj: (NSMutableArray *)array
{
    NSMutableArray *titlesArray = [NSMutableArray new];
    for(int k=0;k<array.count;k++)
    {
        NewsDynamicsModel * model=[array objectAtIndex:k];
       [titlesArray addObject:model.title];
        
    }
    cycleScrollView4.titlesGroup = [titlesArray copy];
    //NewsDynamicsModel
    
}
-(void)setXuanZhuanDh
{
    //旋转动画。
    [myimg.layer addAnimation:[self rotation:2 degree:kRadianToDegrees(360) direction:60 repeatCount:MAXFLOAT] forKey:nil];
    
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    [self.delegate didSelectedNewsDynamicsAtIndex:(int)index];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark ====旋转动画======
-(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount
{
    CATransform3D rotationTransform = CATransform3DMakeRotation(degree, 0, 0, direction);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  
  //  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 3;
    animation.autoreverses = NO;
    animation.cumulative = NO;
    //  animation.delegate = self;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    
    return animation;
}



@end
