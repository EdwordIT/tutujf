//
//  HomeBanner.m
//  XPjrpro
//
//  Created by 占碧光 on 16/6/3.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import "HomeBanner.h"
#import "SDCycleScrollView.h"
#import "UICountingLabel.h"

@interface HomeBanner() <SDCycleScrollViewDelegate>
{
    UIScrollView *demoContainerView;
    SDCycleScrollView *cycleScrollView2 ;
    UICountingLabel *myLabel;
    UILabel * lab1;
    UILabel * lab2;
}

@end


@implementation HomeBanner

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor=separaterColor;
    demoContainerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, screen_width, 190)];
    demoContainerView.contentSize = CGSizeMake(screen_width, 190);
    demoContainerView.frame=CGRectMake(0, 0, screen_width, 190);
    [self addSubview:demoContainerView];
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[];

    
     cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screen_width, 190) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView2.titleLabelBackgroundColor=[UIColor clearColor];
    cycleScrollView2.pageDotColor=RGBA(255,255,255,0.2);
   
    cycleScrollView2.autoScrollTimeInterval=5;
  //  cycleScrollView2.titlesGroup = titles;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [demoContainerView addSubview:cycleScrollView2];
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    });
    
    /**底部动态金额**/
    UIView * bgv=[[UIView alloc] initWithFrame:CGRectMake(10, 165, screen_width-20, 45)];
    bgv.backgroundColor=RGB(255, 255, 255);
    [bgv.layer setCornerRadius:22.5]; //设置矩形四个圆角半径
    bgv.layer.shadowColor=RGB(214,214,214).CGColor;
    bgv.layer.shadowOffset=CGSizeMake(1,1);
    bgv.layer.shadowOpacity=0.5;
    bgv.layer.shadowRadius=2;
    
    
    CGFloat dw=0;
    if(IS_IPhone6plus)
    {
        dw=15;
    }
    
     lab1= [[UILabel alloc] initWithFrame:CGRectMake(62+dw, 16.5,120, 12)];
    lab1.font = CHINESE_SYSTEM(12);
    lab1.textColor=RGB(153,153,153);
    lab1.text=@"累计成交金额";
    lab1.textAlignment=NSTextAlignmentLeft;
    [bgv addSubview:lab1];

     lab2= [[UILabel alloc] initWithFrame:CGRectMake(135+dw, 13,20, 20)];
    lab2.textColor=RGB(255,119,46);
    lab2.text=@"￥";
    lab2.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    lab2.textAlignment=NSTextAlignmentLeft;
    [bgv addSubview:lab2];
    
    myLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(153+dw, 12, 280, 20)];
    myLabel.textAlignment = NSTextAlignmentLeft;
    myLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    myLabel.textColor = RGB(255,119,46);
    [bgv addSubview:myLabel];
    //设置格式
    myLabel.format = @"%.0f";
    //设置变化范围及动画时间
   
    
    
    //ff772e
    [self addSubview:bgv];
    /**底部动态金额**/
    
    return self;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
  [self.delegate didSelectedBannerAtIndex:index];
}

-(void) setTopJinE:(CGFloat)jine
{
    //超过10亿
    if(jine>=1000000000)
    {
        CGFloat  dw=10;
        if(IS_IPhone6plus)
           dw=10;
           if(IS_IPhone6)
              dw=-3;
              if(IS_IPHONE5)
             dw=-2;
             lab1.frame=CGRectMake(62+dw, 16.5,120, 12);
             lab2.frame=CGRectMake(135+dw, 13,20, 20);
             myLabel.frame=CGRectMake(153+dw, 12, 280, 20);
      }
    [myLabel countFrom:0.00
                    to:jine
          withDuration:1.0f];
    
}

-(void)setModelArray:(NSArray *)modelArray{
    // 情景二：采用网络图片实现
   /* NSMutableArray * tempArray= [[NSMutableArray alloc] init];
    for(int k=0;k<modelArray.count;k++)
    {
        [tempArray addObject:[[modelArray objectAtIndex:k] objectForKey:@"imageurl"]];
    }*/
    
    NSArray *imagesURLStrings = modelArray;
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    });
}



@end
