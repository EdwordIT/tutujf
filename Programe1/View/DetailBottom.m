//
//  DetailBottom.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DetailBottom.h"
#import "JRSegmentControl.h"
#import "DetailInvest.h"
#import "DetailSafe.h"
#import "DetailProduct.h"
#import "ZFJSegmentedControl.h"
#import "DetailRepay.h"
#import "RepayModel.h"

@interface DetailBottom ()<HeightDelegate>
{
    DetailProduct * product;
    DetailSafe * safe;
    DetailInvest * invest;
    LoanBase * model;
    DetailRepay *repay;
}

@end

@implementation DetailBottom

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame  data:(LoanBase *) data
{
    self = [super initWithFrame:frame];
    if (self) {
        model=data;
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    self.backgroundColor =[UIColor whiteColor];
    /*
    JRSegmentControl *segment = [[JRSegmentControl alloc] initWithFrame:CGRectMake(0, 0, screen_width, 50) titles:@[@"产品详情", @"安全审核", @"投资记录"]];
    //segment.backgroundColor = [UIColor whiteColor];
    segment.backgroundColor = [UIColor grayColor];
    segment.indicatorViewColor = [UIColor whiteColor];
    segment.delegate = self; // 遵守协议即可
    [self addSubview:segment];
    */
    UIView * linebg=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 10)];
    linebg.backgroundColor=RGB(242,242,242);
    [self addSubview:linebg];
    ZFJSegmentedControl *zvc ;
    NSMutableArray * repalys=   model.repay_plan;
    RepayModel * pp;
    if([repalys count]>0)
    pp=[repalys objectAtIndex:0];
    NSString * dp=[NSString stringWithFormat:@"%@",pp.display] ;
    if([repalys count]>0&&[dp isEqual:@"2"])
    {
      zvc = [[ZFJSegmentedControl alloc]initwithTitleArr:@[@"产品详情", @"安全审核", @"投资记录",@"还款计划"] iconArr:nil SCType:SCType_Underline];
    }
    else
    zvc = [[ZFJSegmentedControl alloc]initwithTitleArr:@[@"产品详情", @"安全审核", @"投资记录"] iconArr:nil SCType:SCType_Underline];
    zvc.frame = CGRectMake(0, 10, screen_width, 50);
    zvc.backgroundColor = [UIColor whiteColor];
    zvc.titleColor = RGB(83,83,83);
    zvc.userInteractionEnabled=YES;
   // zvc.selectBtnSpace = 5;//设置按钮间的间距
    //zvc.selectBtnWID = 70;//设置按钮的宽度 不设就是均分
    zvc.SCType_Underline_HEI = 2;//设置底部横线的高度
    zvc.titleFont = CHINESE_SYSTEM(15);
    zvc.selectTitleColor=navigationBarColor;
    //zvc.color
    zvc.selectType = ^(NSInteger selectIndex,NSString *selectIndexTitle){
        [self clearView];
        if(selectIndex==0)
        {
            [self addSubview:product];
            product.delegate=self;
            LoanInfo * info=model.loan_info;
            [product setLoaUrl:info.contents_url];
            product.userInteractionEnabled=YES;
        }
        if(selectIndex==1)
        {
            if(safe==nil)
                safe=[[DetailSafe alloc] initWithFrame:CGRectMake(0, 60, screen_width, screen_height*3/4)];
            [safe setModel:model];
            [self addSubview:safe];
            [self.delegate didSelectedBottomAtIndex:1 height:screen_height*3/4];
        }
        if(selectIndex==2)
        {
            if(invest==nil)
                invest=[[DetailInvest alloc] initWithFrame:CGRectMake(0, 60, screen_width, 600)];
              [invest setModel:model];
            [self addSubview:invest];
              [self.delegate didSelectedBottomAtIndex:2 height:300];
            
        }
        if(selectIndex==3)
        {
            if(repay==nil)
                repay=[[DetailRepay alloc] initWithFrame:CGRectMake(0, 60, screen_width, 600)];
            [repay setModel:model];
            [self addSubview:repay];
              [self.delegate didSelectedBottomAtIndex:3 height:300];
            
        }
        if(selectIndex==0)
            [self.delegate didSelectedBottomAtIndex:selectIndex height:300];
        if(selectIndex==1)
            [self.delegate didSelectedBottomAtIndex:selectIndex height:screen_height*3/4];
        if(selectIndex==2)
        {
            TenderModel * dic= model.tender_list;
            if(![dic.not_lktenlist_title isEqual:@""])
            [self.delegate didSelectedBottomAtIndex:selectIndex height:300];
            else
               [self.delegate didSelectedBottomAtIndex:selectIndex height:600];
            
        }
        if(selectIndex==3)
        {
            if([model.repay_plan count]>4)
            [self.delegate didSelectedBottomAtIndex:selectIndex height:[model.repay_plan count]*100];
            else
              [self.delegate didSelectedBottomAtIndex:selectIndex height:300];
        }
        
      //  NSLog(@"selectIndexTitle == %@",selectIndexTitle);
      //  self.textLabel.text = [NSString stringWithFormat:@"index = %ld,buttonTitle = %@",selectIndex,selectIndexTitle];
    };
     [self addSubview:zvc];
    if(product==nil)
        product=[[DetailProduct alloc] initWithFrame:CGRectMake(0, 60, screen_width, 1600)];
    [self addSubview:product];
    product.delegate=self;
    LoanInfo * info=model.loan_info;
    [product setLoaUrl:info.contents_url];
}
/*
- (void)segmentControl:(JRSegmentControl *)segment didSelectedIndex:(NSInteger)index
{
    [self clearView];
    if(index==0)
    {
        if(product==nil)
        product=[[DetailProduct alloc] initWithFrame:CGRectMake(0, 50, screen_width, screen_height*3/2)];
        [self addSubview:product];
        product.delegate=self;
        [product setLoaUrl:[urlCheckAddress stringByAppendingString:@"/wap/loan/apploaninfoview#?id=524"]];
    }
    if(index==1)
    {
        if(safe==nil)
        safe=[[DetailSafe alloc] initWithFrame:CGRectMake(0, 50, screen_width, screen_height*3/4)];
        [self addSubview:safe];
    }
    if(index==2)
    {
        if(invest==nil)
        invest=[[DetailInvest alloc] initWithFrame:CGRectMake(0, 50, screen_width, 500)];
        [self addSubview:invest];
    }
    if(index==0)
        [self.delegate didSelectedBottomAtIndex:index height:screen_height*3/2];
    if(index==1)
        [self.delegate didSelectedBottomAtIndex:index height:screen_height*3/4];
    if(index==2)
        [self.delegate didSelectedBottomAtIndex:index height:500];
}
*/
-(void) clearView
{
    for (UIView *subviews in [self subviews]) {
        if ([subviews isKindOfClass:[DetailProduct class]]) {
            [subviews removeFromSuperview];
        }
        if ([subviews isKindOfClass:[DetailSafe class]]) {
            [subviews removeFromSuperview];
        }
        if ([subviews isKindOfClass:[DetailInvest class]]) {
            [subviews removeFromSuperview];
        }
    }
}

- (void)segmentControl:(JRSegmentControl *)segment didScrolledPersent:(CGFloat)persent
{
 
}

-(void)didSelectedHeightAtIndex:(CGFloat)height
{
   [self.delegate didSelectedBottomAtIndex:0 height:height+30];
    
}

@end
