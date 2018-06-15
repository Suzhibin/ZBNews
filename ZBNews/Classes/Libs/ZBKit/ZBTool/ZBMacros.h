//
//  ZBMacros.h
//  ZBNews
//
//  Created by NQ UEC on 2017/10/20.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#ifndef ZBMacros_h
#define ZBMacros_h

#define ZBKBUG_LOG 1
#if(ZBKBUG_LOG == 1)
# define ZBKLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
# define ZBKLog(...);
#endif

// 获取时间间隔
#define TICK   CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define TOCK   NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)

//设备屏幕大小
#define  MainScreenFrame   [[UIScreen mainScreen] bounds]

//屏幕宽
#define ZB_SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)
//屏幕高
#define ZB_SCREEN_HEIGHT               ([UIScreen mainScreen].bounds.size.height)

//是否为ios7
#define is_ios7  [[[UIDevice currentDevice]systemVersion]floatValue]>=7

//4的设备
#define ZB_DEVICE_IS_Retina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
//5,5s的设备
#define ZB_DEVICE_IS_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define ZB_DEVICE_IS_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define ZB_DEVICE_IS_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define ZB_DEVICE_IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define ZB_TABBAR_HEIGHT   CGRectGetHeight(self.tabBarController.tabBar.frame)

#define ZB_STATUS_HEIGHT  [[UIApplication sharedApplication] statusBarFrame].size.height

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
//随机颜色
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//取消键盘响应
#define HIDE_KEYBOARD [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];[[[UIApplication sharedApplication] keyWindow] endEditing:YES];

/** 判断是否为iPhone*/
#define ISiPhone   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
/** 判断是否为iPad*/
#define ISiPad     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/** 判断是真机还是模拟器*/
#if TARGET_OS_IPHONE
//真机
#endif
#if TARGET_IPHONE_SIMULATOR
//模拟器
#endif

//夜间模式
static NSString * const READStyle = @"showNightView";
//无网不显示图片
static NSString * const READIMAGE = @"showImage";
//定位城市
static NSString * const CITY = @"locationCity";

/*
 platform:ios,'8.0'
 target :'应用名字' do
 pod 'VTMagic'
 pod 'SDWebImage'
 pod 'XRCarouselView'
 pod 'MJRefresh'
 pod 'UITableView+FDTemplateLayoutCell'
 pod 'SDAutoLayout'
 pod 'Masonry'
 end
 
 */
/*
 介绍对象啊
 这你就算找对人了，专业对口.要介绍对象，要先说说类。 类是对逻辑上相关函数与数据的封装，是对问题的抽象，而对象就是类的特定实例。Object obj=new Object(),obj就是Object类的对象。
 */

#endif /* ZBMacros_h */
