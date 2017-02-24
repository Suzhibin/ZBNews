//
//  ZBInteractiveTransition.h
//  ZBKit
//
//  Created by NQ UEC on 17/2/15.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBInteractiveTransition : UIPercentDrivenInteractiveTransition
@property (nonatomic,assign) BOOL interacting;
@property (nonatomic,strong) UIPanGestureRecognizer *gesture;

-(void)wireToViewController:(UIViewController *)viewController;
@end
