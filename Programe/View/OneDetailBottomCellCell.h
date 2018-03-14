//
//  OneDetailBottomCellCell.h
//  TTJF
//
//  Created by 占碧光 on 2017/4/11.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneDetailBottomCellCell : UITableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier left:(NSString *) left  right:(NSString*) right;

-(void)setDefaultValue:(NSString *) left  title:(NSString*) right;
@end
