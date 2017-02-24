//
//  ZBDataBaseManager.h
//  ZBKit
//
//  Created by NQ UEC on 16/11/29.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^getAllExistData)(NSArray *dataArray,BOOL isExist);

typedef void (^isSuccess)(BOOL isSuccess);
//基于FMDatabaseQueue 封装的 线程安全的数据操作

@interface ZBDataBaseManager : NSObject


//返回单例对象的类方法
+(ZBDataBaseManager *)sharedInstance;

/**
 *  创建表
 *  @param tableName        表名
 */
- (void)createTable:(NSString *)tableName;

/**
 *  创建表
 *  @param tableName        表名
 *  @param isSuccess        存储创建成功
 */
- (void)createTable:(NSString *)tableName isSuccess:(isSuccess)isSuccess;

/**
 *  向数据库中某个表内插入数据
 *  @param  tableName       表名
 *  @param  obj             对象
 *  @param  itemId          对象所传id
 */
- (void)table:(NSString *)tableName insertDataWithObj:(id)obj ItemId:(NSString *)itemId;

/**
 *  向数据库中某个表内插入数据
 *  @param  tableName       表名
 *  @param  obj             对象
 *  @param  itemId          对象所传id
 *  @param  isSuccess       存储是否成功
 */
- (void)table:(NSString *)tableName insertDataWithObj:(id)obj ItemId:(NSString *)itemId isSuccess:(isSuccess)isSuccess;

/**
 *  获取全部数据
 *  @param  tableName       表名
 *  @return array           表内数据
 */
- (NSArray *)getAllDataWithTable:(NSString *)tableName;

/**
 *  获取全部数据 与 数据是否存在
 *  @param  tableName       表名
 *  @param  itemId          对象所传查询条件
 *  @param  data            block 返回数据和存在
 */
- (void)getAllDataWithTable:(NSString *)tableName itemId:(NSString *)itemId data:(getAllExistData)data;

/*
 *  判断该条数据是否存在
 *  @param  tableName       表名
 *  @param  itemId          对象所传查询条件
 *  @return BOOL            是否存在该数据
 */
-(BOOL)isCollectedWithTable:(NSString *)tableName itemId:(NSString *)itemId;

/**
 *  根据主键id 删除数据库中某个表内一条数据
 *  @param  tableName       表名
 *  @param  itemId          对象所传id
 */
- (void)table:(NSString *)tableName deleteDataWithItemId:(NSString *)itemId;

/**
 *  根据主键id 删除数据库中某个表内一条数据
 *  @param  tableName       表名
 *  @param  itemId          对象所传id
 *  @param  isSuccess       存储是否成功
 */
- (void)table:(NSString *)tableName deleteDataWithItemId:(NSString *)itemId isSuccess:(isSuccess)isSuccess;

/**
 *  根据主键id 修改某条数据
 *  @param  tableName       表名
 *  @param  obj             数据类
 *  @param  itemId          对象所传id
 */
- (void)table:(NSString *)tableName updateDataWithObj:(id)obj itemId:(NSString *)itemId;

/**
 *  根据主键id 修改某条数据
 *  @param  tableName       表名
 *  @param  obj             数据类
 *  @param  itemId          对象所传id
 *  @param  isSuccess       存储是否成功
 */
- (void)table:(NSString *)tableName updateDataWithObj:(id)obj itemId:(NSString *)itemId isSuccess:(isSuccess)isSuccess;

/**
 *  显示数据库大小
 *  @return size            大小
 */
-(NSUInteger)getDBSize;

/**
 *  检查表内数据数量
 *  @param  tableName       表名
 *  @return count           数量
 */
- (NSUInteger)getDBCountWithTable:(NSString *)tableName;

/**
 *  清除表数据
 *
 *  @param  tableName       表名
 */
-(void)cleanDBWithTable:(NSString *)tableName;

/**
 *  关闭数据库
 */
- (void)closeDataBase;
/**
 Posted when a task name.
 */


FOUNDATION_EXPORT NSString * const dbName;

@end
