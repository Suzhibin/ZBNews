//
//  GlobalSettingsTool.m
//  ZBNews
//
//  Created by NQ UEC on 16/12/6.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "GlobalSettingsTool.h"
#import "AppDelegate.h"
#import "Constants.h"
@implementation GlobalSettingsTool
+ (GlobalSettingsTool*)sharedSetting
{
    static GlobalSettingsTool *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
    
}
- (id)init{
    self = [super init];
    if (self) {
        self.enabledPush = YES;
 
    }
    return self;
}
- (void) setDefaultPreferences {

    self.fontSize = 1;
    self.enabledPush = YES;
 
}
//得到模式选项  YES：夜间模式  NO：白天模式
+ (BOOL)getNightPattern{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"readStyle"]) {
        //  NSLog(@"夜间模式");
        return YES;
    }else{
        //    NSLog(@"日间模式");
        return NO;
    }
}
+ (BOOL)downloadImagePattern{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"readImage"]) {
        //NSLog(@"仅WIFI网络下载图片");
        return YES;
    }else{
       // NSLog(@"所有网络都可以下载图片");
        return NO;
    }
   // return !self.onlyWifiDownloadImage ;//|| [AppDelegate sharedAppDelegate].netStatus == AFNetworkReachabilityStatusReachableViaWiFi
}

- (int) getArticleFontSize {
    switch (self.fontSize) {
        case 0:
            return 14;
            break;
        case 1:
            return 16;
            break;
        case 2:
            return 20;
            break;
            
        default:
            return 15;
            break;
    }
}


- (NSString *)appBundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

- (NSString *)appBundleID {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

- (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)appBuildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}
@end
