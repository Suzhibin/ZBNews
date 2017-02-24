//
//  ZBTarckingConfig.h
//  ZBKit
//
//  Created by NQ UEC on 17/2/14.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBTarckingConfig : NSObject
@property (nonatomic,strong)NSDictionary *VCDictionary;
@property (nonatomic,strong)NSDictionary *actionDictionary;
//@property (nonatomic,strong)NSDictionary *tableViewDictionary;
//@property (nonatomic,strong)NSDictionary *collectionDictionary;

+ (ZBTarckingConfig*)sharedInstance;
// 获取按钮标识
- (NSString *)getControlIdentificationWithKey:(NSString *)key;

- (NSString *)getViewControllerIdentificationWithKey:(NSString *)key;

//- (NSString *)getTableViewIdentificationWithKey:(NSString *)key;

//- (NSString *)getCollectionIdentificationWithKey:(NSString *)key;
@end
