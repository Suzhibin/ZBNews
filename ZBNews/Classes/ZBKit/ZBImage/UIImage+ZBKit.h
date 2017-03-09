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
- (UIImage *)zb_circleImage;

/**
 图片上加文字水印

 @param title       文字
 @param fontSize    字体大小
 @return 返回生成文字的图片
 */
- (UIImage *)zb_ImageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize;

/**
 *  获取当前图片的均色，原理是将图片绘制到1px*1px的矩形内，再从当前区域取色，得到图片的均色。
 *
 *  @return 代表图片平均颜色的UIColor对象
 */
- (UIColor *)zb_averageColor;

/**
 取图片某一像素点的颜色
 
 @param point       颜色所在位置
 @return 返回生成颜色
 */
- (UIColor *)zb_ColorAtPixel:(CGPoint)point;

/*
 将图片变成灰色
 @return 变色后的image
 */
- (UIImage *)zb_GrayImage;

/**
 *  设置一张图片的透明度
 *
 *  @param alpha 要用于渲染透明度
 *
 *  @return 设置了透明度之后的图片
 */
- (UIImage *)zb_imageWithAlpha:(CGFloat)alpha;

/*
 纠正图片的方向 
 */
- (UIImage *)zb_fixOrientation;

/*
 按给定的方向旋转图片
 @param orient      方向
 @return 旋转后的image
 */
- (UIImage*)zb_Rotate:(UIImageOrientation)orient;

/*
 垂直翻转 
  @return 翻转后的image
 */
- (UIImage *)zb_FlipVertical;

/*
 水平翻转
 @return 翻转后的image
 */
- (UIImage *)zb_FlipHorizontal;

/*
 将图片旋转弧度
 @return 旋转弧度后的image
 */
- (UIImage *)zb_imageRotatedByRadians:(CGFloat)radians;

/*
 将图片旋转角度
 @return 旋转后的image
 */
- (UIImage *)zb_imageRotatedByDegrees:(CGFloat)degrees;

/*
 截取当前image对象rect区域内的图像
 @return 变色后的image
 */
- (UIImage *)zb_SubImageWithRect:(CGRect)rect;


- (UIImage *)zb_imageWithScaleToSize:(CGSize)size;

/*
 压缩图片至指定像素
 @param size        size
 @return 压缩后的image
 */
- (UIImage *)zb_rescaleImageToPX:(CGFloat )toPX;

/*
 指定大小生成一个平铺的图片
 @param size        size
 @return 翻转后的image
 */
- (UIImage *)zb_TiledImageWithSize:(CGSize)size;

/*
  UIView转化为UIImage
 @return 转化后的image
 */
- (UIImage *)zb_ViewConversionImage:(UIView *)view;

/*
 将两个图片合成一张图片
 @return 合成后的image
 */
- (UIImage*)zb_mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;

/*
 截取 图片中间
 @param size               size
 @param originalImage      截取前的image
 @return 截取后的image
 */
- (UIImage *)zb_handleImage:(UIImage *)originalImage withSize:(CGSize)size;


+ (UIImage *)zb_imageWithAttributedString:(NSAttributedString *)attributedString;

@end



