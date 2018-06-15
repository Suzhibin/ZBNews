//
//  MenuInfo.h
//  ZBNews
//
//  Created by NQ UEC on 2018/6/14.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "BaseModel.h"

@interface MenuInfo : BaseModel
@property (nonatomic,copy)NSString *menu_id;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)NSNumber *viewType;
/**
 *  最近一次刷新时间，自动刷新时间间隔为1h
 */
@property (nonatomic, assign) NSTimeInterval lastTime;
@end
