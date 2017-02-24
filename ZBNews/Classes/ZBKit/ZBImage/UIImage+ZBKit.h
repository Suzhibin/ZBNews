//
//  UIImage+ZBKit.h
//  ZBKit
//
//  Created by NQ UEC on 17/1/19.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^downloadImageCompletion)();

@interface UIImage (ZBKit)

/**
 图片切圆

 @return 返回圆形的图片
 */
- (UIImage *)circleImage;

/**
 图片上加文字水印

 @param title       文字
 @param fontSize    字体大小
 @return 返回生成文字的图片
 */
- (UIImage *)editImageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize;

/**
 取图片某一像素点的颜色
 
 @param point       颜色所在位置
 @return 返回生成颜色
 */
- (UIColor *)editColorAtPixel:(CGPoint)point;

/*
 将图片变成灰色
 @return 变色后的image
 */
- (UIImage *)editGrayImage;

/*
 纠正图片的方向 
 */
- (UIImage *)fixOrientation;

/*
 按给定的方向旋转图片
 @param orient      方向
 @return 旋转后的image
 */
- (UIImage*)editRotate:(UIImageOrientation)orient;

/*
 垂直翻转 
  @return 翻转后的image
 */
- (UIImage *)editFlipVertical;

/*
 水平翻转
 @return 翻转后的image
 */
- (UIImage *)editFlipHorizontal;

/*
 将图片旋转弧度
 @return 旋转弧度后的image
 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

/*
 将图片旋转角度
 @return 旋转后的image
 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/*
 截取当前image对象rect区域内的图像
 @return 变色后的image
 */
- (UIImage *)editSubImageWithRect:(CGRect)rect;

/*
 压缩图片至指定像素
 @param size        size
 @return 压缩后的image
 */
- (UIImage *)rescaleImageToPX:(CGFloat )toPX;

/*
 指定大小生成一个平铺的图片
 @param size        size
 @return 翻转后的image
 */
- (UIImage *)editTiledImageWithSize:(CGSize)size;

/*
  UIView转化为UIImage
 @return 转化后的image
 */
- (UIImage *)editViewConversionImage:(UIView *)view;

/*
 将两个图片合成一张图片
 @return 合成后的image
 */
- (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;

/*
 截取 图片中间
 @param size               size
 @param originalImage      截取前的image
 @return 截取后的image
 */
- (UIImage *)handleImage:(UIImage *)originalImage withSize:(CGSize)size;


@end



