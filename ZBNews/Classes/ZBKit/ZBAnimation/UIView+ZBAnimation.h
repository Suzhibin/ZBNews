//
//  UIView+ZBAnimation.h
//  ZBKit
//
//  Created by NQ UEC on 17/2/9.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZBAnimation)<CAAnimationDelegate>

- (void)zb_circleView;
//关键帧动画
- (void)zb_animatedKeyframes;

//点击移动 带弹簧效果
- (void)zb_animatedDampingWithCenter:(CGPoint)center;

//图片切换 过渡动画
- (void)zb_animatedTransitionWithoptions:(UIViewAnimationOptions)options;

//x轴上移动视图右平移x
- (void)zb_animatedViewMoveWithRightX:(CGFloat)X;

//x轴上移动视图左平移x
- (void)zb_animatedViewMoveWithLeftX:(CGFloat)X;

//y轴上移动视图上升y
- (void)zb_animatedViewMoveWithUpY:(CGFloat)Y;

//y轴上移动视图下降y
- (void)zb_animatedViewMoveWithDownY:(CGFloat)Y;

//浮动动画
-(void)zb_animationFloating;

@end
