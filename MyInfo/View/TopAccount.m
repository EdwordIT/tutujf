//
//  TopAccount.m
//  TTJF
//
//  Created by 占碧光 on 2017/10/23.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "TopAccount.h"


@interface TopAccount ()
@property (nonatomic, copy  ) SelectedTopAccountAtIndex selectedTopAccount;
@property (nonatomic, strong) TopAccountModel *dataModel;

@end

@implementation TopAccount



- (instancetype)initWithFrame:(CGRect)frame  DataDir:(TopAccountModel *)data
                  SelectBlock:(SelectedTopAccountAtIndex)block
{
    self = [super initWithFrame:frame];
    self.dataModel=data;
    self.selectedTopAccount=block;
    self.backgroundColor=[UIColor whiteColor];
    if(self)
        [self initView];
    return self;
}

-(void) initView
{
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(56, 36, 120,14)];
    lab1.font = CHINESE_SYSTEM(14);
    lab1.textAlignment=NSTextAlignmentLeft;
    lab1.textColor =  RGB(83,83,83);
    lab1.text=@"可用金额（元）";
    [self addSubview:lab1];
    
    
    self.account = [[UILabel alloc] initWithFrame:CGRectMake(30, 57, 144,24)];
    self.account.font = NUMBER_FONT(24);
    self.account.textAlignment=NSTextAlignmentCenter;
    self.account.textColor =  RGB(252,18,18);
    self.account.text=@"";
    self.account.tag=7;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImage:)];
    [self.account addGestureRecognizer:tap1];
    if(self.dataModel!=nil)
    {
        self.account.text=self.dataModel.accountnum;
    }
    [self addSubview:self.account];
    
    _chongzhi = [UIButton buttonWithType:UIButtonTypeCustom];
    _chongzhi.frame = CGRectMake(self.frame.size.width-125,15, 110, 35);
    //  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref =RGB(252,18,18).CGColor;

    [_chongzhi.layer setBorderColor:colorref];//边框颜色
    //[btn1 setImage:[UIImage imageNamed:@"gogo.png"] forState:UIControlStateNormal];
    [_chongzhi addTarget:self action:@selector(button_event:) forControlEvents:UIControlEventTouchUpInside];
    _chongzhi.tag=5;
    [_chongzhi setTitle:@"充值" forState:UIControlStateNormal];//button title
    [_chongzhi.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [_chongzhi setTitleColor:RGB(255,255,255) forState:UIControlStateNormal];//title color
    
    _chongzhi.backgroundColor=RGB(252,18,18);
    [_chongzhi.layer setCornerRadius:17.5]; //设置矩形四个圆角半径
    [_chongzhi.layer setBorderWidth:0.0]; //边框宽度
    [self addSubview:_chongzhi];
    
    _tixian = [UIButton buttonWithType:UIButtonTypeCustom];
    _tixian.frame = CGRectMake(self.frame.size.width-125,59, 110, 35);
    //  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref1 =RGB(40,167,252).CGColor;
    [_tixian.layer setBorderColor:colorref1];//边框颜色
    //[btn1 setImage:[UIImage imageNamed:@"gogo.png"] forState:UIControlStateNormal];
    [_tixian addTarget:self action:@selector(button_event:) forControlEvents:UIControlEventTouchUpInside];
    _tixian.tag=6;
    [_tixian setTitle:@"提现" forState:UIControlStateNormal];//button title
    [_tixian.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [_tixian setTitleColor:RGB(255,255,255) forState:UIControlStateNormal];//title color
    
    _tixian.backgroundColor=RGB(40,167,252);
    [_tixian.layer setCornerRadius:17.5]; //设置矩形四个圆角半径
    [_tixian.layer setBorderWidth:0.0]; //边框宽度
    [self addSubview:_tixian];
    
}
-(void)OnTapImage:(UITapGestureRecognizer *)sender{
       BLOCK_EXEC(self.selectedTopAccount,sender.view.tag);
}

-(void)button_event:(UIButton*) sender
{
   BLOCK_EXEC(self.selectedTopAccount,sender.tag);
}

-(void) setDataBind:(TopAccountModel *)data
{
    for (UIView *subviews in [self subviews]) {
        if ([subviews isKindOfClass:[UILabel class]]) {
            [subviews removeFromSuperview];
        }
        if ([subviews isKindOfClass:[UIButton class]]) {
            [subviews removeFromSuperview];
        }
    }
        self.dataModel=data;
        [self initView];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
