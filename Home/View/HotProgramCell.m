//
//  HotProgramCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/3/12.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "HotProgramCell.h"
#import "UIButton+WebCache.h"


@implementation HotProgramCell
{
    UIButton  * selectbg1;
    UIButton * selectbg2;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=separaterColor;
        [self initViews];
    }
    return self;
}

-(void)initViews {
    selectbg1=  [UIButton buttonWithType:UIButtonTypeCustom];
    selectbg1.frame=CGRectMake(10, 7.5, screen_width/2-15, 70);
    selectbg1.tag=1;
    
    selectbg1.backgroundColor=RGB(255,255,255);
    [selectbg1 setImage:[UIImage imageNamed:@"rmbg12"] forState:UIControlStateNormal];
    [selectbg1 setImage:[UIImage imageNamed:@"rmbg13"] forState:UIControlStateHighlighted];
  //  selectbg1.layer.shadowColor=[UIColor grayColor].CGColor;
  // selectbg1.layer.shadowOffset=CGSizeMake(1,1);
   // selectbg1.layer.shadowOpacity=0.5;
   // selectbg1.layer.shadowRadius=2;
    [selectbg1 addTarget:self action:@selector(OnTapBack:) forControlEvents:UIControlEventTouchUpInside];//button 点击回调方法
    
    
    selectbg2=  [UIButton buttonWithType:UIButtonTypeCustom];
     selectbg2.frame=CGRectMake(screen_width/2+5, 7.5, screen_width/2-15, 70);
    [selectbg2 setImage:[UIImage imageNamed:@"rmbg12"] forState:UIControlStateNormal];
    [selectbg2 setImage:[UIImage imageNamed:@"rmbg13"] forState:UIControlStateHighlighted];
    selectbg2.tag=2;
   // selectbg2.layer.shadowColor=[UIColor grayColor].CGColor;
    //selectbg2.layer.shadowOffset=CGSizeMake(1,1);
   // selectbg2.layer.shadowOpacity=0.5;
   // selectbg2.layer.shadowRadius=2;
    [selectbg2 addTarget:self action:@selector(OnTapBack:) forControlEvents:UIControlEventTouchUpInside];//button 点击回调方法
    //selectbg1 jiekuan
    
    
    self.topLeftLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 17,100, 12)];
    _topLeftLabel1.font = CHINESE_SYSTEM(12);
    _topLeftLabel1.textColor=RGB(102,102,102);
    _topLeftLabel1.text=@"我要借款";
  //  [selectbg1 addSubview:self.topLeftLabel1];
    
    //
    _bottomLeftLabel1= [[UILabel alloc] initWithFrame:CGRectMake(10, 43,120,13)];
    _bottomLeftLabel1.text=@"钱到手车开走";
      _bottomLeftLabel1.font = CHINESE_SYSTEM(13);
    _bottomLeftLabel1.textColor = RGB(254,137,18);
    _bottomLeftLabel1.textAlignment=NSTextAlignmentLeft;
    /*
    NSInteger index=[ _bottomLeftLabel1.text rangeOfString:@"亿"].location;
    NSInteger len=[ _bottomLeftLabel1.text  length];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString: _bottomLeftLabel1.text];
    [textColor addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:16.0] range:NSMakeRange(0, index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,136,19) range:NSMakeRange(0, index)];
    [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(13) range:NSMakeRange(index,len-index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,136,19)  range:NSMakeRange(index, len-index)];
           [_bottomLeftLabel1 setAttributedText:textColor];
     */
  //  [selectbg1 addSubview:_bottomLeftLabel1];
    
    _topLeftImg = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/2-97, 10, 72, 52)];
    [_topLeftImg setImage:[UIImage imageNamed:@"Home_Meun_Turnover"]];
   // [selectbg1 addSubview:_topLeftImg];
    
 
    
    
 
    self.topRightLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 17,100, 12)];
    _topRightLabel1.font = CHINESE_SYSTEM(12);
    _topRightLabel1.textColor=RGB(102,102,102);
    _topRightLabel1.text=@"新手指引";
   // [selectbg2 addSubview:self.topRightLabel1];
    //
    _bottomRightLabel1= [[UILabel alloc] initWithFrame:CGRectMake(10, 43, 100, 13)];
    _bottomRightLabel1.font = CHINESE_SYSTEM(13);
    _bottomRightLabel1.textColor = RGB(144,130,246);
    _bottomRightLabel1.text=@"入门宝典";
   // [selectbg2 addSubview:_bottomRightLabel1];
    
    _topRightImg = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/2-97, 10, 72, 52)];
    [_topRightImg setImage:[UIImage imageNamed:@"Home_Meun_Novice"]];
 //   [selectbg2 addSubview:_topRightImg];
    
    [self.contentView addSubview:selectbg1];
    
    [self.contentView addSubview:selectbg2];
    
}

-(void)OnTapBack:(UIButton *)sender{
    UIButton *imageView = (UIButton *)sender;
    
    [self.delegate didSelectedProgramAtIndex:imageView.tag];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setHotQueueData:(HotQueueModel *)hotQueue{
    //_hotQueue = hotQueue; [NSURL URLWithString:hotQueue.left_pic_url]
  // [self.topLeftImg sd_setImageWithURL:[NSURL URLWithString:hotQueue.left_pic_url] placeholderImage:nil];
    [selectbg1 sd_setImageWithURL:[NSURL URLWithString:hotQueue.left_pic_url]  forState:UIControlStateNormal ];
     [selectbg1 sd_setImageWithURL:[NSURL URLWithString:hotQueue.left_pic_url]  forState:UIControlStateHighlighted];
       [selectbg2 sd_setImageWithURL:[NSURL URLWithString:hotQueue.right_pic_url]  forState:UIControlStateHighlighted];
     [selectbg2 sd_setImageWithURL:[NSURL URLWithString:hotQueue.right_pic_url]  forState:UIControlStateNormal ];
  //  _topLeftLabel1.text = hotQueue.l;
  //  _bottomLeftLabel1.text = hotQueue.sub_title;
 //   [self.topRightImg sd_setImageWithURL:[NSURL URLWithString:hotQueue.right_pic_url] placeholderImage:nil];
 //   _topRightLabel1.text = xinshou.title;
   // _bottomRightLabel1.text = xinshou.sub_title;
    

}

@end
