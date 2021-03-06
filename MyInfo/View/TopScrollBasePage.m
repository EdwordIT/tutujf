//
//  TopScrollBasePage.m
//  TTJF
//
//  Created by 占碧光 on 2017/10/22.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "TopScrollBasePage.h"
#import "SDCycleScrollView.h"

// TopScrollBasePage *categoryView = nil;
#define BlackTextColor RGBA(40,40,40,1)


@interface TopScrollBasePage () <SDCycleScrollViewDelegate>

 @property (nonatomic, strong) SelectedPageBannerAtIndex selectedPageBanne;
 @property (nonatomic, strong) NSMutableArray *dataModel;
 @property (nonatomic, strong)  SDCycleScrollView *cycleScroll ;

//@property (nonatomic, strong) UIView *bgView;


@end



@implementation TopScrollBasePage

- (instancetype)initWithFrame:(CGRect)frame
                    DataArray:(NSMutableArray *)dataArray
                  selectBlock:(SelectedPageBannerAtIndex)block
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataModel=dataArray;
        self.selectedPageBanne=block;
        [self CategoryUI];
     }
     return self;
}

 -(void) CategoryUI
{
    if(self.dataModel==nil||[self.dataModel count]<2)
        return;
    TopScrollMode * model=[self.dataModel objectAtIndex:0];
    TopScrollMode * model1=[self.dataModel objectAtIndex:1];
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[model.image_url,model1.image_url];
    
    
    self.cycleScroll = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screen_width, self.height) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    
    self.cycleScroll.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScroll.titleLabelBackgroundColor=[UIColor clearColor];
    self.cycleScroll.pageDotColor=RGBA(255,255,255,0.2);
    
    self.cycleScroll.autoScrollTimeInterval=20;
    [self.cycleScroll setAutoScroll:FALSE];
    self.cycleScroll.backgroundColor=[UIColor clearColor];
    self.cycleScroll.pageControlBottomOffset = kSizeFrom750(40);
    self.cycleScroll.delegate=self;
    self.cycleScroll.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [self addSubview:self.cycleScroll];
     __weak typeof(self) weakSelf = self;
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.cycleScroll.imageURLStringsGroup = imagesURLStrings;
    });
 
    if(self.title1==nil)
    {
        self.title1=[[UILabel alloc] initWithFrame:CGRectMake(0, kSizeFrom750(160), self.cycleScroll.width, kSizeFrom750(40))];
        self.title1.textColor=RGB(255,255,255);
             self.title1.font=SYSTEMSIZE(28);
        self.title1.textAlignment=NSTextAlignmentCenter;
        self.title1.text=model.accountname;
        [self.cycleScroll addSubview:self.title1];
    }
    if(self.jiner1==nil)
    {
        self.jiner1=[[UILabel alloc] initWithFrame:CGRectMake(0, self.title1.bottom+kSizeFrom750(10), self.title1.width, kSizeFrom750(60))];
        self.jiner1.textColor=RGB(255,255,255);
        self.jiner1.textAlignment=NSTextAlignmentCenter;
        self.jiner1.font=NUMBER_FONT_BOLD(50);
        self.jiner1.text=model.accountnum;
         [self.cycleScroll addSubview:self.jiner1];
    }
    if(self.title2==nil)
    {
        self.title2=[[UILabel alloc] initWithFrame:CGRectMake(0, kSizeFrom750(160), self.cycleScroll.width, kSizeFrom750(40))];
        self.title2.textColor=RGB(255,255,255);
        self.title2.font=SYSTEMSIZE(28);
        self.title2.textAlignment=NSTextAlignmentCenter;
        self.title2.text=model1.accountname;
        [self.cycleScroll addSubview:self.title2];
        [self.title2 setHidden:TRUE];
    }
    if(self.jiner2==nil)
    {
        self.jiner2=[[UILabel alloc] initWithFrame:CGRectMake(0, self.title2.bottom+kSizeFrom750(10), self.title1.width, kSizeFrom750(60))];
        self.jiner2.textColor=RGB(255,255,255);
        self.jiner2.textAlignment=NSTextAlignmentCenter;
        self.jiner2.font=NUMBER_FONT_BOLD(50);
        self.jiner2.text=model1.accountnum;
        [self.cycleScroll addSubview:self.jiner2];
         [self.jiner2 setHidden:TRUE];
    }
    
    self.title1.text=model.accountname;
    self.title2.text=model1.accountname;
    self.jiner1.text=model.accountnum;
    self.jiner2.text=model1.accountnum;

    
}

-(void) setDataBind:(NSMutableArray *)data
{
    NSMutableArray *imagesURLStrings = [[NSMutableArray alloc] init];
    if(data!=nil)
    {
        self.dataModel=data;
    for(int k=0;k<[data count];k++)
    {
        TopScrollMode * model=[data objectAtIndex:k];
        [imagesURLStrings addObject:model.image_url];
        if(k==0)
        {
           //  __weak typeof(self) weakSelf = self;
          //  weakSelf.title1.text=model.accountname;
           // weakSelf.jiner1.text=model.accountnum;
         
        }
        if(k==1)
        {
           
         //  self.title2.text=model.accountname;
         //  self.jiner2.text=model.accountnum;
        }
    }
    //  self.dataModel=data;
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
  
    if(self.dataModel!=nil)
    {
        TopScrollMode * model=[self.dataModel objectAtIndex:index];
        BLOCK_EXEC(self.selectedPageBanne,model);
    }
   
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    if(index==0)
    {
        [self.title2 setHidden:TRUE];
        [self.jiner2 setHidden:TRUE];
        [self.title1 setHidden:FALSE];
        [self.jiner1 setHidden:FALSE];
    }
    else if(index==1)
    {
        [self.title1 setHidden:TRUE];
        [self.jiner1 setHidden:TRUE];
        [self.title2 setHidden:FALSE];
        [self.jiner2 setHidden:FALSE];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
