//
//  MyInvestDetailController.m
//  TTJF
//
//  Created by wbzhan on 2018/5/22.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyInvestDetailController.h"
#import "MyInvestDetailModel.h"
#import "GradientButton.h"
#import "ProgrameDetailController.h"//投资专区详情页面
@interface MyInvestDetailController ()
Strong UIScrollView *backScroll;
Strong MyInvestDetailModel *detailModel;
@end

@implementation MyInvestDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"我的投资";
    [self.view addSubview:self.backScroll];
    
    [self getRequest];
    // Do any additional setup after loading the view.
}
-(UIScrollView *)backScroll{
    if (!_backScroll) {
        _backScroll = [[UIScrollView alloc]initWithFrame:RECT(0, kNavHight, screen_width, kViewHeight)];
        _backScroll.showsVerticalScrollIndicator = NO;
    }
    return _backScroll;
}
-(void)getRequest{
    NSArray *keys = @[kToken,@"tender_id"];
    NSArray *values = @[[CommonUtils getToken],self.tender_id];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:myInvestDetailUrl keysArray:keys valuesArray:values refresh:self.backScroll success:^(NSDictionary *successDic) {
        self.detailModel = [MyInvestDetailModel yy_modelWithJSON:successDic];
        [self loadSubViews];
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
#pragma mark --
-(void)loadSubViews
{
    
    [self.backScroll removeAllSubViews];
    
    
    UIView *middleView = [[UIView alloc]init];
    middleView.backgroundColor = COLOR_White;
    [self.backScroll addSubview:middleView];
    
    UILabel *titleL = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, 0, kContentWidth, kSizeFrom750(88))];//项目标题
    [middleView addSubview:titleL];
    titleL.font = SYSTEMSIZE(30);
    titleL.textColor = RGB_51;
    titleL.text = self.detailModel.loan_name;
    
    UIView *line = [[UIView alloc]initWithFrame:RECT(0, titleL.height - kLineHeight, screen_width, kLineHeight)];
    line.backgroundColor = separaterColor;
    [middleView addSubview:line];
    

    
    for (int i=0; i<self.detailModel.loan_info.count; i++) {
        MyInvestInfoModel *model = [self.detailModel.loan_info objectAtIndex:i];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:RECT(kOriginLeft,kSizeFrom750(80)*i+kSizeFrom750(20)+titleL.bottom, kSizeFrom750(200), kSizeFrom750(40))];
        titleLabel.font = SYSTEMSIZE(28);
        titleLabel.textColor = RGB_183;
        titleLabel.text = model.title;
        titleLabel.backgroundColor = COLOR_White;
        [middleView addSubview:titleLabel];
        
        UILabel *textLabel = [[UILabel alloc]initWithFrame:RECT(screen_width/2, titleLabel.top, screen_width/2-kOriginLeft, kSizeFrom750(40))];
        textLabel.font = SYSTEMSIZE(28);
        textLabel.textColor = RGB_51;
        textLabel.text = model.content;
        textLabel.textAlignment = NSTextAlignmentRight;
        textLabel.backgroundColor = COLOR_White;
        [middleView addSubview:textLabel];
        if (i==self.detailModel.loan_info.count-1) {
            middleView.frame = RECT(0, 0, screen_width, textLabel.bottom+kSizeFrom750(20));
        }
    }
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = COLOR_White;
    [self.backScroll addSubview:bottomView];
    
    UILabel *repayTitle = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, 0, kContentWidth, kSizeFrom750(88))];
    [bottomView  addSubview:repayTitle];
    repayTitle.font = SYSTEMSIZE(30);
    repayTitle.textColor = RGB_51;
    repayTitle.text =[@"  " stringByAppendingString:self.detailModel.repay_title];
    
    UIView *line1 = [[UIView alloc]initWithFrame:RECT(0, repayTitle.height - kLineHeight, screen_width, kLineHeight)];
    line1.backgroundColor = separaterColor;
    [bottomView addSubview:line];
    
 
    
    
  
    if (self.detailModel.repay_items.count>0) {
        
        NSArray *nameArr = @[@"回款时间",@"本金（元）",@"收益（元）",@"状态"];
        NSArray *widthArr = @[@(160),@(220),@(200),@(140)];
        NSArray *leftArr = @[@(30),@(190),@(410),@(610)];
        CGFloat bottom = 0;
        for (int i=0; i<nameArr.count; i++) {
            
            UILabel *title = [[UILabel alloc]initWithFrame:RECT(kSizeFrom750([[leftArr objectAtIndex:i] floatValue]),kSizeFrom750(108), kSizeFrom750([[widthArr objectAtIndex:i] floatValue]), kSizeFrom750(30))];
            title.textColor = RGB_183;
            title.font = SYSTEMSIZE(28);
            title.text = nameArr[i];
            [bottomView addSubview:title];
            title.textAlignment = NSTextAlignmentCenter;
            bottom = title.bottom+kSizeFrom750(20);
            
        }
        
        for (int i=0; i<self.detailModel.repay_items.count; i++) {
            ReplyItemModel *model = [self.detailModel.repay_items objectAtIndex:i];
            UILabel *timeLabel = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, bottom+(kSizeFrom750(70)*i), kSizeFrom750([[widthArr objectAtIndex:0] floatValue]), kSizeFrom750(30))];
            timeLabel.textColor = RGB_51;
            timeLabel.font = SYSTEMSIZE(28);
            timeLabel.text = model.recover_time;
            timeLabel.textAlignment = NSTextAlignmentCenter;
            [bottomView addSubview:timeLabel];
            
            UILabel *amountLabel = [[UILabel alloc]initWithFrame:RECT(timeLabel.right, timeLabel.top,  kSizeFrom750([[widthArr objectAtIndex:1] floatValue]), timeLabel.height)];
            amountLabel.textColor = RGB_51;
            amountLabel.font = SYSTEMSIZE(28);
            amountLabel.textAlignment = NSTextAlignmentCenter;

            amountLabel.text = [CommonUtils getHanleNums:model.principal_yes];
            [bottomView addSubview:amountLabel];
            
            UILabel *incomeLabel = [[UILabel alloc]initWithFrame:RECT(amountLabel.right, timeLabel.top,  kSizeFrom750([[widthArr objectAtIndex:2] floatValue]), timeLabel.height)];
            incomeLabel.textColor = RGB_51;
            incomeLabel.font = SYSTEMSIZE(28);
            incomeLabel.textAlignment = NSTextAlignmentCenter;

            incomeLabel.text = [CommonUtils getHanleNums:model.interest_yes];
            [bottomView addSubview:incomeLabel];
            
            UILabel *stateLabel = [[UILabel alloc]initWithFrame:RECT(incomeLabel.right,timeLabel.top,  kSizeFrom750([[widthArr objectAtIndex:3] floatValue]), timeLabel.height)];
            stateLabel.textColor = RGB_51;
            stateLabel.font = SYSTEMSIZE(28);
            stateLabel.textAlignment = NSTextAlignmentCenter;
            stateLabel.text = model.status_name;
            [bottomView addSubview:stateLabel];
            
            if (i==self.detailModel.repay_items.count-1) {
                bottomView.frame = RECT(0, middleView.bottom+kSizeFrom750(20), screen_width, stateLabel.bottom+kSizeFrom750(20));
                
            }else{
                UIView *line2 = [[UIView alloc]initWithFrame:RECT(kOriginLeft, stateLabel.bottom+kSizeFrom750(20)-kLineHeight, kContentWidth, kLineHeight)];
                line2.backgroundColor = separaterColor;
                [bottomView addSubview:line2];
            }
        }
    }
    
    GradientButton * goOriginProgramBtn = InitObject(GradientButton);
    goOriginProgramBtn.frame = CGRectMake(kOriginLeft,bottomView.bottom+kSizeFrom750(70), kContentWidth, kSizeFrom750(90));
    [goOriginProgramBtn setTitle:@"查看原标的" forState:UIControlStateNormal];
    goOriginProgramBtn.titleLabel.font = SYSTEMBOLDSIZE(32);
    [goOriginProgramBtn addTarget:self action:@selector(goOriginProgramBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    goOriginProgramBtn.layer.cornerRadius = goOriginProgramBtn.height/2;
    goOriginProgramBtn.layer.masksToBounds =YES;
    [goOriginProgramBtn setGradientColors:@[COLOR_DarkBlue,COLOR_LightBlue]];
    [self.backScroll addSubview:goOriginProgramBtn];
    
    self.backScroll.contentSize = CGSizeMake(screen_width, goOriginProgramBtn.bottom+kSizeFrom750(30));
   
}
//查看原标的
-(void)goOriginProgramBtnClick:(UIButton *)sender{
    //切换到相应的标签栏，之后跳转
    self.tabBarController.selectedIndex = TabBarProgrameList;
    UINavigationController *selNav = [self.tabBarController.viewControllers objectAtIndex:TabBarProgrameList];
    ProgrameDetailController *detail = InitObject(ProgrameDetailController);
    detail.loan_id = self.detailModel.loan_id;
    [selNav pushViewController:detail animated:NO];
    //首页还是要返回到主页面，防止页面切换
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
