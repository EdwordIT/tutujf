//
//  MineTopCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/10/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "MineTopCell.h"


@implementation MineTopCell
{

}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=RGB(240,240,240);
        UIView  * backcolor=[[UIView alloc] initWithFrame: CGRectMake(0, 0, screen_width, 264)];
        backcolor.backgroundColor=navigationBarColor;
         [self addSubview:backcolor];
        NSMutableArray * data=[[NSMutableArray alloc] init];
        TopScrollMode * model=[[TopScrollMode alloc] init];
        model.accountnum=@"0.00";
        model.accountname=@"总资产(元)";
        model.account_url=[oyUrlAddress stringByAppendingString:@"/wap/member/account"];
        model.index=3;
        model.image_url=[oyUrlAddress stringByAppendingString:@"/wapassets/trust/images/news/user06.png"];
        [data addObject:model];
         TopScrollMode * model1=[[TopScrollMode alloc] init];
         model1.accountnum=@"0.00";
         model1.accountname=@"累计收益(元)";
         model1.account_url=[oyUrlAddress stringByAppendingString:@"/wap/member/accounttwo"];
          model1.index=4;
           model1.image_url=[oyUrlAddress stringByAppendingString:@"/wapassets/trust/images/news/user07.png"];
         [data addObject:model1];
      
        _basepage=[[TopScrollBasePage alloc] initWithFrame:CGRectMake(0, 30, screen_width,190) DataArray:data selectBlock:^(TopScrollMode * data) {
            [self.delegate didopMineAtIndex:data.index];
        }];
     
       [self addSubview:_basepage];
        
        UIView  * backimg=[[UIView alloc] initWithFrame: CGRectMake(15, 35, 50, 50)];
        backimg.backgroundColor=RGB(197,231,252);
        backimg.userInteractionEnabled=YES;
        [backimg.layer setCornerRadius:25];
        _leftBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(4, 4, 42, 42);
        [_leftBtn setImage:[UIImage imageNamed:@"user01.png"] forState:UIControlStateNormal];
        [_leftBtn setImage:[UIImage imageNamed:@"user01.png"] forState:UIControlStateHighlighted];
        [_leftBtn addTarget:self action:@selector(OnMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.tag=1;
        [_leftBtn.layer setBorderColor:[UIColor clearColor].CGColor];//边框颜色
        [_leftBtn.layer setBorderWidth:0]; //边框宽度
        [_leftBtn.layer setCornerRadius:25];
        _leftBtn.backgroundColor=[UIColor whiteColor];
        [backimg addSubview:_leftBtn];
        
       // [self addSubview:backimg];
        
        _leftName=[[UILabel alloc] initWithFrame:CGRectMake(75, 54, 200, 13)];
        _leftName.textAlignment=NSTextAlignmentLeft;
      //  _leftName.font=CHINESE_SYSTEM(13);
        _leftName.textColor=RGB(255,255,255);
        _leftName.text=@"******";
        _leftName.tag=2;
        _leftName.userInteractionEnabled=YES;
         [_leftName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImage:)];
        [_leftName addGestureRecognizer:tap1];
        // [self addSubview:_leftName];
   
        
        _rightView=[[UIView alloc] initWithFrame:CGRectMake(screen_width-55, 35, 40, 40)];
        _rightView.layer.cornerRadius = 20;
       _rightView.layer.borderWidth = 0.8;
        _rightView.layer.backgroundColor = [UIColor clearColor].CGColor;
        _rightView.layer.borderColor = [UIColor whiteColor].CGColor;
        UIImageView * image1=[[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 20, 20)];
        [image1 setImage:[UIImage imageNamed:@"user02.png"]];
        [_rightView addSubview:image1];
    
        _rightView.userInteractionEnabled=YES;
        _rightView.tag=2;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImage:)];
          [_rightView addGestureRecognizer:tap];
        
      //  [self addSubview:_rightView];
        
         if([_ishaveinfo isEqual:@"1"])
        {
            _infolimg=[[UIView alloc] initWithFrame:CGRectMake(screen_width-32, 42, 10,10)];
            _infolimg.layer.cornerRadius = 1.5;
                [_infolimg.layer setCornerRadius:5];
            _infolimg.backgroundColor=RGB(252,18,18);
          //  [self addSubview:_infolimg];
        }
        
        TopAccountModel * model2=[[TopAccountModel alloc] init];
        model2.account_url=@"";
          model2.tj_url=@"";
         model2.cz_url=@"";
        model2.accountnum=@"0.00";
        _account=[[TopAccount alloc] initWithFrame:CGRectMake(15, 214, screen_width-30,110) DataDir:model2 SelectBlock:^(NSInteger index) {
            [self.delegate didopMineAtIndex:index];
        }];
        _account.layer.shadowColor=RGB(214,214,214).CGColor;
        _account.layer.shadowOffset=CGSizeMake(1,1);
        _account.layer.shadowOpacity=0.5;
        _account.layer.shadowRadius=4;
        _account.userInteractionEnabled=YES;
        [_account.layer setCornerRadius:8];
        
       
        
        [self addSubview:_account];
        
        
    }
    return self;
}

-(void)OnTapImage:(UITapGestureRecognizer *)sender{
    [self.delegate didopMineAtIndex:sender.view.tag];
}

-(void)OnMenuBtn:(UIButton *)sender
{
        [self.delegate didopMineAtIndex:sender.tag];
    
}

-(void)setModelData:(UserInfo *)userinfo
{
    TopAccountModel * model=[[TopAccountModel alloc] init];
    model.account_url=@"";
    model.tj_url=userinfo.cash_url;
    model.cz_url=userinfo.recharge_url;
    model.accountnum=userinfo.balance_amount;
    if(_account!=nil)
        [_account setDataBind:model];
    
     TopScrollMode *   m1=[[TopScrollMode alloc] init];
      m1.accountnum=userinfo.total_amount;
      m1.accountname=@"总资产(元)";
      m1.account_url=[oyUrlAddress stringByAppendingString:@"/wap/member/account"];
      m1.index=3;
       m1.image_url=[oyUrlAddress stringByAppendingString:@"/wapassets/trust/images/news/user06.png"];
     TopScrollMode *   m2=[[TopScrollMode alloc] init];
    m2.accountnum=userinfo.to_interest_award;
    m2.accountname=@"累计收益(元)";
    m2.account_url=[oyUrlAddress stringByAppendingString:@"/wap/member/accounttwo"];
    m2.index=4;
    m2.image_url=[oyUrlAddress stringByAppendingString:@"/wapassets/trust/images/news/user07.png"];
    NSMutableArray * data=[[NSMutableArray alloc] init];
    [data addObject:m1];
     [data addObject:m2];
    if(_basepage!=nil)
    {
        _basepage.title2.text=[NSString stringWithFormat:@"%@",m2.accountname];
        _basepage.title1.text=[NSString stringWithFormat:@"%@",m1.accountname];
        
       _basepage.jiner1.text=[NSString stringWithFormat:@"%.2f",[m1.accountnum floatValue]];
        _basepage.jiner2.text=[NSString stringWithFormat:@"%.2f",[m2.accountnum floatValue]];
        //[_basepage setDataBind:data];
    }

}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
