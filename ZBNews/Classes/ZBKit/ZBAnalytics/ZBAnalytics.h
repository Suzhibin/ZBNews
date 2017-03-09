//
//  ZBAnalytics.h
//  ZBKit
//
//  Created by NQ UEC on 17/3/1.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBAnalytics : NSObject

@property (nonatomic,strong)NSDictionary *VCDictionary;
@property (nonatomic,strong)NSDictionary *actionDictionary;
@property (nonatomic,strong)NSDictionary *tableViewDictionary;
@property (nonatomic,strong)NSDictionary *collectionDictionary;

@property (weak, nonatomic) id delegate;
@property (copy, nonatomic) void (^analyticsIdentifierBlock)(NSString *identifier);

+ (instancetype)sharedInstance;

- (void)analyticsSource:(id)source action:(SEL)action target:(id)target;

- (void)analyticsSource:(id)source didSelectIndexPath:(NSIndexPath *)idxPath target:(id)target;

- (void)analyticsString:(NSString *)identifierString;

- (void)analyticsClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

- (NSString *)getViewControllerIdentificationWithKey:(NSString *)key;
/*
- (NSString *)getControlIdentificationWithKey:(NSString *)key;

- (NSString *)getTableViewIdentificationWithKey:(NSString *)key;

- (NSString *)getCollectionIdentificationWithKey:(NSString *)key;
*/
@end
