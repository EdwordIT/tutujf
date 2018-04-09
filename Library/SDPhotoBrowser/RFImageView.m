//
//  RFImageView.m
//  cloudSound
//
//  Created by wbzhan on 2017/9/21.
//  Copyright © 2017年 ReduseFat. All rights reserved.
//

#import "RFImageView.h"
#import <SDWebImageDownloader.h>
@implementation RFImageView
-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(UIImageView *)rectImage
{
    if (!_rectImage) {
        _rectImage = InitObject(UIImageView);
        _rectImage.userInteractionEnabled = YES;
    }
    return _rectImage;
}
-(void)setRectImageWith:(UIImage *)image
{
    self.layer.masksToBounds = YES;
    if (image) {
        self.image = nil;
        if (!_rectImage) {
            [self addSubview:self.rectImage];
//            [self sendSubviewToBack:self.rectImage];
        }
        CGSize imageSize = image.size;
        UIImageView *newImageV = self.rectImage;
        CGRect newImageSize;
        //如果不是保留有效数字，正方形的图形容易被误判
        CGFloat propW = [[NSString stringWithFormat:@"%f",(imageSize.width/self.width)*10000] integerValue];//宽度缩放比例
        CGFloat propH = [[NSString stringWithFormat:@"%f",(imageSize.height/self.height)*10000] integerValue];//高度缩放比例
        
        if (propW>propH) {//宽度截取
            newImageSize.size.height = self.height;
            newImageSize.size.width = self.height*imageSize.width/imageSize.height;
            newImageSize.origin.x = -(newImageSize.size.width - self.size.width)/2;
            newImageSize.origin.y = 0;
            newImageV.frame = newImageSize;
            [newImageV setImage:image];
        }else if(propW<propH){
            newImageSize.size.width = self.width;
            newImageSize.size.height = self.width*imageSize.height/imageSize.width;
            newImageSize.origin.y = -(newImageSize.size.height - self.size.height)/2;
            newImageSize.origin.x = 0;
            newImageV.frame = newImageSize;
            [newImageV setImage:image];
        }else{
            newImageV.frame = RECT(0, 0, self.width, self.height);
            [newImageV setImage:image];
        }
    }
}
-(void)setRectImageUrl:(NSString *)imgUrl
{
    if (IsEmptyStr(imgUrl)) {
        return;
    }else{
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imgUrl] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            //
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (image) {
                [self setRectImageWith:image];
            }
        }];

    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
