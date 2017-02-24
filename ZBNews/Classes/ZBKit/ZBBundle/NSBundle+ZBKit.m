//
//  NSBundle+ZBKit.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/13.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "NSBundle+ZBKit.h"

@implementation NSBundle (ZBKit)

+ (NSString *)IDInfoIcon
{
    static NSString *IDInfo=@"ZBKit.bundle/ZBSetting/IDInfo";
    return IDInfo;
}
+ (NSString *)handShakeIcon
{
    static NSString *handShake=@"ZBKit.bundle/ZBSetting/handShake";
    return handShake;
}
+ (NSString *)MoreAboutIcon
{
    static NSString *MoreAbout=@"ZBKit.bundle/ZBSetting/MoreAbout";
    return MoreAbout;
}
+ (NSString *)MoreHelpIcon
{
    static NSString *MoreHelp=@"ZBKit.bundle/ZBSetting/MoreHelp";
    return MoreHelp;
}
+ (NSString *)MoreMessageIcon
{
    static NSString *MoreMessage=@"ZBKit.bundle/ZBSetting/MoreMessage";
    return MoreMessage;
}
+ (NSString *)MorePushIcon
{
    static NSString *MorePush=@"ZBKit.bundle/ZBSetting/MorePush";
    return MorePush;
}
+ (NSString *)MoreShareIcon
{
    static NSString *MoreShare=@"ZBKit.bundle/ZBSetting/MoreShare";
    return MoreShare;
}
+ (NSString *)MoreUpdateIcon
{
    static NSString *MoreUpdate=@"ZBKit.bundle/ZBSetting/MoreUpdate";
    return MoreUpdate;
}
+ (NSString *)ArrowIcon
{
    static NSString *Arrow=@"ZBKit.bundle/ZBSetting/sliderMenu_rightArrow";
    return Arrow;
}
@end
