//
//  TwoDetailHeadCell.h
//  TTJF
//
//  Created by 占碧光 on 2017/4/11.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalMenu.h"

@interface TwoDetailHeadCell : UITableViewCell<HorizontalMenuDelegate,UIScrollViewDelegate>
-(void) initView;
-(void) setModelDatas:(NSMutableArray *) datas;
@end
