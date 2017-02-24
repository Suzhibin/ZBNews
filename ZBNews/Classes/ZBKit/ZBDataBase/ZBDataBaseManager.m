//
//  ZBDataBaseManager.m
//  ZBKit
//
//  Created by NQ UEC on 16/11/29.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "ZBDataBaseManager.h"
#import "FMDB.h"
#import "ZBCacheManager.h"

#define DBBUG_LOG 1
#if(DBBUG_LOG == 1)
# define DBLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
# define DBLog(...);
#endif

NSString *const dbName =@"ZBKit.db";
@interface ZBDataBaseManager()

@property (strong, nonatomic) FMDatabaseQueue * dbQueue;
@property (nonatomic ,copy)NSString *dbPath;
@end
@implementation ZBDataBaseManager

+(ZBDataBaseManager *)sharedInstance{
    static ZBDataBaseManager *manager = nil;
    static dispatch_once_t onceTaken;
    dispatch_once(&onceTaken,^{
        manager=[[ZBDataBaseManager alloc]init];
        
    });
    
    return manager;
}

- (instancetype)init{
    return [self initWithName:dbName];
    
}
- (instancetype)initWithName:(NSString *)name{
    self = [super init];
    if (self) {
        if (_dbQueue) {
            [self closeDataBase];
        }
    
        NSString *dbPath =[[ZBCacheManager sharedInstance]ZBKitPath];
        
        [[ZBCacheManager sharedInstance]createDirectoryAtPath:dbPath];
        
        //初始化fmdatabase 并传递数据库的创建路径
        self.dbPath = [dbPath stringByAppendingPathComponent:name];
        //创建数据库，并加入到队列中，此时已经默认打开了数据库，无须手动打开
        _dbQueue=[FMDatabaseQueue databaseQueueWithPath:self.dbPath];
        
    }
    return self;
}

- (void)createTable:(NSString *)tableName{
    [self createTable:tableName isSuccess:nil];
}

- (void)createTable:(NSString *)tableName isSuccess:(isSuccess)isSuccess{
    if ([self isTableName:tableName]==NO) {
        return;
    }
    NSString * sql = [NSString stringWithFormat:@"create table if not exists %@ (obj blob NOT NULL,itemId varchar(256) NOT NULL)", tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        result = [db executeUpdate:sql];
        
        isSuccess ? isSuccess(result) : nil;
        
        if (!result) {
            DBLog(@"create table:%@ Error:%@",tableName,db.lastErrorMessage);
        }else{
            DBLog(@"create table:%@ success",tableName);
        }
    }];
}

- (void)table:(NSString *)tableName insertDataWithObj:(id)obj ItemId:(NSString *)itemId{
    [self table:tableName insertDataWithObj:obj ItemId:itemId isSuccess:nil];
}

- (void)table:(NSString *)tableName insertDataWithObj:(id)obj ItemId:(NSString *)itemId isSuccess:(isSuccess)isSuccess {
    if ([self isTableName:tableName]==NO) {
        return;
    }
    //此处把字典归档成二进制数据直接存入数据库，避免添加过多的数据库字段
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (obj,itemId) values(?,?)", tableName];
    //NSLog(@"insertSql:%@",insertSql);
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        result = [db executeUpdate:insertSql,data,itemId];
        
        isSuccess ? isSuccess(result) : nil;
        
        if (!result) {
            DBLog(@"insert table:%@ Error:%@ itemId:%@",tableName,db.lastErrorMessage,itemId);
        }else{
            DBLog(@"insert table:%@ itemId:%@ success",tableName,itemId);
        }
    }];
}

- (NSArray *)getAllDataWithTable:(NSString *)tableName{
    if ([self isTableName:tableName] == NO) {
        return nil;
    }
    NSString *selectSql = [NSString stringWithFormat:@"select *from %@", tableName];
    NSMutableArray *array = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * set = [db executeQuery:selectSql];
        while ([set next]) {
            NSData *data = [set dataForColumn:@"obj"];
            id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [array addObject:obj];
        }
        [set  close];
    }];
    return array;
}

- (void)getAllDataWithTable:(NSString *)tableName itemId:(NSString *)itemId data:(getAllExistData)data{
    if ([self isTableName:tableName] == NO) {
        return;
    }
    NSString *selectSql = [NSString stringWithFormat:@"select *from %@ where itemId = ?", tableName];
    NSMutableArray *array = [NSMutableArray array];
    __block BOOL isExist;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * set = [db executeQuery:selectSql,itemId];
        if ([set next]) {
            isExist=YES;
        }else{
            isExist=NO;
        }
        while ([set next]) {
            NSData *data = [set dataForColumn:@"obj"];
            id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [array addObject:obj];
        }
        
        [set  close];
        
    }];
    data ? data(array,isExist) : nil;
}


-(BOOL)isCollectedWithTable:(NSString *)tableName itemId:(NSString *)itemId{
    if ([self isTableName:tableName] == NO) {
        return nil;
    }
    NSString *selectSql =[NSString stringWithFormat:@"select *from %@ where itemId =?", tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:selectSql,itemId];
        
        if ([set next]) {
            result=YES;
        }else{
            result=NO;
        }
        [set  close];
    }];
    return result;
}

- (void)table:(NSString *)tableName deleteDataWithItemId:(NSString *)itemId{
    [self table:tableName deleteDataWithItemId:itemId isSuccess:nil];
}

- (void)table:(NSString *)tableName deleteDataWithItemId:(NSString *)itemId isSuccess:(isSuccess)isSuccess{
    if ([self isTableName:tableName] == NO) {
        return;
    }
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where itemId = ?", tableName];
    [_dbQueue inDatabase:^(FMDatabase *db) {
      
        BOOL result=[db executeUpdate:deleteSql,itemId];
        
        isSuccess ? isSuccess(result) : nil;
        
        if (!result) {
            DBLog(@"delete table:%@  error:%@ itemId:%@",tableName,db.lastErrorMessage,itemId);
        }else{
            DBLog(@"delete table:%@  itemId:%@ success",tableName,itemId);
        }

    }];
}

- (void)table:(NSString *)tableName updateDataWithObj:(id)obj itemId:(NSString *)itemId{
    [self table:tableName updateDataWithObj:obj itemId:itemId isSuccess:nil];
}

- (void)table:(NSString *)tableName updateDataWithObj:(id)obj itemId:(NSString *)itemId isSuccess:(isSuccess)isSuccess{
    if ([self isTableName:tableName] == NO) {
        return;
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSString *updateSql =[NSString stringWithFormat:@"update %@ set obj =?, itemId = ?", tableName];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        BOOL result = [db executeUpdate:updateSql,data,itemId];
        
        isSuccess ? isSuccess(result) : nil;
        
        if (!result) {
            DBLog(@"update table:%@ error:%@ itemId:%@",tableName,db.lastErrorMessage,itemId);
        }else{
            DBLog(@"update table:%@ itemId:%@ success",tableName,itemId);
        }
    }];
}


- (NSUInteger)getDBSize{
    __block NSUInteger size = 0;
    NSDictionary *fileAttributeDic=[[NSFileManager defaultManager] attributesOfItemAtPath:self.dbPath error:nil];
   return size = fileAttributeDic.fileSize;
}

- (NSUInteger)getDBCountWithTable:(NSString *)tableName{
    if ([self isTableName:tableName] == NO) {
        return 0;
    }
    __block NSUInteger statuscount = 0;
    NSString *selectSql =[NSString stringWithFormat:@"SELECT count(*) FROM %@",tableName];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:selectSql];
        if ([set next]) {
            statuscount = [set intForColumnIndex:0];
        }
        [set  close];
    }];
    return statuscount;
}

-(void)cleanDBWithTable:(NSString *)tableName{
    if ([self isTableName:tableName] == NO) {
        return;
    }
    NSString *selectSql =[NSString stringWithFormat:@"DELETE FROM %@",tableName];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:selectSql];
    }];
    return;
}

- (void)closeDataBase {
    [_dbQueue close];
    _dbQueue=nil;    
}

- (BOOL)isTableName:(NSString *)tableName {
    if (tableName == nil || tableName.length == 0 || [tableName rangeOfString:@" "].location != NSNotFound) {
        DBLog(@"ERROR, table name: %@ format error.", tableName);
        return NO;
    }
    return YES;
}

@end
