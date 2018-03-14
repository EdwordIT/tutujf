//
//  QuicklyXsCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/10/3.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "QuicklyXsCell.h"

@implementation QuicklyXsCell
{
    NSTimer * myTimer;
    UILabel * jindu;
    UIProgressView *processView;
    float jinduv;
    UILabel * lab5;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  //self.backgroundColor=RGB(221,221,221);
    if (self) {
        [self initViews];
    }
    return self;
}

-(void)initViews {
    self.typeimgsrc= [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/2+53, 21,75, 10)];
    [ self.typeimgsrc setImage:[UIImage imageNamed:@"gqzq.png"]];
    [self.contentView addSubview:self.typeimgsrc];
    
    
   UIImageView *img2= [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/2-15, 15,58, 19)];
    [ img2 setImage:[UIImage imageNamed:@"xinshouzx"]];
    [self.contentView addSubview:img2];
    //
    
    self.title= [[UILabel alloc] initWithFrame:CGRectMake(15, 20,screen_width-55, 12)];
    self.title.font = CHINESE_SYSTEM(12);
    self.title.textColor=RGB(51,51,51);
    self.title.text=@"长城0105-03（温州总部）";
    self.title.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview: self.title];
    
    
    self.yuqiinh= [[UILabel alloc] initWithFrame:CGRectMake(10, 51,70,20)];
    self.yuqiinh.text=@"18.00%";
    self.yuqiinh.textAlignment=NSTextAlignmentCenter;
    NSInteger index=[  self.yuqiinh.text rangeOfString:@"%"].location;
    NSInteger len=[  self.yuqiinh.text  length];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:  self.yuqiinh.text];
    [textColor addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:20] range:NSMakeRange(0, index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,48,19) range:NSMakeRange(0, index)];
    [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(13) range:NSMakeRange(index,len-index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,48,19)  range:NSMakeRange(index, len-index)];
    [ self.yuqiinh setAttributedText:textColor];
    [self.contentView addSubview: self.yuqiinh];
    
    
    
    UILabel * lab2= [[UILabel alloc] initWithFrame:CGRectMake(10, 75,70, 12)];
    lab2.font = CHINESE_SYSTEM(12);
    lab2.textColor=RGB(153,153,153);
    lab2.textAlignment=NSTextAlignmentCenter;
    lab2.text=@"年化收益率";
    //   [lab2 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [self.contentView addSubview:lab2];
    
    
    
    self.yuqisj= [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-25, 55,50, 15)];
    self.yuqisj.font = CHINESE_SYSTEM(15);
    self.yuqisj.textColor=RGB(51,51,51);
    self.yuqisj.text=@"1个月";
    self.yuqisj.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.yuqisj];
    
    
    //
    UILabel * lab3= [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-25, 75,50, 12)];
    lab3.font = CHINESE_SYSTEM(12);
    lab3.textColor=RGB(153,153,153);
    lab3.text=@"理财期限";
    //[lab3 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    lab3.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:lab3];
    
    lab5= [[UILabel alloc] initWithFrame:CGRectMake(screen_width-90, 98,90, 12)];
    lab5.font = CHINESE_SYSTEM(12);
    lab5.text=@"到期还本利息";
    lab5.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:lab5];
   
        UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(screen_width-81,50, 66, 32);
        //  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref =navigationBarColor.CGColor;
        
        [btn1.layer setBorderColor:colorref];//边框颜色
        
        //[btn1 setImage:[UIImage imageNamed:@"gogo.png"] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(button_event:) forControlEvents:UIControlEventTouchUpInside];
        btn1.tag=1;
        [btn1 setTitle:@"抢购" forState:UIControlStateNormal];//button title
        [btn1.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        [btn1 setTitleColor:RGB(255,255,255) forState:UIControlStateNormal];//title color
        
        btn1.backgroundColor=RGB(255,46,18);
        [btn1.layer setCornerRadius:16]; //设置矩形四个圆角半径
        [btn1.layer setBorderWidth:0.0]; //边框宽度
        [self.contentView addSubview:btn1];
        
        
    
        lab5.textColor=RGB(51,51,51);
        
    
    
    jindu = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2+15, 98,60, 12)];
    jindu.font = CHINESE_SYSTEM(12);
    jindu.textAlignment=NSTextAlignmentLeft;
    jindu.textColor=RGB(158,158,158);
    jindu.text=@"进度 70%";
    [self.contentView addSubview:jindu];
    
    processView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    processView.frame = CGRectMake(15, 103,screen_width/2-15, 6);
    [processView setProgressTintColor:RGB(48,156,246)];
    [processView setTrackTintColor:RGB(231,231,231)];
    
    jinduv=0.7;
    [processView setProgress:0.0];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                               target:self
                                             selector:@selector(download)
                                             userInfo:nil
                                              repeats:YES];
    //添加该控件到视图View中
    [self.contentView addSubview:processView];
    UIView * bottom=[[UIView alloc] initWithFrame:CGRectMake(0, 125, screen_width, 10)];
    bottom.backgroundColor= separaterColor;
    [self.contentView addSubview:bottom];
}


- (void)download
{
    if (processView.progress >= jinduv) {// 如果进度条到头了
        // 终止定时器
        [myTimer invalidate];
        return  ;
    }
    
    
    processView.progress += 0.04; // 设定步进长度
    //jindu.text=[[NSString stringWithFormat:@"进度:%.0f",processView.progress*100] stringByAppendingString:@"%"];
    // CGFloat xx=processView.progress*(screen_width/2)-50;
    //jindu.frame=CGRectMake(xx, 124, 50, 12);
    // CGFloat rr=44+processView.progress*176;
    CGFloat  gg=83+processView.progress*78;
    [processView setProgressTintColor:RGB(0,gg,239)];
    
}



-(void)button_event:(UIButton*) sender
{
    [self.delegate didSelectedQuicklyAtIndex:sender.tag];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setQuicklyModel:(QuicklyModel *)model
{
    [self.typeimgsrc sd_setImageWithURL:[NSURL URLWithString:model.activity_url_img] placeholderImage:@"Project list_tab_car_"];
    self.yuqisj.text=model.period;
   self.yuqiinh.text=model.apr;
     self.title.text=model.name;
    NSInteger index=[  self.yuqiinh.text rangeOfString:@"%"].location;
    NSInteger len=[  self.yuqiinh.text  length];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:  self.yuqiinh.text];
    [textColor addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:30] range:NSMakeRange(0, index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,136,19) range:NSMakeRange(0, index)];
    [textColor addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(15) range:NSMakeRange(index,len-index)];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGB(255,136,19)  range:NSMakeRange(index, len-index)];
    [ self.yuqiinh setAttributedText:textColor];
 
   
}


@end
