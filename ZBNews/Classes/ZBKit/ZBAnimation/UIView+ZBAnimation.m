//
//  UIView+ZBAnimation.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/9.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "UIView+ZBAnimation.h"

@implementation UIView (ZBAnimation)

- (void)zb_circleView{

    CGRect rect = CGRectMake(0, 0, 100, 50);
    CGSize radio = CGSizeMake(10, 10);//圆角尺寸
    UIRectCorner corner = UIRectCornerTopLeft|UIRectCornerTopRight;//这只圆角位置
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:radio];
    CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];//创建shapelayer
    masklayer.frame = self.bounds;
    masklayer.path = path.CGPath;//设置路径
    self.layer.mask = masklayer;
}

- (void)zb_animatedKeyframes{
    
    [UIView animateKeyframesWithDuration:4 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        CGPoint center = self.center;
        [UIView addKeyframeWithRelativeStartTime: 0 relativeDuration: 0.1 animations: ^{
            self.center = (CGPoint){ center.x + 15, center.y + 80 };
        }];
        [UIView addKeyframeWithRelativeStartTime: 0.1 relativeDuration: 0.15 animations: ^{
            self.center = (CGPoint){ center.x + 45, center.y + 185 };
        }];
        [UIView addKeyframeWithRelativeStartTime: 0.25 relativeDuration: 0.3 animations: ^{
            self.center = (CGPoint){ center.x + 90, center.y + 295 };
        }];
        [UIView addKeyframeWithRelativeStartTime: 0.55 relativeDuration: 0.3 animations: ^{
            self.center = (CGPoint){ center.x + 180, center.y + 375 };
        }];
        [UIView addKeyframeWithRelativeStartTime: 0.85 relativeDuration: 0.15 animations: ^{
            self.center = (CGPoint){ center.x + 260, center.y + 435 };
        }];
        [UIView addKeyframeWithRelativeStartTime: 0 relativeDuration: 1 animations: ^{
            self.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
/*创建弹性动画
 damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
 velocity:弹性复位的速度
 delay 延迟 秒
 */
- (void)zb_animatedDampingWithCenter:(CGPoint)center{
    
    [UIView animateWithDuration:3.0 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.center=center;
    } completion:nil];
}

- (void)zb_animatedTransitionWithoptions:(UIViewAnimationOptions)options{
    
    [UIView transitionWithView: self duration: 0.5 options: options animations: ^{
   
    } completion:nil];
}

- (void)zb_animatedViewMoveWithRightX:(CGFloat)X{

    [UIView animateWithDuration: 0.5 delay: 0 options: UIViewAnimationOptionCurveLinear animations: ^{
        CGPoint center = self.center;
        center.x += X;
        self.center = center;
    } completion: nil];
}

- (void)zb_animatedViewMoveWithLeftX:(CGFloat)X{
    [UIView animateWithDuration: 0.5 delay: 0 options: UIViewAnimationOptionCurveLinear animations: ^{
        CGPoint center = self.center;
        center.x -= X;
        self.center = center;
    } completion: nil];
}

- (void)zb_animatedViewMoveWithUpY:(CGFloat)Y{
    
    [UIView animateWithDuration: 0.5 delay: 0 options: UIViewAnimationOptionCurveLinear animations: ^{
        CGPoint center = self.center;
        center.y -= Y;
        self.center = center;
    } completion: nil];
}

- (void)zb_animatedViewMoveWithDownY:(CGFloat)Y{
    
    [UIView animateWithDuration: 0.5 delay: 0 options: UIViewAnimationOptionCurveLinear animations: ^{
        CGPoint center = self.center;
        center.y += Y;
        self.center = center;
    } completion: nil];
}

- (void)zb_animationFloating{
    
    int x = arc4random() % 10;//实际使用时 去掉随机数
    //1.创建关键帧动画并设置动画属性
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;//动画在开始和结束时的动作
    
    pathAnimation.repeatCount = MAXFLOAT; //重复次数
    pathAnimation.autoreverses=YES;//动画结束是 是否执行逆向动画
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];//速度变化
    
    pathAnimation.duration=x;//动画时长
    pathAnimation.delegate = self;
    
    UIBezierPath *path=[UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.frame, self.frame.size.width/2-5, self.frame.size.width/2-5)];
    //设置path属性
    pathAnimation.path=path.CGPath;
    
    [self.layer addAnimation:pathAnimation forKey:@"pathAnimation"];
    
    CAKeyframeAnimation *scaleX=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    
    scaleX.values   = @[@1.0, @1.1, @1.0];
    scaleX.keyTimes = @[@0.0, @0.5,@1.0];
    scaleX.repeatCount = MAXFLOAT;
    scaleX.autoreverses = YES;
    scaleX.duration=x;
    [self.layer addAnimation:scaleX forKey:@"scaleX"];
    
    CAKeyframeAnimation *scaleY=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    
    scaleY.values   = @[@1.0, @1.1, @1.0];
    scaleY.keyTimes = @[@0.0, @0.5,@1.0];
    scaleY.repeatCount = MAXFLOAT;
    scaleY.autoreverses = YES;
    scaleY.duration=x;
    
    [self.layer addAnimation:scaleY forKey:@"scaleY"];
    
}
#pragma mark CAKeyframeAnimation delegate
- (void)animationDidStart:(CAAnimation *)anim{
   // NSLog(@"开始了");
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
     //方法中的flag参数表明了动画是自然结束还是被打断
    // NSLog(@"结束了");
}
@end
