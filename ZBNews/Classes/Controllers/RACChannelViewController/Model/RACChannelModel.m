//
//  RACChannelModel.m
//  ZBNews
//
//  Created by NQ UEC on 2018/6/13.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "RACChannelModel.h"

@implementation RACChannelModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
     NSLog(@"undefinedKey:%@",key);
     if ([key isEqualToString:@"id"]) {
     self.newsId=value;
     }
     
}
@end
