//
//  ProgrameDetailController.m
//  TTJF
//
//  Created by 占碧光 on 2017/4/11.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "ProgrameDetailController.h"
#import "TwoDetailHeadCell.h"
#import "TwoHadBuyModel.h"
#import "OneDetailModel.h"
#import "OneDetailTopCell.h"
#import "OneDetailBottomCellCell.h"
#import "MJRefresh.h"


@interface ProgrameDetailController ()<UITableViewDataSource, UITableViewDelegate,DetailTopDelegate>

@end

@implementation ProgrameDetailController
{
    NSMutableArray * tArray;
    NSMutableArray * detailAaray;
    NSInteger  curTab;
    NSMutableArray *array1;// 第一个 cell 行
    
    NSMutableArray *array2;/***第二个cell 行*/
      UIImageView *navBarHairlineImageView;
    Boolean isFirstExe;
        NSTimer * myTimer;
    TwoHadBuyModel * twoModel;
   //  UIScrollView *scrollView ;
    UITableViewCell *bottomcell;
    Boolean isSecordExe;
    
    NSMutableArray * modelDatas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.navigationController.navigationBarHidden = YES;
  //  self.title=@"项目详情";
    UILabel *navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    navTitleLabel.numberOfLines=0;//可能出现多行的标题
    [navTitleLabel setAttributedText:[self changeTitle:@"项目详情"]];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.backgroundColor = [UIColor clearColor];
        self.navigationItem.titleView = navTitleLabel;
    
    //[self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    array1= [NSMutableArray arrayWithObjects: @"项目名称",@"项目类型",@"起息时间",@"还款方式",@"转让条件",nil];
    array2= [NSMutableArray arrayWithObjects: @"优先计划A2345667",@"优先计划",@"募集成功以后预计1个工作日起息",@"月还息到期还本",@"项目计息后次日可转让",nil];
    twoModel=[[TwoHadBuyModel alloc] init];
        [self initData];
    // [self setNav];
    [self initTableView];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.translucent = NO;
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
    self.view.backgroundColor=RGB(0, 160, 240);
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    isFirstExe=FALSE;
    isSecordExe=FALSE;

}

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:RGB(255,255,255) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(15) range:NSMakeRange(0, title.length)];
    return title;
}


- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
        navBarHairlineImageView.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
   
    

}

- (UIButton *)leftBtn
{
    UIButton *  _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 35, 8, 16)];
    [_leftBtn setBackgroundImage:[UIImage imageNamed:@"currency_iceo_return"] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return _leftBtn;
}
//响应事件
-(void)leftBtnClick:(UIButton *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//初始化数据
-(void)initData{
    tArray=[[NSMutableArray alloc] init];
    detailAaray=[[NSMutableArray alloc] init];
    modelDatas=[[NSMutableArray alloc] init];
    self.view.backgroundColor =RGB(0, 160, 240);
}
//初始化主界面
-(void)initTableView{
    curTab=1;
    
    //self.view.frame=CGRectMake(0, -1, screen_width, screen_height+1);

    self.tableOne = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-117) style:UITableViewStyleGrouped];
    self.tableOne.backgroundColor=RGB(0, 160, 240);
    self.tableOne.delegate = self;
    self.tableOne.dataSource = self;
    self.tableOne.tag=1;
    self.tableOne.showsVerticalScrollIndicator = NO;
   // self.tableOne.backgroundColor=RGB(246, 246, 246);
    self.tableOne.separatorStyle=UITableViewCellSeparatorStyleNone;

    // 设置tableOne尾部
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0,  screen_height-117, screen_width, 53)];
    UILabel * yhx = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-40, 19,80, 15)];
    yhx.font = CHINESE_SYSTEM(15);
    yhx.textAlignment=NSTextAlignmentCenter;
    yhx.textColor=RGB(255,255,255);
    yhx.text=@"授权投资";
    [footerView addSubview:yhx];
    
    footerView.backgroundColor=RGB(0, 160, 240);
    footerView.tag=2;
    //点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapClickView:)];
    [footerView addGestureRecognizer:tap];
    [self.view addSubview:footerView];
    
    [self.view addSubview:self.tableOne];
    [self setUpTableViewOne];
}


//scrollView的方法视图滑动时 实时调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = self.view.frame.size.width;
    // 图片宽度
    CGFloat yOffset = scrollView.contentOffset.y;
    // 偏移的y值
    if(isFirstExe)
    {
        if(myTimer==nil)
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5                                                   target:self
                                                 selector:@selector(downloadStop)
                                                 userInfo:nil
                                                  repeats:YES];
       
    }
    if(yOffset < 0)
    {
      //  self.tableOne.frame=CGRectMake(0, -yOffset, screen_width, screen_height-117);
        CGFloat totalOffset = 200 + ABS(yOffset);
        CGFloat f = totalOffset / 200;
        //拉伸后的图片的frame应该是同比例缩放。
      self.tableOne.mj_header.frame =  CGRectMake(- (width *f-width) / 2, yOffset, width * f, totalOffset);
     
    }
    else{
     
    }
}



//界面表格刷新
-(void)setUpTableViewOne{
    //添加下拉的动画图片
    //设置普通状态的动画图片    //样式二：设置多张图片（有动画效果）
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=8; ++i) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%ld",i]];
        [idleImages addObject:image];
    }
    
    
    //设置即将刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSInteger i = 1; i<=8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%ld",i]];
        [refreshingImages addObject:image];
    }
    NSArray *pullingImages = [NSArray arrayWithObject:[UIImage imageNamed:@"dropdown_anim__0001"]];
    
    
    //-------以下是使用block方法【不包含animationRefresh方法】,动画设置在上面的部分代码---------
    
  MJRefreshGifHeader *header  = [MJRefreshGifHeader headerWithRefreshingBlock:^{
       // [weakSelf loadNewData];
      
        [self.tableOne.mj_header endRefreshing];
        [self.tableOne.mj_footer endRefreshing];
      isFirstExe=TRUE;// 第一个表格已经执行
      
    }];
    //-------以上是使用block方法【不包含animationRefresh方法】,动画设置在上面的部分代码---------
    //1.设置普通状态的动画图片
    [header setImages:idleImages forState:MJRefreshStateIdle];
    //2.设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    //3.设置正在刷新状态的动画图片
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
     header.backgroundColor=RGB(0,160,240);
    self.tableOne.mj_header = header;

      self.tableOne.mj_header.backgroundColor=RGB(0,160,240);
#pragma mark --- 下面两个设置根据各自需求设置
    //    // 隐藏更新时间
     header.lastUpdatedTimeLabel.hidden = YES;
    //
    //    // 隐藏刷新状态
      header.stateLabel.hidden = YES;
    
   
    
#pragma mark --- 自定义刷新状态和刷新时间文字【当然了，对应的Label不能隐藏】
    // Set title
    [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新数据中..." forState:MJRefreshStateRefreshing];
    
    // Set font
    header.stateLabel.font =CHINESE_SYSTEM(15);
    header.lastUpdatedTimeLabel.font = CHINESE_SYSTEM(14);
    
    // Set textColor
    header.stateLabel.textColor =navigationBarColor;
    header.lastUpdatedTimeLabel.textColor =navigationBarColor;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    self.tableOne.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //构造数据
        if(isSecordExe)
            [self changeTableView:2];
        //重置刷新状态
       // [weakSelf.tableOne.mj_footer setState:MJRefreshStateIdle];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化主界面
-(void)initTableViewTwo{
    curTab=2;
    NSInteger curh= 85+screen_height-667;
    self.tableTwo = [[UITableView alloc] initWithFrame:CGRectMake(0, curh, screen_width, screen_height-117) style:UITableViewStyleGrouped];
    self.tableTwo.delegate = self;
    self.tableTwo.dataSource = self;
     self.tableTwo.tag=2;
    self.tableTwo.showsVerticalScrollIndicator = NO;
    self.tableTwo.backgroundColor=separaterColor;
  
    // [self.tableView setSeparatorColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.01]];
    [self.tableTwo setSeparatorColor:separaterColor];
    [bottomcell addSubview:self.tableTwo];
    [self setUpTableViewTwo];
}

//界面表格刷新
-(void)setUpTableViewTwo{
    //添加下拉的动画图片
    //设置普通状态的动画图片    //样式二：设置多张图片（有动画效果）
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=8; ++i) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%ld",i]];
        [idleImages addObject:image];
    }
    
    
    //设置即将刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSInteger i = 1; i<=8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%ld",i]];
        [refreshingImages addObject:image];
    }
    NSArray *pullingImages = [NSArray arrayWithObject:[UIImage imageNamed:@"dropdown_anim__0001"]];
    
    
    //-------以下是使用block方法【不包含animationRefresh方法】,动画设置在上面的部分代码---------
    
   MJRefreshGifHeader *header   = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        // [weakSelf loadNewData];
        [self.tableTwo.mj_header endRefreshing];
        [self.tableTwo.mj_footer endRefreshing];
        if(isSecordExe)//第一次执行 页面设置
            curTab=1;
       else
       {
           
        [self changeTableView:1];
           
         
       }
    }];
    //-------以上是使用block方法【不包含animationRefresh方法】,动画设置在上面的部分代码---------
    //1.设置普通状态的动画图片
    [header setImages:idleImages forState:MJRefreshStateIdle];
    //2.设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    //3.设置正在刷新状态的动画图片
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    self.tableTwo.mj_header = header;
    //  self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
#pragma mark --- 下面两个设置根据各自需求设置
    //    // 隐藏更新时间
    header.lastUpdatedTimeLabel.hidden = YES;
    //
    //    // 隐藏刷新状态
  //  header.stateLabel.hidden = YES;
    
#pragma mark --- 自定义刷新状态和刷新时间文字【当然了，对应的Label不能隐藏】
    // Set title
    [header setTitle:@"下拉,返回项目详情" forState:MJRefreshStateIdle];
    [header setTitle:@"松开,返回项目详情" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新返回中..." forState:MJRefreshStateRefreshing];
    
    // Set font
    header.stateLabel.font =CHINESE_SYSTEM(12);
    header.lastUpdatedTimeLabel.font = CHINESE_SYSTEM(14);
    
    // Set textColor
    header.stateLabel.textColor =navigationBarColor;
    header.lastUpdatedTimeLabel.textColor =navigationBarColor;
    
    // 马上进入刷新状态
    [header beginRefreshing];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


/**表格数据操作**/

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(curTab==1)
    {
        return 2;
    }
    if(curTab==2)
    {
        return 1;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(curTab==1)
    {
        if(section==0)
        return 1;
        if(section==1)
            return 6;
    }
    if(curTab==2)
    {
        if(section==0)
            return 1;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(curTab==1)
    {
        if(indexPath.section==0)
        {
            return 190;
        }
        if(indexPath.section==1)
        {
           if(indexPath.row!=5)
               return 55;
            else
                return 85+screen_height-667;
        }
    }
    if(curTab==2)
    {
        if(indexPath.section==0)
            return screen_height-117;
    }
       return  screen_height-667;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    else if (section == 1) {
        return 0.1;
    } else if (section == 2) {
        return 0.1;
    }
    else{
        return 0.1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    else if (section == 1) {
        return 0.1;
    } else if (section == 2) {
        return 0.1;
    }
    else{
        return 0.1;
    }
}





-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(curTab==1)
    {
      if (indexPath.section == 0) {
              static NSString *cellIndentifier = @"OneDetailTopCell";
              OneDetailTopCell *cell =  [[OneDetailTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
              cell.accessoryType = UITableViewCellAccessoryNone;
              cell.selectionStyle=UITableViewCellSelectionStyleNone;
              cell.delegate=self;
              cell.backgroundColor=RGB(0, 160, 240);
              return cell;
      }
      else if (indexPath.section == 1){
          if(indexPath.row != 5)
          {
              NSString *left=[array1 objectAtIndex:indexPath.row ];
              NSString *right=[array2 objectAtIndex:indexPath.row ];
              static NSString *cellIndentifier = @"OneDetailBottomCellCell";
              OneDetailBottomCellCell *cell =  [[OneDetailBottomCellCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier left:left right:right];
              cell.accessoryType = UITableViewCellAccessoryNone;
                 cell.selectionStyle = UITableViewCellSelectionStyleNone;
              cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = separaterColor;
              cell.backgroundColor=[UIColor whiteColor];
              return cell;
          }
        else
        {
            static NSString *CellIdentifier = @"newBottomCell";
            bottomcell= (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(bottomcell == nil)
            {
                bottomcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            bottomcell.textLabel.text = @"向上拖动查看更多信息";
            //    [_centerLabel setFont:[UIFont fontWithName:@"Helvetica" size:17.0]];
            //   details_iceo_uploading
              CGFloat curh= 85+screen_height-667;
            UIImageView * image=[[UIImageView alloc] init];
            [image setImage:[UIImage imageNamed:@"details_iceo_uploading"]];
            image.frame=CGRectMake(screen_width/2-90, curh/2-6.5,11, 12);
            
            bottomcell.textLabel.font=CHINESE_SYSTEM(15);
            bottomcell.accessoryType = UITableViewCellAccessoryNone;
            bottomcell.textLabel.textAlignment=NSTextAlignmentCenter;
            bottomcell.textLabel.textColor=RGB(183,183,183);
            bottomcell.backgroundColor=RGB(246,246,246);
            //点击事件
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapClickView:)];
            [bottomcell addGestureRecognizer:tap];
            [bottomcell addSubview:image];
            bottomcell.tag=1;
            return bottomcell;
        }
          
          
      }
        

    }
  
    if(curTab==2)
    {
        if (indexPath.section == 0) {
            
            static NSString *cellIndentifier = @"TwoDetailHeadCell";
            TwoDetailHeadCell *cell =  [[TwoDetailHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell initView];
          //  [cell setModelDatas:modelDatas];绑定数据
            return cell;
            
            
        }
    }
    
    return bottomcell;
}




#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if(curTab==1)
    {
       if (indexPath.section == 0)
       {
       
       }
    }
    if(curTab==2)
    {
        if (indexPath.section == 0) {
            
            
            
        }
    }
}


/**表格数据操作**/

/**首张表格的事件 **/
-(void)didSelectedDetailAtIndex:(NSInteger)index
{

}

-(void)OnTapClickView:(UITapGestureRecognizer *)sender{
    NSInteger index = sender.view.tag;
    if(index==1) //向上拖动
    {
      
    }
   else if(index==2) //授权投资
    {
        
    }
}
/**首张表格的事件**/
- (void)downloadStop
{
    isFirstExe=FALSE;
     self.tableOne.backgroundColor=RGB(246, 246, 246);
        [myTimer invalidate];
      [self initTableViewTwo];
    isSecordExe=TRUE;
}



//  isSecordExe=FALSE;
-(void) changeTableView:(NSInteger) index
{
  if(index==1)
  {
        curTab=1;
     isSecordExe=TRUE;
      [self clearMainTableView];
      [self.tableOne setHidden:FALSE];
      NSInteger curh= 85+screen_height-667;
      self.tableTwo.frame =CGRectMake(0, curh, screen_width, screen_height-117);
      [bottomcell addSubview: self.tableTwo];
      self.tableOne.backgroundColor=RGB(0, 160, 240);
      isFirstExe=FALSE;
      myTimer=nil;
      [self setUpTableViewOne];

  
  }
  else if(index==2)
  {
       curTab=2;
     isSecordExe=FALSE;
     [self.tableOne setHidden:TRUE];
      [self clearOneTableView];
      self.tableTwo.frame=CGRectMake(0, 0, screen_width, screen_height-117);

      [self.view addSubview:self.tableTwo];
  }
}

//清楚底部视图
-(void) clearOneTableView
{
  
    if(bottomcell!=nil)
    {
        for(UIView *v in [bottomcell subviews])
        {
            if ([v isKindOfClass:[UITableView  class]]) {
                [v removeFromSuperview];
                //break;
            }
        }
    }
}
//清楚主视图 二
-(void) clearMainTableView
{
   
    
    if(bottomcell!=nil)
    {
        for(UIView *v in [self.view subviews])
        {
            if ([v isKindOfClass:[UITableView  class]]) {
                if(v.tag==2)
                [v removeFromSuperview];
                //break;
            }
        }
    }
}


@end
