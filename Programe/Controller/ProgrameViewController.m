//
//  ProgrameViewController.m
//  TTJF
//
//  Created by 占碧光 on 2017/3/10.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "ProgrameViewController.h"
#import "MJRefresh.h"

#import "ProgrameCell.h"
#import "ProgrameNewCell.h"
#import "ProgrameModel.h"
#import "ProgrameNewModel.h"
#import "ProgrameDetailController.h"
#import "DMLoginViewController.h"

@interface ProgrameViewController ()<UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>
{
    NSInteger _page;/**< 页数 */
    NSInteger _limit;/**< 每页的个数 */
  
    NSString *_cateid;/**<  */
    NSMutableArray *_dataSourceArray;
     NSInteger _topindex;/**< 每页的个数 */
    /****/
    UIView *backTop ;
    NSInteger _charge;/**当前的选项 */
    NSInteger _order;/**排序规则** */
    
    UIView * topV0;
    UIView * topV1;
    UIView * topV2;

}

@end

@implementation ProgrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _topindex=0;
       _charge = 0;//默认选项
    _order=-1;//默认排序
    _dataSourceArray=[[NSMutableArray alloc] init];
    [self setNav];
    [self initTableView];
    [self.view setBackgroundColor:separaterColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/****
-(void)viewWillAppear:(BOOL)animated{
    
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
       [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
****/
-(void)setNav{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    backView.backgroundColor = UIColorFromRGBValue(0x009ff0);
    [self.view addSubview:backView];
    NSArray *segmentArray = [[NSArray alloc] initWithObjects:@"散标列表",@"转让专区", nil];
    UISegmentedControl *segmentCtr = [[UISegmentedControl alloc] initWithItems:segmentArray];
    segmentCtr.frame = CGRectMake(screen_width/2-80, 30, 160, 28);
    segmentCtr.selectedSegmentIndex = 0;
    [segmentCtr addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [segmentCtr setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [segmentCtr setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    segmentCtr.tintColor = [UIColor whiteColor];
    [segmentCtr addTarget:self action:@selector(OnTapSegmentCtr:) forControlEvents:UIControlEventValueChanged];
    
    [backView addSubview:segmentCtr];
    
    [self changeHeadView];
}
  /* 头部菜单切换搜索效果*/

///初始化头部
-(void) changeHeadView
{
    if(backTop==nil)
    {
    backTop = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screen_width, 40)];
    backTop.backgroundColor = UIColorFromRGBValue(0x009ff0);
      
    UILabel *  lab1 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/6-20, 13, 40,14)];
    lab1.font = CHINESE_SYSTEM(14);
        lab1.textColor =[UIColor whiteColor];  //UIColorFromRGBValue(0xb8ddf7);
    lab1.textAlignment=NSTextAlignmentCenter;
    lab1.text=@"默认";
    [backTop addSubview:lab1];
        
    //b8ddf7
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(screen_width/3,10,0.5, 20)];
    lineView1.backgroundColor = UIColorFromRGBValue(0x98d9f9);
    [backTop addSubview:lineView1];
    
    UILabel *  lab2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-screen_width/6, 13, screen_width/3,14)];
    lab2.font = CHINESE_SYSTEM(14);
    lab2.textColor =  UIColorFromRGBValue(0xb7dcf7); //[UIColor whiteColor];
    lab2.textAlignment=NSTextAlignmentCenter;
    lab2.text=@"年化收益率";
    [backTop addSubview:lab2];//98d9f9
        
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake((screen_width*2)/3-22, 15, 6,10)];
    [img1 setImage:[UIImage imageNamed:@"Nacigationbar_Switch_Close"]];
    [backTop addSubview:img1];
    
    UIView *lineView2= [[UIView alloc] initWithFrame:CGRectMake((screen_width*2)/3,10,0.5, 20)];
    lineView2.backgroundColor =UIColorFromRGBValue(0x98d9f9);
    [backTop addSubview:lineView2];
    
    
    UILabel *  lab3 = [[UILabel alloc] initWithFrame:CGRectMake((screen_width*2)/3, 13,(screen_width)/3,14)];
    lab3.font = CHINESE_SYSTEM(14);
    lab3.textColor = UIColorFromRGBValue(0xb7dcf7);
    lab3.textAlignment=NSTextAlignmentCenter;
    lab3.text=@"项目期限";
    [backTop addSubview:lab3];
        
    UIImageView *img2= [[UIImageView alloc] initWithFrame:CGRectMake(screen_width-30, 15, 6,10)];
    [img2 setImage:[UIImage imageNamed:@"Nacigationbar_Switch_Close"]];
    [backTop addSubview:img2];  //b7dcf7
        
    [self.view addSubview:backTop];
    }
    else //切换初始化
    {
        for(UIView *mylabelview in [backTop subviews])
        {
            if ([mylabelview isKindOfClass:[UILabel class]]) {
                [mylabelview removeFromSuperview];
            }
            
            if ([mylabelview isKindOfClass:[UIImageView class]]) {
                [mylabelview removeFromSuperview];
            }
        }
        UILabel *  lab1 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/6-20, 13, 40,14)];
        lab1.font = CHINESE_SYSTEM(14);
        lab1.textColor =  [UIColor whiteColor]; //;UIColorFromRGBValue(0xb8ddf7);
        lab1.textAlignment=NSTextAlignmentCenter;
        lab1.text=@"默认";
        [backTop addSubview:lab1];
        UILabel *  lab2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-screen_width/6, 13, screen_width/3,14)];
        lab2.font = CHINESE_SYSTEM(14);
        lab2.textColor =  UIColorFromRGBValue(0xb7dcf7); //[UIColor whiteColor];
        lab2.textAlignment=NSTextAlignmentCenter;
        lab2.text=@"年化收益率";
        [backTop addSubview:lab2];//98d9f9
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake((screen_width*2)/3-22, 15, 6,10)];
        [img1 setImage:[UIImage imageNamed:@"Nacigationbar_Switch_Close"]];
        [backTop addSubview:img1];
        
        UILabel *  lab3 = [[UILabel alloc] initWithFrame:CGRectMake((screen_width*2)/3, 13,(screen_width)/3,14)];
        lab3.font = CHINESE_SYSTEM(14);
        lab3.textColor = UIColorFromRGBValue(0xb7dcf7);
        lab3.textAlignment=NSTextAlignmentCenter;
        lab3.text=@"项目期限";
        [backTop addSubview:lab3];
        
        UIImageView *img2= [[UIImageView alloc] initWithFrame:CGRectMake(screen_width-30, 15, 6,10)];
        [img2 setImage:[UIImage imageNamed:@"Nacigationbar_Switch_Close"]];
        [backTop addSubview:img2];  //b7dcf7
   
    }
    if(topV0==nil)
    {
        topV0 = [[UIView alloc] initWithFrame:CGRectMake(0,0,screen_width/3, 40)];
        topV0.backgroundColor=[UIColor clearColor];
        topV0.tag=0;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImage:)];
        tap1.delegate = self;
        tap1.cancelsTouchesInView = NO;
        [topV0 addGestureRecognizer:tap1];
     
        [backTop addSubview:topV0];
    }
    else
    {
        [backTop addSubview:topV0];
    }
  
    if(topV1==nil)
    {
        topV1 = [[UIView alloc] initWithFrame:CGRectMake(screen_width/3,0,screen_width/3, 40)];
        topV1.backgroundColor=[UIColor clearColor];
        topV1.tag=1;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImage:)];
        [topV1 addGestureRecognizer:tap1];
         [backTop addSubview:topV1];
    }
    else
    {
        [backTop addSubview:topV1];
    }
   
    if(topV2==nil)
    {
        topV2 = [[UIView alloc] initWithFrame:CGRectMake((screen_width*2)/3,0,screen_width/3, 40)];
        topV2.backgroundColor=[UIColor clearColor];
        topV2.tag=2;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImage:)];
        [topV2 addGestureRecognizer:tap1];
         [backTop addSubview:topV2];
    }
    else
    {
        [backTop addSubview:topV2];
    }
}


-(void)OnTapImage:(UITapGestureRecognizer *)sender{
    UIView *uv = (UIView *)sender.view;
     CGPoint point = [sender locationInView:sender.view];
    _charge=uv.tag;
    for(UIView *mylabelview in [backTop subviews])
    {
        if ([mylabelview isKindOfClass:[UILabel class]]) {
            [mylabelview removeFromSuperview];
        }
        
        if ([mylabelview isKindOfClass:[UIImageView class]]) {
            [mylabelview removeFromSuperview];
        }
        if ([mylabelview isKindOfClass:[UIView class]]) {
            [mylabelview removeFromSuperview];
        }
    }
    if(_charge==0)
    {
        UILabel *  lab1 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/6-20, 13, 40,14)];
        lab1.font = CHINESE_SYSTEM(14);
        lab1.textColor =  [UIColor whiteColor]; //;UIColorFromRGBValue(0xb8ddf7);
        lab1.textAlignment=NSTextAlignmentCenter;
        lab1.text=@"默认";
        [backTop addSubview:lab1];
        UILabel *  lab2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-screen_width/6, 13, screen_width/3,14)];
        lab2.font = CHINESE_SYSTEM(14);
        lab2.textColor =  UIColorFromRGBValue(0xb7dcf7); //[UIColor whiteColor];
        lab2.textAlignment=NSTextAlignmentCenter;
        lab2.text=@"年化收益率";
        [backTop addSubview:lab2];//98d9f9
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake((screen_width*2)/3-22, 15, 6,10)];
        [img1 setImage:[UIImage imageNamed:@"Nacigationbar_Switch_Close"]];
        [backTop addSubview:img1];
        
        UILabel *  lab3 = [[UILabel alloc] initWithFrame:CGRectMake((screen_width*2)/3, 13,(screen_width)/3,14)];
        lab3.font = CHINESE_SYSTEM(14);
        lab3.textColor = UIColorFromRGBValue(0xb7dcf7);
        lab3.textAlignment=NSTextAlignmentCenter;
        lab3.text=@"项目期限";
        [backTop addSubview:lab3];
        
        UIImageView *img2= [[UIImageView alloc] initWithFrame:CGRectMake(screen_width-30, 15, 6,10)];
        [img2 setImage:[UIImage imageNamed:@"Nacigationbar_Switch_Close"]];
        [backTop addSubview:img2];  //b7dcf7

    }
    else if(_charge==1)
    {
        UILabel *  lab1 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/6-20, 13, 40,14)];
        lab1.font = CHINESE_SYSTEM(14);
        lab1.textColor =  UIColorFromRGBValue(0xb7dcf7);//;UIColorFromRGBValue(0xb8ddf7);
        lab1.textAlignment=NSTextAlignmentCenter;
        lab1.text=@"默认";
        [backTop addSubview:lab1];
        UILabel *  lab2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-screen_width/6, 13, screen_width/3,14)];
        lab2.font = CHINESE_SYSTEM(14);
        lab2.textColor =  [UIColor whiteColor]; //[UIColor whiteColor];
        lab2.textAlignment=NSTextAlignmentCenter;
        lab2.text=@"年化收益率";
        [backTop addSubview:lab2];//98d9f9
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake((screen_width*2)/3-22, 15, 6,10)];
        if(point.y>20)
        {
        [img1 setImage:[UIImage imageNamed:@"Nacigationbar_Switch_down"]];
            _order=1;
        }
        else
        {
           [img1 setImage:[UIImage imageNamed:@"Nacigationbar_Switch_up"]];
              _order=2;
        }
        [backTop addSubview:img1];
        
        UILabel *  lab3 = [[UILabel alloc] initWithFrame:CGRectMake((screen_width*2)/3, 13,(screen_width)/3,14)];
        lab3.font = CHINESE_SYSTEM(14);
        lab3.textColor = UIColorFromRGBValue(0xb7dcf7);
        lab3.textAlignment=NSTextAlignmentCenter;
        lab3.text=@"项目期限";
        [backTop addSubview:lab3];
        
        UIImageView *img2= [[UIImageView alloc] initWithFrame:CGRectMake(screen_width-30, 15, 6,10)];
        [img2 setImage:[UIImage imageNamed:@"Nacigationbar_Switch_Close"]];
        [backTop addSubview:img2];  //b7dcf7

    }
    else if(_charge==2)
    {
        UILabel *  lab1 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/6-20, 13, 40,14)];
        lab1.font = CHINESE_SYSTEM(14);
        lab1.textColor = UIColorFromRGBValue(0xb7dcf7); //;UIColorFromRGBValue(0xb8ddf7);
        lab1.textAlignment=NSTextAlignmentCenter;
        lab1.text=@"默认";
        [backTop addSubview:lab1];
        UILabel *  lab2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-screen_width/6, 13, screen_width/3,14)];
        lab2.font = CHINESE_SYSTEM(14);
        lab2.textColor =  UIColorFromRGBValue(0xb7dcf7); //[UIColor whiteColor];
        lab2.textAlignment=NSTextAlignmentCenter;
        lab2.text=@"年化收益率";
        [backTop addSubview:lab2];//98d9f9
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake((screen_width*2)/3-22, 15, 6,10)];
        [img1 setImage:[UIImage imageNamed:@"Nacigationbar_Switch_Close"]];
        [backTop addSubview:img1];
        
        UILabel *  lab3 = [[UILabel alloc] initWithFrame:CGRectMake((screen_width*2)/3, 13,(screen_width)/3,14)];
        lab3.font = CHINESE_SYSTEM(14);
        lab3.textColor =   [UIColor whiteColor];
        lab3.textAlignment=NSTextAlignmentCenter;
        lab3.text=@"项目期限";
        [backTop addSubview:lab3];
        
        UIImageView *img2= [[UIImageView alloc] initWithFrame:CGRectMake(screen_width-30, 15, 6,10)];
        if(point.y>20)
        {
            [img2 setImage:[UIImage imageNamed:@"Nacigationbar_Switch_down"]];
              _order=1;
        }
        else
        {
            [img2 setImage:[UIImage imageNamed:@"Nacigationbar_Switch_up"]];
              _order=2;
        }
        [backTop addSubview:img2];  //b7dcf7

    }
    //b8ddf7
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(screen_width/3,10,0.5, 20)];
    lineView1.backgroundColor = UIColorFromRGBValue(0x98d9f9);
    [backTop addSubview:lineView1];
    
    UIView *lineView2= [[UIView alloc] initWithFrame:CGRectMake((screen_width*2)/3,10,0.5, 20)];
    lineView2.backgroundColor =UIColorFromRGBValue(0x98d9f9);
    [backTop addSubview:lineView2];
    
    if(topV0!=nil)
    {
        [backTop addSubview:topV0];
    }
    if(topV1!=nil)
    {
        [backTop addSubview:topV1];
    }
    if(topV2!=nil)
    {
        [backTop addSubview:topV2];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

  /* 头部菜单切换效果*/

/**表格数据操作**/
//初始化主界面
-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, screen_width, screen_height-156) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.backgroundColor=separaterColor;
    // 设置表格尾部
    
    // [self.tableView setSeparatorColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.01]];
    [self.tableView setSeparatorColor:separaterColor];
    
    [self.view addSubview:self.tableView];
    
    [self setUpTableView];
    
    
}

//界面表格刷新
-(void)setUpTableView{
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
    //    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(animationRefresh)];
    
    //-------以下是使用block方法【不包含animationRefresh方法】,动画设置在上面的部分代码---------
    
    __weak typeof(self) weakSelf = self;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
       // [weakSelf loadNewData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    //-------以上是使用block方法【不包含animationRefresh方法】,动画设置在上面的部分代码---------
    //1.设置普通状态的动画图片
    [header setImages:idleImages forState:MJRefreshStateIdle];
    //2.设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    //3.设置正在刷新状态的动画图片
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
 //   self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
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
}

//重复刷新
-(void)refreshData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        // [self getHttpDatta:@"839" top:@"5"];
        // [self getDaiBang];
        dispatch_async(dispatch_get_main_queue(), ^{
            //update UI
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        });
    });
    
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section ==0 ){

       // return [_dataSourceArray count]+1;
        
        return 4;
    }
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        {
            if(indexPath.row==0)
            return  147;
            else
                return  142;
        }
    }
    else{
        return 70.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }

    else{
        return 5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if(indexPath.row == 0)
        {
            static NSString *cellIndentifier = @"ProgrameNewCell";
            ProgrameNewCell *cell =  [[ProgrameNewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = separaterColor;
            return cell;
            
        }
        else  if(indexPath.row == 1)
        {
            static NSString *cellIndentifier = @"ProgrameCell";
            ProgrameCell *cell =  [[ProgrameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(_dataSourceArray.count>0)
            {
                ProgrameModel * model=[[ProgrameModel alloc] init];
                [cell setProgrameModel:model];
             
            }
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = separaterColor;
            return cell;
        }
        else  if(indexPath.row == 2)
        {
            static NSString *cellIndentifier = @"ProgrameCell";
            ProgrameCell *cell =  [[ProgrameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
           
            
            if(_dataSourceArray.count>0)
            {
                ProgrameModel * model=[[ProgrameModel alloc] init];
                [cell setProgrameModel:model];
            }
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = separaterColor;
            return cell;
        }
        else  if(indexPath.row == 3)
        {
            static NSString *cellIndentifier = @"ProgrameCell";
            ProgrameCell *cell =  [[ProgrameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            
          // cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
                ProgrameModel * model=[[ProgrameModel alloc] init];
                model.ysj=@"已售尽";
             model.yhx=@"月还息到期还本";
              model.lilu=@"5.23%";
            model.shijian=@"30天";
             model.jindu=@"100%";
                 model.xianmumc=@"宝马520质押贷款";
                [cell setProgrameModel:model];
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = separaterColor;
            return cell;
        }
    }
  
    return nil;
}


-(void)segmentAction:(UISegmentedControl *)Seg{
    _topindex = Seg.selectedSegmentIndex;
       _charge = 0;//默认选项
    [_dataSourceArray removeAllObjects];
    [self setUpTableView];
}

//响应事件
-(void)OnTapBackBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)OnTapSegmentCtr:(UISegmentedControl *)seg{
    NSInteger index = seg.selectedSegmentIndex;
       _topindex=index;//头部选项
    if (index == 0) {
        _page = 1;
          _charge = 0;//默认选项
        _order=-1;
        [self changeHeadView];
        
    }else{
        _page = 1;
        _charge = 0;//默认选项
        _order=-1;
      [self changeHeadView];
    }
    
    
}

-(void)OnTapNameBtn:(UIButton *)sender{
    /*
    NSInteger index = sender.tag - 10;
    if (index == _currentIndex) {
        return;
    }
    _currentIndex = index;
    _cateid = _cateIDArray[index];
    _page = 1;
    [UIView animateWithDuration:0.5 animations:^{
        _lineView.center = CGPointMake(sender.center.x, 39);
    }];
     */
    //刷新数据
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if(indexPath.row > 0)
        {
            
            self.hidesBottomBarWhenPushed=YES;
       
            ProgrameDetailController *next=[[ProgrameDetailController alloc]init];
            [self.navigationController pushViewController:next animated:YES];
          
            self.hidesBottomBarWhenPushed=NO;
        }
        
        else{
           
        }
    }
}
//ProgrameDetailController
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
