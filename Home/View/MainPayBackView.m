//
//  MainBackView.m
//  TTJF
//
//  Created by wbzhan on 2018/8/6.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MainPayBackView.h"

@interface MainPayBackView()
Strong UIView *backView;
Strong UIView *transformView;
Strong UIImageView *iconImage;
Strong UIButton *moreBtn;
Weak UIButton* topBtn;
Weak UIButton* bottomBtn;
Strong NSMutableArray *dataArray;
Assign NSInteger currentIndex;
Assign NSInteger unitCount;
@end

@implementation MainPayBackView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.backView];
        
        [self.backView addSubview:self.iconImage];
        
        [self.backView addSubview:self.transformView];
        
        self.currentIndex = 0;
        
        self.unitCount = 0;
        
        [self loadLayout];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDown:) name:Noti_CountDown object:nil];
    }
    return self;
}
-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = CORNER_RADIUS;

    }
    return _backView;
    
}
-(UIView *)transformView
{
    if (!_transformView) {
        _transformView = InitObject(UIView);
        _transformView.backgroundColor = [UIColor whiteColor];
    }
    return _transformView;
}
-(void)loadLayout{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kOriginLeft);
        make.right.mas_equalTo(-kOriginLeft);
        make.height.mas_equalTo(kSizeFrom750(120));
    }];
    
    [self.transformView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSizeFrom750(140));
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(kSizeFrom750(470));
        make.height.mas_equalTo(self.backView);
    }];
}
-(void)loadInfoWithDic:(NSArray *)paybackList{
    
    
    if (self.dataArray.count==0) {
        self.dataArray =[NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
        UIButton *top = [UIButton buttonWithType:UIButtonTypeCustom];
        [top setTitleColor:HEXCOLOR(@"#666666") forState:UIControlStateNormal];
        [self.transformView addSubview:top];
        self.topBtn = top;
        [top mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kSizeFrom750(15));
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(kSizeFrom750(45));
            make.width.mas_equalTo(kSizeFrom750(470));
        }];
        
        UIButton *bottom = [UIButton buttonWithType:UIButtonTypeCustom];
        [bottom setTitleColor:HEXCOLOR(@"#666666") forState:UIControlStateNormal];
        [self.transformView addSubview:bottom];
        self.bottomBtn = bottom;
        [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(top.mas_bottom);
            make.left.width.height.mas_equalTo(top);
        }];
    }
    if (self.dataArray.count%2==1) {
        [self.dataArray addObject:[self.dataArray firstObject]];
    }
    
}

-(void)transitionAnimation{
    
    //1.创建转场动画对象
    
    CATransition *transition=[[CATransition alloc]init];
    
    //2.设置动画类型,注意对于苹果官方没公开的动画类型只能使用字符串，并没有对应的常量定义
    transition.type=@"cube";
    
    typedef enum : NSUInteger {
        Fade = 1,                   //淡入淡出
        Push,                       //推挤
        Reveal,                     //揭开
        MoveIn,                     //覆盖
        Cube,                       //立方体
        SuckEffect,                 //吮吸
        OglFlip,                    //翻转
        RippleEffect,               //波纹
        PageCurl,                   //翻页
        PageUnCurl,                 //反翻页
        CameraIrisHollowOpen,       //开镜头
        CameraIrisHollowClose,      //关镜头
        CurlDown,                   //下翻页
        CurlUp,                     //上翻页
        FlipFromLeft,               //左翻转
        FlipFromRight,              //右翻转
        
    } AnimationType;
    //设置子类型

    transition.subtype=kCATransitionFromTop;
    //设置动画时常
    transition.duration=ANIMATION_TIME;
    //3.设置转场后的新视图添加转场动画
    [self.backView.layer addAnimation:transition forKey:kCATransitionMoveIn];
    [self.topBtn setTitle:[self.dataArray objectAtIndex:(self.currentIndex%self.dataArray.count)] forState:UIControlStateNormal];
    [self.bottomBtn setTitle:[self.dataArray objectAtIndex:(self.currentIndex%self.dataArray.count)+1] forState:UIControlStateNormal];
    self.currentIndex += 2;
    
}


-(void)countDown:(NSNotification *)noti{
    if (self.unitCount%3==0) {//3秒一次心跳
        [self transitionAnimation];
    }
    self.unitCount++;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
