//
//  ZBGlobalSettingsTool.h
//  ZBKit
//
//  Created by NQ UEC on 17/2/6.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sys/utsname.h"
#import <AdSupport/AdSupport.h>
#import <UIKit/UIKit.h>

@interface ZBGlobalSettingsTool : NSObject

//开启推送
@property (nonatomic, assign, getter=isEnabledPush) BOOL enabledPush;

//正文字号 0 == 小 1 == 中 2 == 大;
@property (nonatomic, assign) int fontSize;

+ (ZBGlobalSettingsTool*)sharedInstance;

/**
 文字大小

 @return size
 */
- (int) getArticleFontSize;

/**
 夜间模式

 @return 是否夜间模式
 */
- (BOOL)getNightPattern;

/**
 图片WIFI浏览
 
 @return 是否WIFI
 */
- (BOOL)downloadImagePattern;

/**
 跳转评论
 
 @param APPID 应用ID
 */
- (void)openURL:(NSString *)APPID;

/**
 跳转设置页面
 */
- (void)openSettings;

/**
 应用的名字
 
 @return 应用的名字
 */
- (NSString *)appBundleName;

/**
 应用的BundleID
 
 @return 应用的BundleID
 */
- (NSString *)appBundleID;

/**
 应用的版本
 
 @return 应用的版本
 */
- (NSString *)appVersion;

/**
 应用的Build
 
 @return 应用的Build
 */
- (NSString *)appBuildVersion;

/**
 设备名字
 
 @return 设备名字
 */
- (NSString *)deviceName;

/**
 iPhone名称
 
 @return iPhone名称
 */
- (NSString *)iPhoneName;

//电池电量
- (CGFloat)batteryLevel;

//系统名称
- (NSString *)systemName;

//系统版本
- (NSString *)systemVersion;
/**
 广告位标识符：在同一个设备上的所有App都会取到相同的值，是苹果专门给各广告提供商用来追踪用户而设的，用户可以在 设置|隐私|广告追踪里重置此id的值，或限制此id的使用，故此id有可能会取不到值，但好在Apple默认是允许追踪的，而且一般用户都不知道有这么个设置，所以基本上用来监测推广效果，是戳戳有余了
 
 @return advertisingID 广告位标识符
 */
- (NSString *)advertisingID;

//uuid
- (NSString *)uuid;

@end
