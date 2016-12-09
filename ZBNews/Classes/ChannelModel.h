//
//  ChannelModel.h
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JKCoding.h"
@interface ChannelModel : NSObject
@property (nonatomic,copy)NSString *channelId;//频道id
@property (nonatomic,copy)NSString *channelName;//频道名字
@property (nonatomic,copy)NSString *content;//json数据
@property (nonatomic,copy)NSString *html;//html数据
@property (nonatomic,copy)NSString *link;//分享html页面
@property (nonatomic,copy)NSString *nid;//id
@property (nonatomic,copy)NSString *source;//来源
@property (nonatomic,copy)NSString *pubDate;//时间
@property (nonatomic,copy)NSString *title;//新闻名字
@property (nonatomic,copy)NSString *desc;//新闻描述
@property (nonatomic,copy)NSString *havePic;//有图片
@property (nonatomic,copy)NSArray *imageurls;//图片数组
@property (nonatomic,copy)NSString *url;//图片url
@property (nonatomic,copy)NSString *i;//测试使用


-(instancetype)initWithDict:(NSDictionary *)dict;
@end
