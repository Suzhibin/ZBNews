//
//  BaseViewModel.h
//  ZBNews
//
//  Created by NQ UEC on 2018/3/23.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonDefine.h"
#import "API_Constants.h"
#import "ZBKit.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "MenuInfo.h"
#import "RACChannelModel.h"
/** 缓存完成的后续操作Block */
typedef void(^pushCompletedBlock)(id  _Nullable x);

@interface BaseViewModel : NSObject
@property (nonatomic,strong)NSMutableArray * menuList;

@property (nonatomic,strong)NSMutableArray * channelList;
//跳转
- (void)pushModel:(RACChannelModel *)model controller:(UIViewController *)controller completion:(pushCompletedBlock)completion;

- (void)cancelRequestWithURLString:(NSString *)URLString menuInfo:(MenuInfo*)menuInfo;
@end
