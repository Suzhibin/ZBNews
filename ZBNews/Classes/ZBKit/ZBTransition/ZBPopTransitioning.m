//
//  ZBPopTransitioning.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/15.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBPopTransitioning.h"

@implementation ZBPopTransitioning
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect finalFrame = [transitionContext finalFrameForViewController:fromVC];
    finalFrame = CGRectOffset(finalFrame,screenBounds.size.width,0);
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView sendSubviewToBack:toVC.view];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        fromVC.view.frame = finalFrame;
        toVC.view.transform = transform;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
