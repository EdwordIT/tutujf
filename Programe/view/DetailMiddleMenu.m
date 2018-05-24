//
//  DetailMiddleMenu.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/15.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DetailMiddleMenu.h"
@interface DetailMiddleMenu ()
Strong UILabel *title;
Strong UILabel *content;
Strong UILabel *subContent;
Strong UIView *line;
@end

@implementation DetailMiddleMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    
    self.title=[[UILabel alloc] initWithFrame:CGRectMake(kOriginLeft, (self.frame.size.height-kSizeFrom750(30))/2, kSizeFrom750(220), kSizeFrom750(30))];
    self.title.textAlignment=NSTextAlignmentLeft;
    self.title.font=SYSTEMSIZE(28);
    self.title.textColor=RGB_183;
    [self addSubview:self.title];
    
    self.content=[[UILabel alloc] init];
    self.content.font=SYSTEMSIZE(28);
    self.content.textColor=RGB(80,80, 80);
    self.content.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.content];
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.title.mas_right).offset(kSizeFrom750(20));
        make.right.mas_equalTo(self).offset(-kOriginLeft);
        make.top.mas_equalTo(kSizeFrom750(30));
        make.height.mas_equalTo(kSizeFrom750(30));
    }];
    
    self.subContent=[[UILabel alloc] init];
    self.subContent.font=SYSTEMSIZE(26);
    self.subContent.textColor=RGB_183;
    self.subContent.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.subContent];
    
    [self.subContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.content);
        make.top.mas_equalTo(self.content.mas_bottom).offset(kSizeFrom750(10));
    }];
    
    self.line=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-kLineHeight, screen_width, kLineHeight)];
    self.line.backgroundColor=separaterColor;
    [self addSubview:self.line];
}
-(void)loadInfoWithModel:(IntroduceModel *)model{
    self.title.text = model.title;
    self.content.text = model.content;
    if (!IsEmptyStr(model.sub_content)) {
        [self.content mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kSizeFrom750(10));
        }];
        self.subContent.text = model.sub_content;
    }else{
        [self.content mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kSizeFrom750(30));
        }];
    }
}
-(void)setMenu:(NSString *)t1 content:(NSString *)c1
{
    self.title.text=t1;
    self.content.text=c1;
}

@end
