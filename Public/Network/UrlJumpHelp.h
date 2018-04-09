//
//  UrlJumpHelp.h
//  TTJF
//
//  Created by 占碧光 on 2017/3/9.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlJumpHelp : NSObject

-(void) initLoad;

-(void)  initListTopPage;

-(void)initAccountTopPage;

-(void)initMorePages;
-(BOOL)isExist:(NSString *)url type:(NSInteger)type;

-(BOOL)  isSearchUrl:(NSMutableArray *)list url:(NSString *)url  type:(NSInteger)type;

@property (nonatomic ,strong)  NSMutableArray *interPages;
@property (nonatomic ,strong)  NSMutableArray *topPages;
@property (nonatomic ,strong)  NSMutableArray *topIndexPages;
@property (nonatomic ,strong)  NSMutableArray *topBarPages;
@property (nonatomic ,strong)  NSMutableArray *morePages;
@property (nonatomic ,strong)  NSMutableArray *accountPages;

@property (nonatomic ,strong)  NSString *rootUrl;

@property (nonatomic ,strong)  NSString *rootTempUrl;
@property (nonatomic )NSInteger  urlDeep;






@end
