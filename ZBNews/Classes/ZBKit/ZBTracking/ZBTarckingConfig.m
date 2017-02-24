//
//  ZBTarckingConfig.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/14.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBTarckingConfig.h"

@implementation ZBTarckingConfig
+ (ZBTarckingConfig*)sharedInstance
{
    static ZBTarckingConfig *ConfigInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        ConfigInstance = [[self alloc] init];
    });
    return ConfigInstance;
    
}
- (NSString *)getViewControllerIdentificationWithKey:(NSString *)key {
    return [self.VCDictionary objectForKey:key];
}

- (NSString *)getControlIdentificationWithKey:(NSString *)key {
    return [self.actionDictionary objectForKey:key];
}
/*
- (NSString *)getTableViewIdentificationWithKey:(NSString *)key {
    return [self.tableViewDictionary objectForKey:key];
}

- (NSString *)getCollectionIdentificationWithKey:(NSString *)key {
    return [self.collectionDictionary objectForKey:key];
}
*/
@end
