//
//  ZBDataBaseManager.m
//  ChineseEmperor
//
//  Created by NQ UEC on 2018/4/2.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "ZBDataBaseManager.h"
#import "FMDB.h"

#define DBBUG_LOG 0
#if(DBBUG_LOG == 1)
# define DBLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
# define DBLog(...);
#endif
NSString *const dbName =@"ZBKit.db";
@implementation ZBDataBaseModel


@end

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
        
        NSString *dbPath =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
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
    NSString * sql = [NSString stringWithFormat:@"create table if not exists %@ (object blob NOT NULL,itemId varchar(256) NOT NULL,createdTime TEXT NOT NULL)", tableName];
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
#pragma mark - 插入数据
- (void)table:(NSString *)tableName insertObj:(id)obj ItemId:(NSString *)itemId{
    [self table:tableName insertObj:obj ItemId:itemId isSuccess:nil];
}

- (void)table:(NSString *)tableName insertObj:(id)obj ItemId:(NSString *)itemId isSuccess:(isSuccess)isSuccess {
    if ([self isTableName:tableName]==NO) {
        return;
    }
    NSError * error;
    DBLog(@"obj:%@",obj);
    NSData * data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:&error];
    if (error) {
        DBLog(@"ERROR, faild to get json data");
        return;
    }
    NSDate * createdTime = [NSDate date];
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (object,itemId,createdTime) values(?,?,?)", tableName];
    //NSLog(@"insertSql:%@",insertSql);
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        result = [db executeUpdate:insertSql,data,itemId,createdTime];
        
        isSuccess ? isSuccess(result) : nil;
        
        if (!result) {
            DBLog(@"insert table:%@ Error:%@ itemId:%@",tableName,db.lastErrorMessage,itemId);
        }else{
            DBLog(@"insert table:%@ itemId:%@ success",tableName,itemId);
        }
    }];
}
#pragma mark - 查询数据
- (NSArray *)getAllDataWithTable:(NSString *)tableName{
    if ([self isTableName:tableName] == NO) {
        return nil;
    }
    NSString *selectSql = [NSString stringWithFormat:@"select *from %@", tableName];
    NSMutableArray *array = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * set = [db executeQuery:selectSql];
        while ([set next]) {
            ZBDataBaseModel *model=[[ZBDataBaseModel alloc]init];
            model.object = [set stringForColumn:@"object"];
            model.itemId=[set stringForColumn:@"itemId"];
            model.createdTime = [set dateForColumn:@"createdTime"];
            [array addObject:model];
        }
        [set  close];
    }];
    
    NSError * error;
    for (ZBDataBaseModel * model in array) {
        error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:[model.object dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:(NSJSONReadingAllowFragments) error:&error];
        if (error) {
            DBLog(@"ERROR, faild to prase to json.");
        } else {
            model.object = object;
        }
    }
    return array;
}

-(BOOL)isExistsWithItemId:(NSString *)itemId table:(NSString *)tableName {
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
- (id)getObjectId:(NSString *)objectId table:(NSString *)tableName {
    ZBDataBaseModel * model= [self getModelObjectId:objectId table:tableName];
    if (model) {
        return model.object;
    } else {
        return nil;
    }
}
- (ZBDataBaseModel *)getModelObjectId:(NSString *)objectId table:(NSString *)tableName {
    if ([self isTableName:tableName] == NO) {
        return nil;
    }
     NSString *selectSql =[NSString stringWithFormat:@"select *from %@ where itemId =?", tableName];
    __block NSString * object = nil;
    __block NSDate * createdTime = nil;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:selectSql, objectId];
        if ([rs next]) {
            object = [rs stringForColumn:@"object"];
            createdTime = [rs dateForColumn:@"createdTime"];
        }
        [rs close];
    }];
    if (object) {
        NSError * error;
        id result = [NSJSONSerialization JSONObjectWithData:[object dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:(NSJSONReadingAllowFragments) error:&error];
        if (error) {
            DBLog(@"ERROR, faild to prase to json");
            return nil;
        }
        ZBDataBaseModel * model = [[ZBDataBaseModel alloc] init];
        model.itemId = objectId;
        model.object = result;
        model.createdTime = createdTime;
        return model;
    } else {
        return nil;
    }
}
#pragma mark - 删除数据
- (void)table:(NSString *)tableName deleteObjectItemId:(NSString *)itemId{
    [self table:tableName deleteObjectItemId:itemId isSuccess:nil];
}

- (void)table:(NSString *)tableName deleteObjectItemId:(NSString *)itemId isSuccess:(isSuccess)isSuccess{
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
#pragma mark - 更新数据
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
#pragma mark - 其他操作
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

- (BOOL)isTableName:(NSString *)tableName {
    if (tableName == nil || tableName.length == 0 || [tableName rangeOfString:@" "].location != NSNotFound) {
        DBLog(@"ERROR, table name: %@ format error.", tableName);
        return NO;
    }
    return YES;
}
- (void)closeDataBase {
    [_dbQueue close];
    _dbQueue=nil;
}
@end
