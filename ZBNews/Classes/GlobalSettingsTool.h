//
//  GlobalSettingsTool.h
//  ZBNews
//
//  Created by NQ UEC on 16/12/6.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalSettingsTool : NSObject

//开启推送
@property (nonatomic, assign, getter=isEnabledPush) BOOL enabledPush;

//夜间模式
@property (nonatomic, assign, getter = isOnNightMode) BOOL onNightMode;

//正文无图模式
@property (nonatomic, assign, getter=isNoImageMode) BOOL noImageMode;

//正文字号 0 == 小 1 == 中 2 == 大;
@property (nonatomic, assign) int fontSize;


+ (GlobalSettingsTool*)sharedSetting;
- (int) getArticleFontSize;

+ (BOOL)downloadImagePattern;
//- (BOOL)detailCouldDownloadImage;
+ (BOOL)getNightPattern;

- (NSString *)appBundleName;

- (NSString *)appBundleID;

- (NSString *)appVersion;

- (NSString *)appBuildVersion;
@end
