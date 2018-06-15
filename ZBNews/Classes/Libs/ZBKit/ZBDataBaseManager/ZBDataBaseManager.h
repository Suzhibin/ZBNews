//
//  ZBDataBaseManager.h
//  ChineseEmperor
//
//  Created by NQ UEC on 2018/4/2.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^getAllExistData)(NSArray *dataArray,BOOL isExist);

typedef void (^isSuccess)(BOOL isSuccess);


@interface ZBDataBaseModel : NSObject

@property (strong, nonatomic) NSString *itemId;
@property (strong, nonatomic) id object;
@property (strong, nonatomic) NSDate *createdTime;

@end

@interface ZBDataBaseManager : NSObject

+(ZBDataBaseManager *)sharedInstance;
/**
 创建表

 @param tableName 表名
 */
- (void)createTable:(NSString *)tableName;

- (void)createTable:(NSString *)tableName isSuccess:(isSuccess)isSuccess;

/**
 插入数据

 @param tableName 表名
 @param obj 数据
 @param itemId key
 */
- (void)table:(NSString *)tableName insertObj:(id)obj ItemId:(NSString *)itemId;

- (void)table:(NSString *)tableName insertObj:(id)obj ItemId:(NSString *)itemId isSuccess:(isSuccess)isSuccess;

/**
查询数据库

 @param tableName 表名
 @return 数据集合
 */
- (NSArray *)getAllDataWithTable:(NSString *)tableName;

/**
 查询数据是否存在

 @param itemId key
 @param tableName 表名
 @return 是否存在
 */
-(BOOL)isExistsWithItemId:(NSString *)itemId table:(NSString *)tableName;

/**
 查询单条数据

 @param objectId key
 @param tableName 表名
 @return 数据
 */
- (id)getObjectId:(NSString *)objectId table:(NSString *)tableName;

/**
 删除数据

 @param tableName 表名
 @param itemId key
 */
- (void)table:(NSString *)tableName deleteObjectItemId:(NSString *)itemId;

- (void)table:(NSString *)tableName deleteObjectItemId:(NSString *)itemId isSuccess:(isSuccess)isSuccess;

/**
 更新数据

 @param tableName 表名
 @param obj 数据
 @param itemId key
 */
- (void)table:(NSString *)tableName updateDataWithObj:(id)obj itemId:(NSString *)itemId;

- (void)table:(NSString *)tableName updateDataWithObj:(id)obj itemId:(NSString *)itemId isSuccess:(isSuccess)isSuccess;

/**
 数据库大小

 @return 大小
 */
- (NSUInteger)getDBSize;

/**
 得到表内的数据个数

 @param tableName 表名
 @return 个数
 */
- (NSUInteger)getDBCountWithTable:(NSString *)tableName;

/**
 删除表

 @param tableName 表名
 */
-(void)cleanDBWithTable:(NSString *)tableName;

/**
 关闭数据库
 */
- (void)closeDataBase;

@end
