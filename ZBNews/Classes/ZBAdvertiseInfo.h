//
//  ZBAdvertiseInfo.h
//  ZBNetworkingDemo
//
//  Created by NQ UEC on 17/1/12.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
static NSString *const adImageName = @"adImageName";
static NSString *const adUrl = @"adUrl";
/*
 *  广告图片地址
 *  判断沙盒中是否存在广告图片
 */
typedef void (^AdvertisingInfo)(NSString *filePath,BOOL isExist);

@interface ZBAdvertiseInfo : NSObject

+ (void)getAdvertising:(AdvertisingInfo)info;

@end
