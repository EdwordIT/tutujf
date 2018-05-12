//
//  DetailProduct.h
//  TTJF
//
//  Created by 占碧光 on 2017/12/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//产品详情

#import "BaseView.h"
#import "ProductDetailModel.h"

typedef void (^DetailProductBlock)(void);
@protocol HeightDelegate <NSObject>
@optional
-(void)sendProductHeight:(CGFloat )height;

@end

@interface DetailProduct : BaseView

@property(nonatomic, strong) NSString *currentURL;
-(void)loadInfoWithModel:(ProductDetailModel *)model;
@property(nonatomic, assign) id<HeightDelegate> delegate;
Copy DetailProductBlock proBlock;
@end
