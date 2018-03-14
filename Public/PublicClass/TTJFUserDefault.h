//
//  TTJFUserDefault.h
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/8.
//  Copyright © 2018年 TTJF. All rights reserved.
//小数据持久化存储

#import <Foundation/Foundation.h>

@interface TTJFUserDefault : NSObject
/**
 *  保存普通字符串
 */
+(void)setStr:(NSString *)str key:(NSString *)key;

/**
 *  读取
 */
+(NSString *)strForKey:(NSString *)key;

/**
 *  删除
 */
+(void)removeStrForKey:(NSString *)key;

/**
 *  保存普通数组
 */
+(void)setArr:(NSArray *)arr key:(NSString *)key;

/**
 *  读取数组
 */
+(NSArray *)arrForKey:(NSString *)key;

/**
 *  删除数组
 */
+(void)removeArrForKey:(NSString *)key;



/**
 *  保存int
 */
+(void)setInt:(NSInteger)i key:(NSString *)key;

/**
 *  读取int
 */
+(NSInteger)intForKey:(NSString *)key;



/**
 *  保存float
 */
+(void)setFloat:(CGFloat)floatValue key:(NSString *)key;

/**
 *  读取float
 */
+(CGFloat)floatForKey:(NSString *)key;



/**
 *  保存bool
 */
+(void)setBool:(BOOL)boolValue key:(NSString *)key;

/**
 *  读取bool
 */
+(BOOL)boolForKey:(NSString *)key;


#pragma mark - 文件归档

/**
 *  归档
 */
+(BOOL)archiveRootObject:(id)obj toFile:(NSString *)path;
/**
 *  删除
 */
+(BOOL)removeRootObjectWithFile:(NSString *)path;

/**
 *  解档
 */
+(id)unarchiveObjectWithFile:(NSString *)path;
@end
