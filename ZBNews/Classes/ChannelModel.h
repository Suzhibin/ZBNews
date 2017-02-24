//
//  ChannelModel.h
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ZBCoding.h"
@interface ChannelModel : NSObject
@property (nonatomic,copy)NSString *newslId;//新闻id
@property (nonatomic,copy)NSString *title;//新闻名字
//@property (nonatomic,strong)NSDictionary *iconDict;//图片
@property (nonatomic,copy)id icon;//图片
@property (nonatomic,copy)NSString *online;//时间
@property (nonatomic,copy)NSString *icon_small1;//图片icon_small1
@property (nonatomic,copy)NSString *icon_small2;//图片icon_small2
@property (nonatomic,copy)NSString *icon_small3;//图片icon_small3
@property (nonatomic,copy)NSString *type;//展示类型
@property (nonatomic,copy)NSString *hits;//浏览数量

-(instancetype)initWithDict:(NSDictionary *)dict;
@end
