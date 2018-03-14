//
//  UrlJumpHelp.m
//  DingXinDai
//
//  Created by 占碧光 on 2017/1/15.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "UrlJumpHelp.h"

@implementation UrlJumpHelp

-(void) initLoad
{
    [self initListTopPage];
    [self initAccountTopPage];
    [self initMorePages];
    
}
-(void)  initListTopPage
{
    self.rootUrl=@"";
    self.urlDeep=0;
    self.rootTempUrl=@"";
    
    self.interPages=[[NSMutableArray alloc] init];
    
    self.topBarPages=[[NSMutableArray alloc] init];
    
    
    [self.topBarPages addObject:[urlCheckAddress stringByAppendingString:@"/wap"]];
    [self.topBarPages addObject:[urlCheckAddress stringByAppendingString:@"/wap/loan/loantender"]];
    [self.topBarPages addObject:[urlCheckAddress stringByAppendingString:@"/wap/member/index"]];
   
    self.topIndexPages=[[NSMutableArray alloc] init];

    
    self.topPages=[[NSMutableArray alloc] init];
    [self.topPages addObject:[urlCheckAddress stringByAppendingString:@"/wap/spread/myqrcode"]];
    [self.topPages addObject:[urlCheckAddress stringByAppendingString:@"/wap/page/getPage?action=supply"]];
    [self.topPages addObject:[urlCheckAddress stringByAppendingString:@"/wap/page/getPage?action=activity"]];
    //http://mshop.dingxindai.com/user/community/list
    [self.topPages addObject:[urlCheckAddress stringByAppendingString:@"/wap/page/getPage?action=process01"]];
    [self.topPages addObject:[urlCheckAddress stringByAppendingString:@"/wap/page/getPage?action=report"]];
    [self.topPages addObject:[urlCheckAddress stringByAppendingString:@"/wap/articles/articlesDetail#"]];
    
    
    [self.topPages addObject:[urlCheckAddress stringByAppendingString:@"/wap/borrow/applyborrow"]];
    [self.topPages addObject:[urlCheckAddress stringByAppendingString:@"/wap/page/getPage?action=noviceguide"]];
    [self.topPages addObject:[urlCheckAddress stringByAppendingString:@"/wap/loan/tenderLoanview#"]];
    [self.topPages addObject:[urlCheckAddress stringByAppendingString:@"/wap/loan/loaninfoview#"]];
    
    
    
}

-(void)initAccountTopPage
{
    self.accountPages=[[NSMutableArray alloc] init];
    
    [self.accountPages addObject:@"http://mshop.dingxindai.com/user/center/proinfo.html"];
    [self.accountPages addObject:@"http://mshop.dingxindai.com/user/user/bank/list.html"];
    //http://mshop.dingxindai.com/user/user/bank/list.html
    [self.accountPages addObject:@"http://mshop.dingxindai.com/shoppingadd.html"];
    [self.accountPages addObject:@"http://mshop.dingxindai.com/user/center/password.html"];
    [self.accountPages addObject:@"http://mshop.dingxindai.com/user/center/pay_pwd.html"];
    [self.accountPages addObject:@"http://mshop.dingxindai.com/user/certification/index.html"];
    
}

-(void)initMorePages
{
    self.morePages=[[NSMutableArray alloc] init];
    
    [self.morePages addObject:@"http://mshop.dingxindai.com/news/list"];
    [self.morePages addObject:@"http://mshop.dingxindai.com/content/show/fxkz.html"];
    [self.morePages addObject:@"http://mshop.dingxindai.com/feedback.html"];
    [self.morePages addObject:@"http://mshop.dingxindai.com/content/show/about.html"];
}
/*
 *
 * **/
-(BOOL)isExist:(NSString *)url type:(NSInteger)type
{
    if(type==0)
        return   [self isSearchUrl:self.topPages url:url type:type];
    else if(type==1)
        return [self isSearchUrl:self.topBarPages url:url type:type];
    else if(type==3)
        return [self isSearchUrl:self.accountPages url:url type:type];
    else if(type==4)
        return [self isSearchUrl:self.morePages url:url type:type];
    else if(type==5)
        return [self isSearchUrl:self.topIndexPages url:url type:type];
    else if(type==6)
        return [self isSearchUrl:self.interPages url:url type:type];
    
    return [self isSearchUrl:self.topPages url:url type:type];
}

-(BOOL)  isSearchUrl:(NSMutableArray *)list url:(NSString *)url  type:(NSInteger)type
{
    
    for(int k=0;k<[list count];k++)
    {
        if(type==0)
        {
            NSString * bijiao=[list objectAtIndex:k];
            if([url rangeOfString:bijiao].location != NSNotFound)
            {
                if([self.rootTempUrl isEqual:@""])
                    self.rootTempUrl=bijiao;
                else
                {
                    if([url rangeOfString:self.rootTempUrl].location != NSNotFound)
                        return true;
                    else
                        return false;
                }
                return true;
            }
        }
        else
        {
            NSString * bijiao=[list objectAtIndex:k];
            if([url rangeOfString:bijiao].location != NSNotFound)
                return true;
        }
    }
    return false;
}

@end
