//
//  ZBAnalytics.m
//  ZBKit
//
//  Created by NQ UEC on 17/3/1.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBAnalytics.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "UIApplication+ZBAnalytics.h"
#import "UIViewController+ZBAnalytics.h"
@implementation ZBAnalytics

+ (instancetype)sharedInstance
{
    static ZBAnalytics *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZBAnalytics alloc]init];
    });
    
    return sharedInstance;
}

- (id)displayIdentifier:(id)source
{
    if ([source isKindOfClass:[UIView class]]) {
        for (UIView *next = [source superview]; next; next = next.superview) {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                return (id)nextResponder;
            } else if ([nextResponder isKindOfClass:[UIApplication class]]) {
                return [[UIApplication sharedApplication] topMostViewController];
            }
        }
    } else if ([source isKindOfClass:[UIGestureRecognizer class]]) {
        UIGestureRecognizer *gestureSource = (UIGestureRecognizer *)source;
        if ([gestureSource.view isKindOfClass:[NSClassFromString(@"_UIAlertControllerView") class]]) {
            return gestureSource.view;
        }
        
        return [self displayIdentifier:gestureSource.view];
    }
    
    return nil;
}

//viewController_UIControl_action_target
- (void)analyticsSource:(id)source action:(SEL)action target:(id)target
{
    NSMutableString *identifierString = [[NSMutableString alloc] init];
    
    if ([target isKindOfClass:[NSClassFromString(@"UIInterfaceActionSelectionTrackingController") class]]) {//iOS10 UIAlertController内部实现变了，所以写成这样
        Ivar ivar = class_getInstanceVariable([target class], "_representationViews");
        NSMutableArray *representationViews =  object_getIvar(target, ivar);
        UIGestureRecognizer *gesture = source;
        
        for (UIView *representationView in representationViews) {
            
            CGPoint point = [gesture locationInView:representationView];
            
            if (point.x >= 0 && point.x <= CGRectGetWidth(representationView.bounds) &&
                point.y >= 0 && point.y <= CGRectGetHeight(representationView.bounds) &&
                gesture.state == UIGestureRecognizerStateEnded) {
                
                Ivar ivar = class_getInstanceVariable([representationView class], "_actionContentView");
                id actionContentView = object_getIvar(representationView, ivar);
                
                Ivar labelIvar = class_getInstanceVariable([actionContentView class], "_label");
                UILabel *label = object_getIvar(actionContentView, labelIvar);
                
                if (NSStringFromClass([[self displayIdentifier:source] class])) {
                    [identifierString appendString:NSStringFromClass([[self displayIdentifier:source] class])];
                }
                if ([[self displayIdentifier:source] isKindOfClass:[UIAlertController class]]) {
                    id viewControllerUnderAlertController = [[[UIApplication sharedApplication] currentViewController] topMostViewController];
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([viewControllerUnderAlertController class])]];
                }
                if (NSStringFromClass([source class])) {
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([source class])]];
                }
                if (label.text) {
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",label.text]];
                }
                if (NSStringFromSelector(action)) {
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromSelector(action)]];
                }
                
                if (NSStringFromClass([target class])) {
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([target class])]];
                }
                
                if (self.analyticsIdentifierBlock) {
                    self.analyticsIdentifierBlock(identifierString);
                }
            }
        }
        
    } else if ([target isKindOfClass:[NSClassFromString(@"_UIAlertControllerView") class]]) {
        
        Ivar ivar = class_getInstanceVariable([target class], "_actionViews");
        NSMutableArray *actionviews =  object_getIvar(target, ivar);
        UIGestureRecognizer *gesture = source;
        
        for (UIView *subview in actionviews) { /*_UIAlertControllerActionView*/
            CGPoint point = [gesture locationInView:subview];
            
            if (point.x >= 0 && point.x <= CGRectGetWidth(subview.bounds) &&
                point.y >= 0 && point.y <= CGRectGetHeight(subview.bounds) &&
                gesture.state == UIGestureRecognizerStateEnded) {
                
                UILabel *titleLabel = [subview performSelector:@selector(titleLabel)];
                
                if (NSStringFromClass([[self displayIdentifier:source] class])) {
                    [identifierString appendString:NSStringFromClass([[self displayIdentifier:source] class])];
                }
                if ([[self displayIdentifier:source] isKindOfClass:[NSClassFromString(@"_UIAlertControllerView") class]]) {
                    id viewControllerUnderAlertController = [[[UIApplication sharedApplication] currentViewController] topMostViewController];
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([viewControllerUnderAlertController class])]];
                }
                if (NSStringFromClass([source class])) {
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([source class])]];
                }
                if (titleLabel.text) {
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",titleLabel.text]];
                }
                if (NSStringFromSelector(action)) {
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromSelector(action)]];
                }
                if (NSStringFromClass([target class])) {
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([target class])]];
                }
                
                if (self.analyticsIdentifierBlock) {
                    self.analyticsIdentifierBlock(identifierString);
                }
            }
        }
        
    } else {
        
        NSString *titleString = nil;
        NSString *imageNameString = nil;
        NSString *backgroundImageName = nil;
        NSString *selectStateString = nil;
        NSString *tagString = nil;
        
        if ([source isKindOfClass:[UIButton class]]) {
            
            UIButton *btn = (UIButton *)source;
            
            titleString = btn.currentTitle;
            selectStateString = [NSString stringWithFormat:@"isSelectState_%@", @(btn.selected)];
            tagString = [NSString stringWithFormat:@"tag_%@", @(btn.tag)];
            
        } else if ([source isKindOfClass:[UIGestureRecognizer class]]) {
            
            UIGestureRecognizer *gestureRecognizer = (UIGestureRecognizer *)source;
            
            if (gestureRecognizer.state == UIGestureRecognizerStateChanged ||
                gestureRecognizer.state == UIGestureRecognizerStateBegan) {
                return;
            }
            
        }
        
        if (NSStringFromClass([[self displayIdentifier:source] class])) {
            [identifierString appendString:NSStringFromClass([[self displayIdentifier:source] class])];
        }
        if (NSStringFromClass([source class])) {
            [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([source class])]];
        }
        if (titleString) {
            [identifierString appendString:[NSString stringWithFormat:@"#%@",titleString]];
        }
        if (imageNameString) {
            [identifierString appendString:[NSString stringWithFormat:@"#%@",imageNameString]];
        }
        if (backgroundImageName) {
            [identifierString appendString:[NSString stringWithFormat:@"#%@", backgroundImageName]];
        }
        if (selectStateString) {
            [identifierString appendString:[NSString stringWithFormat:@"#%@", selectStateString]];
        }
        if (tagString) {
            [identifierString appendString:[NSString stringWithFormat:@"#%@", tagString]];
        }
        if (NSStringFromSelector(action)) {
            [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromSelector(action)]];
        }
        /*
        if (NSStringFromClass([target class])) {
            [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([target class])]];
        }
        */
        if (self.analyticsIdentifierBlock) {
            self.analyticsIdentifierBlock(identifierString);
        }
    }
}

- (void)analyticsSource:(id)source didSelectIndexPath:(NSIndexPath *)idxPath target:(id)target
{
    NSString *idxPathString = [NSString stringWithFormat:@"%@-%@", @(idxPath.section), @(idxPath.row)];
    NSMutableString *identifierString = [[NSMutableString alloc] init];
    if (NSStringFromClass([[self displayIdentifier:source] class])) {
        [identifierString appendString:NSStringFromClass([[self displayIdentifier:source] class])];
    }
    
    if (NSStringFromClass([source class])) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([source class])]];
    }
    
    if (idxPathString) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",idxPathString]];
    }
    
    if (NSStringFromClass([target class])) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([target class])]];
    }
    
    if (self.analyticsIdentifierBlock) {
        self.analyticsIdentifierBlock(identifierString);
    }
}

- (void)analyticsString:(NSString *)identifierString
{
    if (self.analyticsIdentifierBlock) {
        self.analyticsIdentifierBlock(identifierString);
    }
}


- (void)analyticsClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector{
    
    Class class = cls;
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (NSString *)getViewControllerIdentificationWithKey:(NSString *)key {
    return [self.VCDictionary objectForKey:key];
}

- (NSString *)getControlIdentificationWithKey:(NSString *)key {
    return [self.actionDictionary objectForKey:key];
}

- (NSString *)getTableViewIdentificationWithKey:(NSString *)key {
     return [self.tableViewDictionary objectForKey:key];
}
 
- (NSString *)getCollectionIdentificationWithKey:(NSString *)key {
 return [self.collectionDictionary objectForKey:key];
}



@end
