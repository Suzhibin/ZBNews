//
//  NSObject+ZBCoding.h
//  ZBKit
//
//  Created by NQ UEC on 17/2/6.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZBCoding)<NSSecureCoding>

+ (NSDictionary<NSString *, Class> *)codableProperties;

- (void)setWithCoder:(NSCoder *)aDecoder;


@property (nonatomic, readonly) NSDictionary<NSString *, Class> *codableProperties;

@property (nonatomic, readonly) NSDictionary<NSString *, id> *dictionaryRepresentation;

@end


/**
 归档的实现
 */
#define ZBCodingImplementation \
- (instancetype)initWithCoder:(NSCoder *)aDecoder\
{\
    [self setWithCoder:aDecoder];\
    return self;\
}\
\
- (void)encodeWithCoder:(NSCoder *)aCoder\
{\
    for (NSString *key in self.codableProperties)\
    {\
        id object = [self valueForKey:key];\
        if (object) [aCoder encodeObject:object forKey:key];\
    }\
}\

#define ZBExtensionCodingImplementation ZBCodingImplementation
