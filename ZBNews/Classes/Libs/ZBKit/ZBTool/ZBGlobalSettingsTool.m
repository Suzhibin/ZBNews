//
//  ZBGlobalSettingsTool.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/6.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBGlobalSettingsTool.h"

@implementation ZBGlobalSettingsTool

+ (ZBGlobalSettingsTool*)sharedInstance
{
    static ZBGlobalSettingsTool *settingInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        settingInstance = [[self alloc] init];
    });
    return settingInstance;
    
}

- (id)init{
    self = [super init];
    if (self) {
        self.enabledPush = YES;
        self.fontSize=1;
    }
    return self;
}

- (BOOL)getNightPattern{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"readStyle"]) {
        //  NSLog(@"夜间模式");
        return YES;
    }else{
        //    NSLog(@"日间模式");
        return NO;
    }
}
- (BOOL)downloadImagePattern{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"readImage"]) {
        //NSLog(@"仅WIFI网络下载图片");
        return YES;
    }else{
        // NSLog(@"所有网络都可以下载图片");
        return NO;
    }
}

- (int)getArticleFontSize {
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
- (void)openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URL options:@{}
           completionHandler:^(BOOL success) {
               NSLog(@"Open %@: %d",scheme,success);
           }];
    } else {
        if([[UIApplication sharedApplication] canOpenURL:URL]) {
            BOOL success = [application openURL:URL];
            NSLog(@"Open %@: %d",scheme,success);
        }
    }
}
- (void)openSettings{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication]openURL:url];
    }
    
}

- (void)openURL:(NSString *)APPID{
    NSString *appstr=[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",APPID];
    [self openScheme:appstr];
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

- (NSString *)deviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    return deviceString;
}

- (NSString *)iPhoneName {
    return [UIDevice currentDevice].name;
}

- (CGFloat)batteryLevel{
    return [[UIDevice currentDevice] batteryLevel];
}

- (NSString *)systemName{
    return [UIDevice currentDevice].systemName;
}

- (NSString *)systemVersion{
    return [UIDevice currentDevice].systemVersion;
}

- (NSString *)advertisingID{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

- (NSString *)uuid{
    return  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString *)zb_stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

- (NSString *) clientType{
     return [[UIDevice currentDevice]model];
}


@end




