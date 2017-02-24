//
//  ZBAdvertiseView.h
//  ZBKit
//
//  Created by NQ UEC on 17/1/10.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZBAdvertiseView : UIView


/*
 *  创建广告视图
 */
- (instancetype)initWithFrame:(CGRect)frame ;
/*
 *  显示
 */
- (void)show;

/*
 *  图片
 */
@property (nonatomic, strong) UIImage *adImage;

/*
 *  图片路径
 */
@property (nonatomic, copy) NSString *filePath;

/*
 *  跳转url
 */
@property (nonatomic, copy) NSString *linkUrl;

/*
 *  跳转字典
 */
@property (nonatomic, strong) NSDictionary *linkdict;
@end
