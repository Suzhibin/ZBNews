//
//  ZBWeatherAnimatedView.m
//  JSNews
//
//  Created by NQ UEC on 16/11/16.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "ZBWeatherAnimatedView.h"
#import <QuartzCore/CABase.h>
#import "Masonry.h"

#define VIEW_H_W_RATIO 1.5f
//屏幕宽
#define SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)
//屏幕高
#define SCREEN_HEIGHT               ([UIScreen mainScreen].bounds.size.height)
NSString * const STARTANIMATING = @"startAnimating";
@interface ZBWeatherAnimatedView ()
@property (strong, nonatomic) NSArray *imageDataArray;
@property (strong, nonatomic) NSArray *rainImageViewList;
@end

@implementation ZBWeatherAnimatedView

- (instancetype)initWithType:(ZBWeatherViewType)type
{
    self = [super init];
    if (self) {
        self.weatherType=type;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:STARTANIMATING object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnimating) name:STARTANIMATING object:nil];
        [self setupView];
    }
    return self;
}

- (void)setupView {
   
    NSMutableArray *mutArray = [NSMutableArray array];
  
    switch (_weatherType) {
        case ZBWeatherViewTypeSunny: {

            for (int i = 0; i < 3; i ++) {
                //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Fine%d", i]]];
                 UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Fine4"]];
                [self addSubview:imageView];
                [mutArray addObject:imageView];
                CGFloat widthMultiply = 1.3 - i*0.1;
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self);
                    make.width.equalTo(self).multipliedBy(widthMultiply);
                    make.height.equalTo(imageView.mas_width);
                    make.centerY.equalTo(self).offset(-0.2*SCREEN_WIDTH);
                }];
            }
            self.imageDataArray = [mutArray copy];
        } break;
        case ZBWeatherViewTypeCloud: {

           // NSMutableArray *mutArray = [NSMutableArray array];
            for (int i = 3; i > 0; i --) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Cloud%d", i]];
                UIImageView *tempImageView = [[UIImageView alloc] initWithImage:image];
                [self addSubview:tempImageView];
                [mutArray addObject:tempImageView];
                
                [tempImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self);
                    make.width.equalTo(self).multipliedBy(VIEW_H_W_RATIO);
                    make.height.equalTo(tempImageView.mas_width);
                    make.centerY.equalTo(self).offset(-0.25*SCREEN_WIDTH);
                }];
            }
            self.imageDataArray = [mutArray copy];

        } break;
        case ZBWeatherViewTypeRain: {
          //  NSMutableArray *mutArray = [NSMutableArray array];
            NSMutableArray *rainMutArray = [NSMutableArray array];
            for (int i = 3; i > 0; i --) {
                if (1 == i) {
                    //Rain层
                    for (int k = 1; k < 4; k ++) {
                        UIImageView *rainImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Rain%d", k]]];
               
                        [self addSubview:rainImageView];
                        [rainMutArray addObject:rainImageView];
                        
                        [rainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerY.equalTo(self);
                            make.centerX.equalTo(self).offset(0.4*SCREEN_WIDTH);
                            make.width.equalTo(self);
                            make.height.equalTo(rainImageView.mas_width).multipliedBy(1/VIEW_H_W_RATIO);
                        }];
                    }
                }
                //Gloom层
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Gloom%d", i]]];
                [self addSubview:imageView];
                [mutArray addObject:imageView];
                
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self);
                    make.width.equalTo(self).multipliedBy(1.5);
                    make.height.equalTo(imageView.mas_width);
                    make.centerY.equalTo(self).offset(-0.25*SCREEN_WIDTH);
                }];
            }
            self.imageDataArray = [mutArray copy];
            self.rainImageViewList = [rainMutArray copy];

        } break;
    }
}


- (void)startAnimating {
   
    
    switch (_weatherType) {
        case ZBWeatherViewTypeSunny:{
            UIImageView *firstImageView = _imageDataArray.firstObject;
            CAKeyframeAnimation *firstAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            firstAnim.duration = 7.f;
            firstAnim.repeatCount = HUGE_VALF;
            UIBezierPath *firstPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(firstImageView.center.x-10, firstImageView.center.y-3) radius:3 startAngle:0 endAngle:2*M_PI clockwise:YES];
            firstAnim.path = firstPath.CGPath;
            [firstImageView.layer addAnimation:firstAnim forKey:@"position"];
            CABasicAnimation *firstRotateAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            firstRotateAnim.duration = 16.f;
            firstRotateAnim.repeatCount = HUGE_VALF;
            firstRotateAnim.fromValue = @(0);
            firstRotateAnim.toValue = @(-2*M_PI);
            [firstImageView.layer addAnimation:firstRotateAnim forKey:@"rotation"];
            
            UIImageView *secondImageView = _imageDataArray[1];
            CAKeyframeAnimation *secondAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            secondAnim.duration = 6.f;
            secondAnim.repeatCount = HUGE_VALF;
            UIBezierPath *secondPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(secondImageView.center.x, secondImageView.center.y-5) radius:5 startAngle:0 endAngle:2*M_PI clockwise:YES];
            secondAnim.path = secondPath.CGPath;
            [secondImageView.layer addAnimation:secondAnim forKey:@"position"];
            CABasicAnimation *secondRotateAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            secondRotateAnim.duration = 23.f;
            secondRotateAnim.repeatCount = HUGE_VALF;
            secondRotateAnim.fromValue = @(M_PI);
            secondRotateAnim.toValue = @(2*M_PI);
            [secondImageView.layer addAnimation:secondRotateAnim forKey:@"rotation"];
            
            UIImageView *thirdImageView = _imageDataArray[2];
            CAKeyframeAnimation *thirdAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            thirdAnim.duration = 5.f;
            thirdAnim.repeatCount = HUGE_VALF;
            UIBezierPath *thirdPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(thirdImageView.center.x+5, thirdImageView.center.y-10) radius:5 startAngle:0 endAngle:2*M_PI clockwise:YES];
            thirdAnim.path = thirdPath.CGPath;
            [thirdImageView.layer addAnimation:thirdAnim forKey:@"position"];
            CABasicAnimation *thirdRotateAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            thirdRotateAnim.duration = 30.f;
            thirdRotateAnim.repeatCount = HUGE_VALF;
            thirdRotateAnim.fromValue = @(0);
            thirdRotateAnim.toValue = @(-2*M_PI);
            [thirdImageView.layer addAnimation:thirdRotateAnim forKey:@"rotation"];

        }
            
            break;
        case ZBWeatherViewTypeCloud:{
            UIImageView *firstImageView = _imageDataArray.firstObject;
            CAKeyframeAnimation *firstAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            firstAnim.duration = 7.f;
            firstAnim.repeatCount = HUGE_VALF;
            UIBezierPath *firstPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(firstImageView.center.x-15, firstImageView.center.y-3) radius:3 startAngle:0 endAngle:2*M_PI clockwise:YES];
            firstAnim.path = firstPath.CGPath;
            [firstImageView.layer addAnimation:firstAnim forKey:@"position"];
            
            UIImageView *secondImageView = _imageDataArray[1];
            CAKeyframeAnimation *secondAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            secondAnim.duration = 6.f;
            secondAnim.repeatCount = HUGE_VALF;
            UIBezierPath *secondPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(secondImageView.center.x+5, secondImageView.center.y-5) radius:5 startAngle:0 endAngle:2*M_PI clockwise:YES];
            secondAnim.path = secondPath.CGPath;
            [secondImageView.layer addAnimation:secondAnim forKey:@"position"];
            
            UIImageView *thirdImageView = _imageDataArray[2];
            CAKeyframeAnimation *thirdAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            thirdAnim.duration = 5.f;
            thirdAnim.repeatCount = HUGE_VALF;
            UIBezierPath *thirdPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(thirdImageView.center.x, thirdImageView.center.y-10) radius:5 startAngle:0 endAngle:2*M_PI clockwise:YES];
            thirdAnim.path = thirdPath.CGPath;
            [thirdImageView.layer addAnimation:thirdAnim forKey:@"position"];
        
        }
            break;
        case ZBWeatherViewTypeRain:{
            UIImageView *firstImageView = _imageDataArray.firstObject;
            CAKeyframeAnimation *firstAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            firstAnim.duration = 7.f;
            firstAnim.repeatCount = HUGE_VALF;
            UIBezierPath *firstPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(firstImageView.center.x-15, firstImageView.center.y-3) radius:3 startAngle:0 endAngle:2*M_PI clockwise:YES];
            firstAnim.path = firstPath.CGPath;
            [firstImageView.layer addAnimation:firstAnim forKey:@"position"];
            
            UIImageView *secondImageView = _imageDataArray[1];
            CAKeyframeAnimation *secondAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            secondAnim.duration = 6.f;
            secondAnim.repeatCount = HUGE_VALF;
            UIBezierPath *secondPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(secondImageView.center.x+5, secondImageView.center.y-5) radius:5 startAngle:0 endAngle:2*M_PI clockwise:YES];
            secondAnim.path = secondPath.CGPath;
            [secondImageView.layer addAnimation:secondAnim forKey:@"position"];
            
            UIImageView *thirdImageView = _imageDataArray[2];
            CAKeyframeAnimation *thirdAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            thirdAnim.duration = 5.f;
            thirdAnim.repeatCount = HUGE_VALF;
            UIBezierPath *thirdPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(thirdImageView.center.x, thirdImageView.center.y-10) radius:5 startAngle:0 endAngle:2*M_PI clockwise:YES];
            thirdAnim.path = thirdPath.CGPath;
            [thirdImageView.layer addAnimation:thirdAnim forKey:@"position"];
            
            //Rain
            UIImageView *firstRain = _rainImageViewList.firstObject;
            CGFloat destinationX = firstRain.center.x - 0.5*firstRain.frame.size.width;
            CGFloat destinationY = firstRain.center.y + 1.5*firstRain.frame.size.height;
            CGPoint rainDestinationCenter = CGPointMake(destinationX, destinationY);
            for (int index = 0; index < _rainImageViewList.count; index ++) {
                UIImageView *rainImageView = _rainImageViewList[index];
                CAKeyframeAnimation *firstRainAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
                firstRainAnim.duration = 7.f;
                firstRainAnim.repeatCount = HUGE_VALF;
                firstRainAnim.beginTime = CACurrentMediaTime() + index * 7/3;
                UIBezierPath *firstRainPath = [UIBezierPath bezierPath];
                [firstRainPath moveToPoint:firstRain.center];
                [firstRainPath addLineToPoint:rainDestinationCenter];
                firstRainAnim.path = firstRainPath.CGPath;
                [rainImageView.layer addAnimation:firstRainAnim forKey:@"position"];
            }

        }
            break;
        default:
            break;
    }

}
- (void)transformWithHomeScrollOffsetY:(CGFloat)offsetY {
    offsetY += 20;//除去状态栏
    if (offsetY > 0) {
        CGFloat scale = 1 - offsetY/150;
        self.transform = CGAffineTransformMakeScale(scale, 1);
        self.alpha = (64-offsetY)/64;
    }
}

- (void)transformWithPageScrollOffsetY:(CGFloat)offsetY {
    if (offsetY < 0) {
        CGFloat scale = 1 + -offsetY/250;
        self.transform = CGAffineTransformMakeScale(scale, 1);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
