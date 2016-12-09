//
//  ZBDataBaseManager.h
//  ZBNews
//
//  Created by NQ UEC on 16/11/29.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBDataBaseManager : NSObject

//返回单例对象的类方法
+(ZBDataBaseManager *)sharedManager;

/**
 *  向数据库中插入数据
 *
 *  @param obj 数据类
 *  @param itemId 对象所传id
 */
- (void)insertDataWithObj:(id)obj ItemId:(NSString *)itemId;

/**
 *  获取全部数据
 *
 *  @return array
 */
- (NSArray *)fetchAllUsers;

/**
 *  根据主键id 删除一条数据
 *
 *  @param itemId 对象所传id
 */
- (void)deleteDataWithItemId:(NSString *)itemId;

/**
 *  根据主键id 修改某条数据
 *
 *  @param obj    数据类
 *  @param itemId 对象所传id
 
 */
- (void)updateDataWithObj:(id)obj itemId:(NSString *)itemId;

//判断该条数据是否被收藏过
-(BOOL)isCollectedWithItemId:(NSString *)itemId;

/**
 *  检查缓存数量
 *
 *  @return 返回一个整数
 */
- (int)getDBCount;

/**
 *  计算数据库大小
 */
- (unsigned long long)calcTotalStatusListSize;

/**
 *  关闭数据库
 */
- (void)closeDataBase;
/**
 Posted when a task name.
 */
FOUNDATION_EXPORT NSString * const dbName;

@end
