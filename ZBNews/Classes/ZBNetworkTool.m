//
//  ZBNetworkTool.m
//  ZBNews
//
//  Created by NQ UEC on 16/12/9.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "ZBNetworkTool.h"
@interface ZBNetworkTool()<ZBURLSessionDelegate>
@property AFNetworkReachabilityStatus netStatus;
@end
@implementation ZBNetworkTool
+ (ZBNetworkTool *)sharedManager {
    static ZBNetworkTool *networkTool=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkTool = [[ZBNetworkTool alloc] init];
    });
    return networkTool;
}
- (void )getUrlString:(NSString *)string target:(id<ZBURLSessionDelegate>)delegate apiType:(apiType)type{
    [[ZBURLSessionManager sharedManager] getRequestWithUrlString:string target:self apiType:type];
    
}
- (void)urlRequestFinished:(ZBURLSessionManager *)request{
    
}
- (void)urlRequestFailed:(ZBURLSessionManager *)request{
    
    
}

- (NSInteger)startNetWorkMonitoring
{
    
    self.netStatus=[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    // 设置网络状态改变后的处理
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        self.netStatus=status;
        switch (self.netStatus)
        {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    return self.netStatus;
    
}

@end
