//
//  UIViewController+ZBTracking.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/14.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "UIViewController+ZBTracking.h"
#import "ZBControlTool.h"
#import "ZBTarckingConfig.h"
#import "ZBConstants.h"
@implementation UIViewController (ZBTracking)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        SEL originalSelector = @selector(viewDidAppear:);
        SEL cusSelector = @selector(tracking_viewDidAppear:);
        [ZBControlTool TarckingClass:[self class] originalSelector:originalSelector cusSelector:cusSelector];
        
        SEL originalSelector2 = @selector(viewDidDisappear:);
        SEL cusSelector2 = @selector(tracking_viewDidDisappear:);
        [ZBControlTool TarckingClass:[self class] originalSelector:originalSelector2 cusSelector:cusSelector2];
    });
}

#pragma mark - Method
- (void)tracking_viewDidAppear:(BOOL)animated {
    [self tracking_viewDidAppear:animated];
    
    NSString *classID=[[ZBTarckingConfig sharedInstance] getViewControllerIdentificationWithKey:NSStringFromClass([self class])];
    
    if (classID!=nil) {
        ZBKLog(@"Tracking:进入%@:",classID);
    }
}

- (void)tracking_viewDidDisappear:(BOOL)animated {
    [self tracking_viewDidDisappear:animated];
    NSString *classID=[[ZBTarckingConfig sharedInstance] getViewControllerIdentificationWithKey:NSStringFromClass([self class])];
    if (classID!=nil) {
        ZBKLog(@"Tracking:退出%@:",classID);
    }
}


@end
