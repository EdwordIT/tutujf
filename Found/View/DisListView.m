//
//  DisListView.m
//  TTJF
//
//  Created by wbzhan on 2018/8/2.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "DisListView.h"
#import "FoundListModel.h"
#import "UIImage+Color.h"
#import "DisSectionView.h"
#pragma mark --cell
@interface DisListCell:UIButton
Strong UILabel *title;
Strong UIImageView *bgImage;
Strong UILabel *date;
Strong UIImageView *stateImage;//活动状态
Strong UIView *lineView;
-(void) loadInfoWithModel:(FoundListModel *) model;
@end

@implementation DisListCell
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}
-(void)initViews {
    
    self.backgroundColor = COLOR_White;
    
    self.bgImage= [[UIImageView alloc] initWithFrame:CGRectMake(kSizeFrom750(30), kSizeFrom750(30),kSizeFrom750(690), kSizeFrom750(260))];
    [self.bgImage.layer setCornerRadius:kSizeFrom750(5)];
    [self addSubview:self.bgImage];
    
    
    self.stateImage = [[UIImageView alloc]initWithFrame:RECT(screen_width - kSizeFrom750(110) - kSizeFrom750(25), kSizeFrom750(62), kSizeFrom750(109), kSizeFrom750(48))];
    [self addSubview:self.stateImage];
    
    self.title= [[UILabel alloc] initWithFrame:CGRectMake(self.bgImage.left, self.bgImage.bottom+kSizeFrom750(20),self.bgImage.width, kSizeFrom750(30))];
    self.title.font = SYSTEMSIZE(28);
    self.title.textColor=RGB_51;
    self.title.numberOfLines = 0;
    [self addSubview: self.title];
    
    self.date= [[UILabel alloc] initWithFrame:CGRectMake(self.title.left, self.title.bottom+kSizeFrom750(20),self.title.width, kSizeFrom750(25))];
    self.date.font = NUMBER_FONT(24);
    self.date.textColor=RGB_153;
    [self addSubview: self.date];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kSizeFrom750(400),screen_width , kSizeFrom750(20))];
    self.lineView.backgroundColor =COLOR_Background;
    [self  addSubview:self.lineView];
}

-(void) loadInfoWithModel:(FoundListModel *) model{
    
    self.title.text=model.title;
    self.date.text=model.date;
    switch ([model.status integerValue]) {
        case 1://进行中
        {
            [self.stateImage setImage:IMAGEBYENAME(@"activity_ing")];
            [self.bgImage setImageWithString:model.pic_url];
        }
            break;
        case 2://已过期
        {
            [self.stateImage setImage:IMAGEBYENAME(@"activity_over")];
            [self.bgImage sd_setImageWithURL:URLStr(model.pic_url) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [self.bgImage setImage:[UIImage covertToGrayImageFromImage:image]];
            }];
        }
            break;
        case 3://未开始
            [self.stateImage setImage:IMAGEBYENAME(@"activity_unstart")];
            break;
        default:
            break;
    }
}
@end
#pragma mark --listView
@interface DisListView()

@end

@implementation DisListView
-(instancetype)init{
    self = [super init];
    if (self) {
        self.clipsToBounds = NO;
    }
    return self;
}
-(void)loadInfoWithArray:(NSArray *)array andTitle:(NSString *)title{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[DisListCell class]]) {
            [view removeFromSuperview];
        }
    }
//    [self removeAllSubViews];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kSizeFrom750(110))];
    headerView.backgroundColor =COLOR_Background;
    UILabel *textLabel = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, 0, kSizeFrom750(300),headerView.height)];
    textLabel.font = SYSTEMSIZE(32);
    textLabel.textColor = RGB_102;
    textLabel.text = title;
    [headerView addSubview:textLabel];
    [self addSubview:headerView];
    for (int i=0; i<array.count; i++) {
        DisListCell *cell = InitObject(DisListCell);
        [self addSubview:cell];
        FoundListModel *model = array[i];
        [cell loadInfoWithModel:model];
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerView.bottom+kSizeFrom750(420)*i);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(self);
            make.height.mas_equalTo(kSizeFrom750(420));
        }];
        cell.tag = i;
        [cell addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i==array.count-1) {
            [self layoutIfNeeded];
            self.contentSize = CGSizeMake(screen_width, cell.bottom);
        }
    }
}
-(void)buttonClick:(UIButton *)sender{
    
    if (self.listDelegate&&[self.listDelegate respondsToSelector:@selector(didClickListButtonIndex:)]) {
        [self.listDelegate didClickListButtonIndex:sender.tag];
    }
    
}

//超出父类页面可点击
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event

{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint myPoint = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, myPoint)) {
                if ([subView isKindOfClass:[DisSectionView class]]) {//按钮在listView之外子页面disSectionView的次级子页面，所以需要再向下一层
                    for (UIView *secView in subView.subviews){
                        CGPoint secPoint = [secView convertPoint:myPoint fromView:subView];
                        if (CGRectContainsPoint(secView.bounds, secPoint))
                        {
                            return secView;
                        }
                    }
                }
                return subView;
            }
        }
    }
    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
