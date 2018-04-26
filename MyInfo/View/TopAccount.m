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
@end

@implementation TopAccount



- (instancetype)initWithFrame:(CGRect)frame withBlock:(SelectedTopAccountAtIndex)block
{
    self = [super initWithFrame:frame];
    self.selectedTopAccount=block;
    self.backgroundColor=[UIColor whiteColor];
    if(self)
        [self initView];
    return self;
}

-(void) initView
{
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, kSizeFrom750(52), kSizeFrom750(380),kSizeFrom750(30))];
    lab1.font = SYSTEMSIZE(30);
    lab1.textAlignment=NSTextAlignmentCenter;
    lab1.textColor =  RGB(83,83,83);
    lab1.text=@"可用余额（元）";
    [self addSubview:lab1];
    
    
    self.account = [[UILabel alloc] initWithFrame:CGRectMake(0, lab1.bottom+kSizeFrom750(10), lab1.width,kSizeFrom750(50))];
    self.account.font = NUMBER_FONT(48);
    self.account.textAlignment=NSTextAlignmentCenter;
    self.account.textColor =  RGB(252,18,18);
    self.account.text=@"0.00";
 
    self.account.tag=7;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImage:)];
    [self.account addGestureRecognizer:tap1];
   
    [self addSubview:self.account];
    
    _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rechargeBtn.frame = CGRectMake(self.width - kSizeFrom750(285),kSizeFrom750(35),kSizeFrom750(230), kSizeFrom750(56));
    [_rechargeBtn addTarget:self action:@selector(button_event:) forControlEvents:UIControlEventTouchUpInside];
    _rechargeBtn.tag=5;
    [_rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];//button title
    [_rechargeBtn.titleLabel setFont:SYSTEMSIZE(30)];
    _rechargeBtn.layer.cornerRadius = kSizeFrom750(56)/2;
    _rechargeBtn.layer.masksToBounds = YES;
    _rechargeBtn.backgroundColor = RGB(253, 45, 20);
    [self addSubview:_rechargeBtn];
    
    _withdrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _withdrawBtn.frame = CGRectMake(_rechargeBtn.left,_rechargeBtn.bottom+kSizeFrom750(20), _rechargeBtn.width, _rechargeBtn.height);
    [_withdrawBtn addTarget:self action:@selector(button_event:) forControlEvents:UIControlEventTouchUpInside];
    _withdrawBtn.tag=6;
    [_withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];//button title
    [_withdrawBtn.titleLabel setFont:SYSTEMSIZE(30)];
    _withdrawBtn.layer.cornerRadius = kSizeFrom750(56)/2;
    _withdrawBtn.layer.masksToBounds = YES;
    _withdrawBtn.backgroundColor=RGB(40,167,252);
    [self addSubview:_withdrawBtn];
    
}
-(void)loadInfoWithAmount:(NSString *)amount{
        self.account.text = amount;
}
-(void)OnTapImage:(UITapGestureRecognizer *)sender{
       BLOCK_EXEC(self.selectedTopAccount,sender.view.tag);
}

-(void)button_event:(UIButton*) sender
{
   BLOCK_EXEC(self.selectedTopAccount,sender.tag);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
