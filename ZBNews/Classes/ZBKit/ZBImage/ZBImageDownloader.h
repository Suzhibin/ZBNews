//
//  ZBImageDownloader.h
//  ZBKit
//
//  Created by NQ UEC on 17/1/20.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZBCacheManager.h"
typedef void (^downloadCompletion)(UIImage *image);

//typedef void (^requestCompletion)(UIImage *image);

@interface ZBImageDownloader : NSObject

+ (ZBImageDownloader *)sharedInstance;
/**
 *  图片请求 默认缓存路径  /Library/Caches/ZBKit/AppImage
 *
 *  @param imageUrl         图片请求的协议地址
 */
- (void)downloadImageUrl:(NSString *)imageUrl;

/**
 *  图片请求 默认缓存路径  /Library/Caches/ZBKit/AppImage
 *
 *  @param imageUrl         图片请求的协议地址
 *  @param completion       请求完成的操作
 */
- (void)downloadImageUrl:(NSString *)imageUrl completion:(downloadCompletion)completion;

/**
 *  图片请求 自定义缓存路径
 *  @param imageUrl         图片请求的协议地址
 *  @param path             自定义路径
 *  @param completion       请求完成的操作
 */
- (void)downloadImageUrl:(NSString *)imageUrl path:(NSString *)path completion:(downloadCompletion)completion;

/**
 *  图片请求 不缓存
 *
 *  @param imageUrl         图片请求的协议地址
 *  @param completion       请求完成的操作
 */
- (void)requestImageUrl:(NSString *)imageUrl completion:(downloadCompletion)completion;

/**
 *  图片的大小  /Library/Caches/ZBKit/AppImage
 *  @return size            大小
 */
- (NSUInteger)imageFileSize;

/**
 *  图片的数量  /Library/Caches/ZBKit/AppImage
 *  @return Count           数量
 */
- (NSUInteger)imageFileCount;

/**
 *  清除图片
 */
- (void)clearImageFile;

/**
 *  清除图片
 *  @param completion        block 后续操作
 */
- (void)clearImageFileCompletion:(ZBCacheCompletedBlock)completion;

/**
 *  清除某个图片
 *  @param key              图片的地址
 */
- (void)clearImageForkey:(NSString *)key;

/**
 *  清除某个图片
 *  @param key              图片的地址
 *  @param completion        block 后续操作
 */
- (void)clearImageForkey:(NSString *)key completion:(ZBCacheCompletedBlock)completion;

/**
 *  图片存储路径 /Library/Caches/ZBKit/AppImage
 */
- (NSString *)imageFilePath;

- (void)saveThePhotoAlbum:(UIImage *)image;

@end
