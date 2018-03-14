//
//  TopScrollShow.h
//  TTJF
//
//  Created by 占碧光 on 2017/10/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineNavDelegate <NSObject>

@optional
-(void)didTopScrollAtIndex:(NSInteger)index;

@end

@interface TopScrollShow : UIView

@property(nonatomic, assign) id<MineNavDelegate> delegate;

@property(nonatomic, strong) UIButton *leftBtn;

@property(nonatomic, strong) UIView *rightView;

@property(nonatomic, strong) UIView *infolimg;
@property(nonatomic, strong) UIView  *backimg;

@property(nonatomic, copy) NSString *ishaveinfo ;

@property(nonatomic, strong) UILabel *leftName;

@property(nonatomic, strong) UIImageView * image1;

@end
