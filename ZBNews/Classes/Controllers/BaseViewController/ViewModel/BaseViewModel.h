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
/** push完成的后续操作Block */
typedef void(^pushCompletedBlock)(id  _Nullable x);

@interface BaseViewModel : NSObject
@property (nonatomic,strong)NSMutableArray * _Nullable menuList;

@property (nonatomic,strong)NSMutableArray * _Nullable channelList;
//跳转
- (void)pushModel:(RACChannelModel *_Nullable)model controller:(UIViewController *_Nullable)controller completion:(pushCompletedBlock _Nullable )completion;

@end
