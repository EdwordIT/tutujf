//
//  WalletMenu1Cell.h
//  DingXinDai
//
//  Created by 占碧光 on 16/6/26.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
@protocol Menu1TopDelegate <NSObject>

@optional
-(void)didMenu1AtIndex:(NSInteger)index;

@end
 */

@interface WalletMenu1Cell : UITableViewCell


//@property(nonatomic, assign) id<Menu1TopDelegate> delegate;
-(void)setDefaultValue:(NSString *) imgsrc  title:(NSString*) title;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imgsrc:(NSString *) imgsrc  title:(NSString*) title;

@property(nonatomic, strong) NSString *title;/***/
@property(nonatomic, strong) NSString *imgsrc;/***/
@property(nonatomic, strong)  UIView *lineView ;

@end
