//
//  UIAlertAction+ZBAnalytics.m
//  ZBKit
//
//  Created by NQ UEC on 17/3/2.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "UIAlertAction+ZBAnalytics.h"
#import "ZBAnalytics.h"
@implementation UIAlertAction (ZBAnalytics)
+ (void)load{
    
    SEL originalSelector = @selector(actionWithTitle:style:handler:);
    SEL swizzledSelector = @selector(zb_actionWithTitle:style:handler:);
    [[ZBAnalytics sharedInstance] analyticsClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
}

+ (instancetype)zb_actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertAction *alertAction = [[self class] zb_actionWithTitle:title style:style handler:handler];
    return alertAction;
}

@end
