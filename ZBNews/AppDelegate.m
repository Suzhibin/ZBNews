//
//  AppDelegate.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomTabBarController.h"
#import "Constants.h"
#import "GlobalSettingsTool.h"
#import <UMMobClick/MobClick.h>
#import "ZBAdvertiseView.h"
#import "ZBAdvertiseInfo.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NEWSLog(@"Caches = %@",caches);

    UMConfigInstance.appKey = @"584a53957f2c7414430003f6";
    UMConfigInstance.channelId = @"App Store";
     [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    [self setlanguages];
    [self  enablePush:[GlobalSettingsTool sharedSetting].enabledPush];
    CustomTabBarController *tabbar = [[CustomTabBarController alloc]init];
    self.window.rootViewController = tabbar;
    
    [self.window makeKeyAndVisible];
    
    //广告
    [ZBAdvertiseInfo getAdvertising:^(NSString *filePath,BOOL isExist){
        if (isExist) {
            ZBAdvertiseView *advertiseView = [[ZBAdvertiseView alloc] initWithFrame:self.window.bounds];
            advertiseView.filePath = filePath;
            [advertiseView show];
        }else{
            NSLog(@"无图片");
        }
    }];


    return YES;
}
- (void)enablePush:(BOOL)bEnable
{
    if(bEnable)
    {
        NSLog(@"应用内开启推送／不知道系统是否开启");
        //[self createPush];
        
    }else
    {
        NSLog(@"应用内关闭推送／不知道系统是否开启");
      //  [UMessage unregisterForRemoteNotifications];
    }
}
- (void)setlanguages{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:LanguageKey]) {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *language = [languages objectAtIndex:0];
    NEWSLog(@"language:%@",language);
    if ([language hasPrefix:Chinese]) {//开头匹配
        [[NSUserDefaults standardUserDefaults] setObject:Chinese forKey:LanguageKey];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:English forKey:LanguageKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
