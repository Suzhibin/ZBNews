//
//  MainModel.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel
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
        self.menu_id=key;
    }
     */
}

@end
