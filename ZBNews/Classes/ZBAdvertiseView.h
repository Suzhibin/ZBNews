//
//  ZBAdvertiseView.h
//  ZBNetworkingDemo
//
//  Created by NQ UEC on 17/1/10.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
//屏幕宽
#define SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)
//屏幕高
#define SCREEN_HEIGHT               ([UIScreen mainScreen].bounds.size.height)

@interface ZBAdvertiseView : UIView

- (instancetype)initWithFrame:(CGRect)frame ;
/*
 *  显示广告页面方法
 */
- (void)show;

/*
 *  图片
 */
@property (nonatomic, strong) UIImage *image;

/*
 *  图片路径
 */
@property (nonatomic, copy) NSString *filePath;
@end
