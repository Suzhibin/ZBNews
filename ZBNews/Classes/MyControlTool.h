//
//  MyControlTool.h
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CKShimmerLabel.h"
@interface MyControlTool : NSObject
@property (nonatomic,strong)CKShimmerLabel *loadingLabel;
@property (nonatomic,strong)UILabel *TimedOutLabel;
//返回单例对象
+ (MyControlTool *)sharedManager;
//时间转换的方法
+ (NSString *)stringDateWithTimeInterval:(NSString *)timeInterval;

- (UIView *)TimedOutAlert;

- (UIView *)loading:(UIView *)view;

- (void)removeloadingLabel;
- (void)removeTimedOutAlertLabel;
@end
