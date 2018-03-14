//
//  RecharegeViewController.h
//  personnal
//
//  Created by DA WENG on 16/7/28.
//  Copyright © 2016年 DA WENG. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol IPSP2PRechargeWithDelegate <NSObject>
@optional
-(void)IPSP2PResult:(NSString * )Result;

@end

@interface RecharegeViewController : UIViewController
@property (nonatomic ,assign) id delegate;
@property(nonatomic,strong)NSString* urlScheme;
@end
