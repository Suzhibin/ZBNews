//
//  BaseViewController.h
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "API_Constants.h"
#import <UIImageView+WebCache.h>
@interface BaseViewController : UIViewController
//title 设置btn的标题; selector点击btn实现的方法; isLeft 标记btn的位置
- (void)addItemWithTitle:(NSString *)title selector:(SEL)selector location:(BOOL)isLeft;
@end
