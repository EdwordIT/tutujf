//
//  MainBanner.m
//  TTJF
//
//  Created by 占碧光 on 2017/7/18.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "MainBanner.h"
#import "SDCycleScrollView.h"


@interface MainBanner() <SDCycleScrollViewDelegate>
{
    UIScrollView *demoContainerView;
    SDCycleScrollView *cycleScrollView2 ;
    UILabel * jine;
}

@end

@implementation MainBanner 

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    demoContainerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, screen_width, 210)];
    demoContainerView.contentSize = CGSizeMake(screen_width, 210);
    demoContainerView.frame=CGRectMake(0, 0, screen_width, 210);
    [self addSubview:demoContainerView];
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[];
    
    
    cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screen_width, 210) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView2.titleLabelBackgroundColor=[UIColor clearColor];
    cycleScrollView2.autoScrollTimeInterval=5;
    //  cycleScrollView2.titlesGroup = titles;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [demoContainerView addSubview:cycleScrollView2];
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    });
    
    UIView * uv=[[UIView alloc] init];
    uv.frame=CGRectMake(15, 190, screen_width-30, 45);
    uv.backgroundColor=[UIColor whiteColor];
    
    UILabel * lab2= [[UILabel alloc] initWithFrame:CGRectMake(60, 16.5,75, 12)];
    lab2.font = CHINESE_SYSTEM(12);
    lab2.textColor=RGB(153,153,153);
    lab2.textAlignment=NSTextAlignmentLeft;
    lab2.text=@"累计成交金额";
    [uv addSubview:lab2];
    
    
    jine= [[UILabel alloc] initWithFrame:CGRectMake(140, 13.5,195, 18)];
     jine.font = CHINESE_SYSTEM(16);
    jine.textColor=RGB(255,119,46);
    
    jine.textAlignment=NSTextAlignmentLeft;
    [jine.layer setCornerRadius:22.5]; //设置矩形四个圆角半径
    jine.text=@"￥1,756,565,455";
    [self addSubview:uv];
    
    self.backgroundColor=RGB(245,245,245);
    
    return self;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    [self.delegate didSelectedBannerAtIndex:index];
}

-(void)setModelArray:(NSArray *)modelArray{
    // 情景二：采用网络图片实现
    NSMutableArray * tempArray= [[NSMutableArray alloc] init];
     for(int k=0;k<modelArray.count;k++)
     {
     [tempArray addObject:[[modelArray objectAtIndex:k] objectForKey:@"imageurl"]];
     }
    
    NSArray *imagesURLStrings = modelArray;
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    });
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
