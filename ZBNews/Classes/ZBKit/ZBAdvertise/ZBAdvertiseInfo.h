//
//  ZBAdvertiseInfo.h
//  ZBKit
//
//  Created by NQ UEC on 17/1/12.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
static NSString *const adImageName = @"adImageName";
static NSString *const adUrl = @"adUrl";

typedef void (^AdvertisingInfo)(NSString *filePath,NSDictionary *urlDict,BOOL isExist);

@interface ZBAdvertiseInfo : NSObject


//+ (void)getAdvertisingInfo:(AdvertisingInfo)info;

/**
 请求开屏广告 
 
 @param info block回调
 */
+ (void)getAdvertising:(AdvertisingInfo)info;

+ (NSString *)advertiseFilePath;
+ (NSUInteger)advertiseFileSize;
+ (NSUInteger)advertiseFileCount;
@end
