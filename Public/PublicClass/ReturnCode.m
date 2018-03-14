//
//  ReturnCode.m
//  DingXinDai
//
//  Created by 占碧光 on 16/7/20.
//  Copyright © 2016年 占碧光. All rights reserved.
//

#import "ReturnCode.h"

@implementation ReturnCode


 +(NSString *) getSysCMsg:(NSString *)code
{
   NSString * str=@"";
    
    if([code isEqual:@"0"])
    {
      str=@"操作成功";
    }
    else if([code isEqual:@"100001"])
    {
        str=@"sign错误";
    }
    else if([code isEqual:@"100002"])
    {
        str=@"用户名不存在";
    }
    else if([code isEqual:@"100003"])
    {
        str=@"用户名密码错误";
    }
   else if([code isEqual:@"100004"])
    {
        str=@"用户帐号待审核中";
    }
    else if([code isEqual:@"100005"])
    {
        str=@"用户帐号正在验证中";
    }
   else if([code isEqual:@"100006"])
    {
        str=@"会员登录失败";
    }
   else if([code isEqual:@"100007"])
    {
        str=@"会员标识过期或错误";
    }
   else if([code isEqual:@"100008"])
    {
        str=@"新密码或者老密码为空";
    }
   else if([code isEqual:@"100009"])
    {
        str=@"旧密码错误";
    }
   else if([code isEqual:@"100010"])
    {
        str=@"参数为空";
    }
   else if([code isEqual:@"100011"])
    {
        str=@"验证码错误";
    }
   else if([code isEqual:@"100012"])
    {
        str=@"操作异常失败";
    }
   else if([code isEqual:@"100013"])
    {
        str=@"参数错误";
    }
    else if([code isEqual:@"100014"])
    {
        str=@"注册功能关闭";
    }
    else if([code isEqual:@"100015"])
    {
        str=@"密码为空";
    }
   else if([code isEqual:@"100016"])
    {
        str=@"用户名不存在";
    }
   else if([code isEqual:@"100017"])
    {
        str=@"手机号为空";
    }
   else if([code isEqual:@"100018"])
    {
        str=@"会员注册信息错误";
    }
    return str;
}
@end
