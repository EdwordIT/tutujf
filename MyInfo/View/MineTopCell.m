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
        //适配X下的nav的高度
        CGFloat navTitleHeight = kSizeFrom750(160)+kStatusBarHeight;
        self.contentView.backgroundColor = RGB_246;
        UIView *topBg = [[UIView alloc]initWithFrame:RECT(0, 0, screen_width, kSizeFrom750(330)+navTitleHeight)];
        topBg.backgroundColor = navigationBarColor;
        [self.contentView addSubview:topBg];
        
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
        //中间滚动视图
        _basepage=[[TopScrollBasePage alloc] initWithFrame:CGRectMake(0, topBg.height - kSizeFrom750(413) - kSizeFrom750(40), screen_width,kSizeFrom750(413)) DataArray:data selectBlock:^(TopScrollMode * data) {
            [self.delegate didopMineAtIndex:data.index];
        }];
        [topBg addSubview:_basepage];
        
      
        TopAccountModel * model2=[[TopAccountModel alloc] init];
        model2.account_url=@"";
        model2.tj_url=@"";
        model2.cz_url=@"";
        model2.accountnum=@"0.00";
        //可用余额类容
        _account=[[TopAccount alloc] initWithFrame:CGRectMake(kSizeFrom750(30), topBg.height - kSizeFrom750(85), screen_width-kSizeFrom750(30)*2,kSizeFrom750(206)) DataDir:model2 SelectBlock:^(NSInteger index) {
            [self.delegate didopMineAtIndex:index];
        }];
        _account.layer.shadowColor=RGB(214,214,214).CGColor;
        _account.layer.shadowOffset=CGSizeMake(1,1);
        _account.layer.shadowOpacity=0.5;
        _account.layer.shadowRadius=kSizeFrom750(10);
        _account.userInteractionEnabled=YES;
        [_account.layer setCornerRadius:kSizeFrom750(10)];
        
        
        
        [self.contentView addSubview:_account];
        
        
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

static TopScrollMode * extracted() {
    return [TopScrollMode alloc];
}

-(void)setModelData:(MyAccountModel *)userinfo
{
    TopAccountModel * model=[[TopAccountModel alloc] init];
    model.account_url=@"";
    model.tj_url=userinfo.cash_url;
    model.cz_url=userinfo.recharge_url;
    model.accountnum=userinfo.balance_amount;
    if(_account!=nil)
        [_account setDataBind:model];
    
    TopScrollMode *   m1=[extracted() init];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
