//
//  OpenAdvertView.m
//  TTJF
//
//  Created by 占碧光 on 2017/4/17.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "OpenAdvertView.h"
@interface OpenAdvertView()
Strong UILabel *titleLabel;

Strong UILabel *subTitleLabel;
@end
@implementation OpenAdvertView
{
    UIImageView * imageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        CGFloat width = kSizeFrom750(654);
        CGFloat height = kSizeFrom750(956);
         imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, width, height)];
        imageView.center = self.center;
        imageView.tag = 1;
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
//
//        self.titleLabel = [[UILabel alloc]initWithFrame:RECT(kSizeFrom750(50), imageView.bottom+kSizeFrom750(30), kSizeFrom750(380), kSizeFrom750(70))];
//        [self.titleLabel setFont:SYSTEMSIZE(26)];
//        [self.titleLabel setTextColor:RGB_102];
//
//        [CommonUtils setAttString:@"您的土土账户已经注册成功，接下来请开通您的理财账户" withLineSpace:kSizeFrom750(10) titleLabel:self.titleLabel];
//        self.titleLabel.numberOfLines = 0;
//        [self addSubview:self.titleLabel];
//
//        self.subTitleLabel = [[UILabel alloc]initWithFrame:RECT(self.titleLabel.left, self.titleLabel.bottom+kSizeFrom750(20), self.titleLabel.width, kSizeFrom750(25))];
//        self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
//        self.subTitleLabel.font = SYSTEMSIZE(22);
//        self.subTitleLabel.textColor = RGB_183;
//        self.subTitleLabel.text = @"资金有保障 投资更放心";
//        self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:self.subTitleLabel];
//
        UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];//取消
        btn1.frame = CGRectMake(imageView.width/2 - kSizeFrom750(311),imageView.height - kSizeFrom750(87), kSizeFrom750(311), kSizeFrom750(87));
        [btn1 addTarget:self action:@selector(OnSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn1.tag=2;
        [imageView addSubview:btn1];
        
        UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];//托管
        btn2.frame = CGRectMake(btn1.right, btn1.top,btn1.width, btn1.height);
        [btn2 addTarget:self action:@selector(OnSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn2.tag=1;
        [imageView addSubview:btn2];
     
    }
    
    return self;
}

//-(void) setDataBind:(MyAccountModel *) userinfo
//{
//    [imageView setImageWithString:userinfo.trust_reg_imgurl];
//}
-(void) setImageWithUrl:(NSString *) urlString{
        [imageView setImageWithString:urlString];
}

-(void) OnSaveBtn:(UIButton *)sender
{
    [self.delegate didOpenAdvertView:sender.tag];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
