//
//  DetailProduct.h
//  TTJF
//
//  Created by 占碧光 on 2017/12/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//产品详情

#import <UIKit/UIKit.h>
@protocol HeightDelegate <NSObject>

@optional
-(void)didSelectedHeightAtIndex:(CGFloat)height;

@end

@interface DetailProduct : UIView

@property(nonatomic, strong) NSString *currentURL;

-(void) setLoaUrl:(NSString *) url;
@property(nonatomic, assign) id<HeightDelegate> delegate;

@end
