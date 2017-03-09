//
//  UIControl+ZBAnalytics.m
//  ZBKit
//
//  Created by NQ UEC on 17/3/1.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "UIControl+ZBAnalytics.h"
#import "ZBAnalytics.h"
#import "ZBConstants.h"
@implementation UIControl (ZBAnalytics)
+ (void)load {
    SEL originalSelector = @selector(sendAction:to:forEvent:);
    SEL swizzledSelector = @selector(zb_sendAction:to:forEvent:);
    [[ZBAnalytics sharedInstance] analyticsClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
}
- (void)zb_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    [self zb_sendAction:action to:target forEvent:event];
    
        [[ZBAnalytics sharedInstance] analyticsSource:self action:action target:target];
    /*
    if ([[[event allTouches] anyObject] phase] == UITouchPhaseEnded) {
        NSString *actionString = NSStringFromSelector(action);
        
        NSString *targetName = NSStringFromClass([target class]);
        
        NSString *eventID = [[ZBAnalytics sharedInstance] getControlIdentificationWithKey:[NSString stringWithFormat:@"%@_%@_%ld",targetName,actionString,self.tag]];
        
        if (eventID!=nil) {
            ZBKLog(@"Tracking:%@",eventID);
        }
    }
     */
    
}

@end
