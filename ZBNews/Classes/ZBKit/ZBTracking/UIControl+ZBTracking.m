//
//  UIControl+ZBTracking.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/14.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "UIControl+ZBTracking.h"
#import "ZBControlTool.h"
#import "ZBTarckingConfig.h"
#import "ZBConstants.h"
@implementation UIControl (ZBTracking)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL cusSelector = @selector(tracking_sendAction:to:forEvent:);
        [ZBControlTool TarckingClass:[self class] originalSelector:originalSelector cusSelector:cusSelector];

    });
}
- (void)tracking_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    [self tracking_sendAction:action to:target forEvent:event];
    
    if ([[[event allTouches] anyObject] phase] == UITouchPhaseEnded) {
        NSString *actionString = NSStringFromSelector(action);
     
        NSString *targetName = NSStringFromClass([target class]);
      
        NSString *eventID = [[ZBTarckingConfig sharedInstance] getControlIdentificationWithKey:[NSString stringWithFormat:@"%@_%@_%ld",targetName,actionString,self.tag]];

        if (eventID!=nil) {
            ZBKLog(@"Tracking:%@",eventID);
        }
    }
   
}

@end
