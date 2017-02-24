//
//  UIImageView+ZBKit.h
//  ZBKit
//
//  Created by NQ UEC on 17/2/23.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBImageDownloader.h"
@interface UIImageView (ZBKit)

/**
 *  图片请求 默认缓存路径
 *
 *  @param urlString         图片请求的协议地址
 */
- (void)zb_setImageWithURL:(NSString *)urlString ;

/**
 *  图片请求 默认缓存路径
 *
 *  @param urlString         图片请求的协议地址
 *  @param placeholder       占位图片
 */
- (void)zb_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholder;

/**
 *  图片请求 可自定义缓存路径
 *
 *  @param urlString         图片请求的协议地址
 *  @param placeholder       占位图片
 *  @param path              自定义路径
 */
- (void)zb_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholder path:(NSString *)path;
/**
 *  图片请求 默认缓存路径
 *
 *  @param urlString         图片请求的协议地址
 *  @param completion        完成后操作
 */
- (void)zb_setImageWithURL:(NSString *)urlString completion:(downloadCompletion)completion;

/**
 *  图片请求 默认缓存路径
 *
 *  @param urlString         图片请求的协议地址
 *  @param placeholder       占位图片
 *  @param completion        完成后操作
 */
- (void)zb_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholder completion:(downloadCompletion)completion;

/**
 *  图片请求 可自定义缓存路径
 *
 *  @param urlString         图片请求的协议地址
 *  @param placeholder       占位图片
 *  @param path              自定义路径
 *  @param completion        完成后操作
 */
- (void)zb_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholder path:(NSString *)path completion:(downloadCompletion)completion;

@end


