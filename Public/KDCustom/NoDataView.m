//
//  NodataView.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/27.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView
- (id)init {
    self = [super init];
    if (self) {
        
        self.backgroundColor = RGB_246;
        
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGB_153;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font =SYSTEMSIZE(28);
        _titleLabel.text = @"暂无数据";
        [self addSubview:_titleLabel];
        
        _clickBtn = [[UIButton alloc]init];
        [_clickBtn setTitle:@"刷新数据" forState:UIControlStateNormal];
        [_clickBtn setTitleColor:RGB_153 forState:UIControlStateNormal];
        _clickBtn.adjustsImageWhenHighlighted = NO;
        _clickBtn.layer.cornerRadius = kSizeFrom750(10);
        _clickBtn.layer.masksToBounds = YES;
        _clickBtn.layer.borderColor = [RGB_153 CGColor];
        _clickBtn.layer.borderWidth = kLineHeight;
        [self addSubview:_clickBtn];
        [_clickBtn addTarget:self action:@selector(refreshClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self).mas_offset(-kSizeFrom750(40));
            make.width.height.mas_equalTo(CGSizeMake(kSizeFrom750(330), kSizeFrom750(330)));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(kSizeFrom750(40));
        }];
        
        [_clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kSizeFrom750(40));
        }];
    }
    return self;
}
-(void)refreshClick:(UIButton *)sender{
   
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}

-(void)creatBlock:(NodataRefreshBlock)block{
    _refreshBlock = block;
}
+ (NoDataView *)noDataRefreshBlock:(NodataRefreshBlock)block{
    
    NoDataView *view = [[NoDataView alloc] init];
    view.imageView.image = IMAGEBYENAME(@"icons_nodata");
    [view creatBlock:block];
    return view;
}

+(NoDataView *)noNetWorkView{
    return nil;
}


////重写view
//- (void)prepare{
//    [super prepare];
////主标题自定义
//    self.self.titleLabFont = SYSTEMSIZE(28);
//    self.self.titleLabTextColor = RGB_153;
////按钮自定义
//    self.actionBtnBorderColor = RGB_153;
//    self.actionBtnTitleColor = RGB_153;
//    self.actionBtnFont = SYSTEMSIZE(30);
//    self.actionBtnBorderWidth = kLineHeight;
////图片大小自定义
//    self.imageSize = CGSizeMake(kSizeFrom750(330), kSizeFrom750(330));
//
//    self.autoShowEmptyView = NO;//改为手动控制是否显示
//}
//+(instancetype)noDataEmpty{
//
//    return [NodataView emptyViewWithImageStr:@"nodata"
//                                    titleStr:@"暂无数据"
//                                   detailStr:@"请检查您的网络连接是否正确!"];
//}
//
////带刷新的nodataView
//+(instancetype)noDataRefreshBlock:(NodataRefreshBlock)refreshBlock
//{
//    return [NodataView emptyActionViewWithImageStr:@"icons_nodata" titleStr:@"暂无数据" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
//        refreshBlock();
//    }];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
