//
//  PlatformDataCell.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/19.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PlatformDataBlock)(void);
typedef void (^InfoDisclosureBlock)(void);
@interface PlatformDataCell : UITableViewCell

Copy PlatformDataBlock platBlock;

Copy InfoDisclosureBlock infoBlock;
@end
