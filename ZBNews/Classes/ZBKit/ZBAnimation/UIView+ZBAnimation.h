//
//  UIView+ZBAnimation.h
//  ZBKit
//
//  Created by NQ UEC on 17/2/9.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZBAnimation)<CAAnimationDelegate>

- (void)circleView;
//关键帧动画
- (void)animatedKeyframes;

//点击移动 带弹簧效果
- (void)animatedDampingWithCenter:(CGPoint)center;

//图片切换 过渡动画
- (void)animatedTransitionWithoptions:(UIViewAnimationOptions)options;

//x轴上移动视图右平移x
- (void)animatedViewMoveWithRightX:(CGFloat)X;

//x轴上移动视图左平移x
- (void)animatedViewMoveWithLeftX:(CGFloat)X;

//y轴上移动视图上升y
- (void)animatedViewMoveWithUpY:(CGFloat)Y;

//y轴上移动视图下降y
- (void)animatedViewMoveWithDownY:(CGFloat)Y;

//浮动动画
-(void)AnimationFloating;

@end
