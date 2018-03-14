//
//  WalletMenu2Cell.h
//  DingXinDai
//
//  Created by 占碧光 on 16/6/26.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
@protocol Menu2TopDelegate <NSObject>

@optional
-(void)didMenu2AtIndex:(NSInteger)index;

@end
 */

@interface WalletMenu2Cell : UITableViewCell

-(void)setDefaultValue:(NSString *) imgsrc  title:(NSString*) title imageright:(NSString*) imageright;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imgsrc:(NSString *) imgsrc  title:(NSString*) title imgsrcright:(NSString *) imgsrcright;
@property(nonatomic, strong) NSString *title;/***/
@property(nonatomic, strong) NSString *imgsrc;/***/
@property(nonatomic, strong) NSString *imgsrcright;/***/
@property(nonatomic, strong)  UIView *lineView ;

@end
