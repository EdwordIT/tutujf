//
//  NavView.h
//  CLBigTest
//
//  Created by Rain on 16/9/2.
//  Copyright © 2016年 Rain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavViewDelegate <NSObject>

@optional
-(void)didNavViewDAtIndex:(NSInteger)index;

@end

@interface NavView : UIView

///@property(nonatomic, strong) UIImageView *imageView ;

@property(nonatomic, strong) UIImageView *personalimg ;

@property(nonatomic, strong) UILabel *mobilenum ;


@property(nonatomic, strong) UIImageView *infolimg ;

@property(nonatomic, assign) id<NavViewDelegate> delegate;

@end
