//
//  ZBInteractiveTransition.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/15.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBInteractiveTransition.h"
@interface ZBInteractiveTransition()

@property (nonatomic,assign) BOOL shouldComplete;
@property (nonatomic, weak) UIViewController *vc;

@end
@implementation ZBInteractiveTransition
- (void)wireToViewController:(UIViewController *)viewController{
    self.vc = viewController;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    
    [viewController.view addGestureRecognizer:pan];

}

-(CGFloat)completionSpeed{
    //NSLog(@"%f",self.percentComplete);
    return self.percentComplete == 0.0?1.0f:self.percentComplete;
    //return 1-self.percentComplete;
}

-(void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer{
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
               //手势开始的时候标记手势状态，并开始相应的事件
            self.interacting = YES;
            [self.vc.navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged:{
            CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
            CGFloat fraction = translation.x/[[UIScreen mainScreen] bounds].size.width;
            fraction = fminf(1.0,fmaxf(fraction, 0.0));
            //NSLog(@"A:%f",fraction);
            self.shouldComplete = (fraction > 0.3);
             //手势过程中，通过updateInteractiveTransition设置pop过程进行的百分比
            [self updateInteractiveTransition:fraction];
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            self.interacting = NO;
            self.gesture.enabled = NO;
            if (!self.shouldComplete || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            }else{
                [self finishInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}

@end
