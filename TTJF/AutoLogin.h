//
//  AutoLogin.h
//  TTJF
//
//  Created by 占碧光 on 2017/2/26.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AutoLoginDelegate <NSObject>

@optional
-(void)didAutoLoginSelect:(NSString *)username pswd:(NSString *)pswd isvalid:(Boolean)isvalid;

@end


@interface AutoLogin : NSObject

@property(nonatomic, assign) id<AutoLoginDelegate> delegate;

@property  NSString  * MobileNum;
@property  NSString  *  password;
@property BOOL IsValid;

-(void) InitData;

@end
