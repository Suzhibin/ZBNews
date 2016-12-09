//
//  HeaderAnimatedView.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "HeaderAnimatedView.h"
#import "Masonry.h"
#import "MainViewController.h"
#import "ZBWeatherAnimatedView.h"
#import "Constants.h"
#import "GlobalSettingsTool.h"
#define TEMPERATURE_LABEL_FONT [UIFont boldSystemFontOfSize:40.f]
#define TEMPERATURE_LABEL_TEXT_COLOR [UIColor hexColor:@"3F444D"]
@interface HeaderAnimatedView ()
@property (strong, nonatomic) UILabel *temperatureLabel;

@property (strong, nonatomic) ZBWeatherAnimatedView *weatherView;
@end

@implementation HeaderAnimatedView
- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editchangeNightView) name:NIGHT object:nil];//夜间模式通知
        [self setupView];
       // NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/cityname";
      //  NSString *httpArg = @"cityname=%E5%8C%97%E4%BA%AC";
    }
    return self;
}

- (void)editchangeNightView
{
    [self getNightPattern];
}
- (void)setupView {
 
    [self getNightPattern];
    
    // self.weatherView=[[ZBWeatherAnimatedView alloc]initWithType:ZBWeatherViewTypeCloud];
    
    self.weatherView=[[ZBWeatherAnimatedView alloc]initWithType:ZBWeatherViewTypeRain];
    
    // self.weatherView=[[ZBWeatherAnimatedView alloc]initWithType:ZBWeatherViewTypeSunny];
    
    
    //[self.weatherView startAnimating];
    [self addSubview:self.weatherView];
    
    [_weatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
    }];
    
}

- (void)mainHomeScrollViewDidScroll2OffsetY:(CGFloat)offsetY {
    [_weatherView transformWithHomeScrollOffsetY:offsetY];
}

- (void)pageScrollViewDidScroll2OffsetY:(CGFloat)offsetY {
    [_weatherView transformWithPageScrollOffsetY:offsetY];
}

- (void)getNightPattern
{
    if ([GlobalSettingsTool getNightPattern]==YES) {
        
        [self setBackgroundColor:[UIColor colorWithRed:0.11 green:0.12 blue:0.13 alpha:1.00]];
        
    }else{
        
        [self setBackgroundColor:[UIColor whiteColor]];
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
