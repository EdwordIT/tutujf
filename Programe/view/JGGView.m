//
//  JGGView.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/29.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "JGGView.h"
#import "RFImageView.h"
#import "SDPhotoBrowser.h"

@interface JGGView()<SDPhotoBrowserDelegate>

@end

@implementation JGGView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)loadJGGViewWithDataSource:(NSArray *)dataSource completeBlock:(TapBlcok)tapBlock
{
    self.backgroundColor = separaterColor;
    [self removeAllSubViews];
    NSLog(@"model.imgArray1 = %@",dataSource);
    CGFloat imageWidth = kSizeFrom750(150);
    CGFloat imageHeight = kSizeFrom750(150);
    self.dataSource = dataSource;
    self.tapBlock = tapBlock;
    for (NSUInteger i=0; i<dataSource.count; i++) {
      
        RFImageView *iv = [[RFImageView alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
        [self addSubview:iv];
        [iv setBackgroundColor:[UIColor redColor]];
        if ([dataSource[i] isKindOfClass:[UIImage class]]) {
            iv.image = dataSource[i];
        }else if ([dataSource[i] isKindOfClass:[NSString class]]){
            [iv setRectImageUrl:dataSource[i]];
        }
        iv.userInteractionEnabled = YES;//默认关闭NO，打开就可以接受点击事件
        iv.tag = i;
        //九宫格的布局
        CGFloat  Direction_X;
        CGFloat  Direction_Y;

        Direction_X =kJGG_GAP+i%4*(imageWidth+kJGG_GAP);
        Direction_Y  =kJGG_GAP+((i/4)*(imageHeight+kJGG_GAP));
        iv.frame = RECT(Direction_X, Direction_Y, imageWidth, imageHeight);
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageAction:)];
        [iv addGestureRecognizer:singleTap];
    }
    
}

#pragma mark --tapImageAction --
-(void)tapImageAction:(UITapGestureRecognizer *)tap{
    
    RFImageView *tapView = (RFImageView *)tap.view;
    if (tapView.rectImage.image == nil) {
        
        return;
    }
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = tapView.tag;
    photoBrowser.imageCount = _dataSource.count;
    photoBrowser.sourceImagesContainerView = self;
    [photoBrowser show];
    
    if (self.maxDataSource.count==0) {
        self.maxDataSource = [NSArray arrayWithArray:self.dataSource];
    }
    if (self.tapBlock) {
        self.tapBlock(tapView.tag,self.maxDataSource,self.indexpath);
    }
}
#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlString = self.maxDataSource[index];
    return [NSURL URLWithString:urlString];
}
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{

    UIImageView *imageView = ((RFImageView *)self.subviews[index]).rectImage;
    return imageView.image;
    
}

@end
