//
//  TwoHadBuyCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/4/11.
//  Copyright © 2017年 占碧光. All rights reserved.
//
//已购信息
#import "TwoHadBuyCell.h"



@implementation TwoHadBuyCell
{
   
    UIView * botmCel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor=[UIColor whiteColor];
    if (self) {

        [self awakeFromNib];
          [self initMiddle];
    }
    return self;
}

-(void) initTopView:(NSMutableArray *) datas
{
    TwoHadBuyModel * model1=[ datas  objectAtIndex:0];
    TwoHadBuyModel * model2=[ datas  objectAtIndex:1];
     TwoHadBuyModel * model3=[ datas  objectAtIndex:2];

    UIView * topView=[[UIView alloc ] initWithFrame:CGRectMake(0, 0, screen_width, 140)];
    
    UIImageView *  _topLeftImg = [[UIImageView alloc] initWithFrame:CGRectMake((screen_width/3-39)/2, 20, 39, 54)];
    [_topLeftImg setImage:[UIImage imageNamed:@"details_ranking_no1"]];
    [ topView addSubview:_topLeftImg];
    //details_ranking_no1
    
    UILabel * yhx = [[UILabel alloc] initWithFrame:CGRectMake((screen_width/3-100)/2, 88,100, 12)];
    yhx.font = CHINESE_SYSTEM(12);
    yhx.textAlignment=NSTextAlignmentCenter;
    yhx.textColor=RGB(102,102,102);
    yhx.text=[NSString stringWithFormat:@"%@元",model1.monney];
    [ topView addSubview:yhx];
    
    UILabel * yhx1 = [[UILabel alloc] initWithFrame:CGRectMake((screen_width/3-100)/2, 110,100, 12)];
    yhx1.font = CHINESE_SYSTEM(12);
    yhx1.textAlignment=NSTextAlignmentCenter;
    yhx1.textColor=RGB(153,153,153);
    yhx1.text=model1.mobile;
    [ topView addSubview:yhx1];
    
    UIImageView *  _topMiddleImg = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/2-18.5, 20, 39, 54)];
    [_topMiddleImg setImage:[UIImage imageNamed:@"details_ranking_no2"]];
    [ topView addSubview:_topMiddleImg];
    
    UILabel * yhx2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-50, 88,100, 12)];
    yhx2.font = CHINESE_SYSTEM(12);
    yhx2.textAlignment=NSTextAlignmentCenter;
    yhx2.textColor=RGB(102,102,102);
    yhx2.text=[NSString stringWithFormat:@"%@元",model2.monney];
    [ topView addSubview:yhx2];
    
    UILabel * yhx21 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-50, 110,100, 12)];
    yhx21.font = CHINESE_SYSTEM(12);
    yhx21.textAlignment=NSTextAlignmentCenter;
    yhx21.textColor=RGB(153,153,153);
    yhx21.text=model1.mobile;
    [ topView addSubview:yhx21];
    
    UIImageView *  _topRightImg = [[UIImageView alloc] initWithFrame:CGRectMake((screen_width*5)/6-18.5, 20, 39, 54)];
    [_topRightImg setImage:[UIImage imageNamed:@"details_ranking_no3"]];
    [ topView addSubview:_topRightImg];
    
    UILabel * yhx3 = [[UILabel alloc] initWithFrame:CGRectMake((screen_width*5)/6-50, 88,100, 12)];
    yhx3.font = CHINESE_SYSTEM(12);
    yhx3.textAlignment=NSTextAlignmentCenter;
    yhx3.textColor=RGB(102,102,102);
    yhx3.text=[NSString stringWithFormat:@"%@元",model3.monney];
    [ topView addSubview:yhx3];
    
    UILabel * yhx31 = [[UILabel alloc] initWithFrame:CGRectMake((screen_width*5)/6-50, 110,100, 12)];
    yhx31.font = CHINESE_SYSTEM(12);
    yhx31.textAlignment=NSTextAlignmentCenter;
    yhx31.textColor=RGB(153,153,153);
    yhx31.text=model1.mobile;
    [ topView addSubview:yhx31];
    
    
    [self addSubview:topView];

}

-(void) initMiddle
{
   UIView * midView=[[UIView alloc ] initWithFrame:CGRectMake(0, 140, screen_width, 40)];
    midView.backgroundColor=RGB(249,249,249);
    UILabel * lab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 14,screen_width/3, 12)];
    lab1.font = CHINESE_SYSTEM(12);
    lab1.textAlignment=NSTextAlignmentLeft;
    lab1.textColor=RGB(191,191,191);
    lab1.text=@"投资用户";
    [ midView addSubview:lab1];
    
    UILabel * lab2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-100, 14,200, 12)];
    lab2.font = CHINESE_SYSTEM(12);
    lab2.textAlignment=NSTextAlignmentCenter;
    lab2.textColor=RGB(191,191,191);
    lab2.text=@"投资金额(元)";
    [ midView addSubview:lab2];

    
    UILabel * lab3 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width*2/3, 14,screen_width/3-15, 12)];
    lab3.font = CHINESE_SYSTEM(12);
    lab3.textAlignment=NSTextAlignmentRight;
    lab3.textColor=RGB(191,191,191);
    lab3.text=@"投资时间";
    [ midView addSubview:lab3];
    
     [self addSubview:midView];

}

-(void)getModelView:(TwoHadBuyModel *) model heightV:(NSInteger) index
{
    UIView * cell=[[UIView alloc ] initWithFrame:CGRectMake(0, 42*index, screen_width, 42)];
    
    UILabel * lab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 17,screen_width/3, 12)];
    lab1.font = CHINESE_SYSTEM(12);
    lab1.textAlignment=NSTextAlignmentLeft;
    lab1.textColor=RGB(191,191,191);
    lab1.text=model.mobile;
    [ cell addSubview:lab1];
    
    UIImageView *  _topLeftImg = [[UIImageView alloc] initWithFrame:CGRectMake(90, 15, 15, 15)];
    if([model.linktype isEqual:@"1"]) // 手机
    [_topLeftImg setImage:[UIImage imageNamed:@"details_ranking_no1"]];
    else if([model.linktype isEqual:@"2"]) // pc
        [_topLeftImg setImage:[UIImage imageNamed:@"details_ranking_no1"]];
    else if([model.linktype isEqual:@"3"]) // 微信
        [_topLeftImg setImage:[UIImage imageNamed:@"details_ranking_no1"]];
    [ cell addSubview:_topLeftImg];
    
    UILabel * lab2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-100, 17,200, 12)];
    lab2.font = CHINESE_SYSTEM(12);
    lab2.textAlignment=NSTextAlignmentCenter;
    lab2.textColor=RGB(191,191,191);
    lab2.text=model.monney;
    [ cell addSubview:lab2];
    
    
    UILabel * lab3 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width*2/3, 17,screen_width/3-15, 12)];
    lab3.font = CHINESE_SYSTEM(12);
    lab3.textAlignment=NSTextAlignmentRight;
    lab3.textColor=RGB(191,191,191);
    lab3.text=[NSString stringWithFormat:@"%@ %@",model.datestr,model.timestr];//@"今天 17:36:50";
    [ cell addSubview:lab3];
    
    [botmCel addSubview:cell];
}

- (void)awakeFromNib{
   // [self initTopView];
    NSMutableArray * numary=[[NSMutableArray alloc] init];
    TwoHadBuyModel * model=[[TwoHadBuyModel alloc] init];
    model.mobile=@"139*****435";
      model.monney=@"20990.00";
    model.linktype=@"1";
    model.sort=@"1";
    model.timestr=@"16:45:40";
      model.datestr=@"2017-04-10";
    [numary addObject:model];
    
    TwoHadBuyModel * model1=[[TwoHadBuyModel alloc] init];
    model1.mobile=@"139*****435";
    model1.monney=@"20990.00";
    model1.linktype=@"1";
    model1.sort=@"2";
    model1.timestr=@"16:45:40";
    model1.datestr=@"2017-04-10";
    [numary addObject:model1];
    
    TwoHadBuyModel * model2=[[TwoHadBuyModel alloc] init];
    model2.mobile=@"139*****435";
    model2.monney=@"20990.00";
    model2.linktype=@"1";
    model2.sort=@"3";
    model2.timestr=@"16:45:40";
    model2.datestr=@"2017-04-10";
    [numary addObject:model2];
    
    
    TwoHadBuyModel * model3=[[TwoHadBuyModel alloc] init];
    model3.mobile=@"139*****435";
    model3.monney=@"20990.00";
    model3.linktype=@"1";
    model3.sort=@"3";
    model3.timestr=@"16:45:40";
    model3.datestr=@"2017-04-10";
    [numary addObject:model3];
    
    TwoHadBuyModel * model4=[[TwoHadBuyModel alloc] init];
    model4.mobile=@"139*****435";
    model4.monney=@"20990.00";
    model4.linktype=@"1";
    model4.sort=@"4";
    model4.timestr=@"16:45:40";
    model4.datestr=@"今天";
    [numary addObject:model4];
    
    TwoHadBuyModel * model5=[[TwoHadBuyModel alloc] init];
    model5.mobile=@"139*****435";
    model5.monney=@"20990.00";
    model5.linktype=@"2";
    model5.sort=@"5";
    model5.timestr=@"16:45:40";
    model5.datestr=@"昨天";
    [numary addObject:model5];
    
    TwoHadBuyModel * model6=[[TwoHadBuyModel alloc] init];
    model6.mobile=@"139*****435";
    model6.monney=@"20990.00";
    model6.linktype=@"3";
    model6.sort=@"6";
    model6.timestr=@"16:45:40";
    model6.datestr=@"2017-04-10";
    [numary addObject:model6];
    
    
    [self setModelDatas:numary];
}



-(void) setModelDatas:(NSMutableArray *) datas
{
    if(datas.count>3)
    botmCel=[[UIView alloc] initWithFrame:CGRectMake(0, 180, screen_width, 42*(datas.count-3))];
   // [self clearView];
    for (int k=0; k<datas.count; k++) {
        TwoHadBuyModel * model=[ datas  objectAtIndex:k];
        if(k<3)
        {
                k=2;
           // if(k==0)
            [self initTopView:datas];
        
        }
        else
        {
          [self getModelView:model heightV:(k-3)] ;
        }
    }
    [self addSubview:botmCel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
