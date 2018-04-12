//
//  OpenAdvertView.h
//  TTJF
//
//  Created by 占碧光 on 2017/4/17.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAccountModel.h"

@protocol OpenShowAdvertDelegate <NSObject>

@optional
-(void)didOpenAdvertView:(NSInteger)type;

@end

@interface OpenAdvertView : UIView

@property(nonatomic, assign) id<OpenShowAdvertDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;

//-(void) setDataBind:(MyAccountModel *) userinfo;
-(void) setImageWithUrl:(NSString *) urlString;
@end
