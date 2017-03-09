//
//  UIViewController+ZBAnalytics.m
//  ZBKit
//
//  Created by NQ UEC on 17/3/1.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "UIViewController+ZBAnalytics.h"
#import "ZBAnalytics.h"
#import "ZBConstants.h"
@implementation UIViewController (ZBAnalytics)
+ (void)load {
    SEL originalSelector = @selector(viewDidAppear:);
    SEL swizzledSelector = @selector(zb_viewDidAppear:);
    [[ZBAnalytics sharedInstance] analyticsClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
    
    SEL originalSelector2 = @selector(viewDidDisappear:);
    SEL swizzledSelector2 = @selector(zb_viewDidDisappear:);
    [[ZBAnalytics sharedInstance] analyticsClass:[self class] originalSelector:originalSelector2 swizzledSelector:swizzledSelector2];
}

#pragma mark - Method
- (void)zb_viewDidAppear:(BOOL)animated {
    [self zb_viewDidAppear:animated];
    
    if ([ZBAnalytics sharedInstance].VCDictionary.count==0) {
        NSString *disappear=[NSString stringWithFormat:@"进入%@",NSStringFromClass([self class])];
        [[ZBAnalytics sharedInstance] analyticsString:disappear];
    }else{
        NSString *identifier=[[ZBAnalytics sharedInstance] getViewControllerIdentificationWithKey:NSStringFromClass([self class])];
        if (identifier!=nil) {
            NSString *disappear=[NSString stringWithFormat:@"进入%@",identifier];
            [[ZBAnalytics sharedInstance] analyticsString:disappear];
        }
        
    }

}

- (void)zb_viewDidDisappear:(BOOL)animated {
    [self zb_viewDidDisappear:animated];
    
    if ([ZBAnalytics sharedInstance].VCDictionary.count==0) {
        NSString *disappear=[NSString stringWithFormat:@"退出%@",NSStringFromClass([self class])];
        [[ZBAnalytics sharedInstance] analyticsString:disappear];
    }else{
        NSString *identifier=[[ZBAnalytics sharedInstance] getViewControllerIdentificationWithKey:NSStringFromClass([self class])];
        if (identifier!=nil) {
            NSString *disappear=[NSString stringWithFormat:@"退出%@",identifier];
            [[ZBAnalytics sharedInstance] analyticsString:disappear];
        }

    }
    
    
}

- (UIViewController *)topMostViewController
{
    if (self.presentedViewController == nil || [self.presentedViewController isKindOfClass:[UIImagePickerController class]]) {
        
        return self;
        
    } else if ([self.presentedViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *navigationController = (UINavigationController *)self.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        
        return [lastViewController topMostViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)self.presentedViewController;
    
    return [presentedViewController topMostViewController];
}

@end
