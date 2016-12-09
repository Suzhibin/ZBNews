//
//  ZBDataBaseManager.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/29.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "ZBDataBaseManager.h"
#import "FMDB.h"
NSString *const dbName =@"data.db";
@interface ZBDataBaseManager()

@property (strong, nonatomic) FMDatabaseQueue * dbQueue;
@property (nonatomic ,copy)NSString *diskPath;
@end
@implementation ZBDataBaseManager
static ZBDataBaseManager *manager = nil;
//返回单例对象的类方法
+(ZBDataBaseManager *)sharedManager{
    
    static dispatch_once_t onceTaken;
    dispatch_once(&onceTaken,^{
        manager=[[ZBDataBaseManager alloc]init];
        
    });
    
    return manager;
}
//重写init方法，进行一些必要的初始化操作
- (instancetype)init{
    return [self initWithName:dbName];
    
}
- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        if (_dbQueue) {
            [self closeDataBase];
        }
        
        NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //初始化fmdatabase 并传递数据库的创建路径
       self.diskPath = [dbPath stringByAppendingPathComponent:name];
        
        //创建数据库，并加入到队列中，此时已经默认打开了数据库，无须手动打开，只需要从队列中去除数据库即可
        _dbQueue=[FMDatabaseQueue databaseQueueWithPath:self.diskPath];
        
        [self createTable];
        
    }
    return self;
}
- (void)createTable
{
    //    if ([self isTableName:tableName]==NO) {
    //        return;
    //    }
    NSString * sql = @"create table if not exists ZBtable (obj blob NOT NULL,itemId varchar(256) NOT NULL)";
    //    NSLog(@"sql:%@",sql);
    __block BOOL isSuccessed;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        isSuccessed = [db executeUpdate:sql];
        
        
        if (!isSuccessed) {
            
            //lastErrorMessage 返回最近一次操作失败的信息
            NSLog(@"创建Error:%@",db.lastErrorMessage);
        }else{
            NSLog(@"创建成功");
        }
        
    }];
    
}

//插入数据
- (void)insertDataWithObj:(id)obj ItemId:(NSString *)itemId{
    // if ([obj isKindOfClass:[DetailsModel class]]) {
    //     DetailsModel *model = (DetailsModel *)obj;
    
    NSLog(@"itemId:%@",itemId);
    //    if ([self isTableName:tableName]==NO) {
    //        return;
    //    }
    
    //    [obj encodeWithCoder:aCoder];
    //    [obj initWithCapacity:aCoder];
    
    //此处把字典归档成二进制数据直接存入数据库，避免添加过多的数据库字段
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    
    NSString *insertSql = @"insert into ZBtable (obj,itemId) values(?,?)";
    //     NSLog(@"insertSql:%@",insertSql);
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        result = [db executeUpdate:insertSql,data,itemId];
        
        if (!result) {
            NSLog(@"插入Error:%@",db.lastErrorMessage);
        }else{
            NSLog(@"插入成功");
        }
        
    }];
    
    //    }
    
}

//获取全部数据
- (NSArray *)fetchAllUsers{
    
    NSString *selectSql = @"select *from ZBtable";
    NSMutableArray *array = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * set = [db executeQuery:selectSql];
        
        while ([set next]) {
            NSData *data = [set dataForColumn:@"obj"];
            //    NSString *itemId = [set stringForColumn:@"itemId"];
            id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            [array addObject:obj];
            
        }
        [set  close];
    }];
    
    return array;
    
}
//根据主键id 删除一条数据
- (void)deleteDataWithItemId:(NSString *)itemId
{
    NSString * deleteSql = @"delete from ZBtable where itemId = ?";
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (![db executeUpdate:deleteSql,itemId]) {
            NSLog(@"delete error:%@",db.lastErrorMessage);
        }
        NSLog(@"删除");
        
    }];
    
    
}
//根据主键id 修改某条数据
- (void)updateDataWithObj:(id)obj itemId:(NSString *)itemId{
    
    NSString *updateSql = @"update ZBtable set obj =? where itemId = ?";
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        BOOL isSuccessed = [db executeUpdate:updateSql,obj,itemId];
        if (!isSuccessed) {
            NSLog(@"update error:%@",db.lastErrorMessage);
        }
    }];
    
    
}

//判断该条数据是否被收藏过
-(BOOL)isCollectedWithItemId:(NSString *)itemId{
    NSLog(@"itemId:%@",itemId);
    NSString *selectSql = @"select *from ZBtable where itemId =?";
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
    
    //如果有该条数据，next 为Yes
    return result;
    
}



-(unsigned long long)calcTotalStatusListSize
{

    unsigned long long size = 0;

    NSDictionary *fileAttributeDic=[[NSFileManager defaultManager] attributesOfItemAtPath:self.diskPath error:nil];
    size = fileAttributeDic.fileSize;
    
    //只有数据库本身文件大小时，显示0M，否则计算数据大小
    if([self getDBCount] > 0)
        return size;
    else
        return 0;
}

- (int)getDBCount
{
    __block int statuscount = 0;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *s = [db executeQuery:@"SELECT count(*) FROM ZBtable"];
        if ([s next]) {
            statuscount = [s intForColumnIndex:0];
        }
        
    }];
    
    return statuscount;
}

//关闭数据库
- (void)closeDataBase {
    [_dbQueue close];
    _dbQueue=nil;
    
}


@end
