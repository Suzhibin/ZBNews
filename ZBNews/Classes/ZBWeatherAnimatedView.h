//
//  ZBWeatherAnimatedView.h
//  JSNews
//
//  Created by NQ UEC on 16/11/16.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString * const STARTANIMATING;

//用于标识不同类型
typedef NS_ENUM(NSInteger,ZBWeatherViewType) {
    
    ZBWeatherViewTypeSunny,   //阳光明媚
    ZBWeatherViewTypeCloud,   //多云
    ZBWeatherViewTypeRain,    //阴雨
} ;

@interface ZBWeatherAnimatedView : UIView
@property (nonatomic, assign) ZBWeatherViewType weatherType;

- (instancetype)initWithType:(ZBWeatherViewType)type;
- (void)startAnimating;
- (void)transformWithHomeScrollOffsetY:(CGFloat)offsetY;
- (void)transformWithPageScrollOffsetY:(CGFloat)offsetY;
@end
