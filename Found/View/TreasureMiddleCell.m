//
//  TreasureMiddleCell.m
//  DingXinDai
//
//  Created by 占碧光 on 2016/12/8.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import "TreasureMiddleCell.h"
#import "UIImageView+WebCache.h"
#import "XunBaoMenuModel.h"

#define  widthMenu  96


@implementation TreasureMiddleCell
{
    UIView *lineView ;
    UIView *lineView1;
    UIView *lineView2;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        //新手指引   签到有礼     活动专区   理财小贴士  分期商场  砍价专区
    }
    return self;
}

-(void)didTreasureMiddleIndex:(NSInteger)index
{
     [self.delegate didTreasureMiddleIndex:index];
}

-(void)OnTapBack:(UIButton *)sender{
    lineView = [[UIView alloc] initWithFrame:CGRectMake( screen_width/3,0, 0.5, widthMenu)];
    lineView.backgroundColor = lineBg1;
    [self addSubview:lineView];
    
    lineView1= [[UIView alloc] initWithFrame:CGRectMake( (screen_width*2)/3,0, 0.5, widthMenu)];
    lineView1.backgroundColor = lineBg1;
    [self addSubview:lineView1];
    
    [self.delegate didTreasureMiddleIndex:sender.tag];
}


-(UIView *)getMenuView:(NSString *) imgsrc labstr:(NSString *)labstr ink:(NSInteger)ink
{
  //  UIView * menu=[[UIView alloc] init];
   UIButton *   menu=  [UIButton buttonWithType:UIButtonTypeCustom];

    [menu setImage:[UIImage imageNamed:@"rmbg12"] forState:UIControlStateNormal];
    [menu setImage:[UIImage imageNamed:@"rmbg14"] forState:UIControlStateHighlighted];
    [menu addTarget:self action:@selector(OnTapBack:) forControlEvents:UIControlEventTouchUpInside];//button 点击回调方法
    if(ink==1)
        menu.frame=CGRectMake(0, 0, screen_width/3, widthMenu);
    else if(ink==2)
        menu.frame=CGRectMake(screen_width/3, 0, screen_width/3, widthMenu);
    else if(ink==3)
        menu.frame=CGRectMake(screen_width*2/3, 0, screen_width/3, widthMenu);
    else if(ink==4)
        menu.frame=CGRectMake(0, widthMenu, screen_width/3, widthMenu);
    else if(ink==5)
        menu.frame=CGRectMake(screen_width/3, widthMenu, screen_width/3, widthMenu);
    else if(ink==6)
        menu.frame=CGRectMake(screen_width*2/3, widthMenu, screen_width/3, widthMenu);
    else
        menu.frame=CGRectMake((screen_width/3)*(ink%3-1), widthMenu*(ink%3-1), screen_width/3, widthMenu);

    UILabel  * lab1=[[UILabel alloc] initWithFrame:CGRectMake(0, 70,screen_width/3, 12)];
    
    lab1.font = CHINESE_SYSTEM(12);
    lab1.textColor=RGB(102,102,102);
    lab1.textAlignment=NSTextAlignmentCenter;
    lab1.text=labstr;
    
    [menu addSubview:lab1];
    
    UIImageView  * img = [[UIImageView alloc] initWithFrame:CGRectMake((screen_width/3-45)/2,14, 45,45)];
    if([imgsrc rangeOfString:@"http://"].location != NSNotFound||[imgsrc rangeOfString:@"https://"].location != NSNotFound)
    [img sd_setImageWithURL:[NSURL URLWithString:imgsrc] placeholderImage:[UIImage imageNamed:@"xinshouz"]];
    else
   [img setImage:[UIImage imageNamed:imgsrc]];
    [menu addSubview:img];
    
     menu.tag=10000+ink;
    
  
    
    return menu;
}

-(void) setDataBind:(NSMutableArray *) data
{
    for (UIView *subviews in [self subviews]) {
        if ([subviews isKindOfClass:[UIView class]]) {
            [subviews removeFromSuperview];
        }
        if ([subviews isKindOfClass:[UIButton class]]) {
            [subviews removeFromSuperview];
        }
        if ([subviews isKindOfClass:[UIImageView class]]) {
            [subviews removeFromSuperview];
        }
        if ([subviews isKindOfClass:[UILabel class]]) {
            [subviews removeFromSuperview];
        }
    }
    for(int k=0;k<data.count;k++)
    {
        XunBaoMenuModel * model=[data objectAtIndex:k];
        [self addSubview:[self getMenuView:model.pic_url labstr:model.title ink:k+1]];
    }
    if(data.count>5)
    {
        lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0,widthMenu, screen_width, 0.5)];
        lineView2.backgroundColor = lineBg1;
        [self addSubview:lineView2];
        
       UIView  * lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0,2*widthMenu, screen_width, 0.5)];
        lineView3.backgroundColor = lineBg1;
        [self addSubview:lineView3];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake( screen_width/3,0, 0.5, 2*widthMenu)];
        lineView.backgroundColor = lineBg1;
        [self addSubview:lineView];
        
        lineView1= [[UIView alloc] initWithFrame:CGRectMake( (screen_width*2)/3,0, 0.5, 2*widthMenu)];
        lineView1.backgroundColor = lineBg1;
        [self addSubview:lineView1];
        
    }
    else if(data.count>2)
    {
        lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0,widthMenu, screen_width, 0.5)];
        lineView2.backgroundColor = lineBg1;
        [self addSubview:lineView2];
       
        lineView = [[UIView alloc] initWithFrame:CGRectMake( screen_width/3,0, 0.5, 2*widthMenu)];
        lineView.backgroundColor = lineBg1;
        [self addSubview:lineView];
        
        lineView1= [[UIView alloc] initWithFrame:CGRectMake( (screen_width*2)/3,0, 0.5, 2*widthMenu)];
        lineView1.backgroundColor = lineBg1;
        [self addSubview:lineView1];
    }
    /*
    [self addSubview:[self getMenuView:@"xinshouzy" labstr:@"新手指引" ink:2]];
    [self addSubview:[self getMenuView:@"huodongzq" labstr:@"活动专区" ink:3]];
    [self addSubview:[self getMenuView:@"licaits" labstr:@"理财小贴士" ink:4]];
    [self addSubview:[self getMenuView:@"fenqisc" labstr:@"分期商场" ink:5]];
    [self addSubview:[self getMenuView:@"kanjiazq" labstr:@"砍价专区" ink:6]];
*/
    
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
