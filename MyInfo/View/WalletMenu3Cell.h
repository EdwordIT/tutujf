//
//  WalletMenu3Cell.h
//  DingXinDai
//
//  Created by 占碧光 on 16/7/6.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletMenu3Cell : UITableViewCell
-(void)setDefaultValue:(NSString *) imgsrc  title:(NSString*) title right:(NSString *)right;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imgsrc:(NSString *) imgsrc  title:(NSString*) title right:(NSString *)right;

@property(nonatomic, strong)  UIView *lineView ;

//@property(nonatomic, assign) id<Menu2TopDelegate> delegate;

@end
