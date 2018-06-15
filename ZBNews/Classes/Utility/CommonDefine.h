//
//  CommonDefine.h
//  ZBNews
//
//  Created by NQ UEC on 2018/6/12.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#define NEWSBUG_LOG 1
#if(NEWSBUG_LOG == 1)
# define SLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
# define SLog(...);
#endif


// 打印当前方法名
#define JSPRINT_METHOD JSLog(@"==%@:%p running method '%@'==", self.class, self, NSStringFromSelector(_cmd));



//设备屏幕大小
#define  MainScreenFrame   [[UIScreen mainScreen] bounds]

//屏幕宽
#define SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)
//屏幕高
#define SCREEN_HEIGHT               ([UIScreen mainScreen].bounds.size.height)
//是否为ios7
#define is_ios7  [[[UIDevice currentDevice]systemVersion]floatValue]>=7


//随机颜色
#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define Sfavorites  @"favorites"
#define Scalendar  @"calendar"

/*
 platform:ios,'8.0'
 target :'ZBNews' do
 pod 'VTMagic'
 pod 'SDWebImage'
 pod 'XRCarouselView'
 pod 'MJRefresh'
 pod 'UITableView+FDTemplateLayoutCell'
 pod 'SDAutoLayout'
 pod 'Masonry'
 end
 
 */

#endif /* CommonDefine_h */
