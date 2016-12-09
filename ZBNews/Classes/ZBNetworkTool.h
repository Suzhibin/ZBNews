//
//  ZBNetworkTool.h
//  ZBNews
//
//  Created by NQ UEC on 16/12/9.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "ZBNetworking.h"
@interface ZBNetworkTool : NSObject
//返回单例对象
+ (ZBNetworkTool *)sharedManager;

- (NSInteger)startNetWorkMonitoring;

@end
