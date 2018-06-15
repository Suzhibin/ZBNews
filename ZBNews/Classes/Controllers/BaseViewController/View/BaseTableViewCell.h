//
//  BaseTableViewCell.h
//  ZBNews
//
//  Created by NQ UEC on 2017/9/12.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "CommonDefine.h"
#import "UIImageView+WebCache.h"
#import "ZBKit.h"
@class RACChannelModel;
@interface BaseTableViewCell : UITableViewCell
@property (nonatomic,strong)RACChannelModel *channelModel;

@end
