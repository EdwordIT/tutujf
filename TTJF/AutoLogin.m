//
//  AutoLogin.m
//  TTJF
//
//  Created by 占碧光 on 2017/2/26.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "AutoLogin.h"
#import "sqlite3.h"
#import "AppDelegate.h"
#import "ggHttpFounction.h"
#import "HttpSignCreate.h"
#import "HttpUrlAddress.h"

#define DBNAME @"tutujinfu.db"
#define TABLENAME @"TTJF"

@implementation AutoLogin
{
    NSString *databaseFilePath;
    sqlite3 *db;
    NSDate *date;
}


#pragma sqllite

-(void) InitData
{
    self.MobileNum=@"";
    self.password=@"";
    self.IsValid=TRUE;
      [self IsSetLocate];
}





-(Boolean) IsSetLocate
{

                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                //根据键值取出name
                NSString *lgtime = [defaults objectForKey:@"LoginTime"];
                NSString *lguser = [defaults objectForKey:@"LoginAccount"];
                NSString *lgpsd = [defaults objectForKey:@"LoginPassword"];
                if(lgtime==nil)
                    lgtime=@"2015-01-01";
                NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",lgtime]];
                Boolean result=[self compareOneDay:[self getCurrentTime] withAnotherDay:date] ;
                if(!result)
                {
                    [self cleanCaches];//清理缓存
                    self.MobileNum=[NSString stringWithFormat:@"%@",lguser];
                    self.password=[NSString stringWithFormat:@"%@",lgpsd];
                    self.IsValid=FALSE;
                    
                    [_delegate didAutoLoginSelect:self.MobileNum pswd:self.password isvalid:FALSE];
                    
                }
                else
                {
                    self.MobileNum=[NSString stringWithFormat:@"%@",lguser];
                    self.password=[NSString stringWithFormat:@"%@",lgpsd];
                    self.IsValid=TRUE;
                    [self getLogin:self.MobileNum password: self.password];
                }
                return  result;

    
}

-(void) getLogin:(NSString *)user_name  password:(NSString *)password
{
    UIDevice* curDev = [UIDevice currentDevice];
    NSString *terminal_type=@"iphone";
    NSString *terminal_id=curDev.identifierForVendor.UUIDString;//curDev.identifierForVendor.UUIDString;
    NSString *terminal_name= [curDev.name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *terminal_model=curDev.model;
    NSString * terminal_token=theAppDelegate.device_token;
    NSString *urlStr = @"";
    NSDictionary *dict_data=[[NSDictionary alloc] initWithObjects:@[user_name,password,terminal_type,terminal_id,terminal_name,terminal_model,terminal_token] forKeys:@[@"user_name",@"password",@"terminal_type",@"terminal_id",@"terminal_name",@"terminal_model",@"terminal_token"]];
    //  paixu
    NSMutableArray * paixu1=[[NSMutableArray alloc] init];
    [paixu1 addObject:@"user_name"];
    [paixu1 addObject:@"password"];
    [paixu1 addObject:@"terminal_type"];
    [paixu1 addObject:@"terminal_id"];
    [paixu1 addObject:@"terminal_name"];
    [paixu1 addObject:@"terminal_model"];
    [paixu1 addObject:@"terminal_token"];
    NSString *sign=[HttpSignCreate GetSignStr:dict_data paixu:paixu1];
   // terminal_name=[terminal_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSString *  password1=[HttpSignCreate encodeString:password];
      user_name=[HttpSignCreate encodeString:user_name];
      terminal_name=[HttpSignCreate encodeString:terminal_name];
    urlStr = [NSString stringWithFormat:login,oyApiUrl,user_name,password1,terminal_type,terminal_id,terminal_name,terminal_model,terminal_token,sign];
    
    NSData * data=  [ggHttpFounction  synHttpGet:urlStr];
    if([ggHttpFounction getJsonIsOk:data])
    {
        NSDictionary * dir= [ggHttpFounction getJsonData1:data];
        if(dir!=nil)
        {
            
            theAppDelegate.user_token=  [dir objectForKey:@"user_token"];
            theAppDelegate.user_name= user_name;
            NSString * temp=[[dir objectForKey:@"expiration_date"] substringWithRange:NSMakeRange(0,10)];
            theAppDelegate.expirationdate=temp;
            theAppDelegate.IsLogin=TRUE;
            [TTJFUserDefault setStr:[dir objectForKey:@"user_token"] key:kToken];
                [_delegate didAutoLoginSelect:self.MobileNum pswd:self.password isvalid:self.IsValid];
           // [self getYUancheng];
        }
        
    }
    else
    {
         [_delegate didAutoLoginSelect:self.MobileNum pswd:self.password isvalid:FALSE];
        
    }
    
    
}


-(Boolean) exitLogin
{
 
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:@"2015-01-01" forKey:@"LoginTime"];
    [userDef synchronize];
    
    
    return TRUE;
    
}


#pragma mark -得到当前时间
- (NSDate *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    
    //NSLog(@"---------- currentDate == %@",date);
    return date;
}


- (Boolean)compareOneDay:(NSDate *)fromDate withAnotherDay:(NSDate *)toDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dayComponents = [gregorian components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];
    NSLog(@"date1 : %@, date2 : %@", fromDate, toDate);
    
    if ((-dayComponents.day)<20) {
        //NSLog(@"Date1  is in the future");
        return TRUE;
    }
    else if ((-dayComponents.day)>=20){
        //NSLog(@"Date1 is in the past");
        return FALSE;
    }
    //NSLog(@"Both dates are the same");
    return TRUE;
}

- (void)cleanCaches{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}
@end
