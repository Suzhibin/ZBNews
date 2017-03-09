//
//  ZBConstants.h
//  ZBKit
//
//  Created by NQ UEC on 17/1/19.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#ifndef ZBConstants_h
#define ZBConstants_h

#define ZBKBUG_LOG 0
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
#define SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)
//屏幕高
#define SCREEN_HEIGHT               ([UIScreen mainScreen].bounds.size.height)

//是否为ios7
#define is_ios7  [[[UIDevice currentDevice]systemVersion]floatValue]>=7

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
//随机颜色
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

// 打印当前方法名
#define JSPRINT_METHOD JSLog(@"==%@:%p running method '%@'==", self.class, self, NSStringFromSelector(_cmd));

//夜间模式 显示图片 Name
#define READStyle @"showNightView"

//wifi 显示图片 Name
#define READIMAGE @"showImage"

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

#endif /* ZBConstants_h */
