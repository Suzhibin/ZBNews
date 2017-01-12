//
//  ChannelViewModel.h
//  ZBNews
//
//  Created by NQ UEC on 16/12/9.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBNetworking.h"
#import "ChannelModel.h"
@protocol channelViewModelDelegate <NSObject>
@required
- (void)requestFinished:(ZBURLRequest *)request sendModel:(ChannelModel *)model;
@optional
- (void)requestFailed:(ZBURLSessionManager *)request;
@end
@interface ChannelViewModel : NSObject
@property (nonatomic, weak) id <channelViewModelDelegate>delegate;
/**
 *  网络数据
 *
 *  @param url url
 */
- (void)getDataWithUrl:(NSString *)url type:(apiType)type;
@end
