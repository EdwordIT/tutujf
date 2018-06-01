//
//  CooperationController.m
//  TTJF
//
//  Created by wbzhan on 2018/5/3.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "CooperationController.h"
#import "BaseModel.h"
@interface CooperationModel:BaseModel
Copy NSString *img_url;
Copy NSString *title;
Copy NSString *content;
@end

@implementation CooperationModel

@end
typedef void  (^AnimationFinishedBlock)(NSInteger tag);
/**
 风控合作子view
 */
@interface CooperationView:UIView
Strong UIImageView *iconImage;
Strong UILabel *titleLabel;
Strong UILabel *textLabel;
Copy AnimationFinishedBlock finishedBlock;
-(void)reloadLayout:(BOOL)isBack;

@end
@implementation CooperationView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView
{
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.iconImage];
    
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.textLabel];
    
}
-(UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]initWithFrame:RECT(0, kSizeFrom750(100)+kViewHeight, screen_width, kSizeFrom750(350))];
        _iconImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImage;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:RECT(0, kSizeFrom750(490)+kViewHeight, screen_width, kSizeFrom750(40))];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = SYSTEMBOLDSIZE(36);
        _titleLabel.textColor = navigationBarColor;
    }
    return _titleLabel;
}
-(UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]initWithFrame:RECT(kOriginLeft*2, kSizeFrom750(570)+kViewHeight, kSizeFrom750(630), kSizeFrom750(300))];
        _textLabel.textColor = RGB_102;
        _textLabel.numberOfLines = 0;
        _textLabel.font = SYSTEMSIZE(28);
    }
    return _textLabel;
}
-(void)changeTitle{
    [UIView animateWithDuration:0.3 animations:^{
        self.titleLabel.top = kSizeFrom750(490);
    }];
}
-(void)changeText{
    [UIView animateWithDuration:0.3 animations:^{
        self.textLabel.top = kSizeFrom750(570);
    }];
}
-(void)reloadBlock
{
    if (self.finishedBlock) {
        self.finishedBlock(self.tag);
    }
}
-(void)reloadLayout:(BOOL)isBack
{
    if (!isBack) {
        [self reloadBlock];
        [UIView animateWithDuration:0.3 animations:^{
            self.iconImage.top = kSizeFrom750(100);
        }];
        [self performSelector:@selector(changeTitle) withObject:nil afterDelay:0.3];
        [self performSelector:@selector(changeText) withObject:nil afterDelay:0.6];
       

    }else{
        self.iconImage.top = kSizeFrom750(100)+kViewHeight;
    
        self.titleLabel.top = kSizeFrom750(490)+kViewHeight;
        
        self.textLabel.top = kSizeFrom750(570)+kViewHeight;

    }
   
}
@end

@interface CooperationController ()<UIScrollViewDelegate>
Strong UIScrollView *scrollView;
Assign NSInteger currentPage;
Strong NSMutableArray *dataArray;
Strong UIImageView *bottomImage;
Strong UIButton *bottomBtn;
Strong NSTimer *timer;
Assign NSInteger countdown;
@end

@implementation CooperationController
-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"风控合作";
    [self.view addSubview:self.scrollView];
    self.currentPage = 0;//默认选项
    self.dataArray = InitObject(NSMutableArray);
    [self getRequest];
    self.countdown = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                               target:self
                                                selector:@selector(animationRepeat:)
                                             userInfo:nil
                                              repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    // Do any additional setup after loading the view.
}
-(void)animationRepeat:(NSTimer *)timer{
    self.countdown=self.countdown+2;
    self.bottomBtn.alpha =   fabs(sin((self.countdown/180.0*M_PI))) ;//正弦函数取绝对值
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:RECT(0, kNavHight, screen_width, kViewHeight)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = RGB(250, 250, 250);
    }
    return _scrollView;
}
-(UIImageView *)bottomImage
{
    if (!_bottomImage) {
        _bottomImage = [[UIImageView alloc]initWithFrame:RECT(0, screen_height - kSizeFrom750(200), screen_width, kSizeFrom750(200))];
        [_bottomImage setImage:IMAGEBYENAME(@"cooperationBottom")];
    }
    return _bottomImage;
}
-(UIButton *)bottomBtn
{
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc]initWithFrame:RECT(0, kSizeFrom750(80), kSizeFrom750(237), kSizeFrom750(98))];
        _bottomBtn.centerX = screen_width/2;
        [_bottomBtn setImage:IMAGEBYENAME(@"cooperation_pull") forState:UIControlStateNormal];
        _bottomBtn.adjustsImageWhenHighlighted = NO;
        [_bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}
-(void)getRequest
{
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getCooperationUrl keysArray:nil valuesArray:nil refresh:nil success:^(NSDictionary *successDic) {
        if ([successDic isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)successDic;
            for (NSDictionary *dic in arr) {
                CooperationModel *model = [CooperationModel yy_modelWithJSON:dic];
                [self.dataArray addObject:model];
            }
            [self loadScrollView];
        }
       
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
-(void)loadScrollView
{
    [self.scrollView removeAllSubViews];
    
    [self.view addSubview:self.bottomImage];
    
    [self.bottomImage addSubview:self.bottomBtn];
    for (int i=0; i<self.dataArray.count; i++) {
        CooperationView *view = [[CooperationView alloc]initWithFrame:RECT(0, kViewHeight*i, screen_width, kViewHeight)];
        [self.scrollView addSubview:view];
        CooperationModel *model = [self.dataArray objectAtIndex:i];
        [view.iconImage setImageWithString:model.img_url];
        view.titleLabel.text = model.title;
        if ([model.content rangeOfString:@"\\n"].location!=NSNotFound) {
          model.content = [model.content stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        }
        [CommonUtils setAttString:model.content withLineSpace:kSizeFrom750(12) titleLabel:view.textLabel];
        view.textLabel.height = [CommonUtils getSpaceLabelHeight:model.content withFont:view.textLabel.font withWidth:view.textLabel.width lineSpace:kSizeFrom750(12)];
        view.tag = i+10;
        view.finishedBlock = ^(NSInteger tag){
            for (UIView *view in self.scrollView.subviews) {
                if ([view isKindOfClass:[CooperationView class]]) {
                    if (view.tag!=tag) {
                        [(CooperationView *)view reloadLayout:YES];
                    }
                }
                
            }
        };
    }
    
    self.scrollView.contentSize = CGSizeMake(screen_width, kViewHeight*self.dataArray.count);

    [((CooperationView *)[self.scrollView viewWithTag:10]) reloadLayout:NO];
}
//点击进入下一页
-(void)bottomBtnClick:(UIButton *)sender
{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
  
    CGFloat pageFloat = scrollview.contentOffset.y / scrollview.height;
    int page = roundf(pageFloat);
    if (self.currentPage!=page) {//如果滑动成功
        
        self.currentPage = page;
        CooperationView *sub = [self.scrollView viewWithTag:self.currentPage+10];
        if (sub!=nil) {
            [sub reloadLayout:NO];
        }
    }else{
        
    }
    
    if (page==self.dataArray.count-1) {
        [self.bottomBtn setImage:IMAGEBYENAME(@"") forState:UIControlStateNormal];
    }else{
        [self.bottomBtn setImage:IMAGEBYENAME(@"cooperation_pull") forState:UIControlStateNormal];
    }
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
