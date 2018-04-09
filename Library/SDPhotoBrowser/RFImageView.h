//
//  RFImageView.h
//  cloudSound
//
//  Created by wbzhan on 2017/9/21.
//  Copyright © 2017年 ReduseFat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RFImageView : UIImageView
Strong UIImageView *rectImage;

-(void)setRectImageUrl:(NSString *)imgUrl;

-(void)setRectImageWith:(UIImage *)image;
@end
