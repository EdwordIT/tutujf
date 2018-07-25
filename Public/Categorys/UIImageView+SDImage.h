//
//  UIImageView+SDImage.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/23.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ImageClickBlock)(UIImageView *imageView);
@interface UIImageView (SDImage)

@property (nonatomic, copy) ImageClickBlock clickBlock;
-(void)setImageWithString:(NSString *)imageUrl;
-(void)addTapGesture;
@end
