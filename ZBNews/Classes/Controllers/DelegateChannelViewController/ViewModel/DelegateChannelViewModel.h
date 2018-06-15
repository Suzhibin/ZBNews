//
//  DelegateChannelViewModel.h
//  ZBNews
//
//  Created by NQ UEC on 2018/6/13.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "BaseViewModel.h"
#import "RACChannelModel.h"

@protocol delegateChannelViewModelDelegate <NSObject>

- (void)requestFinished:(NSMutableArray *)dataArray ;

- (void)requestFailed:(NSError *)error;

@end

@interface DelegateChannelViewModel : BaseViewModel

@property(nonatomic,copy)NSString *urlString;

@property (weak,nonatomic)id<delegateChannelViewModelDelegate>viewModelDelegate;
//网络请求
- (void)requestListDataWithPage:(NSInteger)page menuInfo:(MenuInfo*)menuInfo requestType:(apiType)requestType;
//取消请求
- (void)cancelRequestWithMenuInfo:(MenuInfo*)menuInfo;

//获取对应额cell
- (NSString *)dataCellIdentifier:(RACChannelModel *)model;
//跳转 移至 ViewModel 基类里
//- (void)pushModel:(RACChannelModel *)model controller:(UIViewController *)controller;
@end
