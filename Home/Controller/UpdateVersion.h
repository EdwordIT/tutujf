//
//  UpdateVersion.h
//  TTJF
//
//  Created by 占碧光 on 2017/11/24.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VersionInfo.h"
@protocol OpenVersionDelegate <NSObject>

@optional
-(void)didOpenVersionView:(NSInteger)type;

@end


@interface UpdateVersion : UIView

@property(nonatomic, assign) id<OpenVersionDelegate> delegate;

- (id)initWithFrame:(CGRect)frame ;

@property(nonatomic, strong) UILabel *title;

-(void) setDataBind:(VersionInfo *) userinfo;

@end
