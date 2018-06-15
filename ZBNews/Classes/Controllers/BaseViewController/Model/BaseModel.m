//
//  BaseModel.m
//  ZBNews
//
//  Created by NQ UEC on 2018/3/23.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    /*
     NSLog(@"undefinedKey:%@",key);
     if ([key isEqualToString:@"id"]) {
     self.channelId=key;
     }
     */
}
@end
