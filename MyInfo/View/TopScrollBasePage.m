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
 @property (nonatomic, strong)  SDCycleScrollView *cycleScrollView2 ;
 @property (nonatomic, strong)  UIScrollView *demoContainerView;

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
     self.demoContainerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, screen_width, 190)];
    self.demoContainerView.contentSize = CGSizeMake(screen_width, 190);
    self.demoContainerView.frame=CGRectMake(0, 0, screen_width, 190);
    [self addSubview:self.demoContainerView];
    self.demoContainerView.backgroundColor=[UIColor clearColor];
    if(self.dataModel==nil||[self.dataModel count]<2)
        return;
    TopScrollMode * model=[self.dataModel objectAtIndex:0];
    TopScrollMode * model1=[self.dataModel objectAtIndex:1];
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[model.image_url,model1.image_url];
    
    
    self.cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screen_width, 190) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    
    self.cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView2.titleLabelBackgroundColor=[UIColor clearColor];
    self.cycleScrollView2.pageDotColor=RGBA(255,255,255,0.2);
    
    self.cycleScrollView2.autoScrollTimeInterval=20;
    [self.cycleScrollView2 setAutoScroll:FALSE];
    self.cycleScrollView2.backgroundColor=[UIColor clearColor];
    //  cycleScrollView2.titlesGroup = titles;
    self.cycleScrollView2.delegate=self;
    self.cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [self.demoContainerView addSubview:self.cycleScrollView2];
     __weak typeof(self) weakSelf = self;
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    });//http://www.tutujf.com/wapassets/trust/images/news/user01.png
 
    if(self.title1==nil)
    {
        self.title1=[[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-100, 70, 200, 13)];
        self.title1.textColor=RGB(255,255,255);
             self.title1.font=CHINESE_SYSTEM(13);
        self.title1.textAlignment=NSTextAlignmentCenter;
        self.title1.text=model.accountname;
        [self.cycleScrollView2 addSubview:self.title1];
    }
    if(self.jiner1==nil)
    {
        self.jiner1=[[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-100, 93, 200, 24)];
        self.jiner1.textColor=RGB(255,255,255);
        self.jiner1.textAlignment=NSTextAlignmentCenter;
        self.jiner1.font=NUMBER_FONT_BOLD(24);
        self.jiner1.text=model.accountnum;
         [self.cycleScrollView2 addSubview:self.jiner1];
    }
    if(self.title2==nil)
    {
        self.title2=[[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-80, 70, 160, 13)];
        self.title2.textColor=RGB(255,255,255);
        self.title2.font=CHINESE_SYSTEM(13);
        self.title2.textAlignment=NSTextAlignmentCenter;
        self.title2.text=model1.accountname;
        [self.cycleScrollView2 addSubview:self.title2];
        [self.title2 setHidden:TRUE];
    }
    if(self.jiner2==nil)
    {
        self.jiner2=[[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-80, 93, 160, 24)];
        self.jiner2.textColor=RGB(255,255,255);
        self.jiner2.textAlignment=NSTextAlignmentCenter;
        self.jiner2.font=NUMBER_FONT_BOLD(24);
        self.jiner2.text=model1.accountnum;
        [self.cycleScrollView2 addSubview:self.jiner2];
         [self.jiner2 setHidden:TRUE];
    }
    
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
  
  //  [self.delegate didSelectedBannerAtIndex:index];
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
