//
//  UIGestureRecognizer+ZBAnalytics.m
//  ZBKit
//
//  Created by NQ UEC on 17/3/1.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "UIGestureRecognizer+ZBAnalytics.h"
#import "ZBAnalytics.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation UIGestureRecognizer (ZBAnalytics)

+ (void)load{

    SEL originalSelector = @selector(initWithTarget:action:);
    SEL swizzledSelector = @selector(zb_initWithTarget:action:);
    [[ZBAnalytics sharedInstance] analyticsClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
}

- (instancetype)zb_initWithTarget:(nullable id)target action:(nullable SEL)action
{
    UIGestureRecognizer *selfGestureRecognizer = [self zb_initWithTarget:target action:action];
    
    if (!target && !action) {
        return selfGestureRecognizer;
    }
    
    if ([target isKindOfClass:[UIScrollView class]]) {
        return selfGestureRecognizer;
    }
    
    Class class = [target class];
    
    SEL originalSEL = action;
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"vi_%@", NSStringFromSelector(action)]);
    
    BOOL isAddMethod = class_addMethod(class, swizzledSEL, (IMP)vi_gestureAction, "v@:@");
    
    if (isAddMethod) {
        Method originalMethod = class_getInstanceMethod(class, originalSEL);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    return selfGestureRecognizer;
}

void vi_gestureAction(id self, SEL _cmd, id sender) {
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"vi_%@", NSStringFromSelector(_cmd)]);
    ((void(*)(id, SEL, id))objc_msgSend)(self, swizzledSEL, sender);
    [[ZBAnalytics sharedInstance] analyticsSource:sender action:_cmd target:self];
}

@end
