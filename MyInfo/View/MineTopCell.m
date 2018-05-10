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
        [self.contentView setBackgroundColor:COLOR_Background];
        //适配X下的nav的高度
        CGFloat navTitleHeight = kNavHight;
        UIView *topBg = [[UIView alloc]initWithFrame:RECT(0, 0, screen_width, kSizeFrom750(350)+navTitleHeight)];
        topBg.backgroundColor = navigationBarColor;
        [self.contentView addSubview:topBg];
        
        NSMutableArray * data=[[NSMutableArray alloc] init];
        TopScrollMode * model=[[TopScrollMode alloc] init];
        model.accountnum=@"0.00";
        model.accountname=@"总资产(元)";
        model.index=3;
        model.imageName=@"mineTop_01";
        [data addObject:model];
        TopScrollMode * model1=[[TopScrollMode alloc] init];
        model1.accountnum=@"0.00";
        model1.accountname=@"累计收益(元)";
        model1.index=4;
        model1.imageName=@"mineTop_02";
        [data addObject:model1];
        //中间滚动视图
        _basepage=[[TopScrollBasePage alloc] initWithFrame:CGRectMake(0, topBg.height - kSizeFrom750(413), screen_width,kSizeFrom750(413)) DataArray:data selectBlock:^(TopScrollMode * data) {
            [self.delegate didopMineAtIndex:data.index];
        }];
        [topBg addSubview:_basepage];
        
    
        //可用余额类容
        _account=[[TopAccount alloc] initWithFrame:CGRectMake(kSizeFrom750(30), topBg.height - kSizeFrom750(85), screen_width-kSizeFrom750(30)*2,kSizeFrom750(205))  withBlock:^(NSInteger index) {
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
-(void)setModelData:(MyAccountModel *)userinfo
{
    
    [_account loadInfoWithAmount:userinfo.balance_amount];
    //总资产
    _basepage.jiner1.text=[NSString stringWithFormat:@"%.2f",[userinfo.total_amount floatValue]];
    //累计收益
    _basepage.jiner2.text=[NSString stringWithFormat:@"%.2f",[userinfo.to_interest_award floatValue]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
