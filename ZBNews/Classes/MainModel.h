//
//  MainModel.h
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainModel : NSObject
@property (nonatomic,copy)NSString *channelId;
@property (nonatomic,copy)NSString *name;
-(instancetype)initWithDict:(NSDictionary *)dict;

/**
 *  最近一次刷新时间，自动刷新时间间隔为1h
 */
@property (nonatomic, assign) NSTimeInterval lastTime;

@end
