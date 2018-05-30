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
    CGFloat defaultHeight;
     ZFJSegmentedControl *sectionSeg ;
    DetailProduct * product;
    DetailSafe * safe;
    DetailInvest * invest;
    DetailRepay *repay;
    CGFloat webHeight;
    CGFloat safeHeight;
    CGFloat investHeight;
    CGFloat repayHeight;
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
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


-(void)loadBottomWithModel:(LoanBase *)model
{
    [self removeAllSubViews];
    BOOL isTransfer = YES;
    if (model.transfer_ret==nil) {
        isTransfer = NO;
    }
    self.backgroundColor =[UIColor whiteColor];
    UIView * linebg=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kSizeFrom750(20))];
    linebg.backgroundColor=COLOR_Background;
    [self addSubview:linebg];
    
    NSArray * repalys=  model.repay_plan.items;//还款计划列表
    NSString * display=[NSString stringWithFormat:@"%@",model.repay_plan.display];
    
    //如果是债权转让，则不需要投资记录
    if(isTransfer){
        sectionSeg = [[ZFJSegmentedControl alloc]initwithTitleArr:@[@"产品详情", @"安全审核", @"还款计划"] iconArr:nil SCType:SCType_Underline];
    }else{
        if([repalys count]>0&&[display isEqual:@"2"])//是否有还款计划
        {
        sectionSeg = [[ZFJSegmentedControl alloc]initwithTitleArr:@[@"产品详情", @"安全审核", @"投资记录",@"还款计划"] iconArr:nil SCType:SCType_Underline];
        }
        else
        sectionSeg = [[ZFJSegmentedControl alloc]initwithTitleArr:@[@"产品详情", @"安全审核", @"投资记录"] iconArr:nil SCType:SCType_Underline];
    }
    
    sectionSeg.frame = CGRectMake(0, kSizeFrom750(20), screen_width, kSizeFrom750(100));
    sectionSeg.backgroundColor = [UIColor whiteColor];
    sectionSeg.titleColor = RGB(83,83,83);
    sectionSeg.userInteractionEnabled=YES;
    sectionSeg.selectIndex =  0;
    sectionSeg.titleFont = SYSTEMSIZE(30);
    sectionSeg.selectTitleColor=navigationBarColor;
    [self addSubview:sectionSeg];
    defaultHeight = kSizeFrom750(280);
    
    product = [[DetailProduct alloc]initWithFrame:CGRectMake(0, sectionSeg.bottom, screen_width, defaultHeight)];
    product.delegate=self;
    [product loadInfoWithModel:model.loan_details];
    product.userInteractionEnabled=YES;
    [self addSubview:product];
    
    //安全审核
    safe=[[DetailSafe alloc] initWithFrame:CGRectMake(0, product.top, screen_width, defaultHeight)];
    [safe setHidden:YES];
    safeHeight =  [safe setModel:model];
    [self addSubview:safe];
    
    //投资记录
    invest=[[DetailInvest alloc] initWithFrame:CGRectMake(0, product.top, screen_width, defaultHeight)];
    [invest setModel:model];
    TenderModel * dic= model.tender_list;
    if([dic.is_show_tenlist isEqual:@"-1"])//不显示投资人
        investHeight = defaultHeight;
    else
        investHeight =dic.items.count*kSizeFrom750(150);
    [invest setHidden:YES];
    [self addSubview:invest];
    
    //还款计划
    repay=[[DetailRepay alloc] initWithFrame:CGRectMake(0, product.top, screen_width, defaultHeight)];
    [repay setModel:model];
    if([model.repay_plan.items count]>3)
        repayHeight=[model.repay_plan.items count]*kSizeFrom750(150);
    else
        repayHeight = defaultHeight;
    [repay setHidden:YES];
    [self addSubview:repay];
    __weak typeof(self) weakSelf = self;
    sectionSeg.selectType = ^(NSInteger selectIndex,NSString *selectIndexTitle){
        [weakSelf showView:selectIndex isTrans:isTransfer];
    };
}
-(void)showView:(NSInteger )index isTrans:(BOOL)isTransfer{
    switch (index) {
        case 0:
        {
            [product setHidden:NO];
            [safe setHidden:YES];
            [invest setHidden:YES];
            [repay setHidden:YES];
            [self.delegate didSelectedBottomAtIndex:index height:webHeight];
        }
            break;
        case 1:
        {
            [product setHidden:YES];
            [safe setHidden:NO];
            [invest setHidden:YES];
            [repay setHidden:YES];
            [self.delegate didSelectedBottomAtIndex:index height:safeHeight];

        }
            break;
        case 2:
        {
            [product setHidden:YES];
            [safe setHidden:YES];
            if (isTransfer) {//如果是债权转让，不要投资记录，即为还款计划内容前移一位
                [repay setHidden:NO];
                [invest setHidden:YES];
            }else{
                [invest setHidden:NO];
                [repay setHidden:YES];
            }
            [self.delegate didSelectedBottomAtIndex:index height:investHeight];

        }
            break;
        case 3:
        {
            [product setHidden:YES];
            [safe setHidden:YES];
            [invest setHidden:YES];
            [repay setHidden:NO];
            [self.delegate didSelectedBottomAtIndex:index height:repayHeight];
        }
            break;
            
        default:
            break;
    }
}


- (void)segmentControl:(JRSegmentControl *)segment didScrolledPersent:(CGFloat)persent
{
 
}
-(void)sendProductHeight:(CGFloat)height
{
    webHeight = height;
    if (sectionSeg.selectIndex==0) {
        [self.delegate didSelectedBottomAtIndex:0 height:height];
    }
    
}
@end
