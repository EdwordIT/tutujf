//
//  PropertyController.m
//  TTJF
//
//  Created by wbzhan on 2018/5/28.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "PropertyController.h"
#import "ZFChart.h"
#import "MyIncomeModel.h"
@interface PropertyController ()<ZFPieChartDelegate,ZFPieChartDataSource>
{
    NSString *btnTitle;
    
}
Strong ZFPieChart *pieChartView;//饼状图
Strong UIView *topBackView;
Strong UIView *topView;
Strong UIScrollView *backScroll;
Strong UIButton *switchBtn;//切换收益
Strong UIView *bottomView;
Strong MyIncomeModel *baseModel;
Strong UILabel *amountTitle;//
Strong UILabel *amountLabel;//总资产、总收益
Strong NSMutableArray *colorsArray;//颜色数组
Strong NSMutableArray *percentageArray;//百分比
@end

@implementation PropertyController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isMyIncome) {
        btnTitle = @"查看我的资产";
    }else{
        btnTitle = @"查看我的收益";
    }

    self.colorsArray = InitObject(NSMutableArray);
    self.percentageArray = InitObject(NSMutableArray);
    
    [self.view addSubview:self.backScroll];
    [self.backScroll addSubview:self.topBackView];
    [self.backScroll addSubview:self.topView];
    [self.topView addSubview:self.pieChartView];
    [self.topView addSubview:self.amountLabel];
    [self.topView addSubview:self.amountTitle];
    [self.topView addSubview:self.switchBtn];
    [self.backScroll addSubview:self.bottomView];
  
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.pieChartView.mas_centerY).offset(-kSizeFrom750(30));
        make.centerX.mas_equalTo(self.pieChartView);
    }];
    [self.amountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.pieChartView.mas_centerY).offset(kSizeFrom750(50));
        make.centerX.mas_equalTo(self.pieChartView);
    }];
    [self getRequest];
    
    // Do any additional setup after loading the view.
}
#pragma mark --lazyLoading
-(UIScrollView *)backScroll
{
    if (!_backScroll) {
        _backScroll = [[UIScrollView alloc]initWithFrame:RECT(0, kNavHight, screen_width, kViewHeight)];
    }
    return _backScroll;
}
-(UIView *)topBackView{
    if (!_topBackView) {
        _topBackView = [[UIView alloc]initWithFrame:RECT(0, 0, screen_width, kContentWidth/2)];
        _topBackView.backgroundColor = navigationBarColor;
    }
    return _topBackView;
}
-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:RECT(kOriginLeft*2, kSizeFrom750(30), kSizeFrom750(630), kSizeFrom750(720))];
        _topView.backgroundColor = COLOR_White;
        [CommonUtils setShadowCornerRadiusToView:_topView];
    }
    return _topView;
}
-(ZFPieChart *)pieChartView
{
    if (!_pieChartView) {
        _pieChartView = [[ZFPieChart alloc] initWithFrame:CGRectMake(kOriginLeft, 0, self.topView.width - kOriginLeft*2, self.topView.width - kOriginLeft*2)];
        _pieChartView.dataSource = self;
        _pieChartView.delegate = self;
        _pieChartView.isShadow = NO;
        _pieChartView.isShowPercent = NO;//不显示百分比
        _pieChartView.piePatternType = kPieChartPatternTypeCirque;
    }
    return _pieChartView;
}
-(UILabel *)amountTitle{
    if (!_amountTitle) {
        _amountTitle = InitObject(UILabel);
        _amountTitle.textColor = RGB_153;
        _amountTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _amountLabel;
}
-(UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = InitObject(UILabel);
        _amountLabel.textColor = RGB_51;
        _amountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _amountLabel;
}
-(UIButton *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = InitObject(UIButton);
        _switchBtn.frame = RECT(0, _pieChartView.bottom+kSizeFrom750(20), kSizeFrom750(300), kSizeFrom750(60));
        _switchBtn.centerX = _pieChartView.centerX;
        [_switchBtn setTitle:btnTitle forState:UIControlStateNormal];
        _switchBtn.layer.cornerRadius = kSizeFrom750(8);
        _switchBtn.layer.borderColor = [RGB(255, 110, 64) CGColor];;
        [_switchBtn setTitleColor:RGB(255, 110, 64) forState:UIControlStateNormal];
        _switchBtn.layer.borderWidth = kLineHeight;
        _switchBtn.layer.masksToBounds = YES;
        [_switchBtn.titleLabel setFont:SYSTEMSIZE(28)];
        _switchBtn.adjustsImageWhenHighlighted = NO;
        [_switchBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:RECT(self.topView.left, self.topView.bottom+kSizeFrom750(30), self.topView.width, 0)];
    }
    return _bottomView;
}
#pragma mark --数据处理
-(void)loadbottomView
{
    [self.pieChartView strokePath];
    [self.bottomView removeAllSubViews];
    
    NSArray *dataArray ;
    NSString *amount;
    NSString *title;
    if (self.isMyIncome) {
        dataArray = self.baseModel.profit_amount_info;
        amount = [CommonUtils getHanleNums:self.baseModel.total_profit_amount];
        title = self.baseModel.total_profit_amount_txt;
    }else
        {
            dataArray = self.baseModel.amount_info;
            amount = [CommonUtils getHanleNums:self.baseModel.total_amount];
            title = self.baseModel.total_amount_txt;
            
        }
    self.amountLabel.text = amount;
    self.amountTitle.text = title;
    for (int i=0 ; i<dataArray.count; i++) {
        InfoContentModel *model = [dataArray objectAtIndex:i];
        UIView *subView = [[UIView alloc]initWithFrame:RECT(0, kSizeFrom750(100)*i, self.bottomView.width, kSizeFrom750(70))];
        subView.layer.cornerRadius = kSizeFrom750(8);
        subView.layer.borderColor = [RGB_183 CGColor];
        subView.layer.borderWidth = kLineHeight;
        subView.backgroundColor = COLOR_White;
        [self.bottomView addSubview:subView];

        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:RECT(kSizeFrom750(50),kSizeFrom750(20), kSizeFrom750(200), kSizeFrom750(30))];
        titleLabel.font = SYSTEMSIZE(28);
        titleLabel.textColor = RGB_183;
        titleLabel.text = model.title;
        [subView addSubview:titleLabel];
        
        UIView *icon = [[UIView alloc]initWithFrame:RECT(kSizeFrom750(20), 0, kSizeFrom750(10), kSizeFrom750(10))];
        icon.centerY = titleLabel.centerY;
        icon.layer.cornerRadius = kSizeFrom750(10)/2;
        icon.layer.masksToBounds = YES;
        icon.backgroundColor = HEXCOLOR(model.color);
        [subView addSubview:icon];

        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:RECT(titleLabel.right,titleLabel.top, subView.width - titleLabel.right -kSizeFrom750(20),titleLabel.height)];
        contentLabel.font = NUMBER_FONT(30);
        contentLabel.textColor = RGB_51;
        contentLabel.textAlignment = NSTextAlignmentRight;
        contentLabel.text =[@"￥" stringByAppendingString:[CommonUtils getHanleNums:model.amount]];
        [subView addSubview:contentLabel];
        
        if (i==dataArray.count-1) {
            self.bottomView.height = subView.bottom+kSizeFrom750(20);
            self.backScroll.contentSize = CGSizeMake(screen_width, self.bottomView.bottom);
        }
    }
}
#pragma mark --buttonClick
-(void)switchBtnClick:(UIButton *)sender{
    if (self.isMyIncome) {//我的收益点击切换为总资产
        btnTitle = @"查看我的资产";
        self.titleString = @"我的收益";
        self.switchBtn.layer.borderColor = [RGB(255, 110, 64) CGColor];;
        [_switchBtn setTitleColor:RGB(255, 110, 64) forState:UIControlStateNormal];
        
    }else{
        btnTitle = @"查看我的收益";
        self.titleString = @"我的资产";
        self.switchBtn.layer.borderColor = [RGB(103, 137, 255) CGColor];;
        [self.switchBtn setTitleColor:RGB(103, 137, 255) forState:UIControlStateNormal];
    }
    self.isMyIncome = !self.isMyIncome;
    [self getRequest];
    [self.switchBtn setTitle:btnTitle forState:UIControlStateNormal];
}
#pragma mark --pieChartDelegate and DataSource
//返回value数据(NSArray必须存储NSString类型)
- (NSArray *)valueArrayInPieChart:(ZFPieChart *)chart{
    return self.percentageArray;
}
//返回颜色数组(NSArray必须存储UIColor类型)
- (NSArray *)colorArrayInPieChart:(ZFPieChart *)chart{
    return self.colorsArray;
}
//设置饼图的半径

- (CGFloat)radiusForPieChart:(ZFPieChart *)pieChart{
    return kSizeFrom750(240);
}
/**
 *  当饼图类型为圆环类型时，可通过此方法把半径平均分成n段，圆环的线宽为n分之1，间接计算圆环线宽，简单理解就是调整圆环线宽的粗细
 *  (若不设置，默认平均分2段)
 *  (e.g. 当radius为150，把半径平均分成4段，则圆环的线宽为150 * (1 / 4), 即37.5)，如下图所示
 *
 *  (PS:此方法对 整圆(kPieChartPatternTypeForCircle)类型 无效)
 *
 *  @return 设置半径平均段数(可以为小数, 返回的值必须大于1，当<=1时则自动返回默认值)
 */
-(CGFloat)radiusAverageNumberOfSegments:(ZFPieChart *)pieChart
{
    return 3.5;//将半径等分段数
}
#pragma mark --loadRequest
-(void)getRequest
{
    
    [[HttpCommunication sharedInstance] postSignRequestWithPath:self.isMyIncome?getMyTotalIncomeUrl:getMyTotalAmountUrl keysArray:@[kToken] valuesArray:@[[CommonUtils getToken]] refresh:nil success:^(NSDictionary *successDic) {
        self.baseModel = [MyIncomeModel yy_modelWithJSON:successDic];
        [self.percentageArray removeAllObjects];
        [self.colorsArray removeAllObjects];
        
        NSArray *dataArray;
        if (self.isMyIncome) {
            dataArray = self.baseModel.profit_amount_info;
        }else{
            dataArray = self.baseModel.amount_info;
        }
        for (int i=0; i<dataArray.count; i++) {
            InfoContentModel *model = dataArray[i];
            if ([model.proportion floatValue]>0.002) {
                [self.percentageArray addObject:@"0.002"];
                 [self.colorsArray addObject:COLOR_White];
            }
            [self.percentageArray addObject:model.proportion];
            [self.colorsArray addObject:HEXCOLOR(model.color)];
        }
        
       
        [self loadbottomView];

    } failure:^(NSDictionary *errorDic) {
        
    }];
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
