//
//  HomeBanner.m
//  XPjrpro
//
//  Created by 占碧光 on 16/6/3.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import "HomeBanner.h"
#import "SDCycleScrollView.h"
#import "HomepageModel.h"
@interface HomeBanner() <SDCycleScrollViewDelegate>
{
    UIScrollView *demoContainerView;
    SDCycleScrollView *cycleScrollView2 ;

}

@end


@implementation HomeBanner

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor=separaterColor;
    CGFloat height = kSizeFrom750(380);
    demoContainerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, screen_width, height)];
    demoContainerView.contentSize = CGSizeMake(screen_width, height);
    demoContainerView.frame=CGRectMake(0, 0, screen_width, height);
    [self addSubview:demoContainerView];
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[];

    
     cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screen_width, height) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView2.titleLabelBackgroundColor=[UIColor clearColor];
    cycleScrollView2.pageDotColor=RGBA(255,255,255,0.2);
   
    cycleScrollView2.autoScrollTimeInterval=5;
  //  cycleScrollView2.titlesGroup = titles;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [demoContainerView addSubview:cycleScrollView2];
    
    cycleScrollView2.pageControlBottomOffset = kSizeFrom750(30);
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self ->cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    });
    
    return self;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
  [self.delegate didSelectedBannerAtIndex:index];
}

-(void)setModelArray:(NSArray *)modelArray{
    
    NSArray *imagesURLStrings = modelArray;
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self ->cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    });
}



@end
