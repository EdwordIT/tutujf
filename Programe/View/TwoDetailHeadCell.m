//
//  TwoDetailHeadCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/4/11.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "TwoDetailHeadCell.h"
#import "TwoHadBuyCell.h"
#import "TwoHadBuyModel.h"


@implementation TwoDetailHeadCell
{
    UIProgressView *processView;
    UILabel * XMXX;
    NSTimer * myTimer;
    
    UIView * tempV;
    float jinduv;
    
   // UIView * tempTop;
   // UIView * tempTop1;
    
    UIView * mainView;
    
    UIScrollView *scrollView ;
    
    NSMutableArray * thirdAry;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self initView];
    
    
    return self;
}
-(void) initView{
    if(mainView==nil)
    {
        mainView=[[UIView alloc] init];
        mainView.frame=CGRectMake(0, 0, screen_width, screen_height-117);
    }
     HorizontalMenu *menu = [[HorizontalMenu alloc] initWithFrame:CGRectMake(0, 0, screen_width, 44) withTitles:@[@"项目信息", @"安全保障", @"已购记录"]];
     menu.delegate = self;
    [mainView addSubview:menu];
    [self addSubview:mainView];
    [self initXMXXView];

}
//初始化滚动条
-(void) initScoll
{
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, screen_width, screen_height-98)];
    scrollView.backgroundColor =[UIColor whiteColor];
    
    scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    scrollView.pagingEnabled = NO; //是否翻页
    scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = YES; // 是否滑动
    scrollView.bounces = NO;
 
}
//项目信息
-(void) initXMXXView
{
    
    [self initScoll];
    [self initHeadXMXXView];
    CGSize size={screen_width,mainView.frame.size.height-44};//508
    scrollView.contentSize =size;
    [mainView addSubview:scrollView];
}

//安全保障
-(void) initHeadAQBZ
{
      [self initScoll];
    [self initHeadAQBZView1];
      [self initHeadAQBZView2];
      [self initHeadAQBZView3];
    
    CGSize size={screen_width,mainView.frame.size.height-44};//508
    scrollView.contentSize =size;
    [mainView addSubview:scrollView];
}

//已购记录
-(void) initHeadYGJL
{
 [self initScoll];
    [self initHeadYGJLView];
    
    CGSize size={screen_width,mainView.frame.size.height-44};//508
    scrollView.contentSize =size;
    [mainView addSubview:scrollView];
    
    
}

-(void) initHeadXMXXView
{
    UIView * topLine=[[UIView alloc] init];
    topLine.frame=CGRectMake(15, 15, 4, 12);
    topLine.layer.cornerRadius=1;
    self.layer.borderWidth  = 0.1;
    topLine.backgroundColor=RGB(0,160,240);
    
   UILabel * yhx = [[UILabel alloc] initWithFrame:CGRectMake(28, 15,150, 12)];
    yhx.font = CHINESE_SYSTEM(12);
    yhx.textAlignment=NSTextAlignmentLeft;
    yhx.textColor=RGB(52,52,52);
    yhx.text=@"项目说明";
    [scrollView addSubview:yhx];
    
    [scrollView addSubview:topLine];
    
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:12];
    NSString *titleContent = @"       亲，欢迎您通过以下方式与我们的营销顾问取得联系，交流您再营销推广工作中遇到的问题，营销顾问将免费为您提供咨询服务。顾问取得联系，交流您再营销推广工作中遇.";
    titleLabel.text = titleContent;
    titleLabel.numberOfLines = 0;//多行显示，计算高度
    titleLabel.textColor = RGB(105,105,105);
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(screen_width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    titleLabel.frame =CGRectMake(5, 48,screen_width-10,titleSize.height)  ;
    
    [scrollView addSubview:titleLabel];
}



-(void) initHeadAQBZView1
{
    UIView * topLine=[[UIView alloc] init];
    topLine.frame=CGRectMake(15, 15, 4, 12);
    topLine.layer.cornerRadius=1;
    self.layer.borderWidth  = 0.1;
    topLine.backgroundColor=RGB(0,160,240);
    
    UILabel * yhx = [[UILabel alloc] initWithFrame:CGRectMake(28, 15,150, 12)];
    yhx.font = CHINESE_SYSTEM(12);
    yhx.textAlignment=NSTextAlignmentLeft;
    yhx.textColor=RGB(52,52,52);
    yhx.text=@"风险备附金计划";
    [scrollView addSubview:yhx];
    
    [scrollView addSubview:topLine];
    
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:12];
    NSString *titleContent = @"      交流您再营销推广工作中遇到的问题，营销顾问将免费为您提供咨询服务。顾问取得联系，交流您再营销推广工作中遇.";
    titleLabel.text = titleContent;
    titleLabel.numberOfLines = 0;//多行显示，计算高度
    titleLabel.textColor = RGB(105,105,105);
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(screen_width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    titleLabel.frame =CGRectMake(5, 48,screen_width-10,titleSize.height)  ;
    
    [scrollView addSubview:titleLabel];
    
    UIView * bottomLine=[[UIView alloc] init];
    bottomLine.frame=CGRectMake(15, 128, screen_width-15, 0.3);
    bottomLine.backgroundColor=lineBg;
    
    [scrollView addSubview:bottomLine];
}

-(void) initHeadAQBZView2
{

    UIView * topLine=[[UIView alloc] init];
    topLine.frame=CGRectMake(15, 154, 4, 12);
    topLine.layer.cornerRadius=1;
    self.layer.borderWidth  = 0.1;
    topLine.backgroundColor=RGB(0,160,240);
    
    UILabel * yhx = [[UILabel alloc] initWithFrame:CGRectMake(28, 154,150, 12)];
    yhx.font = CHINESE_SYSTEM(12);
    yhx.textAlignment=NSTextAlignmentLeft;
    yhx.textColor=RGB(52,52,52);
    yhx.text=@"严格的风控流程";
    [scrollView addSubview:yhx];
    
    [scrollView addSubview:topLine];
    
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:12];
    NSString *titleContent = @"      交流您再营销推广工作中遇到的问题，营销顾问将免费为您提供咨询服务。顾问取得联系，交流您再营销推广工作中遇.营销顾问将免费为您提供咨询服务。顾问取得联系，交流您再营销推广工作中遇.营销顾问将免费为您提供咨询服务。顾问取得联系，交流您再营销推广工作中遇.";
    titleLabel.text = titleContent;
    titleLabel.numberOfLines = 0;//多行显示，计算高度
    titleLabel.textColor = RGB(105,105,105);
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(screen_width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    titleLabel.frame =CGRectMake(5, 180,screen_width-10,titleSize.height)  ;
    
    
    
    [scrollView addSubview:titleLabel];
    
    UIView * bottomLine=[[UIView alloc] init];
    bottomLine.frame=CGRectMake(15, 305, screen_width-15, 0.3);
    bottomLine.backgroundColor=lineBg;
    
    [scrollView addSubview:bottomLine];
}


-(void) initHeadAQBZView3
{
    UIView * topLine=[[UIView alloc] init];
    topLine.frame=CGRectMake(15, 330, 4, 12);
    topLine.layer.cornerRadius=1;
    self.layer.borderWidth  = 0.1;
    topLine.backgroundColor=RGB(0,160,240);
    
    UILabel * yhx = [[UILabel alloc] initWithFrame:CGRectMake(28, 330,150, 12)];
    yhx.font = CHINESE_SYSTEM(12);
    yhx.textAlignment=NSTextAlignmentLeft;
    yhx.textColor=RGB(52,52,52);
    yhx.text=@"投资人监督委员会监督";
    [scrollView addSubview:yhx];
    
  [scrollView addSubview:topLine];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:12];
    NSString *titleContent = @"      交流您再营销推广工作中遇到的问题，营销顾问将免费为您提供咨询服务。顾问取得联系，交流您再营销推广工作中遇.营销顾问将免费为您提供咨询服务。顾问取得联系，交流您再营销推广工作中遇.营销顾问将免费为您提供咨询服务。顾问取得联系，交流您再营销推广工作中遇.";
    titleLabel.text = titleContent;
    titleLabel.numberOfLines = 0;//多行显示，计算高度
    titleLabel.textColor = RGB(105,105,105);
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(screen_width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    titleLabel.frame =CGRectMake(5, 356,screen_width-10,titleSize.height)  ;
    
    [scrollView addSubview:titleLabel];
}

-(void) setModelDatas:(NSMutableArray *) datas
{
    thirdAry=datas;
}
//
-(void) initHeadYGJLView
{
    TwoHadBuyCell  * buycell=[[TwoHadBuyCell alloc] initWithFrame:CGRectMake(0, 0,screen_width, screen_height-117) ];
    [buycell setModelDatas:thirdAry];
     [scrollView addSubview:buycell];
}



-(void) clearView
{
  if(mainView!=nil)
  {
     for(UIView *v in [scrollView subviews])
     {
         if ([v isKindOfClass:[UIView  class]]) {
             [v removeFromSuperview];
             //break;
         }
     }
  }
}

#pragma mark - HorizontalMenuDelegate

- (void)clieckButton:(UIButton *)button
{
    NSLog(@"%ld", button.tag);
    if( button.tag==0)  //项目信息
    {
        [self clearView];
        [self initXMXXView];
    }
    else if( button.tag==1)
    {
         [self clearView];
        [self initHeadAQBZ];
    }
    
    else if( button.tag==2)
    {
        [self clearView];
        [self initHeadYGJL];
    }
        
}

@end
