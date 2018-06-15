//
//  RACChannelViewModel.h
//  ZBNews
//
//  Created by NQ UEC on 2018/6/13.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "BaseViewModel.h"

@interface RACChannelViewModel : BaseViewModel

@property(nonatomic,copy)NSString *urlString;

//网络请求
- (RACSignal *)requestListDataWithPage:(NSInteger)page menuInfo:(MenuInfo*)menuInfo requestType:(apiType)requestType;

//取消请求的方法
- (void)cancelRequestWithMenuInfo:(MenuInfo*)menuInfo;

//获取对应额cell
- (NSString *)dataCellIdentifier:(RACChannelModel *)model;

//跳转 移至 ViewModel 基类里
//- (void)pushModel:(RACChannelModel *)model controller:(UIViewController *)controller;
@end
