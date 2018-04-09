//
//  MBTabbarView.h
//  MedicalBeauty
//
//  Created by wbzhan on 2017/12/15.
//  Copyright © 2017年 MedicalBeauty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MBTabbarDelegate <NSObject>

- (void)didSelectedItem:(NSInteger)index;

@end
@interface MBTabbarView : UIView
@property (nonatomic, weak) id <MBTabbarDelegate> delegate;


- (void)createTabBarWithBackgroundImage:(UIImage *)bgImage buttonsImageName:(NSArray *)buttonsImageName buttonsSelectImageName:(NSArray *)buttonsSelectImageName buttonsTitle:(NSArray *)buttonsTitle isLocation:(BOOL)isLocation;

- (void)setSelectedIndex:(NSInteger)index;

- (void)setRedPointAtIndex:(NSInteger)index isShow:(BOOL)isShow;

@end


@interface TabBarItem : UIView
//- (id)initWithNormalImage:(UIImage *)imageNormal selectedImage:(UIImage *)imageSelected
//                    title:(NSString *)title index:(NSInteger)index
//                   target:(id)target selector:(SEL)sel;
- (id)initWithNormalImage:(NSString *)imageNormal selectedImage:(NSString *)imageSelected
                    title:(NSString *)title index:(NSInteger)index
                   target:(id)target selector:(SEL)sel isLocation:(BOOL)isLocation;


- (void)setSelected:(BOOL)selected;

- (void)showRedPoint:(BOOL)isShow;
@end
